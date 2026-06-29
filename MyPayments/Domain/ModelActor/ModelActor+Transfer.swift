import Foundation
import SwiftData

// MARK: - Transfer data access
extension ModelActor {
    func transferAccounts() throws -> [Account] {
        try context.fetch(FetchDescriptor<AccountEntity>())
            .map(\.asAccount)
            .sorted { $0.holder < $1.holder }
    }

    func transferHistory() throws -> [TransactionRecord] {
        let descriptor = FetchDescriptor<TransactionEntity>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try context.fetch(descriptor).map(\.asRecord)
    }

    func createInitialAccountsIfNeeded(_ accounts: [Account]) throws {
        guard let primary = accounts.first else { return }
        if try accountEntity(primary.id) == nil {
            try resetTransfers(to: accounts)
        }
    }

    func resetTransfers(to accounts: [Account]) throws {
        try context.delete(model: AccountEntity.self)
        try context.delete(model: TransactionEntity.self)
        accounts.forEach { context.insert(AccountEntity(account: $0)) }
        try context.save()
    }

    func commitTransfer(_ request: TransferRequest) throws -> TransactionRecord {
        if let existing = try transactionEntity(requestID: request.requestID) {
            return existing.asRecord
        }

        guard let source = try accountEntity(request.source) else {
            throw TransferError.accountNotFound(request.source)
        }
        guard let destination = try accountEntity(request.destination) else {
            throw TransferError.accountNotFound(request.destination)
        }

        let currency = request.amount.currency
        guard source.currency == currency.rawValue,
              destination.currency == currency.rawValue
        else {
            throw TransferError.currencyMismatch(
                source: CurrencyCode(rawValue: source.currency) ?? .eur,
                destination: CurrencyCode(rawValue: destination.currency) ?? .eur
            )
        }

        guard source.balance >= request.amount.amount else {
            throw TransferError.insufficientFunds(
                available: Money(amount: source.balance, currency: currency),
                required: request.amount
            )
        }

        source.balance -= request.amount.amount
        destination.balance += request.amount.amount

        let entity = TransactionEntity(
            id: UUID(),
            source: source.id,
            destination: destination.id,
            amount: request.amount.amount,
            currency: currency.rawValue,
            timestamp: .now,
            requestID: request.requestID,
            sourceBalanceAfter: source.balance,
            destinationBalanceAfter: destination.balance
        )
        context.insert(entity)
        try context.save()
        return entity.asRecord
    }

    // MARK: - Private fetch helpers
    private func accountEntity(_ id: AccountID) throws -> AccountEntity? {
        let raw = id.raw
        return try context.fetch(FetchDescriptor<AccountEntity>(
            predicate: #Predicate {
                $0.id == raw })
        ).first
    }

    private func transactionEntity(requestID: String) throws -> TransactionEntity? {
        try context.fetch(FetchDescriptor<TransactionEntity>(
            predicate: #Predicate {
                $0.requestID == requestID
            }
        )).first
    }
}

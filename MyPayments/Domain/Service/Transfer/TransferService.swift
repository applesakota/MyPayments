import Foundation

final class TransferService: TransferServiceProtocol {
    private let repository: TransferRepositoryProtocol

    init(repository: TransferRepositoryProtocol) {
        self.repository = repository
    }

    func accounts() async -> [Account] {
        await repository.accounts()
    }

    func transactionHistory() async -> [TransactionRecord] {
        await repository.transactionHistory()
    }

    func reset(to accounts: [Account]) async {
        await repository.reset(to: accounts)
    }

    func transfer(_ request: TransferRequest) async throws -> TransactionRecord {
        guard request.amount.isPositive else { throw TransferError.invalidAmount }
        guard request.source != request.destination else { throw TransferError.sameAccount }

        return try await repository.commit(request)
    }
}

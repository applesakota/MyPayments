import ComposableArchitecture
import Foundation

struct PaymentClient {
    var accounts: @Sendable () async -> [Account]
    var transfer: @Sendable (TransferRequest) async throws -> TransactionRecord
    var transactionHistory: @Sendable () async -> [TransactionRecord]
    var reset: @Sendable () async -> Void
}

extension PaymentClient {
    static func live(for user: User, modelActor: ModelActor) -> PaymentClient {
        let currency = user.currency
        let accounts: [Account] = [
            Account(id: user.accountID, holder: user.fullName, number: user.cardNumber, balance: Money(amount: user.balance, currency: currency)),
            Account(id: "acc-ana", holder: "Janko Jankovic", number: "1111222233334444", balance: Money(amount: 250, currency: currency)),
            Account(id: "acc-petar", holder: "Petar Petrovic", number: "5555666677778888", balance: Money(amount: 80, currency: currency)),
            Account(id: "acc-skyline", holder: "Mirko Mirkovic", number: "9999000011112222", balance: Money(amount: 5000, currency: currency)),
        ]
        let repository = TransferRepository(modelActor: modelActor, initialAccounts: accounts)
        let service = TransferService(repository: repository)
        return .live(service: service, initialAccounts: { accounts })
    }

    static func live(
        service: any TransferServiceProtocol,
        initialAccounts: @escaping @Sendable () -> [Account]
    ) -> PaymentClient {
        PaymentClient(
            accounts: { await service.accounts() },
            transfer: { try await service.transfer($0) },
            transactionHistory: { await service.transactionHistory() },
            reset: { await service.reset(to: initialAccounts()) }
        )
    }
}

extension PaymentClient: DependencyKey {
    static let liveValue = PaymentClient(
        accounts: unimplemented("PaymentClient.accounts", placeholder: []),
        transfer: unimplemented("PaymentClient.transfer"),
        transactionHistory: unimplemented("PaymentClient.transactionHistory", placeholder: []),
        reset: unimplemented("PaymentClient.reset")
    )
}

extension DependencyValues {
    var paymentClient: PaymentClient {
        get { self[PaymentClient.self] }
        set { self[PaymentClient.self] = newValue }
    }
}

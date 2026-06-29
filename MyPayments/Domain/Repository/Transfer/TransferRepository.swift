import Foundation

actor TransferRepository: TransferRepositoryProtocol {
    private let modelActor: ModelActor
    private let initialAccounts: [Account]
    private var isPrepared = false

    init(modelActor: ModelActor, initialAccounts: [Account]) {
        self.modelActor = modelActor
        self.initialAccounts = initialAccounts
    }

    func accounts() async -> [Account] {
        await prepare()
        return (try? await modelActor.transferAccounts()) ?? []
    }

    func balance(of id: AccountID) async throws -> Money {
        await prepare()
        let accounts = try await modelActor.transferAccounts()
        guard let account = accounts.first(where: { $0.id == id }) else {
            throw TransferError.accountNotFound(id)
        }
        return account.balance
    }

    func transactionHistory() async -> [TransactionRecord] {
        await prepare()
        return (try? await modelActor.transferHistory()) ?? []
    }

    func reset(to accounts: [Account]) async {
        try? await modelActor.resetTransfers(to: accounts)
        isPrepared = true
    }

    func commit(_ request: TransferRequest) async throws -> TransactionRecord {
        await prepare()
        return try await modelActor.commitTransfer(request)
    }

    private func prepare() async {
        guard !isPrepared else { return }
        isPrepared = true
        try? await modelActor.createInitialAccountsIfNeeded(initialAccounts)
    }
}

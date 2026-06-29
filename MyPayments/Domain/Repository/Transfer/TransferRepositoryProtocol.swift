import Foundation

protocol TransferRepositoryProtocol: Sendable {
    func accounts() async -> [Account]
    func balance(of id: AccountID) async throws -> Money
    func commit(_ request: TransferRequest) async throws -> TransactionRecord
    func transactionHistory() async -> [TransactionRecord]
    func reset(to accounts: [Account]) async
}

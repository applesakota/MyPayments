import Foundation

protocol TransferServiceProtocol: Sendable {
    func accounts() async -> [Account]
    func transfer(_ request: TransferRequest) async throws -> TransactionRecord
    func transactionHistory() async -> [TransactionRecord]
    func reset(to accounts: [Account]) async
}

import Foundation

enum TransferStatus: String, Sendable {
    case completed
}

struct TransactionRecord: Sendable, Identifiable, Equatable {
    let id: UUID
    let source: AccountID
    let destination: AccountID
    let amount: Money
    let timestamp: Date
    let requestID: String
    let status: TransferStatus
    let sourceBalanceAfter: Money
    let destinationBalanceAfter: Money
}

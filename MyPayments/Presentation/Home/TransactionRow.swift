import Foundation

/// One audit record prepared for display: from which account, to which, and how much.
struct TransactionRow: Equatable, Identifiable, Sendable {
    let id: UUID
    let from: String
    let to: String
    let amount: Decimal
    let date: Date
}

extension TransactionRecord {
    func row(holders: [AccountID: String]) -> TransactionRow {
        TransactionRow(
            id: id,
            from: holders[source] ?? source.raw,
            to: holders[destination] ?? destination.raw,
            amount: amount.amount,
            date: timestamp
        )
    }
}

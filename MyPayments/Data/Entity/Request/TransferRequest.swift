import Foundation

struct TransferRequest: Sendable, Equatable {
    let source: AccountID
    let destination: AccountID
    let amount: Money
    let requestID: String

    init(
        source: AccountID,
        destination: AccountID,
        amount: Money,
        requestID: String = UUID().uuidString
    ) {
        self.source = source
        self.destination = destination
        self.amount = amount
        self.requestID = requestID
    }
}

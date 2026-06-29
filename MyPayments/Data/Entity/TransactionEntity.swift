import Foundation
import SwiftData

@Model
final class TransactionEntity {
    @Attribute(.unique) var id: UUID
    var source: String
    var destination: String
    var amount: Decimal
    var currency: String
    var timestamp: Date
    var requestID: String
    var sourceBalanceAfter: Decimal
    var destinationBalanceAfter: Decimal

    init(
        id: UUID,
        source: String,
        destination: String,
        amount: Decimal,
        currency: String,
        timestamp: Date,
        requestID: String,
        sourceBalanceAfter: Decimal,
        destinationBalanceAfter: Decimal
    ) {
        self.id = id
        self.source = source
        self.destination = destination
        self.amount = amount
        self.currency = currency
        self.timestamp = timestamp
        self.requestID = requestID
        self.sourceBalanceAfter = sourceBalanceAfter
        self.destinationBalanceAfter = destinationBalanceAfter
    }
}

extension TransactionEntity {
    var asRecord: TransactionRecord {
        let currencyCode = CurrencyCode(rawValue: currency) ?? .eur
        return TransactionRecord(
            id: id,
            source: AccountID(source),
            destination: AccountID(destination),
            amount: Money(amount: amount, currency: currencyCode),
            timestamp: timestamp,
            requestID: requestID,
            status: .completed,
            sourceBalanceAfter: Money(amount: sourceBalanceAfter, currency: currencyCode),
            destinationBalanceAfter: Money(amount: destinationBalanceAfter, currency: currencyCode)
        )
    }
}

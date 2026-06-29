import Foundation
import SwiftData

@Model
final class AccountEntity {
    @Attribute(.unique) var id: String
    var holder: String
    var number: String
    var balance: Decimal
    var currency: String

    init(id: String, holder: String, number: String, balance: Decimal, currency: String) {
        self.id = id
        self.holder = holder
        self.number = number
        self.balance = balance
        self.currency = currency
    }

    convenience init(account: Account) {
        self.init(
            id: account.id.raw,
            holder: account.holder,
            number: account.number,
            balance: account.balance.amount,
            currency: account.balance.currency.rawValue
        )
    }
}

extension AccountEntity {
    var asAccount: Account {
        Account(
            id: AccountID(id),
            holder: holder,
            number: number,
            balance: Money(amount: balance, currency: CurrencyCode(rawValue: currency) ?? .eur)
        )
    }
}

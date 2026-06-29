import Foundation
import SwiftData

@Model
public final class User {
    public var id: UUID
    public var name: String
    public var surname: String
    public var cardNumber: String
    public var currency: CurrencyCode = CurrencyCode.eur
    public var balance: Decimal

    public init(
        id: UUID = UUID(),
        name: String,
        surname: String,
        cardNumber: String,
        currency: CurrencyCode = .eur,
        balance: Decimal = 0
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.cardNumber = cardNumber
        self.currency = currency
        self.balance = balance
    }
}

// MARK: - Computed properties
extension User {
    var accountID: AccountID { AccountID(id.uuidString) }

    public var fullName: String {
        "\(name) \(surname)"
    }
    
    public var initials: String {
        "\(name.first.map(String.init) ?? "")\(surname.first.map(String.init) ?? "")".uppercased()
    }
    
    public var maskedCard: String {
        "•••• " + cardNumber.suffix(4)
    }
}

extension User {
    static var stub: User {
        return User(
            name: "",
            surname: "",
            cardNumber: ""
        )
    }
}

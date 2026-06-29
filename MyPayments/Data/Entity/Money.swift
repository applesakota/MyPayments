import Foundation

public enum CurrencyCode: String, Codable, Sendable {
    case eur = "EUR", usd = "USD", rsd = "RSD"
}

struct Money: Sendable, Equatable {
    let amount: Decimal
    let currency: CurrencyCode
    static func eur(_ a: Decimal) -> Money { .init(amount: a, currency: .eur) }
    var isPositive: Bool { amount > 0 }
}

import Foundation

enum TransferError: LocalizedError, Equatable, Sendable {
    case invalidAmount
    case sameAccount
    case accountNotFound(AccountID)
    case currencyMismatch(source: CurrencyCode, destination: CurrencyCode)
    case insufficientFunds(available: Money, required: Money)

    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Transfer amount must be greater than zero."
        case .sameAccount:
            return "Source and destination accounts must be different."
        case .accountNotFound(let id):
            return "Account \(id) was not found."
        case .currencyMismatch(let source, let destination):
            return "Currency mismatch: source is \(source.rawValue), destination is \(destination.rawValue)."
        case .insufficientFunds(let available, let required):
            return "Insufficient funds: \(available.amount) available, \(required.amount) required."
        }
    }
}

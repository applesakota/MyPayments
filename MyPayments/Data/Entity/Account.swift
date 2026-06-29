import Foundation

struct Account: Sendable, Identifiable, Equatable {
    let id: AccountID
    let holder: String
    let number: String
    var balance: Money
}

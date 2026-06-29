import Foundation

struct AccountID: Hashable, Sendable, CustomStringConvertible, ExpressibleByStringLiteral {
    let raw: String
    
    init(_ raw: String) {
        self.raw = raw
    }
    
    init(stringLiteral value: String) {
        self.raw = value
    }
    
    var description: String {
        raw
    }
}

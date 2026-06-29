import Foundation

struct NonEmptyRule: ValidationRule {
    func isValid(_ text: String) -> Bool {
        return !text.isEmpty
    }
    
    func errorMessage(for placeholder: String) -> String {
        .init(format: "%@ is required", placeholder)
    }
    
    func shouldValidate(hasEdited: Bool) -> Bool {
        hasEdited
    }
}



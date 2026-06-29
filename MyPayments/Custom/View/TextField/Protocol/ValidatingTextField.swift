import SwiftUI

protocol ValidatingTextField: View {
    var text: String { get }
    var title: String { get }
    var isValidationEnabled: Bool { get }
    var validationRules: [ValidationRule] { get }
}

extension ValidatingTextField {
    func validate(hasEdited: Bool = true) -> Bool {
        guard isValidationEnabled else { return true }
        return validationRules.allSatisfy {
            $0.shouldValidate(text: text, hasEdited: hasEdited)
            ? $0.isValid(text)
            : true
        }
    }
    
    func validationError(hasEdited: Bool = true) -> String? {
        guard isValidationEnabled else { return nil }
        return validationRules.first {
            $0.shouldValidate(text: text, hasEdited: hasEdited)
            && !$0.isValid(text)
        }?.errorMessage(for: title)
    }
}

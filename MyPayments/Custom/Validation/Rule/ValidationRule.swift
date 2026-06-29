protocol ValidationRule {
    func isValid(_ text: String) -> Bool
    func errorMessage(for placeholder: String) -> String
}

// MARK: - Validation Rule Extension
extension ValidationRule {
    func shouldValidate(text: String, hasEdited: Bool) -> Bool {
        true
    }
}

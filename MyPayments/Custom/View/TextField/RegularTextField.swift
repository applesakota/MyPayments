import SwiftUI

struct RegularTextField: ValidatingTextField {
    @Environment(\.isEnabled) private var isEnabled
    
    @Binding var text: String
    
    private(set) var title: String
    private(set) var isValidationEnabled: Bool
    private(set) var validationRules: [ValidationRule]
    private var keyboardType: UIKeyboardType
    private var trailingSystemImage: String?

    @FocusState private var isFocused: Bool
    @State private var isValid = false
    @State private var isStartedEditing = false
    
    
    init(
        _ title: String,
        text: Binding<String>,
        isValidationEnabled: Bool = true,
        validationRules: [ValidationRule] = [NonEmptyRule()],
        keyboardType: UIKeyboardType = .default,
        trailingSystemImage: String? = nil,
    ) {
        self.title = title
        _text = text
        self.isValidationEnabled = isValidationEnabled
        self.validationRules = validationRules
        self.keyboardType = keyboardType
        self.trailingSystemImage = trailingSystemImage
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if !text.isEmpty {
                    Text(title)
                        .foregroundStyle(.gray)
                }
                
                HStack {
                    TextField(
                        title,
                        text: $text,
                        prompt: .init(title).foregroundStyle(
                            isError ? .red : .gray
                        )
                    )
                    .keyboardType(keyboardType)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
                    .foregroundStyle(!isEnabled ? .gray : .black)
                    .disabled(!isEnabled)

                    if let trailingSystemImage {
                        Image(systemName: trailingSystemImage)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .frame(height: UIConstant.TextField.height)
            .roundedCornersBackground(isValid: !isError)
            .onChange(of: isFocused) { _, newValue in
                if !newValue {
                    isStartedEditing = true
                    update()
                }
            }
            .onChange(of: text) { _, _ in
                isStartedEditing = true
                update()
            }
            .preference(key: ValidationPreferenceKey.self, value: isValid)
            .onAppear {
                if !text.isEmpty {
                    isStartedEditing = true
                    update()
                }
            }
            
            if isStartedEditing, !isValid, let error = validationError(hasEdited: isStartedEditing) {
                Text(error)
                    .foregroundStyle(Color.red)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isFocused = false }
            }
        }
    }
}

// MARK: - Computed Properties
private extension RegularTextField {
    var isError: Bool {
        isStartedEditing && !isValid
    }
}

// MARK: - Update
private extension RegularTextField {
    func update() {
        isValid = validate(hasEdited: isStartedEditing)
    }
}

#Preview {
    RegularTextField("EMMAIL", text: .constant("some text"))
}

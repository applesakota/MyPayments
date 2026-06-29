import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var isEmailValid = false
    @State private var showAlert = false
    @EnvironmentObject private var authState: AuthState
    
    var userAuthenticated: ((User) -> Void)

    var body: some View {
        VStack(spacing: UIConstant.Spacing.x3) {
            Image("splashicon")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIConstant.Image.maxWidthLogo)
            Text("Send money in seconds")
                .font(.system(size: 32))
                .fontWeight(.bold)
            Text("No password needed — just your email.")
            
            RegularTextField(
                "Username",
                text: $email,
                validationRules: [
                    NonEmptyRule(),
                    EmailRule()
                ]
            )
            .onPreferenceChange(ValidationPreferenceKey.self) { value in
                isEmailValid = value
            }
            
            Spacer()
            
            Button {
                signin()
            } label: {
                Text("Continue")
            }
            .buttonStyle(MainActionButtonStyle())
            .disabled(!isEmailValid)
        }
        .padding(.horizontal)
        .foregroundStyle(.white)
        .background(Color.appBackground)
    }
}

//MARK: - Sign in
private extension SignInView {
    func signin() {
        let user = User(
            name: "Marko",
            surname: "Markovic",
            cardNumber: "1234567890123456",
            balance: Constant.Payment.startingBalance
        )
        userAuthenticated(user)
    }
}

#Preview {
    SignInView() { _ in }
        .environmentObject(AuthState.stub)
}

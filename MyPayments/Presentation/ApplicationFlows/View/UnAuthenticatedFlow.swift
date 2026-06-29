import SwiftUI

enum UnAuthenticatedFlowProgress {
    case initializing
    case authenticated(User)
}

struct UnAuthenticatedFlow: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @StateObject private var authState: AuthState
    
    var unAuthenticatedFlowState: any UnAuthenticatedFlowState
    
    init(
        authState: AuthState,
        unAuthenticatedFlowState: any UnAuthenticatedFlowState
    ) {
        _authState = StateObject(wrappedValue: authState)
        self.unAuthenticatedFlowState = unAuthenticatedFlowState
    }
    
    var body: some View {
        NavigationStack(path: $authState.navigation.path) {
            SignInView { user in
                Task {
                    await signInFlow(user: user)
                }
            }
        }
        .environmentObject(authState)
        .task {
            await unAuthenticatedFlowState.update(with: .initializing)
        }
    }
    
    func signInFlow(user: User) async {
        await unAuthenticatedFlowState.update(with: .authenticated(user))
    }
}

#Preview {
//    UnAuthenticatedFlow()
}

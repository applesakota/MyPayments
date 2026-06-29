import ComposableArchitecture
import SwiftUI

enum AuthenticatedFlowProgress {
    case initializing
    case signedOut
}

struct AuthenticatedFlow: View {
    private let user: User
    private let authenticatedFlowState: any AuthenticatedFlowState
    @State private var store: StoreOf<HomeFeature>

    init(
        user: User,
        modelActor: ModelActor,
        authenticatedFlowState: any AuthenticatedFlowState
    ) {
        self.user = user
        self.authenticatedFlowState = authenticatedFlowState

        self._store = State(initialValue: Store(
            initialState: HomeFeature.State(userAccountID: user.accountID)
        ) {
            HomeFeature()
        } withDependencies: {
            $0.paymentClient = .live(for: user, modelActor: modelActor)
            $0.sessionClient = SessionClient(
                signOut: {
                    await authenticatedFlowState.update(with: .signedOut)
                }
            )
        })
    }

    var body: some View {
        NavigationStack {
            HomeView(store: store)
        }
        .task {
            await authenticatedFlowState.update(with: .initializing)
        }
    }
}

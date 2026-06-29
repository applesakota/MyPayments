import SwiftUI

struct MainApplicationView: View {

    @State private var viewModel: MainApplicationViewModel

    init(viewModel: MainApplicationViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            switch viewModel.applicationState {
            case .initializing:
                ApplicationLoadingScreen(
                    viewModel: ApplicationLoadingViewModel(
                        modelActor: viewModel.modelActor,
                        flowState: viewModel
                    )
                )
            case .userUnauthenticated:
                UnAuthenticatedFlow(
                    authState: AuthState(),
                    unAuthenticatedFlowState: viewModel
                )
            case .userAuthenticated(let user):
                AuthenticatedFlow(
                    user: user,
                    modelActor: viewModel.modelActor,
                    authenticatedFlowState: viewModel
                )
            }
        }
        .animation(.default, value: isInitializing)
        .preferredColorScheme(.light)
    }

    private var isInitializing: Bool {
        if case .initializing = viewModel.applicationState { return true }
        return false
    }
}

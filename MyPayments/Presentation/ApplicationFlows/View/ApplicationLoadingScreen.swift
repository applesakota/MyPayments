import SwiftUI

enum ApplicationLoadingProgress: Sendable {
    case completedWithUnauthorizedState
    case completedWithAuthorizedState(
        user: User
    )
}

struct ApplicationLoadingScreen: View {
    @State private var progressViewShowing: Bool = false
    @State private var viewModel: ApplicationLoadingViewModel?
    
    init(
        viewModel: ApplicationLoadingViewModel? = nil
    ) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Image("splashicon")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIConstant.Image.maxWidthLogo)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .overlay {
                    if progressViewShowing {
                        ProgressView()
                            .tint(.white)
                            .offset(y: geometry.size.height * 0.2)
                    }
                }
        }
        .background(Color.appBackground)
        .task {
            guard let viewModel else { return }
            self.progressViewShowing = true
            await viewModel.initialize()
        }
    }
}

#Preview {
    ApplicationLoadingScreen()
}

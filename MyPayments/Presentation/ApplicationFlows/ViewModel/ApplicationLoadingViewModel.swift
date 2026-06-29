import Foundation
import SwiftUI

@MainActor
@Observable
class ApplicationLoadingViewModel {
    private(set) var isLoading = true
    private let modelActor: ModelActor
    private weak var flowState: ApplicationLoadingScreenState?
    
    private enum LocalConstant {
        static let minimumTimeToWaitForSplashScreen: TimeInterval = 3
    }
    
    init(
        modelActor: ModelActor,
        flowState: ApplicationLoadingScreenState?
    ) {
        self.modelActor = modelActor
        self.flowState = flowState
    }
    
    func initialize() async {
        let start = Date()

        let progress = await splashScreenInitializing()

        // Keep the splash on screen for at least the minimum duration, even when
        // the auth check returns instantly, so it never just flashes by.
        let elapsed = Date().timeIntervalSince(start)
        let remaining = LocalConstant.minimumTimeToWaitForSplashScreen - elapsed
        if remaining > 0 {
            try? await Task.sleep(for: .seconds(remaining))
        }

        guard let progress else { return }
        await flowState?.update(with: progress)
    }
    
    func splashScreenInitializing() async -> ApplicationLoadingProgress? {
        guard let user = await isUserAuthenticated() else {
            return .completedWithUnauthorizedState
        }
        return .completedWithAuthorizedState(
            user: user
        )
    }
    
    func isUserAuthenticated() async -> User? {
        do {
            return try await modelActor.fetchUser()
        } catch {
            return nil
        }
    }
}


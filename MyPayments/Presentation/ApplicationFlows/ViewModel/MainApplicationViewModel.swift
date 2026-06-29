import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class MainApplicationViewModel {

    private(set) var applicationState: ApplicationState = .initializing
    private(set) var modelActor: ModelActor

    init(modelContainer: ModelContainer) {
        self.modelActor = ModelActor(modelContainer: modelContainer)
    }
}

// MARK: - ApplicationLoadingScreenState
extension MainApplicationViewModel: ApplicationLoadingScreenState {
    func update(with progress: ApplicationLoadingProgress) async {
        switch progress {
        case .completedWithUnauthorizedState:
            applicationState = .userUnauthenticated
        case .completedWithAuthorizedState(let user):
            applicationState = .userAuthenticated(user)
        }
    }
}

// MARK: - UnAuthenticatedFlowState
extension MainApplicationViewModel: UnAuthenticatedFlowState {
    func update(with progress: UnAuthenticatedFlowProgress) async {
        switch progress {
        case .initializing:
            break
        case .authenticated(let user):
            do {
                try await persist(user)
                applicationState = .userAuthenticated(user)
            } catch {
                applicationState = .userUnauthenticated
            }
        }
    }
}

// MARK: - AuthenticatedFlowState
extension MainApplicationViewModel: AuthenticatedFlowState {
    func update(with progress: AuthenticatedFlowProgress) async {
        switch progress {
        case .initializing:
            break
        case .signedOut:
            await clearSession()
            applicationState = .userUnauthenticated
        }
    }

    private func clearSession() async {
        do {
            try await modelActor.deleteAllUsers()
            try await modelActor.save()
        } catch {
            // Even if clearing fails, still leave the authenticated session.
        }
    }
}

// MARK: - Persistence
private extension MainApplicationViewModel {
    func persist(_ user: User) async throws {
        try await modelActor.deleteAllUsers()
        try await modelActor.insertUser(user)
        try await modelActor.save()
    }
}

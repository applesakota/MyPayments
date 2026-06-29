import ComposableArchitecture

struct SessionClient {
    var signOut: @Sendable () async -> Void
}

extension SessionClient: DependencyKey {
    static let liveValue = SessionClient(signOut: {})
    static let testValue = SessionClient(
        signOut: unimplemented("SessionClient.signOut")
    )
}

extension DependencyValues {
    var sessionClient: SessionClient {
        get { self[SessionClient.self] }
        set { self[SessionClient.self] = newValue }
    }
}

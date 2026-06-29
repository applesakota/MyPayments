import Foundation

@MainActor
protocol ApplicationLoadingScreenState: AnyObject {
    func update(with progress: ApplicationLoadingProgress) async
}

@MainActor
protocol UnAuthenticatedFlowState: AnyObject {
    func update(with progress: UnAuthenticatedFlowProgress) async
}

@MainActor
protocol AuthenticatedFlowState: AnyObject {
    func update(with progress: AuthenticatedFlowProgress) async
}

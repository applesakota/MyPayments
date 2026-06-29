import SwiftUI
import Combine

final class AuthState: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var navigation = Navigation(path: .init())
}

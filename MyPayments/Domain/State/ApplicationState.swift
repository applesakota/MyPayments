import Foundation

enum ApplicationState {
    case initializing
    case userUnauthenticated
    case userAuthenticated(User)
}

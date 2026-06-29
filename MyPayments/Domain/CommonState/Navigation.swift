import SwiftUI

struct Navigation {
    var path: NavigationPath
    
    // MARK: - Navigate Forward
    mutating func navigate<Destination: Hashable>(to destination: Destination) {
        path.append(destination)
    }
    
    // MARK: - Navigate Back (one step)
    mutating func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    //MARK: - Navigate Back (N Steps)
    mutating func pop(by count: Int) {
        guard !path.isEmpty else { return }
        path.removeLast(count)
    }
    
    mutating func reset(to path: NavigationPath = .init()) {
        self.path = path
    }
    
    mutating func resetDestination<Destination: Hashable>(to destination: Destination) {
        self.path = .init()
        navigate(to: destination)
    }
    
}

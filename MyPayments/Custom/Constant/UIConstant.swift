import Foundation

struct UIConstant {
    struct Button {
        static let defaultWidth: CGFloat = 44
        static let defaultHeight: CGFloat = 44
    }
    
    struct Spacing {
        static let zero: CGFloat = 0
        static let x: CGFloat = 8
        static let x2: CGFloat = x * 2
        static let x3: CGFloat = x * 3
        static let x4: CGFloat = x * 4
        static let x5: CGFloat = x * 5
        static let x6: CGFloat = x * 6
        static let x7: CGFloat = x * 7
        static let x05: CGFloat = x * 0.5
    }
    
    struct Radius {
        static let x: CGFloat = 2
        static let x2: CGFloat = x * 2
        static let x3: CGFloat = x * 3
        static let x4: CGFloat = x * 4
        static let x5: CGFloat = x * 5
        static let x6: CGFloat = x * 6
        static let x7: CGFloat = x * 7
        
    }
}


extension UIConstant {
    enum Image {
        static let maxWidthLogo: CGFloat = 160
    }
}

extension UIConstant {
    enum TextField {
        static let height: CGFloat = 56
    }
}

extension UIConstant {
    enum Card {
        static let height: CGFloat = 200
        static let compactHeight: CGFloat = 180
        static let cornerRadius: CGFloat = 20
        static let balanceFontSize: CGFloat = 34
    }
}

extension UIConstant {
    enum FloatingButton {
        static let size: CGFloat = 56
        static let shadowRadius: CGFloat = 4
    }
}

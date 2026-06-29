import SwiftUI

public struct RoundedCornersBackgroundViewModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled
    private let isValid: Bool

    public init(isValid: Bool) {
        self.isValid = isValid
    }
    
    public func body(content: Content) -> some View {
        content
            .padding([.top, .bottom], UIConstant.Spacing.x05)
            .padding([.leading, .trailing])
            .background {
                RoundedRectangle(cornerRadius: UIConstant.Radius.x3)
                    .fill(
                        (isEnabled ? Color(.white) : Color(.white)).shadow(
                            .inner(
                                radius: UIConstant.Radius.x,
                                x: 0.5 * 3,
                                y: 0.5 * 3
                            )
                        )
                    )
                    .stroke(isValid ? .gray : .red, lineWidth: 1)
            }
    }
}

// MARK: - View + RoundedCornersBackgroundViewModifier

public extension View {
    func roundedCornersBackground(isValid: Bool = true) -> some View {
        modifier(RoundedCornersBackgroundViewModifier(isValid: isValid))
    }
}

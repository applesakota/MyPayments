import SwiftUI

struct MainActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    var height: CGFloat = UIConstant.Button.defaultHeight
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .lineLimit(1)
            .fontWeight(.black)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .foregroundStyle(
                isEnabled ? .white : .white.opacity(0.5)
            )
            .background(
                isEnabled ? Color.gray : Color.gray.opacity(0.4)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: .infinity)
            )
    }
}



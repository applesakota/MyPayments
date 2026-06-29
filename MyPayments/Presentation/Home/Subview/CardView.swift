import SwiftUI

struct CardView: View {
    let holderName: String
    let accountNumber: String
    let balance: String
    var height: CGFloat = UIConstant.Card.height

    @State private var isFlipped = false

    var body: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)
            back
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))   // un-mirror the back
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height)
        .background(
            LinearGradient(
                colors: [.cardGradientStart, .cardGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: UIConstant.Card.cornerRadius)
        )
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isFlipped)
        .contentShape(Rectangle())
        .onTapGesture { isFlipped.toggle() }
    }

    // MARK: - Faces

    private var front: some View {
        VStack(alignment: .leading, spacing: UIConstant.Spacing.x2) {
            HStack {
                Text("Current balance")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Image(systemName: "creditcard.fill")
                    .foregroundStyle(.white.opacity(0.7))
            }

            Text(balance)
                .font(.system(size: UIConstant.Card.balanceFontSize, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Text(masked)
                .font(.title3.monospaced())
                .foregroundStyle(.white)

            HStack(spacing: UIConstant.Spacing.x05) {
                Image(systemName: "hand.tap.fill")
                Text("Tap to reveal")
            }
            .font(.caption2)
            .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var back: some View {
        VStack(alignment: .leading, spacing: UIConstant.Spacing.x2) {
            HStack {
                Text("Card number")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Image(systemName: "creditcard.fill")
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            Text(grouped(accountNumber))
                .font(.title2.monospaced().weight(.semibold))
                .foregroundStyle(.white)

            Spacer()

            Text(holderName.uppercased())
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Number formatting

    private var masked: String {
        "•••• •••• •••• " + accountNumber.suffix(4)
    }

    private func grouped(_ number: String) -> String {
        stride(from: 0, to: number.count, by: 4).map { offset in
            let start = number.index(number.startIndex, offsetBy: offset)
            let end = number.index(start, offsetBy: 4, limitedBy: number.endIndex) ?? number.endIndex
            return String(number[start..<end])
        }
        .joined(separator: " ")
    }
}

#Preview {
    CardView(
        holderName: "Marko Markovic",
        accountNumber: "1234567890123456",
        balance: "€1,234.00"
    )
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.appBackground)
}

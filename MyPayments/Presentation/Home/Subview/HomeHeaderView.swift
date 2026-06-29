import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstant.Spacing.x2) {
            HStack(spacing: UIConstant.Spacing.x2) {
                blankCard
                Image(systemName: "arrow.left.arrow.right")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
                blankCard
            }

            VStack(alignment: .leading, spacing: UIConstant.Spacing.x05) {
                Text("Transfer between accounts")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("Pick a source and a destination account, enter an amount, and the money moves instantly — every transfer is recorded below.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }

    private var blankCard: some View {
        RoundedRectangle(cornerRadius: UIConstant.Card.cornerRadius)
            .fill(
                LinearGradient(
                    colors: [.cardGradientStart, .cardGradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(maxWidth: .infinity)
            .frame(height: 72)
            .overlay {
                Image(systemName: "creditcard.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.35))
            }
    }
}

#Preview {
    HomeHeaderView()
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
}

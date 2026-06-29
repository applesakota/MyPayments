import SwiftUI

struct TransactionView: View {
    let transaction: TransactionRow

    var body: some View {
        HStack(spacing: UIConstant.Spacing.x2) {
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.85), in: Circle())

            VStack(alignment: .leading, spacing: UIConstant.Spacing.x05) {
                Text(transaction.from)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                HStack(spacing: UIConstant.Spacing.x05) {
                    Image(systemName: "arrow.turn.down.right")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.6))
                    Text(transaction.to)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(1)
                }

                Text(transaction.date, format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Spacer()

            Text(transaction.amount, format: .currency(code: "EUR"))
                .font(.callout.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: UIConstant.Card.cornerRadius))
    }
}

#Preview {
    VStack(spacing: UIConstant.Spacing.x2) {
        TransactionView(transaction: TransactionRow(id: UUID(), from: "Marko Markovic", to: "Ana Anic", amount: 222, date: .now))
        TransactionView(transaction: TransactionRow(id: UUID(), from: "Skyline d.o.o.", to: "Marko Markovic", amount: 200, date: .now))
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.appBackground)
}

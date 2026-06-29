import ComposableArchitecture
import SwiftUI

struct TransferView: View {
    @Bindable var store: StoreOf<TransferFeature>

    var body: some View {
        NavigationStack {
            VStack(spacing: UIConstant.Spacing.x2) {
                ScrollView {
                    VStack(spacing: UIConstant.Spacing.x2) {
                        RegularTextField(
                            "Amount",
                            text: $store.amountText,
                            validationRules: [NonEmptyRule()],
                            keyboardType: .decimalPad,
                            trailingSystemImage: "eurosign"
                        )

                        cardSection(label: "From", selection: $store.sourceID)
                        cardSection(label: "To", selection: $store.destinationID)
                    }
                }

                Button {
                    store.send(.transferButtonTapped)
                } label: {
                    Text("Transfer")
                }
                .buttonStyle(MainActionButtonStyle())
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .foregroundStyle(.white)
            .navigationTitle("Transfer money")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { store.send(.cancelButtonTapped) } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
        }
        .presentationBackground(Color.appBackground)
        .task { store.send(.onAppear) }
    }

    @ViewBuilder
    private func cardSection(label: String, selection: Binding<AccountID?>) -> some View {
        let account = store.accounts.first {
            $0.id == selection.wrappedValue
        }
        VStack(alignment: .leading, spacing: UIConstant.Spacing.x) {
            HStack {
                Text(label)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Menu {
                    ForEach(store.accounts) { account in
                        Button {
                            selection.wrappedValue = account.id
                        } label: {
                            Text("\(account.holder)")
                        }
                    }
                } label: {
                    Label("Change", systemImage: "chevron.up.chevron.down")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                }
            }

            if let account {
                CardView(
                    holderName: account.holder,
                    accountNumber: account.number,
                    balance: formatted(account.balance)
                )
            }
        }
    }

    private func formatted(_ money: Money) -> String {
        money.amount.formatted(.currency(code: money.currency.rawValue))
    }
}

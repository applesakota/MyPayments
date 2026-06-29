import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIConstant.Spacing.x2) {
                HomeHeaderView()

                Text("Transactions")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                LazyVStack(spacing: UIConstant.Spacing.x2) {
                    ForEach(store.rows) { row in
                        TransactionView(transaction: row)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .overlay {
            if store.isLoading {
                ProgressView()
                    .tint(.white)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                store.send(.addTransferButtonTapped)
            } label: {
                Image(systemName: "plus")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.floatingButtonForeground)
                    .frame(width: UIConstant.FloatingButton.size, height: UIConstant.FloatingButton.size)
                    .background(Color.white, in: Circle())
                    .shadow(radius: UIConstant.FloatingButton.shadowRadius)
            }
            .padding()
        }
        .fullScreenCover(item: $store.scope(state: \.transfer, action: \.transfer)) { transferStore in
            TransferView(store: transferStore)
        }
        .task {
            store.send(.onAppear)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        store.send(.resetButtonTapped)
                    } label: {
                        Label("Reset balance", systemImage: "arrow.counterclockwise")
                    }
                    Button("Log out") {
                        store.send(.signOutButtonTapped)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            store: Store(initialState: HomeFeature.State(userAccountID: "user")) {
                HomeFeature()
            } withDependencies: {
                $0.paymentClient = PaymentClient(
                    accounts: {
                        [Account(id: "user", holder: "Marko Markovic", number: "1234567890123456", balance: .eur(778))]
                    },
                    transfer: { _ in
                        TransactionRecord(
                            id: UUID(), source: "user", destination: "acc",
                            amount: .eur(0), timestamp: .now, requestID: "",
                            status: .completed, sourceBalanceAfter: .eur(0), destinationBalanceAfter: .eur(0)
                        )
                    },
                    transactionHistory: { [] },
                    reset: {}
                )
            }
        )
    }
}

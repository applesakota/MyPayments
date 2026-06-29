import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        let userAccountID: AccountID
        var rows: [TransactionRow] = []
        var isLoading = false
        @Presents var transfer: TransferFeature.State?

        init(userAccountID: AccountID) {
            self.userAccountID = userAccountID
        }
    }

    enum Action {
        case onAppear
        case dataLoaded(accounts: [Account], audit: [TransactionRecord])
        case addTransferButtonTapped
        case transfer(PresentationAction<TransferFeature.Action>)
        case resetButtonTapped
        case signOutButtonTapped
    }

    @Dependency(\.paymentClient) var paymentClient
    @Dependency(\.sessionClient) var sessionClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return load(&state)

            case let .dataLoaded(accounts, audit):
                state.isLoading = false
                let holders = Dictionary(uniqueKeysWithValues: accounts.map { ($0.id, $0.holder) })
                state.rows = audit.map { $0.row(holders: holders) }
                return .none

            case .addTransferButtonTapped:
                state.transfer = TransferFeature.State(userAccountID: state.userAccountID)
                return .none

            case .transfer(.presented(.delegate(.didComplete))):
                return load(&state)

            case .transfer:
                return .none

            case .resetButtonTapped:
                state.isLoading = true
                return .run { send in
                    await paymentClient.reset()
                    await send(.onAppear)
                }

            case .signOutButtonTapped:
                return .run { _ in await sessionClient.signOut() }
            }
        }
        .ifLet(\.$transfer, action: \.transfer) {
            TransferFeature()
        }
    }
    private func load(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return .run { send in
            let accounts = await paymentClient.accounts()
            let audit = await paymentClient.transactionHistory()
            await send(.dataLoaded(accounts: accounts, audit: audit))
        }
    }
}

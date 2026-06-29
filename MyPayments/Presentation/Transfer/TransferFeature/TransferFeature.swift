import ComposableArchitecture
import Foundation

@Reducer
struct TransferFeature {
    @ObservableState
    struct State: Equatable {
        var accounts: [Account] = []
        var sourceID: AccountID?
        var destinationID: AccountID?
        var amountText = ""
        var isSending = false
        @Presents var alert: AlertState<Action.Alert>?

        var amount: Decimal? { Decimal(string: amountText) }

        init(userAccountID: AccountID) {
            self.sourceID = userAccountID
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case accountsLoaded([Account])
        case transferButtonTapped
        case cancelButtonTapped
        case transferResponse(Result<TransactionRecord, TransferError>)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)

        enum Alert: Equatable {}
        enum Delegate { case didComplete }
    }

    @Dependency(\.paymentClient) var paymentClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                return .run { send in
                    await send(.accountsLoaded(await paymentClient.accounts()))
                }

            case let .accountsLoaded(accounts):
                state.accounts = accounts
                if state.destinationID == nil {
                    state.destinationID = accounts.first { $0.id != state.sourceID }?.id
                }
                return .none

            case .cancelButtonTapped:
                return .run { _ in await dismiss() }

            case .transferButtonTapped:
                guard !state.isSending,
                      let source = state.sourceID,
                      let destination = state.destinationID else { return .none }

                let amount = state.amount ?? 0
                let currency = state.accounts.first { $0.id == source }?.balance.currency ?? .eur
                let request = TransferRequest(
                    source: source,
                    destination: destination,
                    amount: Money(amount: amount, currency: currency)
                )
                state.isSending = true
                return .run { send in
                    do {
                        let record = try await paymentClient.transfer(request)
                        await send(.transferResponse(.success(record)))
                    } catch let error as TransferError {
                        await send(.transferResponse(.failure(error)))
                    } catch {
                        await send(.transferResponse(.failure(.invalidAmount)))
                    }
                }

            case .transferResponse(.success):
                state.isSending = false
                return .run { send in
                    await send(.delegate(.didComplete))
                    await dismiss()
                }

            case let .transferResponse(.failure(error)):
                state.isSending = false
                state.alert = AlertState {
                    TextState("Transfer failed")
                } message: {
                    TextState(error.errorDescription ?? "Something went wrong.")
                }
                return .none

            case .alert, .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

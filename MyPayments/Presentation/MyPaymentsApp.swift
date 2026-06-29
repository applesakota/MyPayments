import SwiftUI
import SwiftData

@main
struct MyPaymentsApp: App {
    @Environment(\.scenePhase) var scenePhase
    @AppStorage(Constant.Theme.selectedTheme) private var selectedThemeRaw: String = AppTheme.system.rawValue
    
    private let persistentModels: [any PersistentModel.Type]
    private let modelContainer: ModelContainer
    private let viewModel: MainApplicationViewModel
    
    init() {
        self.persistentModels = [
            User.self,
            AccountEntity.self,
            TransactionEntity.self
        ]
        
        do {
            let schema = Schema(persistentModels)
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: Self.isRunningTests
            )
            let modelContainer = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            self.modelContainer = modelContainer
            viewModel = MainApplicationViewModel(modelContainer: modelContainer)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainApplicationView(viewModel: viewModel)
        }
        .modelContainer(modelContainer)
    }
}

private extension MyPaymentsApp {
    static var isRunningTests: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}

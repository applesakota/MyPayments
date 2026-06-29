import Foundation
import SwiftData

@ModelActor
actor ModelActor: Sendable {
    
    var context: ModelContext { modelExecutor.modelContext }
    
    func fetchUser() throws -> User? {
        let descriptor = FetchDescriptor<User>()
        return try context.fetch(descriptor).first
    }
    
    func deleteAllUsers() throws {
        try context.delete(model: User.self)
    }
    
    func insertUser(_ user: User) throws {
        context.insert(user)
    }
    
    func save() throws {
        try context.save()
    }
}

// MARK: - Basic model interaction
extension ModelActor {
    func fetchModels<Model: PersistentModel>() throws -> [Model] {
        let descriptor = FetchDescriptor<Model>()
        return try context.fetch(descriptor)
    }
    
    func delete<Model: PersistentModel>(model: Model) {
        context.delete(model)
    }
    
    func deleteAll<Model: PersistentModel>(model: Model.Type) throws {
        try context.delete(model: model)
    }
    
    func insert<Model: PersistentModel>(model: Model) {
        context.insert(model)
    }
}

// MARK: - Stub
extension ModelActor {
    static func stub() -> ModelActor? {
        guard let modelContainer = try? ModelContainer() else {
            return nil
        }
        return .init(modelContainer: modelContainer)
    }
}

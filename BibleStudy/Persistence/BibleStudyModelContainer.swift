import Foundation
import SwiftData

enum BibleStudyMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [BibleStudySchemaV1.self]
    static let stages: [MigrationStage] = []
}

enum BibleStudyModelContainer {
    static func make(inMemory: Bool = false, storeURL: URL? = nil) throws -> ModelContainer {
        let schema = Schema(BibleStudySchemaV1.models)
        precondition(!inMemory || storeURL == nil, "An in-memory store cannot use a disk URL")

        let configuration: ModelConfiguration
        if let storeURL {
            configuration = ModelConfiguration(
                "BibleStudy",
                schema: schema,
                url: storeURL,
                cloudKitDatabase: .none
            )
        } else {
            configuration = ModelConfiguration(
                "BibleStudy",
                schema: schema,
                isStoredInMemoryOnly: inMemory,
                cloudKitDatabase: .none
            )
        }
        return try ModelContainer(
            for: schema,
            migrationPlan: BibleStudyMigrationPlan.self,
            configurations: [configuration]
        )
    }
}

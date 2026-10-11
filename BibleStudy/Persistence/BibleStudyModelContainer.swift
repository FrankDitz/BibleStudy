import SwiftData

enum BibleStudyMigrationPlan: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [BibleStudySchemaV1.self]
    static let stages: [MigrationStage] = []
}

enum BibleStudyModelContainer {
    static func make(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema(BibleStudySchemaV1.models)
        let configuration = ModelConfiguration(
            "BibleStudy",
            schema: schema,
            isStoredInMemoryOnly: inMemory,
            cloudKitDatabase: .none
        )
        return try ModelContainer(
            for: schema,
            migrationPlan: BibleStudyMigrationPlan.self,
            configurations: [configuration]
        )
    }
}

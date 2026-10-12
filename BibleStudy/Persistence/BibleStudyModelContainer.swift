import Foundation
import SwiftData

enum BibleStudyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [BibleStudySchemaV1.self, BibleStudySchemaV2.self]
    }
    static var stages: [MigrationStage] {
        [
            .lightweight(
                fromVersion: BibleStudySchemaV1.self,
                toVersion: BibleStudySchemaV2.self
            )
        ]
    }
}

enum BibleStudyModelContainer {
    static func make(inMemory: Bool = false, storeURL: URL? = nil) throws -> ModelContainer {
        let schema = Schema(BibleStudySchemaV2.models)
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
        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: BibleStudyMigrationPlan.self,
                configurations: [configuration]
            )
        } catch {
            // Early development builds changed the original schema before a versioned chain
            // existed. SwiftData reports those stores as an unknown staged-migration version,
            // even though this additive change can be inferred without deleting user data.
            return try ModelContainer(for: schema, configurations: [configuration])
        }
    }
}

import Foundation
import SwiftData

enum BibleStudySchemaV3: VersionedSchema {
    static let versionIdentifier = Schema.Version(3, 0, 0)

    static let models: [any PersistentModel.Type] = [
        BibleStudySchemaV1.Profile.self,
        BibleStudySchemaV1.ReadingPosition.self,
        BibleStudySchemaV1.ReadingPlan.self,
        BibleStudySchemaV1.PlanCompletionEvent.self,
        BibleStudySchemaV1.ScriptureAnnotation.self,
        BibleStudySchemaV1.LearningProgress.self,
        BibleStudySchemaV1.ContentProvenance.self,
        BibleStudySchemaV2.ActiveReadingPlan.self,
        BibleStudySchemaV2.PlanAssignmentCompletionEvent.self,
        VirtueFormationRecord.self,
    ]

    @Model
    final class VirtueFormationRecord {
        var id: UUID = UUID()
        var payload: Data = Data()
        var modifiedAt: Date = Date()
        var deletedAt: Date?

        init(
            id: UUID = UUID(),
            payload: Data,
            modifiedAt: Date = .now,
            deletedAt: Date? = nil
        ) {
            self.id = id
            self.payload = payload
            self.modifiedAt = modifiedAt
            self.deletedAt = deletedAt
        }
    }
}

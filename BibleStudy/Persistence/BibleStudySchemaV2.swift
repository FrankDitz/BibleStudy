import Foundation
import SwiftData

enum BibleStudySchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)

    static let models: [any PersistentModel.Type] = [
        BibleStudySchemaV1.Profile.self,
        BibleStudySchemaV1.ReadingPosition.self,
        BibleStudySchemaV1.ReadingPlan.self,
        BibleStudySchemaV1.PlanCompletionEvent.self,
        BibleStudySchemaV1.ScriptureAnnotation.self,
        BibleStudySchemaV1.LearningProgress.self,
        BibleStudySchemaV1.ContentProvenance.self,
        ActiveReadingPlan.self,
        PlanAssignmentCompletionEvent.self,
    ]

    @Model
    final class ActiveReadingPlan {
        var id: UUID = UUID()
        var title: String = ""
        var statusRawValue: String = ReadingPlanStatus.active.rawValue
        var payload: Data = Data()
        var pausedYear: Int?
        var pausedMonth: Int?
        var pausedDay: Int?
        var createdAt: Date = Date()
        var modifiedAt: Date = Date()
        var deletedAt: Date?

        init(
            id: UUID,
            title: String,
            status: ReadingPlanStatus = .active,
            payload: Data,
            pausedOn: PlanLocalDate? = nil,
            createdAt: Date = .now,
            modifiedAt: Date = .now,
            deletedAt: Date? = nil
        ) {
            self.id = id
            self.title = title
            statusRawValue = status.rawValue
            self.payload = payload
            pausedYear = pausedOn?.year
            pausedMonth = pausedOn?.month
            pausedDay = pausedOn?.day
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.deletedAt = deletedAt
        }

        var status: ReadingPlanStatus {
            get { ReadingPlanStatus(rawValue: statusRawValue) ?? .draft }
            set { statusRawValue = newValue.rawValue }
        }

        var pausedOn: PlanLocalDate? {
            get {
                guard let pausedYear, let pausedMonth, let pausedDay else { return nil }
                return PlanLocalDate(year: pausedYear, month: pausedMonth, day: pausedDay)
            }
            set {
                pausedYear = newValue?.year
                pausedMonth = newValue?.month
                pausedDay = newValue?.day
            }
        }
    }

    @Model
    final class PlanAssignmentCompletionEvent {
        var id: UUID = UUID()
        var planID: UUID = UUID()
        var assignmentID: String = ""
        var actionRawValue: String = PlanCompletionAction.completed.rawValue
        var occurredAt: Date = Date()
        var deviceID: String = ""

        init(
            id: UUID = UUID(),
            planID: UUID,
            assignmentID: String,
            action: PlanCompletionAction,
            occurredAt: Date = .now,
            deviceID: String
        ) {
            self.id = id
            self.planID = planID
            self.assignmentID = assignmentID
            actionRawValue = action.rawValue
            self.occurredAt = occurredAt
            self.deviceID = deviceID
        }

        var action: PlanCompletionAction {
            PlanCompletionAction(rawValue: actionRawValue) ?? .completed
        }
    }
}

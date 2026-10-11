import Foundation
import SwiftData

enum BibleStudySchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static let models: [any PersistentModel.Type] = [
        Profile.self,
        ReadingPosition.self,
        ReadingPlan.self,
        PlanCompletionEvent.self,
        ScriptureAnnotation.self,
        LearningProgress.self,
        ContentProvenance.self,
    ]

    @Model
    final class Profile {
        var id: UUID = UUID()
        var displayName: String?
        var createdAt: Date = Date()
        var modifiedAt: Date = Date()
        var deletedAt: Date?

        init(
            id: UUID = UUID(),
            displayName: String? = nil,
            createdAt: Date = .now,
            modifiedAt: Date = .now,
            deletedAt: Date? = nil
        ) {
            self.id = id
            self.displayName = displayName
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.deletedAt = deletedAt
        }
    }

    @Model
    final class ReadingPosition {
        var id: UUID = UUID()
        var editionProviderID: String = ""
        var editionValue: String = ""
        var canonicalBookID: String = "GEN"
        var chapter: Int = 1
        var verse: Int?
        var modifiedAt: Date = Date()
        var deletedAt: Date?

        init(
            id: UUID = UUID(),
            editionProviderID: String,
            editionValue: String,
            canonicalBookID: String,
            chapter: Int,
            verse: Int? = nil,
            modifiedAt: Date = .now,
            deletedAt: Date? = nil
        ) {
            self.id = id
            self.editionProviderID = editionProviderID
            self.editionValue = editionValue
            self.canonicalBookID = canonicalBookID
            self.chapter = chapter
            self.verse = verse
            self.modifiedAt = modifiedAt
            self.deletedAt = deletedAt
        }
    }

    @Model
    final class ReadingPlan {
        var id: UUID = UUID()
        var templateID: String?
        var title: String = ""
        var startDate: Date = Date()
        var statusRawValue: String = ReadingPlanStatus.draft.rawValue
        var scheduleVersion: Int = 1
        var createdAt: Date = Date()
        var modifiedAt: Date = Date()
        var deletedAt: Date?

        init(
            id: UUID = UUID(),
            templateID: String? = nil,
            title: String,
            startDate: Date,
            status: ReadingPlanStatus = .draft,
            scheduleVersion: Int = 1,
            createdAt: Date = .now,
            modifiedAt: Date = .now,
            deletedAt: Date? = nil
        ) {
            self.id = id
            self.templateID = templateID
            self.title = title
            self.startDate = startDate
            statusRawValue = status.rawValue
            self.scheduleVersion = scheduleVersion
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.deletedAt = deletedAt
        }

        var status: ReadingPlanStatus {
            get { ReadingPlanStatus(rawValue: statusRawValue) ?? .draft }
            set { statusRawValue = newValue.rawValue }
        }
    }

    @Model
    final class PlanCompletionEvent {
        var id: UUID = UUID()
        var planID: UUID = UUID()
        var dayIndex: Int = 0
        var actionRawValue: String = PlanCompletionAction.completed.rawValue
        var occurredAt: Date = Date()
        var deviceID: String = ""

        init(
            id: UUID = UUID(),
            planID: UUID,
            dayIndex: Int,
            action: PlanCompletionAction,
            occurredAt: Date = .now,
            deviceID: String
        ) {
            self.id = id
            self.planID = planID
            self.dayIndex = dayIndex
            actionRawValue = action.rawValue
            self.occurredAt = occurredAt
            self.deviceID = deviceID
        }

        var action: PlanCompletionAction {
            PlanCompletionAction(rawValue: actionRawValue) ?? .completed
        }
    }

    @Model
    final class ScriptureAnnotation {
        var id: UUID = UUID()
        var kindRawValue: String = ScriptureAnnotationKind.bookmark.rawValue
        var canonicalBookID: String = "GEN"
        var chapter: Int = 1
        var verseStart: Int?
        var verseEnd: Int?
        var editionProviderID: String?
        var editionValue: String?
        var noteText: String?
        var colorName: String?
        var createdAt: Date = Date()
        var modifiedAt: Date = Date()
        var deletedAt: Date?

        init(
            id: UUID = UUID(),
            kind: ScriptureAnnotationKind,
            canonicalBookID: String,
            chapter: Int,
            verseStart: Int? = nil,
            verseEnd: Int? = nil,
            editionProviderID: String? = nil,
            editionValue: String? = nil,
            noteText: String? = nil,
            colorName: String? = nil,
            createdAt: Date = .now,
            modifiedAt: Date = .now,
            deletedAt: Date? = nil
        ) {
            self.id = id
            kindRawValue = kind.rawValue
            self.canonicalBookID = canonicalBookID
            self.chapter = chapter
            self.verseStart = verseStart
            self.verseEnd = verseEnd
            self.editionProviderID = editionProviderID
            self.editionValue = editionValue
            self.noteText = noteText
            self.colorName = colorName
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.deletedAt = deletedAt
        }

        var kind: ScriptureAnnotationKind {
            get { ScriptureAnnotationKind(rawValue: kindRawValue) ?? .bookmark }
            set { kindRawValue = newValue.rawValue }
        }
    }

    @Model
    final class LearningProgress {
        var id: UUID = UUID()
        var contentID: String = ""
        var contentVersion: Int = 1
        var statusRawValue: String = LearningProgressStatus.notStarted.rawValue
        var completedAt: Date?
        var modifiedAt: Date = Date()
        var deletedAt: Date?

        init(
            id: UUID = UUID(),
            contentID: String,
            contentVersion: Int,
            status: LearningProgressStatus = .notStarted,
            completedAt: Date? = nil,
            modifiedAt: Date = .now,
            deletedAt: Date? = nil
        ) {
            self.id = id
            self.contentID = contentID
            self.contentVersion = contentVersion
            statusRawValue = status.rawValue
            self.completedAt = completedAt
            self.modifiedAt = modifiedAt
            self.deletedAt = deletedAt
        }

        var status: LearningProgressStatus {
            get { LearningProgressStatus(rawValue: statusRawValue) ?? .notStarted }
            set { statusRawValue = newValue.rawValue }
        }
    }

    @Model
    final class ContentProvenance {
        var id: UUID = UUID()
        var contentID: String = ""
        var contentVersion: Int = 1
        var sourceURL: String = ""
        var sourceLocator: String = ""
        var jurisdictionRawValue: String = "universal"
        var sourceCheckedAt: Date = Date()
        var reviewedAt: Date?
        var reviewBy: Date?
        var reviewerRole: String?
        var rightsNote: String?

        init(
            id: UUID = UUID(),
            contentID: String,
            contentVersion: Int,
            sourceURL: String,
            sourceLocator: String,
            jurisdictionRawValue: String,
            sourceCheckedAt: Date,
            reviewedAt: Date? = nil,
            reviewBy: Date? = nil,
            reviewerRole: String? = nil,
            rightsNote: String? = nil
        ) {
            self.id = id
            self.contentID = contentID
            self.contentVersion = contentVersion
            self.sourceURL = sourceURL
            self.sourceLocator = sourceLocator
            self.jurisdictionRawValue = jurisdictionRawValue
            self.sourceCheckedAt = sourceCheckedAt
            self.reviewedAt = reviewedAt
            self.reviewBy = reviewBy
            self.reviewerRole = reviewerRole
            self.rightsNote = rightsNote
        }
    }
}

enum ReadingPlanStatus: String, Codable, Sendable {
    case draft
    case active
    case paused
    case completed
    case archived
}

enum PlanCompletionAction: String, Codable, Sendable {
    case completed
    case reopened
}

enum ScriptureAnnotationKind: String, Codable, Sendable {
    case bookmark
    case highlight
    case note
}

enum LearningProgressStatus: String, Codable, Sendable {
    case notStarted
    case inProgress
    case completed
}

import Foundation

enum VirtueStudyCollection: String, Codable, CaseIterable, Sendable {
    case foundations
    case cardinal
    case christian

    var title: String {
        switch self {
        case .foundations: "Begin here"
        case .cardinal: "The cardinal virtues"
        case .christian: "Seven virtues against the capital sins"
        }
    }
}

struct VirtueLessonSection: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let body: String
}

struct VirtueKnowledgeCheck: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let prompt: String
    let options: [String]
    let correctOptionIndex: Int
    let explanation: String
}

struct VirtueSelfExaminationStep: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let question: String
    let guidance: String
}

/// Qualitative learning supports that turn a lecture into a repeatable formation loop.
/// They remain authored content: the app never infers a learner's conscience or moral state.
struct VirtueLessonFormationSupport: Codable, Equatable, Sendable {
    let workedCaseAnalysis: String
    let scriptureSynthesis: String
    let scriptureTransferQuestion: String
    let witnessTitle: String
    let witnessBody: String
    let supportingSourceIDs: [String]
    let selfExaminationIntroduction: String
    let selfExaminationExample: String
    let selfExaminationSteps: [VirtueSelfExaminationStep]
    let knowledgeChecks: [VirtueKnowledgeCheck]
}

struct VirtueStudyLesson: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let summary: String
    let estimatedMinutes: Int
    let sections: [VirtueLessonSection]
    let scriptureEncounters: [VirtueScriptureEncounter]
    let reflectionPrompts: [String]
    let sourceIDs: [String]
    let formationSupport: VirtueLessonFormationSupport?

    init(
        id: String,
        title: String,
        summary: String,
        estimatedMinutes: Int,
        sections: [VirtueLessonSection],
        scriptureEncounters: [VirtueScriptureEncounter],
        reflectionPrompts: [String],
        sourceIDs: [String],
        formationSupport: VirtueLessonFormationSupport? = nil
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.estimatedMinutes = estimatedMinutes
        self.sections = sections
        self.scriptureEncounters = scriptureEncounters
        self.reflectionPrompts = reflectionPrompts
        self.sourceIDs = sourceIDs
        self.formationSupport = formationSupport
    }
}

struct VirtueStudyCourse: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let collection: VirtueStudyCollection
    let virtueID: VirtueIdentifier?
    let title: String
    let subtitle: String
    let overview: String
    let whyItMatters: String
    let systemImage: String
    let contentVersion: Int
    let lessons: [VirtueStudyLesson]
    let sources: [VirtueContentSource]
    let review: VirtueContentReview

    var estimatedMinutes: Int {
        lessons.reduce(0) { $0 + $1.estimatedMinutes }
    }

    func source(id: String) -> VirtueContentSource? {
        sources.first { $0.id == id }
    }
}

struct VirtueCourseProgress: Identifiable, Codable, Equatable, Sendable {
    var id: String { courseID }

    let courseID: String
    let startedAt: Date
    var completedLessonIDs: Set<String>
    var lastOpenedLessonID: String?
    var beginningReflection: String?
    var endingReflection: String?
    var updatedAt: Date

    init(
        courseID: String,
        startedAt: Date,
        completedLessonIDs: Set<String> = [],
        lastOpenedLessonID: String? = nil,
        beginningReflection: String? = nil,
        endingReflection: String? = nil,
        updatedAt: Date
    ) {
        self.courseID = courseID
        self.startedAt = startedAt
        self.completedLessonIDs = completedLessonIDs
        self.lastOpenedLessonID = lastOpenedLessonID
        self.beginningReflection = beginningReflection
        self.endingReflection = endingReflection
        self.updatedAt = updatedAt
    }

    func completedLessonCount(in course: VirtueStudyCourse) -> Int {
        course.lessons.count { completedLessonIDs.contains($0.id) }
    }

    func isComplete(_ course: VirtueStudyCourse) -> Bool {
        !course.lessons.isEmpty && completedLessonCount(in: course) == course.lessons.count
    }
}

struct VirtueLessonReflection: Identifiable, Codable, Equatable, Sendable {
    var id: String { "\(courseID).\(lessonID)" }

    let courseID: String
    let lessonID: String
    var response: String
    var updatedAt: Date
}

enum VirtueCourseReflectionStage: Sendable {
    case beginning
    case ending
}

enum VirtueStudyError: Error, Equatable {
    case courseNotFound
    case lessonNotFound
}

enum VirtueStudyEngine {
    static func begin(
        courseID: String,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        guard VirtueStudyCatalog.course(id: courseID) != nil else {
            throw VirtueStudyError.courseNotFound
        }
        guard state.courseProgress.contains(where: { $0.courseID == courseID }) == false else {
            return
        }
        state.courseProgress.append(
            VirtueCourseProgress(courseID: courseID, startedAt: date, updatedAt: date)
        )
    }

    static func openLesson(
        courseID: String,
        lessonID: String,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        guard let course = VirtueStudyCatalog.course(id: courseID) else {
            throw VirtueStudyError.courseNotFound
        }
        guard course.lessons.contains(where: { $0.id == lessonID }) else {
            throw VirtueStudyError.lessonNotFound
        }
        try begin(courseID: courseID, in: &state, at: date)
        guard let index = state.courseProgress.firstIndex(where: { $0.courseID == courseID }) else {
            throw VirtueStudyError.courseNotFound
        }
        state.courseProgress[index].lastOpenedLessonID = lessonID
        state.courseProgress[index].updatedAt = date
    }

    static func setLessonCompleted(
        courseID: String,
        lessonID: String,
        completed: Bool,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        try openLesson(courseID: courseID, lessonID: lessonID, in: &state, at: date)
        guard let index = state.courseProgress.firstIndex(where: { $0.courseID == courseID }) else {
            throw VirtueStudyError.courseNotFound
        }
        if completed {
            state.courseProgress[index].completedLessonIDs.insert(lessonID)
        } else {
            state.courseProgress[index].completedLessonIDs.remove(lessonID)
        }
        state.courseProgress[index].updatedAt = date
    }

    static func saveCourseReflection(
        courseID: String,
        stage: VirtueCourseReflectionStage,
        text: String,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        try begin(courseID: courseID, in: &state, at: date)
        guard let index = state.courseProgress.firstIndex(where: { $0.courseID == courseID }) else {
            throw VirtueStudyError.courseNotFound
        }
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        switch stage {
        case .beginning:
            state.courseProgress[index].beginningReflection = cleaned.isEmpty ? nil : cleaned
        case .ending:
            state.courseProgress[index].endingReflection = cleaned.isEmpty ? nil : cleaned
        }
        state.courseProgress[index].updatedAt = date
    }

    static func saveLessonReflection(
        courseID: String,
        lessonID: String,
        text: String,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        try openLesson(courseID: courseID, lessonID: lessonID, in: &state, at: date)
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        state.lessonReflections.removeAll {
            $0.courseID == courseID && $0.lessonID == lessonID
        }
        guard !cleaned.isEmpty else { return }
        state.lessonReflections.append(
            VirtueLessonReflection(
                courseID: courseID,
                lessonID: lessonID,
                response: cleaned,
                updatedAt: date
            )
        )
    }
}

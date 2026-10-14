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

struct VirtueStudyLesson: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let summary: String
    let estimatedMinutes: Int
    let sections: [VirtueLessonSection]
    let scriptureEncounters: [VirtueScriptureEncounter]
    let reflectionPrompts: [String]
    let sourceIDs: [String]
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
    var updatedAt: Date

    init(
        courseID: String,
        startedAt: Date,
        completedLessonIDs: Set<String> = [],
        lastOpenedLessonID: String? = nil,
        updatedAt: Date
    ) {
        self.courseID = courseID
        self.startedAt = startedAt
        self.completedLessonIDs = completedLessonIDs
        self.lastOpenedLessonID = lastOpenedLessonID
        self.updatedAt = updatedAt
    }

    func completedLessonCount(in course: VirtueStudyCourse) -> Int {
        course.lessons.count { completedLessonIDs.contains($0.id) }
    }

    func isComplete(_ course: VirtueStudyCourse) -> Bool {
        !course.lessons.isEmpty && completedLessonCount(in: course) == course.lessons.count
    }
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
}

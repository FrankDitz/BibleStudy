import Foundation

enum VirtueStudyCatalog {
    static let foundationCourse = OrientationVirtueCurriculum.course
    static let christianCourses = CounterVirtueCurriculum.courses
    static let cardinalCourses = CardinalVirtueCurriculum.courses

    /// The learning sequence begins with the Catholic foundation, then studies the seven
    /// capital-sin counter-virtues before turning to the four cardinal virtues in depth.
    static let courses: [VirtueStudyCourse] =
        [foundationCourse] + christianCourses + cardinalCourses

    /// Only courses that pass the full mini-lecture acceptance gate are available to begin.
    /// This prevents research notes or short prototypes from being presented as finished teaching.
    static let lectureReadyCourseIDs = Set(
        courses.compactMap { course in
            course.lessons.allSatisfy { VirtueLectureStandard.issues(for: $0).isEmpty }
                ? course.id : nil
        }
    )

    static func course(id: String) -> VirtueStudyCourse? {
        courses.first { $0.id == id }
    }

    static func course(for virtueID: VirtueIdentifier) -> VirtueStudyCourse? {
        courses.first { $0.virtueID == virtueID }
    }

    static func isLectureReady(_ course: VirtueStudyCourse) -> Bool {
        lectureReadyCourseIDs.contains(course.id)
    }
}

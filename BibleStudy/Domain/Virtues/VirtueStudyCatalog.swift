import Foundation

enum VirtueStudyCatalog {
    static let foundationCourse = OrientationVirtueCurriculum.course
    static let christianCourses = CounterVirtueCurriculum.courses
    static let cardinalCourses = CardinalVirtueCurriculum.courses

    /// The learning sequence begins with the Catholic foundation, then studies the seven
    /// capital-sin counter-virtues before turning to the four cardinal virtues in depth.
    static let courses: [VirtueStudyCourse] =
        [foundationCourse] + christianCourses + cardinalCourses

    static func course(id: String) -> VirtueStudyCourse? {
        courses.first { $0.id == id }
    }

    static func course(for virtueID: VirtueIdentifier) -> VirtueStudyCourse? {
        courses.first { $0.virtueID == virtueID }
    }
}

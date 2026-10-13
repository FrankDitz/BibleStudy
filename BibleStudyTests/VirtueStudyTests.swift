import Foundation
import XCTest

@testable import BibleStudy

final class VirtueStudyTests: XCTestCase {
    func testCatalogContainsFoundationFourCardinalAndSevenChristianCourses() {
        XCTAssertEqual(VirtueStudyCatalog.courses.count, 12)
        XCTAssertEqual(VirtueStudyCatalog.cardinalCourses.count, 4)
        XCTAssertEqual(VirtueStudyCatalog.christianCourses.count, 7)
        XCTAssertEqual(Set(VirtueStudyCatalog.courses.map(\.id)).count, 12)
        XCTAssertEqual(
            Set(VirtueStudyCatalog.cardinalCourses.compactMap(\.virtueID)),
            Set([.prudence, .justice, .fortitude, .cardinalTemperance])
        )
        XCTAssertEqual(
            Set(VirtueStudyCatalog.christianCourses.compactMap(\.virtueID)),
            VirtueFormationCatalog.supportedIdentifiers
        )
    }

    func testEveryCourseHasCompleteUniqueSourceBackedLessons() {
        for course in VirtueStudyCatalog.courses {
            XCTAssertGreaterThanOrEqual(course.lessons.count, 4, course.id)
            XCTAssertFalse(course.overview.isEmpty, course.id)
            XCTAssertFalse(course.whyItMatters.isEmpty, course.id)
            XCTAssertFalse(course.sources.isEmpty, course.id)
            XCTAssertEqual(Set(course.lessons.map(\.id)).count, course.lessons.count, course.id)
            XCTAssertEqual(Set(course.sources.map(\.id)).count, course.sources.count, course.id)

            let availableSourceIDs = Set(course.sources.map(\.id))
            for lesson in course.lessons {
                XCTAssertGreaterThan(lesson.estimatedMinutes, 0, lesson.id)
                XCTAssertFalse(lesson.sections.isEmpty, lesson.id)
                XCTAssertFalse(lesson.scriptureEncounters.isEmpty, lesson.id)
                XCTAssertFalse(lesson.reflectionPrompts.isEmpty, lesson.id)
                XCTAssertFalse(lesson.sourceIDs.isEmpty, lesson.id)
                XCTAssertTrue(
                    Set(lesson.sourceIDs).isSubset(of: availableSourceIDs),
                    "Unknown source in \(course.id).\(lesson.id)"
                )
                XCTAssertTrue(
                    lesson.scriptureEncounters.allSatisfy {
                        CatholicCanon.contains(osisID: $0.reference.bookID)
                    },
                    "Non-Catholic-canon reference in \(course.id).\(lesson.id)"
                )
            }
        }
    }

    func testCardinalCoursesUseRickabyCatechismAndContemporaryChurchTeaching() {
        for course in VirtueStudyCatalog.cardinalCourses {
            let sourceIDs = Set(course.sources.map(\.id))
            XCTAssertTrue(sourceIDs.contains("rickaby-four-square"), course.id)
            XCTAssertTrue(sourceIDs.contains("ccc-human-virtues-study"), course.id)
            XCTAssertTrue(course.sources.contains(where: { $0.sourceClass == .universalChurch }), course.id)
            XCTAssertTrue(course.sources.contains(where: { $0.sourceClass == .scripture }), course.id)
        }
    }

    func testCourseProgressIsFactualReversibleAndCourseScoped() throws {
        let course = VirtueStudyCatalog.foundationCourse
        let firstLesson = try XCTUnwrap(course.lessons.first)
        var state = VirtueFormationState.empty
        let startedAt = Date(timeIntervalSince1970: 100)

        try VirtueStudyEngine.openLesson(
            courseID: course.id,
            lessonID: firstLesson.id,
            in: &state,
            at: startedAt
        )
        try VirtueStudyEngine.setLessonCompleted(
            courseID: course.id,
            lessonID: firstLesson.id,
            completed: true,
            in: &state,
            at: startedAt.addingTimeInterval(10)
        )

        var progress = try XCTUnwrap(state.courseProgress.first)
        XCTAssertEqual(state.courseProgress.count, 1)
        XCTAssertEqual(progress.courseID, course.id)
        XCTAssertEqual(progress.lastOpenedLessonID, firstLesson.id)
        XCTAssertEqual(progress.completedLessonCount(in: course), 1)
        XCTAssertFalse(progress.isComplete(course))

        try VirtueStudyEngine.setLessonCompleted(
            courseID: course.id,
            lessonID: firstLesson.id,
            completed: false,
            in: &state
        )
        progress = try XCTUnwrap(state.courseProgress.first)
        XCTAssertEqual(progress.completedLessonCount(in: course), 0)
    }

    func testLegacyFormationPayloadDecodesWithNoCourseProgress() throws {
        let state = try JSONDecoder().decode(
            VirtueFormationState.self,
            from: Data(#"{"cycles":[],"checkIns":[]}"#.utf8)
        )

        XCTAssertTrue(state.courseProgress.isEmpty)
    }

    func testUnknownCourseAndLessonFailClosed() throws {
        var state = VirtueFormationState.empty
        XCTAssertThrowsError(
            try VirtueStudyEngine.begin(courseID: "missing", in: &state)
        ) { error in
            XCTAssertEqual(error as? VirtueStudyError, .courseNotFound)
        }
        XCTAssertThrowsError(
            try VirtueStudyEngine.openLesson(
                courseID: VirtueStudyCatalog.foundationCourse.id,
                lessonID: "missing",
                in: &state
            )
        ) { error in
            XCTAssertEqual(error as? VirtueStudyError, .lessonNotFound)
        }
        XCTAssertTrue(state.courseProgress.isEmpty)
    }
}

import Foundation
import XCTest

@testable import BibleStudy

final class VirtueStudyTests: XCTestCase {
    func testCatalogContainsOrientationSevenCounterVirtueAndFourCardinalCourses() {
        XCTAssertEqual(VirtueStudyCatalog.courses.count, 12)
        XCTAssertEqual(VirtueStudyCatalog.cardinalCourses.count, 4)
        XCTAssertEqual(VirtueStudyCatalog.christianCourses.count, 7)
        XCTAssertEqual(VirtueStudyCatalog.courses.reduce(0) { $0 + $1.lessons.count }, 121)
        XCTAssertEqual(Set(VirtueStudyCatalog.courses.map(\.id)).count, 12)
        XCTAssertEqual(VirtueStudyCatalog.courses.first?.id, "virtue-foundations")
        XCTAssertEqual(
            Array(VirtueStudyCatalog.courses.dropFirst(1).prefix(7).map(\.collection)),
            Array(repeating: .christian, count: 7)
        )
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
            XCTAssertEqual(course.contentVersion, course.id == "virtue-foundations" ? 3 : 2, course.id)
            XCTAssertEqual(course.lessons.count, course.id == "virtue-foundations" ? 11 : 10, course.id)
            XCTAssertFalse(course.overview.isEmpty, course.id)
            XCTAssertFalse(course.whyItMatters.isEmpty, course.id)
            XCTAssertFalse(course.sources.isEmpty, course.id)
            XCTAssertEqual(course.review.state, .inReview, course.id)
            XCTAssertEqual(course.review.reviewerRole, "Qualified Catholic reviewer pending", course.id)
            XCTAssertEqual(Set(course.lessons.map(\.id)).count, course.lessons.count, course.id)
            XCTAssertEqual(Set(course.sources.map(\.id)).count, course.sources.count, course.id)

            let availableSourceIDs = Set(course.sources.map(\.id))
            for lesson in course.lessons {
                XCTAssertGreaterThan(lesson.estimatedMinutes, 0, lesson.id)
                XCTAssertGreaterThanOrEqual(lesson.sections.count, 6, lesson.id)
                XCTAssertFalse(lesson.scriptureEncounters.isEmpty, lesson.id)
                XCTAssertGreaterThanOrEqual(lesson.reflectionPrompts.count, 3, lesson.id)
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

    func testFoundationCourseMeetsFullLectureStandard() {
        let course = VirtueStudyCatalog.foundationCourse

        for lesson in course.lessons {
            let metrics = VirtueLectureStandard.metrics(for: lesson)
            let issues = VirtueLectureStandard.issues(for: lesson)

            XCTAssertTrue(
                issues.isEmpty,
                "\(lesson.id) failed the lecture standard with \(issues.map(\.rawValue).sorted()); "
                    + "instructional=\(metrics.instructionalWords), total=\(metrics.totalSectionWords), "
                    + "passages=\(metrics.scripturePassages), verses=\(metrics.scriptureVerses), "
                    + "review=\(metrics.reviewPrompts), minutes=\(metrics.estimatedMinutes)"
            )
        }

        XCTAssertTrue(VirtueCourseLearningStandard.issues(for: course).isEmpty)
        XCTAssertGreaterThanOrEqual(
            course.lessons.filter { $0.formationSupport?.knowledgeChecks.isEmpty == false }.count,
            3
        )
        XCTAssertFalse(course.lessons.last?.formationSupport?.knowledgeChecks.isEmpty ?? true)
    }

    func testFoundationCourseHasConscienceAndFormationSupports() throws {
        let course = VirtueStudyCatalog.foundationCourse
        let conscience = try XCTUnwrap(
            course.lessons.first { $0.id == "foundations-conscience" }
        )

        XCTAssertTrue(conscience.sourceIDs.contains("ccc-moral-acts-study"))
        XCTAssertTrue(conscience.sourceIDs.contains("ccc-conscience-study"))
        XCTAssertGreaterThanOrEqual(conscience.scriptureEncounters.count, 3)

        for lesson in course.lessons {
            let support = try XCTUnwrap(lesson.formationSupport, lesson.id)
            XCTAssertGreaterThanOrEqual(support.selfExaminationPrompts.count, 9, lesson.id)
            XCTAssertFalse(support.workedCaseAnalysis.isEmpty, lesson.id)
            XCTAssertFalse(support.scriptureSynthesis.isEmpty, lesson.id)
            XCTAssertFalse(support.scriptureTransferQuestion.isEmpty, lesson.id)
            XCTAssertFalse(support.witnessBody.isEmpty, lesson.id)
            XCTAssertTrue(
                Set(support.supportingSourceIDs).isSubset(of: Set(lesson.sourceIDs)),
                lesson.id
            )
        }
    }

    func testOnlyCoursesPassingTheLectureGateAreAvailable() {
        XCTAssertEqual(VirtueStudyCatalog.lectureReadyCourseIDs, ["virtue-foundations"])

        for course in VirtueStudyCatalog.courses {
            let actuallyReady =
                course.lessons.allSatisfy {
                    VirtueLectureStandard.issues(for: $0).isEmpty
                } && VirtueCourseLearningStandard.issues(for: course).isEmpty
            XCTAssertEqual(
                VirtueStudyCatalog.isLectureReady(course),
                actuallyReady,
                course.id
            )
        }
    }

    func testCardinalCoursesUseRickabyCatechismAndContemporaryChurchTeaching() {
        for course in VirtueStudyCatalog.cardinalCourses {
            let sourceIDs = Set(course.sources.map(\.id))
            XCTAssertTrue(sourceIDs.contains("rickaby-four-square"), course.id)
            XCTAssertTrue(sourceIDs.contains("ccc-human-virtues-study"), course.id)
            XCTAssertTrue(course.sources.contains(where: { $0.sourceClass == .universalChurch }), course.id)
            XCTAssertEqual(
                course.sources.first(where: { $0.id == "rickaby-four-square" })?.sourceClass,
                .reviewedSecondary,
                course.id
            )
            XCTAssertGreaterThan(course.sources.count, 1, course.id)
        }
    }

    func testCounterVirtueCoursesUseTheExactCatholicPairs() {
        let expected: [(VirtueIdentifier, String)] = [
            (.humility, "Humility against Pride"),
            (.charity, "Charity and Generosity against Avarice"),
            (.kindness, "Kindness and Goodwill against Envy"),
            (.patience, "Patience and Meekness against Wrath"),
            (.chastity, "Chastity against Lust"),
            (.temperance, "Temperance against Gluttony"),
            (.diligence, "Diligence and Perseverance against Sloth and Acedia"),
        ]

        XCTAssertEqual(VirtueStudyCatalog.christianCourses.compactMap(\.virtueID), expected.map(\.0))
        XCTAssertEqual(VirtueStudyCatalog.christianCourses.map(\.title), expected.map(\.1))
        for course in VirtueStudyCatalog.christianCourses {
            XCTAssertTrue(course.sources.contains(where: { $0.id == "ccc-capital-sins-study" }))
            XCTAssertFalse(course.sources.contains(where: { $0.id == "rickaby-four-square" }))
        }
    }

    func testLegacyCourseAndLessonIdentifiersRemainAvailable() {
        XCTAssertNotNil(VirtueStudyCatalog.course(id: "virtue-foundations"))
        XCTAssertNotNil(VirtueStudyCatalog.course(id: "cardinal-prudence"))
        XCTAssertNotNil(VirtueStudyCatalog.course(id: "cardinal-justice"))
        XCTAssertNotNil(VirtueStudyCatalog.course(id: "cardinal-fortitude"))
        XCTAssertNotNil(VirtueStudyCatalog.course(id: "cardinal-temperance"))

        for course in VirtueStudyCatalog.christianCourses {
            guard let virtueID = course.virtueID else {
                XCTFail("Missing virtue identifier for \(course.id)")
                continue
            }
            XCTAssertEqual(
                course.id,
                "christian-\(virtueID.rawValue.replacingOccurrences(of: ".", with: "-"))"
            )
            let legacySuffixes = ["meaning", "distortions", "scripture", "practice"]
            for suffix in legacySuffixes {
                XCTAssertNotNil(
                    course.lessons.first { $0.id == "\(virtueID.rawValue)-\(suffix)" },
                    "Missing legacy lesson \(virtueID.rawValue)-\(suffix)"
                )
            }
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

    func testPrivateCourseAndLessonReflectionsAreReversibleAndBackwardCompatible() throws {
        let course = VirtueStudyCatalog.foundationCourse
        let lesson = try XCTUnwrap(course.lessons.first)
        var state = VirtueFormationState.empty

        try VirtueStudyEngine.saveCourseReflection(
            courseID: course.id,
            stage: .beginning,
            text: "  I think virtue is mostly self-control.  ",
            in: &state
        )
        try VirtueStudyEngine.saveCourseReflection(
            courseID: course.id,
            stage: .ending,
            text: "I now see grace, relationship, and ordered love.",
            in: &state
        )
        try VirtueStudyEngine.saveLessonReflection(
            courseID: course.id,
            lessonID: lesson.id,
            text: "  A private examination.  ",
            in: &state
        )

        XCTAssertEqual(state.courseProgress.first?.beginningReflection, "I think virtue is mostly self-control.")
        XCTAssertEqual(
            state.courseProgress.first?.endingReflection,
            "I now see grace, relationship, and ordered love."
        )
        XCTAssertEqual(state.lessonReflections.first?.response, "A private examination.")

        try VirtueStudyEngine.saveLessonReflection(
            courseID: course.id,
            lessonID: lesson.id,
            text: " ",
            in: &state
        )
        XCTAssertTrue(state.lessonReflections.isEmpty)
    }

    func testLegacyFormationPayloadDecodesWithNoCourseProgress() throws {
        let state = try JSONDecoder().decode(
            VirtueFormationState.self,
            from: Data(#"{"cycles":[],"checkIns":[]}"#.utf8)
        )

        XCTAssertTrue(state.courseProgress.isEmpty)
        XCTAssertTrue(state.lessonReflections.isEmpty)
    }

    func testLegacyCourseProgressDecodesWithoutPrivateReflections() throws {
        let state = try JSONDecoder().decode(
            VirtueFormationState.self,
            from: Data(
                #"""
                {
                  "cycles": [],
                  "checkIns": [],
                  "courseProgress": [{
                    "courseID": "virtue-foundations",
                    "startedAt": 0,
                    "completedLessonIDs": ["foundations-happiness"],
                    "lastOpenedLessonID": "foundations-happiness",
                    "updatedAt": 10
                  }]
                }
                """#.utf8
            )
        )

        let progress = try XCTUnwrap(state.courseProgress.first)
        XCTAssertNil(progress.beginningReflection)
        XCTAssertNil(progress.endingReflection)
        XCTAssertTrue(state.lessonReflections.isEmpty)
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

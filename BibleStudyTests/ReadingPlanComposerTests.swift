import XCTest

@testable import BibleStudy

final class ReadingPlanComposerTests: XCTestCase {
    func testEveryChapterIsAnIndependentChecklistAssignment() throws {
        let preview = try composer.preview(
            draft(scope: .books(["MATT"]), pace: .chaptersPerReadingDay(3))
        )

        let firstDay = try XCTUnwrap(preview.days.first)
        XCTAssertEqual(firstDay.assignments.map(\.displayTitle), ["Matthew 1", "Matthew 2", "Matthew 3"])
        XCTAssertTrue(firstDay.assignments.allSatisfy { $0.chapterCount == 1 })
    }

    private let calendar = makeCalendar(timeZone: "America/New_York")

    func testChaptersPerDayUsesOnlyEligibleWeekdaysAndKeepsFinalPartialDay() throws {
        let preview = try composer.preview(
            draft(
                scope: .books(["JOHN"]),
                pace: .chaptersPerReadingDay(5),
                startDate: date(2026, 10, 9),
                eligibleWeekdays: [.monday, .wednesday, .friday]
            )
        )

        XCTAssertEqual(preview.readingDayCount, 5)
        XCTAssertEqual(preview.days.map(\.chapterCount), [5, 5, 5, 5, 1])
        XCTAssertEqual(
            preview.schedule.map(\.scheduledDate),
            [
                date(2026, 10, 9), date(2026, 10, 12), date(2026, 10, 14),
                date(2026, 10, 16), date(2026, 10, 19),
            ]
        )
    }

    func testFinishByBalancesCoverageAcrossTheAvailableWindow() throws {
        let preview = try composer.preview(
            draft(
                scope: .books(["GEN"]),
                pace: .finishBy(date(2026, 10, 10)),
                startDate: date(2026, 10, 1)
            )
        )

        XCTAssertEqual(preview.readingDayCount, 10)
        XCTAssertEqual(preview.days.map(\.chapterCount), Array(repeating: 5, count: 10))
        XCTAssertEqual(preview.scheduledStartDate, date(2026, 10, 1))
        XCTAssertEqual(preview.scheduledFinishDate, date(2026, 10, 10))
        XCTAssertEqual(preview.restDayCount, 0)
    }

    func testFinishBySpreadsShortScopeWithoutInventingEmptyReadingDays() throws {
        let preview = try composer.preview(
            draft(
                scope: .books(["RUTH"]),
                pace: .finishBy(date(2026, 10, 31)),
                startDate: date(2026, 10, 1)
            )
        )

        XCTAssertEqual(preview.readingDayCount, 4)
        XCTAssertEqual(
            preview.schedule.map(\.scheduledDate),
            [
                date(2026, 10, 1), date(2026, 10, 11),
                date(2026, 10, 21), date(2026, 10, 31),
            ]
        )
        XCTAssertEqual(preview.days.map(\.chapterCount), [1, 1, 1, 1])
        XCTAssertEqual(preview.restDayCount, 27)
    }

    func testSelectedBooksUseCatholicCanonicalOrderAndExactCoverage() throws {
        let preview = try composer.preview(
            draft(
                scope: .books([" john ", "MARK"]),
                pace: .chaptersPerReadingDay(4)
            )
        )
        let chapters = preview.days.flatMap(\.assignments).flatMap(\.chapters)

        XCTAssertEqual(chapters.count, 37)
        XCTAssertEqual(chapters.first, CanonicalChapter(bookID: "MARK", chapter: 1))
        XCTAssertEqual(chapters.last, CanonicalChapter(bookID: "JOHN", chapter: 21))
        XCTAssertEqual(Set(chapters).count, chapters.count)
    }

    func testInterleavingPreservesOrderWithinBothTestamentsAndCoversWholeCanon() throws {
        let preview = try composer.preview(
            draft(
                scope: .catholicBible,
                pace: .chaptersPerReadingDay(4),
                ordering: .interleaveTestaments
            )
        )
        let chapters = preview.days.flatMap(\.assignments).flatMap(\.chapters)
        let oldTestament = chapters.filter {
            CatholicCanon.book(osisID: $0.bookID)?.testament == .old
        }
        let newTestament = chapters.filter {
            CatholicCanon.book(osisID: $0.bookID)?.testament == .new
        }

        XCTAssertEqual(chapters.count, 1_333)
        XCTAssertEqual(Set(chapters).count, 1_333)
        XCTAssertEqual(oldTestament, CatholicChapterManifest.cpdvV1.chapters(in: .old))
        XCTAssertEqual(newTestament, CatholicChapterManifest.cpdvV1.chapters(in: .new))
        XCTAssertTrue(chapters.prefix(20).contains { $0.bookID == "MATT" })
    }

    func testExactVersePassageIsPreservedInPreviewAssignment() throws {
        let passage = try CustomPlanPassage(
            bookID: "john",
            chapter: 3,
            verseStart: 16,
            verseEnd: 18
        )
        let preview = try composer.preview(
            draft(scope: .passage(passage), pace: .chaptersPerReadingDay(1))
        )
        let assignment = try XCTUnwrap(preview.days.first?.assignments.first)

        XCTAssertEqual(assignment.bookID, "JOHN")
        XCTAssertEqual(assignment.startChapter, 3)
        XCTAssertEqual(assignment.endChapter, 3)
        XCTAssertEqual(assignment.verseStart, 16)
        XCTAssertEqual(assignment.verseEnd, 18)
        XCTAssertEqual(
            try assignment.scriptureReference(versionID: 42).passageID,
            "JOHN.3.16-18"
        )
    }

    func testPreviewRetainsRecoveryAndReminderPreferences() throws {
        let reminder = PlanReminderTime(hour: 7, minute: 30)
        let source = draft(
            scope: .books(["LUKE"]),
            pace: .chaptersPerReadingDay(2),
            recoveryPreference: .redistribute,
            reminderTime: reminder
        )

        let preview = try composer.preview(source)

        XCTAssertEqual(preview.draft.recoveryPreference, .redistribute)
        XCTAssertEqual(preview.draft.reminderTime, reminder)
        XCTAssertEqual(preview.normalizedTitle, "My Plan")
    }

    func testDemandingWorkloadIsDisclosed() throws {
        let preview = try composer.preview(
            draft(
                scope: .catholicBible,
                pace: .finishBy(date(2027, 1, 8)),
                startDate: date(2026, 10, 11)
            )
        )

        XCTAssertTrue(
            preview.warnings.contains(
                .demandingDailyLoad(maximumChapters: preview.maximumDailyChapters)
            )
        )
        XCTAssertGreaterThanOrEqual(preview.maximumDailyChapters, 10)
    }

    func testInvalidInputsFailExplicitly() throws {
        XCTAssertThrowsError(
            try composer.preview(draft(title: "   "))
        ) { error in
            XCTAssertEqual(error as? ReadingPlanComposerError, .blankTitle)
        }
        XCTAssertThrowsError(
            try composer.preview(draft(scope: .books([])))
        ) { error in
            XCTAssertEqual(error as? ReadingPlanComposerError, .emptyScope)
        }
        XCTAssertThrowsError(
            try composer.preview(draft(eligibleWeekdays: []))
        ) { error in
            XCTAssertEqual(error as? ReadingPlanComposerError, .emptyEligibleWeekdays)
        }
        XCTAssertThrowsError(
            try composer.preview(draft(pace: .chaptersPerReadingDay(0)))
        ) { error in
            XCTAssertEqual(error as? ReadingPlanComposerError, .invalidChapterPace)
        }
        XCTAssertThrowsError(
            try composer.preview(
                draft(
                    pace: .finishBy(date(2026, 9, 30)),
                    startDate: date(2026, 10, 1)
                )
            )
        ) { error in
            XCTAssertEqual(error as? ReadingPlanComposerError, .finishDateBeforeStartDate)
        }
        XCTAssertThrowsError(
            try composer.preview(draft(reminderTime: .init(hour: 24, minute: 0)))
        ) { error in
            XCTAssertEqual(error as? ReadingPlanComposerError, .invalidReminderTime)
        }
    }

    func testInterleavingRequiresBooksFromBothTestaments() {
        XCTAssertThrowsError(
            try composer.preview(
                draft(
                    scope: .testament(.new),
                    ordering: .interleaveTestaments
                )
            )
        ) { error in
            XCTAssertEqual(
                error as? ReadingPlanComposerError,
                .interleavingRequiresBothTestaments
            )
        }
    }

    func testPassageMustExistInCompatibleManifest() throws {
        let passage = try CustomPlanPassage(bookID: "JOHN", chapter: 99)

        XCTAssertThrowsError(
            try composer.preview(draft(scope: .passage(passage)))
        ) { error in
            XCTAssertEqual(error as? ReadingPlanComposerError, .passageOutsideManifest)
        }
    }

    private var composer: ReadingPlanComposer {
        ReadingPlanComposer(calendar: calendar)
    }

    private func draft(
        title: String = "  My Plan  ",
        scope: CustomReadingPlanScope = .testament(.new),
        pace: CustomPlanPace = .chaptersPerReadingDay(3),
        startDate: PlanLocalDate = PlanLocalDate(year: 2026, month: 10, day: 1),
        eligibleWeekdays: Set<PlanWeekday> = PlanWeekday.everyDay,
        ordering: CustomPlanOrdering = .canonical,
        recoveryPreference: CustomPlanRecoveryPreference = .keepDates,
        reminderTime: PlanReminderTime? = nil
    ) -> CustomReadingPlanDraft {
        CustomReadingPlanDraft(
            title: title,
            scope: scope,
            pace: pace,
            startDate: startDate,
            eligibleWeekdays: eligibleWeekdays,
            ordering: ordering,
            recoveryPreference: recoveryPreference,
            reminderTime: reminderTime
        )
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> PlanLocalDate {
        PlanLocalDate(year: year, month: month, day: day)
    }

    private static func makeCalendar(timeZone identifier: String) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(identifier: identifier)!
        return calendar
    }

    private func makeCalendar(timeZone identifier: String) -> Calendar {
        Self.makeCalendar(timeZone: identifier)
    }
}

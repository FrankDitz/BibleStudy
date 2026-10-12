import XCTest

@testable import BibleStudy

final class ReadingPlanSchedulerTests: XCTestCase {
    private let newYorkCalendar = makeCalendar(timeZone: "America/New_York")

    func testDailySchedulePreservesLocalDatesAcrossDSTStart() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)

        let schedule = try scheduler.schedule(
            logicalDayCount: 4,
            rules: PlanScheduleRules(startDate: date(2025, 3, 8))
        )

        XCTAssertEqual(
            schedule.map(\.scheduledDate),
            [date(2025, 3, 8), date(2025, 3, 9), date(2025, 3, 10), date(2025, 3, 11)]
        )
    }

    func testScheduleIncludesLeapDay() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)

        let schedule = try scheduler.schedule(
            logicalDayCount: 3,
            rules: PlanScheduleRules(startDate: date(2024, 2, 28))
        )

        XCTAssertEqual(
            schedule.map(\.scheduledDate),
            [date(2024, 2, 28), date(2024, 2, 29), date(2024, 3, 1)]
        )
    }

    func testDailySchedulePreservesLocalDatesAcrossDSTEnd() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)

        let schedule = try scheduler.schedule(
            logicalDayCount: 3,
            rules: PlanScheduleRules(startDate: date(2026, 10, 31))
        )

        XCTAssertEqual(
            schedule.map(\.scheduledDate),
            [date(2026, 10, 31), date(2026, 11, 1), date(2026, 11, 2)]
        )
    }

    func testScheduleSkipsIneligibleWeekdays() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let weekdays: Set<PlanWeekday> = [.monday, .wednesday, .friday]

        let schedule = try scheduler.schedule(
            logicalDayCount: 4,
            rules: PlanScheduleRules(
                startDate: date(2026, 10, 9),
                eligibleWeekdays: weekdays
            )
        )

        XCTAssertEqual(
            schedule.map(\.scheduledDate),
            [date(2026, 10, 9), date(2026, 10, 12), date(2026, 10, 14), date(2026, 10, 16)]
        )
    }

    func testLocalScheduleDoesNotShiftWhenViewedInAnotherTimeZone() throws {
        let start = date(2026, 11, 1)
        let newYork = try ReadingPlanScheduler(calendar: newYorkCalendar).schedule(
            logicalDayCount: 2,
            rules: PlanScheduleRules(startDate: start)
        )
        let losAngeles = try ReadingPlanScheduler(
            calendar: Self.makeCalendar(timeZone: "America/Los_Angeles")
        ).schedule(
            logicalDayCount: 2,
            rules: PlanScheduleRules(startDate: start)
        )

        XCTAssertEqual(newYork, losAngeles)
    }

    func testProgressReportsMissedDaysAndReadingAhead() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let schedule = try scheduler.schedule(
            logicalDayCount: 5,
            rules: PlanScheduleRules(startDate: date(2026, 10, 1))
        )

        XCTAssertEqual(
            scheduler.progress(schedule: schedule, events: [], asOf: date(2026, 10, 3)).pace,
            .behind(days: 3)
        )

        let events = [
            completion(day: 1, at: 1),
            completion(day: 2, at: 2),
            completion(day: 3, at: 3),
            completion(day: 4, at: 4),
        ]
        XCTAssertEqual(
            scheduler.progress(schedule: schedule, events: events, asOf: date(2026, 10, 2)).pace,
            .ahead(days: 2)
        )
    }

    func testCompletionReversalAndDuplicateEventAreIdempotent() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let schedule = try scheduler.schedule(
            logicalDayCount: 2,
            rules: PlanScheduleRules(startDate: date(2026, 10, 1))
        )
        let first = completion(day: 1, at: 1)
        let events = [
            first,
            first,
            PlanDayCompletionEvent(
                logicalDayIndex: 1,
                action: .reopened,
                occurredAt: Date(timeIntervalSince1970: 2),
                deviceID: "phone"
            ),
        ]

        let progress = scheduler.progress(
            schedule: schedule,
            events: events,
            asOf: date(2026, 10, 1)
        )

        XCTAssertEqual(progress.completedCount, 0)
        XCTAssertEqual(progress.pace, .behind(days: 1))
    }

    func testCompletingEveryDayMarksPlanCompleteEvenWhenEarly() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let schedule = try scheduler.schedule(
            logicalDayCount: 2,
            rules: PlanScheduleRules(startDate: date(2026, 10, 10))
        )

        let progress = scheduler.progress(
            schedule: schedule,
            events: [completion(day: 1, at: 1), completion(day: 2, at: 2)],
            asOf: date(2026, 10, 1)
        )

        XCTAssertEqual(progress.pace, .complete)
    }

    func testPauseResumeMovesOnlyUnfinishedAffectedDays() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let rules = PlanScheduleRules(startDate: date(2026, 10, 1))
        let schedule = try scheduler.schedule(logicalDayCount: 4, rules: rules)

        let revision = try scheduler.resume(
            schedule: schedule,
            events: [completion(day: 2, at: 1)],
            pausedOn: date(2026, 10, 2),
            resumesOn: date(2026, 10, 10),
            rules: rules,
            createdAt: Date(timeIntervalSince1970: 10)
        )
        let resumed = revision.revisedSchedule

        XCTAssertEqual(resumed[0].scheduledDate, date(2026, 10, 1))
        XCTAssertEqual(resumed[1].scheduledDate, date(2026, 10, 2))
        XCTAssertEqual(resumed[2].scheduledDate, date(2026, 10, 10))
        XCTAssertEqual(resumed[3].scheduledDate, date(2026, 10, 11))
        XCTAssertEqual(
            revision.reason,
            .resumed(pausedOn: date(2026, 10, 2), resumesOn: date(2026, 10, 10))
        )
    }

    func testShiftForwardPreservesCompletedDaysAndUnreadWorkload() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let rules = PlanScheduleRules(startDate: date(2026, 10, 1))
        let schedule = try scheduler.schedule(logicalDayCount: 4, rules: rules)

        let revision = try scheduler.recover(
            schedule: schedule,
            events: [completion(day: 1, at: 1)],
            asOf: date(2026, 10, 10),
            mode: .shiftForward,
            rules: rules
        )

        XCTAssertEqual(
            revision.revisedSchedule.map(\.scheduledDate),
            [date(2026, 10, 1), date(2026, 10, 10), date(2026, 10, 11), date(2026, 10, 12)]
        )
    }

    func testRedistributeUsesAvailableWindowWithoutChangingLogicalOrder() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let rules = PlanScheduleRules(
            startDate: date(2026, 10, 1),
            eligibleWeekdays: [.monday, .wednesday, .friday]
        )
        let schedule = try scheduler.schedule(logicalDayCount: 5, rules: rules)

        let revision = try scheduler.recover(
            schedule: schedule,
            events: [],
            asOf: date(2026, 10, 12),
            mode: .redistribute(through: date(2026, 10, 16)),
            rules: rules
        )

        XCTAssertEqual(
            revision.revisedSchedule.map(\.scheduledDate),
            [
                date(2026, 10, 12),
                date(2026, 10, 12),
                date(2026, 10, 14),
                date(2026, 10, 14),
                date(2026, 10, 16),
            ]
        )
    }

    func testKeepDatesRecordsAnUnchangedRevision() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)
        let rules = PlanScheduleRules(startDate: date(2026, 10, 1))
        let schedule = try scheduler.schedule(logicalDayCount: 3, rules: rules)

        let revision = try scheduler.recover(
            schedule: schedule,
            events: [],
            asOf: date(2026, 10, 10),
            mode: .keepDates,
            rules: rules,
            createdAt: Date(timeIntervalSince1970: 10)
        )

        XCTAssertEqual(revision.previousSchedule, schedule)
        XCTAssertEqual(revision.revisedSchedule, schedule)
        XCTAssertEqual(revision.createdAt, Date(timeIntervalSince1970: 10))
    }

    func testInvalidRulesAndRecoveryWindowsFailExplicitly() throws {
        let scheduler = ReadingPlanScheduler(calendar: newYorkCalendar)

        XCTAssertThrowsError(
            try scheduler.schedule(
                logicalDayCount: 1,
                rules: PlanScheduleRules(
                    startDate: date(2026, 10, 1),
                    eligibleWeekdays: []
                )
            )
        ) { error in
            XCTAssertEqual(error as? ReadingPlanSchedulerError, .emptyEligibleWeekdays)
        }

        let rules = PlanScheduleRules(startDate: date(2026, 10, 1))
        let schedule = try scheduler.schedule(logicalDayCount: 1, rules: rules)
        XCTAssertThrowsError(
            try scheduler.recover(
                schedule: schedule,
                events: [],
                asOf: date(2026, 10, 10),
                mode: .newFinishDate(date(2026, 10, 9)),
                rules: rules
            )
        ) { error in
            XCTAssertEqual(
                error as? ReadingPlanSchedulerError,
                .finishDateBeforeRecoveryDate
            )
        }
    }

    private func completion(day: Int, at time: TimeInterval) -> PlanDayCompletionEvent {
        PlanDayCompletionEvent(
            logicalDayIndex: day,
            action: .completed,
            occurredAt: Date(timeIntervalSince1970: time),
            deviceID: "phone"
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
}

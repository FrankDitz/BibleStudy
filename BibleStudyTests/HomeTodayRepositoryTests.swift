import SwiftData
import XCTest

@testable import BibleStudy

@MainActor
final class HomeTodayRepositoryTests: XCTestCase {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        return calendar
    }

    func testTodayUsesSavedReadingAndExactNextPlanChapter() throws {
        let (repository, context) = try makeRepository()
        try ReadingPositionRepository(modelContext: context).save(
            try ScriptureReference(versionID: 42, bookID: "MATT", chapter: 5),
            provider: .youVersion,
            at: date(2026, 10, 13, 8)
        )
        let plan = try activateNewTestamentPlan(in: context)

        let today = try repository.snapshot(
            asOf: date(2026, 10, 13, 12),
            calendar: calendar
        )

        XCTAssertEqual(today.reading.title, "Matthew 5")
        XCTAssertTrue(today.reading.isSavedPosition)
        XCTAssertEqual(today.plan?.planID, plan.id)
        XCTAssertEqual(today.plan?.dayIndex, 1)
        XCTAssertEqual(today.plan?.totalReadingCount, 3)
        XCTAssertEqual(today.plan?.completedReadingCount, 0)
        XCTAssertEqual(today.plan?.nextReadingTitle, "Matthew 1")
        XCTAssertEqual(today.plan?.nextReadingReference?.chapter, 1)
        XCTAssertEqual(today.plan?.pace, .behind(days: 1))
        XCTAssertEqual(today.virtue.identifier, .diligence)
        XCTAssertTrue(today.recentActivity.contains { $0.title == "Last read Matthew 5" })
    }

    func testCompletionAdvancesNextReadingAndBuildsCalendarDayStreak() throws {
        let (repository, context) = try makeRepository()
        let plan = try activateNewTestamentPlan(in: context)
        let planRepository = ActiveReadingPlanRepository(modelContext: context)
        let assignments = try XCTUnwrap(plan.days.first?.assignments)

        try planRepository.toggleAssignment(
            planID: plan.id,
            assignmentID: assignments[0].id,
            at: date(2026, 10, 12, 18)
        )
        try planRepository.toggleAssignment(
            planID: plan.id,
            assignmentID: assignments[1].id,
            at: date(2026, 10, 13, 9)
        )

        var today = try repository.snapshot(
            asOf: date(2026, 10, 13, 12),
            calendar: calendar
        )
        XCTAssertEqual(today.plan?.completedReadingCount, 2)
        XCTAssertEqual(today.plan?.nextReadingTitle, "Matthew 3")
        XCTAssertEqual(today.planActivityStreak, 2)
        XCTAssertTrue(today.recentActivity.contains { $0.title == "Completed Matthew 2" })

        try planRepository.toggleAssignment(
            planID: plan.id,
            assignmentID: assignments[1].id,
            at: date(2026, 10, 13, 13)
        )
        today = try repository.snapshot(
            asOf: date(2026, 10, 13, 14),
            calendar: calendar
        )
        XCTAssertEqual(today.plan?.completedReadingCount, 1)
        XCTAssertEqual(today.plan?.nextReadingTitle, "Matthew 2")
        XCTAssertEqual(today.planActivityStreak, 1)
        XCTAssertEqual(today.recentActivity.first?.title, "Reopened Matthew 2")
        XCTAssertEqual(today.recentActivity.count { $0.title.contains("Matthew 2") }, 1)
    }

    func testRecentActivityNeverExposesPrivateNoteTextOrPassage() throws {
        let (repository, context) = try makeRepository()
        context.insert(
            BibleStudySchemaV1.ScriptureAnnotation(
                kind: .note,
                canonicalBookID: "JOHN",
                chapter: 3,
                verseStart: 16,
                noteText: "TOP SECRET REFLECTION TEXT",
                modifiedAt: date(2026, 10, 13, 10)
            )
        )
        try context.save()

        let today = try repository.snapshot(
            asOf: date(2026, 10, 13, 12),
            calendar: calendar
        )
        let titles = today.recentActivity.map(\.title).joined(separator: " ")

        XCTAssertTrue(titles.contains("Updated a private note"))
        XCTAssertFalse(titles.contains("TOP SECRET"))
        XCTAssertFalse(titles.contains("John 3:16"))
    }

    func testRecommendationsSkipCompletedLearningAndRotateVirtuesWeekly() throws {
        let first = HomeTodayRecommendations.learning(
            asOf: date(2026, 10, 13, 12),
            completedTopicIDs: ["mass", "rosary", "sacraments", "liturgical-year"],
            calendar: calendar
        )
        XCTAssertEqual(first.topic.id, "prayer-devotions")
        XCTAssertEqual(first.eyebrow, "Learn something today")

        let review = HomeTodayRecommendations.learning(
            asOf: date(2026, 10, 13, 12),
            completedTopicIDs: Set(LearningTopicCatalog.topics.map(\.id)),
            calendar: calendar
        )
        XCTAssertEqual(review.eyebrow, "Review a Catholic practice")

        XCTAssertEqual(
            HomeTodayRecommendations.virtue(
                asOf: date(2026, 10, 13, 12),
                calendar: calendar
            ).identifier,
            .diligence
        )
        XCTAssertEqual(
            HomeTodayRecommendations.virtue(
                asOf: date(2026, 10, 20, 12),
                calendar: calendar
            ).identifier,
            .patience
        )
    }

    func testEmptyStateIsTruthfulAndActionable() throws {
        let (repository, _) = try makeRepository()

        let today = try repository.snapshot(
            asOf: date(2026, 10, 13, 12),
            calendar: calendar
        )

        XCTAssertFalse(today.reading.isSavedPosition)
        XCTAssertEqual(today.reading.reference, YouVersionCatalogPolicy.developmentStart)
        XCTAssertNil(today.plan)
        XCTAssertTrue(today.recentActivity.isEmpty)
        XCTAssertEqual(today.planActivityStreak, 0)
    }

    private func makeRepository() throws -> (HomeTodayRepository, ModelContext) {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        return (HomeTodayRepository(modelContext: context), context)
    }

    private func activateNewTestamentPlan(
        in context: ModelContext
    ) throws -> ActiveReadingPlanSnapshot {
        let template = try XCTUnwrap(
            ReadingPlanTemplate.featured.first { $0.id == "new-testament-90" }
        )
        let snapshot = try ActiveReadingPlanSnapshot.make(
            template: template,
            startDate: PlanLocalDate(year: 2026, month: 10, day: 12),
            eligibleWeekdays: PlanWeekday.everyDay,
            calendar: calendar,
            id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
            createdAt: date(2026, 10, 12, 7)
        )
        try ActiveReadingPlanRepository(modelContext: context).activate(
            snapshot,
            at: date(2026, 10, 12, 7)
        )
        return snapshot
    }

    private func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int) -> Date {
        calendar.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day,
                hour: hour
            )
        )!
    }
}

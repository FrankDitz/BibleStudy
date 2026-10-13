import SwiftData
import XCTest

@testable import BibleStudy

@MainActor
final class ActiveReadingPlanRepositoryTests: XCTestCase {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        return calendar
    }

    func testTemplateActivationRoundTripsTheExactSnapshot() throws {
        let (repository, _) = try makeRepository()
        let template = try XCTUnwrap(
            ReadingPlanTemplate.featured.first { $0.id == "start-with-jesus-21" }
        )
        let snapshot = try ActiveReadingPlanSnapshot.make(
            template: template,
            startDate: localDate(2026, 10, 12),
            eligibleWeekdays: [.monday, .wednesday, .friday],
            calendar: calendar,
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            createdAt: Date(timeIntervalSince1970: 100)
        )

        try repository.activate(snapshot, at: Date(timeIntervalSince1970: 101))
        let restored = try XCTUnwrap(repository.activeState())

        XCTAssertEqual(restored.snapshot, snapshot)
        XCTAssertEqual(restored.status, .active)
        XCTAssertTrue(restored.completedAssignmentIDs.isEmpty)
    }

    func testAssignmentCompletionAndReversalAreDurableAndDriveDayCompletion() throws {
        let (repository, _) = try makeRepository()
        let snapshot = try makeSnapshot()
        try repository.activate(snapshot)
        let assignment = try XCTUnwrap(snapshot.days.first?.assignments.first)

        XCTAssertTrue(
            try repository.toggleAssignment(
                planID: snapshot.id,
                assignmentID: assignment.id,
                at: Date(timeIntervalSince1970: 1)
            )
        )
        var state = try XCTUnwrap(repository.activeState())
        XCTAssertTrue(state.completedAssignmentIDs.contains(assignment.id))
        XCTAssertTrue(state.completedDayIndices.contains(1))

        XCTAssertFalse(
            try repository.toggleAssignment(
                planID: snapshot.id,
                assignmentID: assignment.id,
                at: Date(timeIntervalSince1970: 2)
            )
        )
        state = try XCTUnwrap(repository.activeState())
        XCTAssertFalse(state.completedAssignmentIDs.contains(assignment.id))
        XCTAssertFalse(state.completedDayIndices.contains(1))
    }

    func testActivatingAnotherPlanArchivesThePreviousPlan() throws {
        let (repository, context) = try makeRepository()
        let first = try makeSnapshot(id: UUID())
        let second = try makeSnapshot(id: UUID())

        try repository.activate(first, at: Date(timeIntervalSince1970: 1))
        try repository.activate(second, at: Date(timeIntervalSince1970: 2))

        XCTAssertEqual(try repository.activeState()?.snapshot.id, second.id)
        let stored = try context.fetch(FetchDescriptor<BibleStudySchemaV2.ActiveReadingPlan>())
        XCTAssertEqual(stored.first { $0.id == first.id }?.status, .archived)
        XCTAssertEqual(stored.first { $0.id == second.id }?.status, .active)
    }

    func testReplacingSchedulePersistsRecoveryWithoutChangingAssignments() throws {
        let (repository, _) = try makeRepository()
        let snapshot = try makeSnapshot()
        try repository.activate(snapshot)
        let revised = snapshot.schedule.map {
            PlanScheduledDay(
                logicalDayIndex: $0.logicalDayIndex,
                scheduledDate: PlanLocalDate(
                    year: $0.scheduledDate.year,
                    month: $0.scheduledDate.month,
                    day: $0.scheduledDate.day + 1
                )
            )
        }

        try repository.replaceSchedule(planID: snapshot.id, with: revised)
        let restored = try XCTUnwrap(repository.activeState())

        XCTAssertEqual(restored.snapshot.schedule, revised)
        XCTAssertEqual(restored.snapshot.days, snapshot.days)
    }

    func testUnknownAssignmentFailsWithoutWritingAnEvent() throws {
        let (repository, context) = try makeRepository()
        let snapshot = try makeSnapshot()
        try repository.activate(snapshot)

        XCTAssertThrowsError(
            try repository.toggleAssignment(planID: snapshot.id, assignmentID: "missing")
        ) { error in
            XCTAssertEqual(error as? ActiveReadingPlanError, .unknownAssignment)
        }
        XCTAssertTrue(
            try context.fetch(
                FetchDescriptor<BibleStudySchemaV2.PlanAssignmentCompletionEvent>()
            ).isEmpty
        )
    }

    func testCompletingAndReopeningWholePlanUpdatesDurableStatus() throws {
        let (repository, _) = try makeRepository()
        let snapshot = try makeSnapshot()
        try repository.activate(snapshot)

        for (offset, assignmentID) in snapshot.assignmentIDs.sorted().enumerated() {
            try repository.toggleAssignment(
                planID: snapshot.id,
                assignmentID: assignmentID,
                at: Date(timeIntervalSince1970: Double(offset + 1))
            )
        }
        var state = try XCTUnwrap(repository.activeState())
        XCTAssertEqual(state.status, .completed)
        XCTAssertEqual(state.completionFraction, 1)

        let reopenedID = try XCTUnwrap(snapshot.assignmentIDs.sorted().first)
        try repository.toggleAssignment(
            planID: snapshot.id,
            assignmentID: reopenedID,
            at: Date(timeIntervalSince1970: 100)
        )
        state = try XCTUnwrap(repository.activeState())
        XCTAssertEqual(state.status, .active)
        XCTAssertLessThan(state.completionFraction, 1)
    }

    func testPauseAndSameDayResumePreserveSchedule() throws {
        let (repository, _) = try makeRepository()
        let snapshot = try makeSnapshot()
        let pausedOn = localDate(2026, 10, 12)
        try repository.activate(snapshot)

        try repository.pause(planID: snapshot.id, on: pausedOn)
        XCTAssertEqual(try repository.activeState()?.status, .paused)
        XCTAssertEqual(try repository.activeState()?.pausedOn, pausedOn)

        try repository.resume(planID: snapshot.id, on: pausedOn, calendar: calendar)
        let resumed = try XCTUnwrap(repository.activeState())
        XCTAssertEqual(resumed.status, .active)
        XCTAssertNil(resumed.pausedOn)
        XCTAssertEqual(resumed.snapshot.schedule, snapshot.schedule)
    }

    func testLegacyRangeBecomesChapterChecklistAndPreservesCompletion() throws {
        let (repository, context) = try makeRepository()
        let planID = UUID()
        let legacyAssignment = ReadingPlanAssignment(
            id: "legacy.matthew-1-3",
            position: 1,
            bookID: "MATT",
            startChapter: 1,
            endChapter: 3
        )
        let snapshot = ActiveReadingPlanSnapshot(
            id: planID,
            source: .template,
            sourceID: "legacy",
            sourceRevision: 1,
            title: "Legacy Plan",
            summary: "Legacy grouped readings",
            versionID: 42,
            canonManifestID: CatholicChapterManifest.cpdvV1.id,
            canonManifestRevision: CatholicChapterManifest.cpdvV1.revision,
            days: [
                ReadingPlanTemplateDay(logicalDayIndex: 1, assignments: [legacyAssignment])
            ],
            schedule: [
                PlanScheduledDay(
                    logicalDayIndex: 1,
                    scheduledDate: localDate(2026, 10, 13)
                )
            ],
            eligibleWeekdays: PlanWeekday.everyDay,
            recoveryPreference: .keepDates,
            reminderTime: nil,
            coverStyle: .midnight,
            createdAt: Date(timeIntervalSince1970: 1)
        )
        try repository.activate(snapshot)
        context.insert(
            BibleStudySchemaV2.PlanAssignmentCompletionEvent(
                planID: planID,
                assignmentID: legacyAssignment.id,
                action: .completed,
                occurredAt: Date(timeIntervalSince1970: 2),
                deviceID: "legacy-device"
            )
        )
        try context.save()

        var state = try XCTUnwrap(repository.activeState())
        let assignments = try XCTUnwrap(state.snapshot.days.first?.assignments)
        XCTAssertEqual(assignments.map(\.displayTitle), ["Matthew 1", "Matthew 2", "Matthew 3"])
        XCTAssertEqual(state.completedAssignmentIDs.count, 3)
        XCTAssertTrue(state.completedDayIndices.contains(1))

        try repository.toggleAssignment(
            planID: planID,
            assignmentID: assignments[1].id,
            at: Date(timeIntervalSince1970: 3)
        )
        state = try XCTUnwrap(repository.activeState())
        XCTAssertEqual(state.completedAssignmentIDs.count, 2)
        XCTAssertFalse(state.completedDayIndices.contains(1))
    }

    private func makeRepository() throws -> (ActiveReadingPlanRepository, ModelContext) {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        return (ActiveReadingPlanRepository(modelContext: context), context)
    }

    private func makeSnapshot(id: UUID = UUID()) throws -> ActiveReadingPlanSnapshot {
        let template = try XCTUnwrap(
            ReadingPlanTemplate.featured.first { $0.id == "start-with-jesus-21" }
        )
        return try ActiveReadingPlanSnapshot.make(
            template: template,
            startDate: localDate(2026, 10, 12),
            eligibleWeekdays: PlanWeekday.everyDay,
            calendar: calendar,
            id: id
        )
    }

    private func localDate(_ year: Int, _ month: Int, _ day: Int) -> PlanLocalDate {
        PlanLocalDate(year: year, month: month, day: day)
    }
}

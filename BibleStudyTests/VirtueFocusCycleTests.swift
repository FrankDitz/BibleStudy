import SwiftData
import XCTest

@testable import BibleStudy

@MainActor
final class VirtueFocusCycleTests: XCTestCase {
    func testCycleRequiresOwnerSelectedPracticeAndContext() throws {
        var state = VirtueFormationState.empty
        let practice = try XCTUnwrap(VirtueFoundationLibrary.charity.practices.first)

        XCTAssertThrowsError(
            try VirtueFocusCycleEngine.start(
                in: &state,
                virtueID: .humility,
                context: .relationships,
                practice: practice,
                duration: .oneWeek
            )
        ) { error in
            XCTAssertEqual(error as? VirtueFocusCycleError, .practiceDoesNotBelongToVirtue)
        }

        XCTAssertThrowsError(
            try VirtueFocusCycleEngine.start(
                in: &state,
                virtueID: .charity,
                context: .digitalLife,
                practice: practice,
                duration: .oneWeek
            )
        ) { error in
            XCTAssertEqual(error as? VirtueFocusCycleError, .practiceDoesNotMatchContext)
        }
    }

    func testPauseAndReturnPreserveElapsedFormationWithoutPenalty() throws {
        let calendar = fixedCalendar
        let start = try date(2026, 10, 1)
        let pause = try date(2026, 10, 4)
        let resume = try date(2026, 10, 11)
        let practice = try XCTUnwrap(VirtueFoundationLibrary.charity.practices.first)
        var state = VirtueFormationState.empty
        let cycleID = try VirtueFocusCycleEngine.start(
            in: &state,
            virtueID: .charity,
            context: .serviceAndCommunity,
            practice: practice,
            duration: .twoWeeks,
            at: start
        )

        try VirtueFocusCycleEngine.pause(cycleID: cycleID, in: &state, at: pause)
        XCTAssertEqual(state.currentCycle?.dayNumber(asOf: resume, calendar: calendar), 4)

        try VirtueFocusCycleEngine.resume(cycleID: cycleID, in: &state, at: resume)
        XCTAssertEqual(state.currentCycle?.dayNumber(asOf: resume, calendar: calendar), 4)
        XCTAssertEqual(state.currentCycle?.status, .active)
        XCTAssertEqual(state.currentCycle?.accumulatedPauseInterval, 7 * 86_400)
    }

    func testOnlyOneOpenCycleCanExistAndCompletedCycleAllowsAnother() throws {
        let practice = try XCTUnwrap(VirtueFoundationLibrary.charity.practices.first)
        var state = VirtueFormationState.empty
        let firstID = try VirtueFocusCycleEngine.start(
            in: &state,
            virtueID: .charity,
            context: .serviceAndCommunity,
            practice: practice,
            duration: .oneWeek
        )

        XCTAssertThrowsError(
            try VirtueFocusCycleEngine.start(
                in: &state,
                virtueID: .charity,
                context: .serviceAndCommunity,
                practice: practice,
                duration: .oneWeek
            )
        ) { error in
            XCTAssertEqual(error as? VirtueFocusCycleError, .activeCycleExists)
        }

        try VirtueFocusCycleEngine.close(cycleID: firstID, in: &state)
        XCTAssertNoThrow(
            try VirtueFocusCycleEngine.start(
                in: &state,
                virtueID: .charity,
                context: .serviceAndCommunity,
                practice: practice,
                duration: .fourWeeks
            )
        )
    }

    func testRepositoryPersistsCycleSnapshot() throws {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        let repository = VirtueFormationRepository(modelContext: context)
        let practice = try XCTUnwrap(VirtueFoundationLibrary.diligence.practices.first)

        let updated = try repository.update { state in
            _ = try VirtueFocusCycleEngine.start(
                in: &state,
                virtueID: .diligence,
                context: .work,
                practice: practice,
                duration: .fourWeeks
            )
        }

        let restored = try VirtueFormationRepository(
            modelContext: ModelContext(container)
        ).state()
        XCTAssertEqual(restored.cycles.map(\.id), updated.cycles.map(\.id))
        XCTAssertEqual(restored.currentCycle?.virtueID, updated.currentCycle?.virtueID)
        XCTAssertEqual(restored.currentCycle?.duration, updated.currentCycle?.duration)
        XCTAssertEqual(restored.currentCycle?.practice.id, practice.id)
    }

    func testDailyCheckInUpdatesSameDayWithoutScoringAndKeepsObservationPrivate() throws {
        let checkInDate = try date(2026, 10, 13)
        let practice = try XCTUnwrap(VirtueFoundationLibrary.patience.practices.first)
        var state = VirtueFormationState.empty
        let cycleID = try VirtueFocusCycleEngine.start(
            in: &state,
            virtueID: .patience,
            context: .difficultSeason,
            practice: practice,
            duration: .oneWeek,
            at: checkInDate
        )

        try VirtueFocusCycleEngine.recordCheckIn(
            cycleID: cycleID,
            status: .noticedOpportunity,
            privateObservation: "  Private detail  ",
            in: &state,
            at: checkInDate,
            calendar: fixedCalendar
        )
        try VirtueFocusCycleEngine.recordCheckIn(
            cycleID: cycleID,
            status: .practiced,
            privateObservation: "  Revised private detail  ",
            in: &state,
            at: checkInDate.addingTimeInterval(3_600),
            calendar: fixedCalendar
        )

        let checkIn = try XCTUnwrap(state.checkIns.first)
        XCTAssertEqual(state.checkIns.count, 1)
        XCTAssertEqual(checkIn.status, .practiced)
        XCTAssertEqual(checkIn.privateObservation, "Revised private detail")
        let metadata = try JSONEncoder().encode(checkIn.shareableMetadata)
        XCTAssertFalse(String(decoding: metadata, as: UTF8.self).contains("Revised private detail"))
    }

    func testPausedCycleRejectsCheckInWithoutChangingState() throws {
        let practice = try XCTUnwrap(VirtueFoundationLibrary.patience.practices.first)
        var state = VirtueFormationState.empty
        let cycleID = try VirtueFocusCycleEngine.start(
            in: &state,
            virtueID: .patience,
            context: .difficultSeason,
            practice: practice,
            duration: .oneWeek
        )
        try VirtueFocusCycleEngine.pause(cycleID: cycleID, in: &state)

        XCTAssertThrowsError(
            try VirtueFocusCycleEngine.recordCheckIn(
                cycleID: cycleID,
                status: .practiced,
                privateObservation: nil,
                in: &state
            )
        ) { error in
            XCTAssertEqual(error as? VirtueFocusCycleError, .checkInWhilePaused)
        }
        XCTAssertTrue(state.checkIns.isEmpty)
    }

    func testLegacyCyclePayloadDecodesWithEmptyCheckIns() throws {
        let state = try JSONDecoder().decode(
            VirtueFormationState.self,
            from: Data(#"{"cycles":[]}"#.utf8)
        )
        XCTAssertEqual(state, .empty)
    }

    func testWeeklyReviewSummarizesFactsAndPreservesThenNowWords() throws {
        let start = try date(2026, 10, 1)
        let practice = try XCTUnwrap(VirtueFoundationLibrary.kindness.practices.first)
        var state = VirtueFormationState.empty
        let cycleID = try VirtueFocusCycleEngine.start(
            in: &state,
            virtueID: .kindness,
            context: .relationships,
            practice: practice,
            duration: .twoWeeks,
            beginningReflection: "I rush past opportunities to encourage people.",
            at: start
        )
        try VirtueFocusCycleEngine.recordCheckIn(
            cycleID: cycleID,
            status: .noticedOpportunity,
            privateObservation: nil,
            in: &state,
            at: start,
            calendar: fixedCalendar
        )
        try VirtueFocusCycleEngine.recordCheckIn(
            cycleID: cycleID,
            status: .practiced,
            privateObservation: nil,
            in: &state,
            at: start.addingTimeInterval(2 * 86_400),
            calendar: fixedCalendar
        )

        try VirtueReviewEngine.submit(
            cycleID: cycleID,
            nowObservation: "I notice the moment sooner and can choose a specific word.",
            graceNoticed: "A conversation slowed me down.",
            decision: .continuePractice,
            in: &state,
            at: start.addingTimeInterval(6 * 86_400),
            calendar: fixedCalendar
        )

        let review = try XCTUnwrap(state.reviews.first)
        XCTAssertEqual(review.weekIndex, 1)
        XCTAssertEqual(review.summary.totalCheckIns, 2)
        XCTAssertEqual(review.summary.practiced, 1)
        XCTAssertEqual(review.summary.noticedOpportunity, 1)
        XCTAssertEqual(review.thenObservation, "I rush past opportunities to encourage people.")
        XCTAssertEqual(
            review.nowObservation,
            "I notice the moment sooner and can choose a specific word."
        )
        XCTAssertEqual(state.currentCycle?.status, .active)
    }

    func testReviewUpdateIsIdempotentAndCloseDecisionEndsCycle() throws {
        let start = try date(2026, 10, 1)
        let practice = try XCTUnwrap(VirtueFoundationLibrary.kindness.practices.first)
        var state = VirtueFormationState.empty
        let cycleID = try VirtueFocusCycleEngine.start(
            in: &state,
            virtueID: .kindness,
            context: .relationships,
            practice: practice,
            duration: .oneWeek,
            at: start
        )

        try VirtueReviewEngine.submit(
            cycleID: cycleID,
            nowObservation: "First wording",
            graceNoticed: nil,
            decision: .continuePractice,
            in: &state,
            at: start.addingTimeInterval(6 * 86_400),
            calendar: fixedCalendar
        )
        let reviewID = try XCTUnwrap(state.reviews.first?.id)
        try VirtueReviewEngine.submit(
            cycleID: cycleID,
            nowObservation: "Revised wording",
            graceNoticed: nil,
            decision: .retainPractice,
            in: &state,
            at: start.addingTimeInterval(6 * 86_400),
            calendar: fixedCalendar
        )

        XCTAssertEqual(state.reviews.count, 1)
        XCTAssertEqual(state.reviews.first?.id, reviewID)
        XCTAssertEqual(state.reviews.first?.nowObservation, "Revised wording")
        XCTAssertEqual(state.cycles.first?.status, .completed)
        XCTAssertNil(state.currentCycle)
    }

    func testReviewRequiresOwnerWrittenNowReflection() throws {
        let practice = try XCTUnwrap(VirtueFoundationLibrary.kindness.practices.first)
        var state = VirtueFormationState.empty
        let cycleID = try VirtueFocusCycleEngine.start(
            in: &state,
            virtueID: .kindness,
            context: .relationships,
            practice: practice,
            duration: .oneWeek
        )

        XCTAssertThrowsError(
            try VirtueReviewEngine.submit(
                cycleID: cycleID,
                nowObservation: "   ",
                graceNoticed: nil,
                decision: .closePractice,
                in: &state
            )
        ) { error in
            XCTAssertEqual(error as? VirtueFocusCycleError, .missingReflection)
        }
        XCTAssertTrue(state.reviews.isEmpty)
        XCTAssertEqual(state.currentCycle?.status, .active)
    }

    private var fixedCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) throws -> Date {
        try XCTUnwrap(
            fixedCalendar.date(from: DateComponents(year: year, month: month, day: day, hour: 12))
        )
    }
}

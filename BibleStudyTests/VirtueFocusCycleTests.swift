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

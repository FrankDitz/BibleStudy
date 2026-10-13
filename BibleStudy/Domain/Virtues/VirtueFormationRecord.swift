import Foundation

struct VirtueFormationSnapshot: Equatable, Sendable {
    let cyclesBegun: Int
    let cyclesCompleted: Int
    let reviewsWritten: Int
    let checkInsByStatus: [VirtueCheckInStatus: Int]
    let contextsPracticed: Set<VirtuePracticeContext>
    let virtuesEncountered: Set<VirtueIdentifier>
    let activeRulePractices: Int

    init(state: VirtueFormationState) {
        cyclesBegun = state.cycles.count
        cyclesCompleted = state.cycles.count { $0.status == .completed }
        reviewsWritten = state.reviews.count
        checkInsByStatus = Dictionary(grouping: state.checkIns, by: \.status).mapValues(\.count)
        contextsPracticed = Set(state.cycles.map(\.context))
        virtuesEncountered = Set(state.cycles.map(\.virtueID))
        activeRulePractices = state.rulePractices.count(where: \.isActive)
    }
}

struct VirtueFormationMilestone: Identifiable, Equatable, Sendable {
    let id: String
    let title: String
    let detail: String
}

enum VirtueFormationRecordBuilder {
    static func milestones(for state: VirtueFormationState) -> [VirtueFormationMilestone] {
        var result: [VirtueFormationMilestone] = []
        if !state.cycles.isEmpty {
            result.append(
                VirtueFormationMilestone(
                    id: "first-cycle",
                    title: "A practice begun",
                    detail: "You chose a virtue, context, and concrete practice."
                )
            )
        }
        if !state.reviews.isEmpty {
            result.append(
                VirtueFormationMilestone(
                    id: "first-review",
                    title: "A prayerful review",
                    detail: "You paused to notice facts, grace, and your next faithful choice."
                )
            )
        }
        if state.rulePractices.contains(where: \.isActive) {
            result.append(
                VirtueFormationMilestone(
                    id: "rule-practice",
                    title: "A practice retained",
                    detail: "Your Rule of Life now holds a practice you deliberately chose."
                )
            )
        }
        if Set(state.cycles.map(\.virtueID)).isSuperset(of: VirtueFormationCatalog.supportedIdentifiers) {
            result.append(
                VirtueFormationMilestone(
                    id: "seven-virtues",
                    title: "All seven encountered",
                    detail: "You have practiced with each of the seven virtues at least once."
                )
            )
        }
        return result
    }
}

enum VirtueFormationIntegration {
    static func echoRequest(
        for cycle: VirtueFocusCycle,
        at date: Date = .now
    ) -> BibleStudyEchoReflectionRequest {
        let virtueTitle = VirtueFoundationLibrary.pathway(for: cycle.virtueID)?.title ?? "this virtue"
        return BibleStudyEchoReflectionRequest(
            id: UUID(),
            createdAt: date,
            prompt:
                "Reflect prayerfully on my practice of \(virtueTitle): \(cycle.practice.title). Where did I notice grace, resistance, and an invitation for one faithful next step?",
            virtueIDs: [cycle.virtueID]
        )
    }

    static func completionEvent(
        for cycle: VirtueFocusCycle,
        at date: Date? = nil
    ) -> BibleStudyHubEvent {
        BibleStudyHubEvent(
            id: UUID(),
            type: .virtueCycleCompleted,
            occurredAt: date ?? cycle.completedAt ?? .now,
            entityID: cycle.id,
            payload: BibleStudyHubEventPayload(virtueIDs: [cycle.virtueID])
        )
    }
}

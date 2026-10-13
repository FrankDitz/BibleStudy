import Foundation

enum VirtueCycleDuration: Int, Codable, CaseIterable, Sendable {
    case oneWeek = 7
    case twoWeeks = 14
    case fourWeeks = 28

    var title: String {
        switch self {
        case .oneWeek: "1 week"
        case .twoWeeks: "2 weeks"
        case .fourWeeks: "4 weeks"
        }
    }
}

enum VirtueCycleStatus: String, Codable, CaseIterable, Sendable {
    case active
    case paused
    case completed
}

enum VirtueCycleOrigin: String, Codable, Sendable {
    case foundation
    case focusCycle
    case thematicJourney
}

struct VirtueFocusCycle: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let virtueID: VirtueIdentifier
    let context: VirtuePracticeContext
    let practice: VirtuePracticeDefinition
    let duration: VirtueCycleDuration
    let origin: VirtueCycleOrigin
    let startedAt: Date
    var status: VirtueCycleStatus
    var pausedAt: Date?
    var accumulatedPauseInterval: TimeInterval
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        virtueID: VirtueIdentifier,
        context: VirtuePracticeContext,
        practice: VirtuePracticeDefinition,
        duration: VirtueCycleDuration,
        origin: VirtueCycleOrigin = .focusCycle,
        startedAt: Date = .now,
        status: VirtueCycleStatus = .active,
        pausedAt: Date? = nil,
        accumulatedPauseInterval: TimeInterval = 0,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.virtueID = virtueID
        self.context = context
        self.practice = practice
        self.duration = duration
        self.origin = origin
        self.startedAt = startedAt
        self.status = status
        self.pausedAt = pausedAt
        self.accumulatedPauseInterval = accumulatedPauseInterval
        self.completedAt = completedAt
    }

    func dayNumber(asOf date: Date, calendar: Calendar = .current) -> Int {
        let effectiveDate = pausedAt.map { min($0, date) } ?? date
        let adjustedDate = effectiveDate.addingTimeInterval(-accumulatedPauseInterval)
        let start = calendar.startOfDay(for: startedAt)
        let current = calendar.startOfDay(for: max(startedAt, adjustedDate))
        let elapsed = calendar.dateComponents([.day], from: start, to: current).day ?? 0
        return min(duration.rawValue, max(1, elapsed + 1))
    }

    func targetEndDate(calendar: Calendar = .current) -> Date {
        let activeEnd = startedAt.addingTimeInterval(accumulatedPauseInterval)
        return calendar.date(byAdding: .day, value: duration.rawValue - 1, to: activeEnd) ?? activeEnd
    }
}

struct VirtueFormationState: Codable, Equatable, Sendable {
    var cycles: [VirtueFocusCycle]

    static let empty = VirtueFormationState(cycles: [])

    var currentCycle: VirtueFocusCycle? {
        cycles.last { $0.status == .active || $0.status == .paused }
    }
}

enum VirtueFocusCycleError: Error, Equatable {
    case unsupportedVirtue
    case practiceDoesNotBelongToVirtue
    case practiceDoesNotMatchContext
    case activeCycleExists
    case cycleNotFound
    case invalidTransition
}

enum VirtueFocusCycleEngine {
    static func start(
        in state: inout VirtueFormationState,
        virtueID: VirtueIdentifier,
        context: VirtuePracticeContext,
        practice: VirtuePracticeDefinition,
        duration: VirtueCycleDuration,
        at date: Date = .now
    ) throws -> UUID {
        guard VirtueFormationCatalog.supportedIdentifiers.contains(virtueID) else {
            throw VirtueFocusCycleError.unsupportedVirtue
        }
        guard
            VirtueFoundationLibrary.pathway(for: virtueID)?.practices.contains(where: {
                $0.id == practice.id
            }) == true
        else {
            throw VirtueFocusCycleError.practiceDoesNotBelongToVirtue
        }
        guard practice.contexts.contains(context) else {
            throw VirtueFocusCycleError.practiceDoesNotMatchContext
        }
        guard state.currentCycle == nil else {
            throw VirtueFocusCycleError.activeCycleExists
        }

        let cycle = VirtueFocusCycle(
            virtueID: virtueID,
            context: context,
            practice: practice,
            duration: duration,
            startedAt: date
        )
        state.cycles.append(cycle)
        return cycle.id
    }

    static func pause(
        cycleID: UUID,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        guard let index = state.cycles.firstIndex(where: { $0.id == cycleID }) else {
            throw VirtueFocusCycleError.cycleNotFound
        }
        guard state.cycles[index].status == .active else {
            throw VirtueFocusCycleError.invalidTransition
        }
        state.cycles[index].status = .paused
        state.cycles[index].pausedAt = date
    }

    static func resume(
        cycleID: UUID,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        guard let index = state.cycles.firstIndex(where: { $0.id == cycleID }) else {
            throw VirtueFocusCycleError.cycleNotFound
        }
        guard state.cycles[index].status == .paused,
            let pausedAt = state.cycles[index].pausedAt,
            date >= pausedAt
        else {
            throw VirtueFocusCycleError.invalidTransition
        }
        state.cycles[index].accumulatedPauseInterval += date.timeIntervalSince(pausedAt)
        state.cycles[index].pausedAt = nil
        state.cycles[index].status = .active
    }

    static func close(
        cycleID: UUID,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) throws {
        guard let index = state.cycles.firstIndex(where: { $0.id == cycleID }) else {
            throw VirtueFocusCycleError.cycleNotFound
        }
        guard state.cycles[index].status != .completed else {
            throw VirtueFocusCycleError.invalidTransition
        }
        state.cycles[index].status = .completed
        state.cycles[index].pausedAt = nil
        state.cycles[index].completedAt = date
    }
}

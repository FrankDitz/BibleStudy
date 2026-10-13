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
    let beginningReflection: String?
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
        beginningReflection: String? = nil,
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
        self.beginningReflection = beginningReflection?
            .trimmingCharacters(in: .whitespacesAndNewlines)
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
    var checkIns: [VirtueCheckIn]
    var reviews: [VirtueCycleReview]
    var rulePractices: [VirtueRulePractice]
    var ruleRevisions: [VirtueRuleRevision]
    var courseProgress: [VirtueCourseProgress]

    init(
        cycles: [VirtueFocusCycle] = [],
        checkIns: [VirtueCheckIn] = [],
        reviews: [VirtueCycleReview] = [],
        rulePractices: [VirtueRulePractice] = [],
        ruleRevisions: [VirtueRuleRevision] = [],
        courseProgress: [VirtueCourseProgress] = []
    ) {
        self.cycles = cycles
        self.checkIns = checkIns
        self.reviews = reviews
        self.rulePractices = rulePractices
        self.ruleRevisions = ruleRevisions
        self.courseProgress = courseProgress
    }

    private enum CodingKeys: String, CodingKey {
        case cycles
        case checkIns
        case reviews
        case rulePractices
        case ruleRevisions
        case courseProgress
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cycles = try container.decodeIfPresent([VirtueFocusCycle].self, forKey: .cycles) ?? []
        checkIns = try container.decodeIfPresent([VirtueCheckIn].self, forKey: .checkIns) ?? []
        reviews = try container.decodeIfPresent([VirtueCycleReview].self, forKey: .reviews) ?? []
        rulePractices =
            try container.decodeIfPresent([VirtueRulePractice].self, forKey: .rulePractices) ?? []
        ruleRevisions =
            try container.decodeIfPresent([VirtueRuleRevision].self, forKey: .ruleRevisions) ?? []
        courseProgress =
            try container.decodeIfPresent([VirtueCourseProgress].self, forKey: .courseProgress) ?? []
    }

    static let empty = VirtueFormationState()

    var currentCycle: VirtueFocusCycle? {
        cycles.last { $0.status == .active || $0.status == .paused }
    }

    func checkIn(
        for cycleID: UUID,
        on date: Date,
        calendar: Calendar = .current
    ) -> VirtueCheckIn? {
        checkIns.last {
            $0.cycleID == cycleID && calendar.isDate($0.occurredAt, inSameDayAs: date)
        }
    }
}

enum VirtueFocusCycleError: Error, Equatable {
    case unsupportedVirtue
    case practiceDoesNotBelongToVirtue
    case practiceDoesNotMatchContext
    case activeCycleExists
    case cycleNotFound
    case invalidTransition
    case checkInWhilePaused
    case missingReflection
}

enum VirtueFocusCycleEngine {
    static func start(
        in state: inout VirtueFormationState,
        virtueID: VirtueIdentifier,
        context: VirtuePracticeContext,
        practice: VirtuePracticeDefinition,
        duration: VirtueCycleDuration,
        origin: VirtueCycleOrigin = .focusCycle,
        beginningReflection: String? = nil,
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
            origin: origin,
            startedAt: date,
            beginningReflection: beginningReflection
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

    static func recordCheckIn(
        cycleID: UUID,
        status: VirtueCheckInStatus,
        privateObservation: String?,
        in state: inout VirtueFormationState,
        at date: Date = .now,
        calendar: Calendar = .current
    ) throws {
        guard let cycle = state.cycles.first(where: { $0.id == cycleID }) else {
            throw VirtueFocusCycleError.cycleNotFound
        }
        guard cycle.status == .active else {
            throw VirtueFocusCycleError.checkInWhilePaused
        }
        let observation = privateObservation?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let existing = state.checkIn(for: cycleID, on: date, calendar: calendar)
        state.checkIns.removeAll {
            $0.cycleID == cycleID && calendar.isDate($0.occurredAt, inSameDayAs: date)
        }
        state.checkIns.append(
            VirtueCheckIn(
                id: existing?.id ?? UUID(),
                cycleID: cycleID,
                virtueID: cycle.virtueID,
                practiceID: cycle.practice.id,
                status: status,
                occurredAt: date,
                privateObservation: observation?.isEmpty == false ? observation : nil,
                cycleDay: cycle.dayNumber(asOf: date, calendar: calendar)
            )
        )
    }
}

struct VirtueActivitySummary: Codable, Equatable, Sendable {
    let practiced: Int
    let noticedOpportunity: Int
    let choseDifferently: Int
    let notApplicable: Int
    let reflectedInEcho: Int

    var totalCheckIns: Int {
        practiced + noticedOpportunity + choseDifferently + notApplicable + reflectedInEcho
    }
}

enum VirtueReviewDecision: String, Codable, CaseIterable, Sendable {
    case continuePractice
    case changePractice
    case retainPractice
    case closePractice

    var title: String {
        switch self {
        case .continuePractice: "Continue this practice"
        case .changePractice: "Close and choose another"
        case .retainPractice: "Retain in my Rule of Life"
        case .closePractice: "Close without retaining"
        }
    }
}

struct VirtueCycleReview: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let cycleID: UUID
    let weekIndex: Int
    let reviewedAt: Date
    let summary: VirtueActivitySummary
    let thenObservation: String?
    let nowObservation: String
    let graceNoticed: String?
    let decision: VirtueReviewDecision
}

enum VirtueReviewEngine {
    static func summary(
        cycleID: UUID,
        weekIndex: Int,
        in state: VirtueFormationState,
        calendar: Calendar = .current
    ) throws -> VirtueActivitySummary {
        guard let cycle = state.cycles.first(where: { $0.id == cycleID }) else {
            throw VirtueFocusCycleError.cycleNotFound
        }
        let firstCycleDay = max(1, (weekIndex - 1) * 7 + 1)
        let lastCycleDay = weekIndex * 7
        let checkIns = state.checkIns.filter {
            guard $0.cycleID == cycleID else { return false }
            let day = $0.cycleDay ?? cycle.dayNumber(asOf: $0.occurredAt, calendar: calendar)
            return (firstCycleDay...lastCycleDay).contains(day)
        }
        return VirtueActivitySummary(
            practiced: checkIns.count { $0.status == .practiced },
            noticedOpportunity: checkIns.count { $0.status == .noticedOpportunity },
            choseDifferently: checkIns.count { $0.status == .choseDifferently },
            notApplicable: checkIns.count { $0.status == .notApplicable },
            reflectedInEcho: checkIns.count { $0.status == .reflectedInEcho }
        )
    }

    static func submit(
        cycleID: UUID,
        nowObservation: String,
        graceNoticed: String?,
        decision: VirtueReviewDecision,
        in state: inout VirtueFormationState,
        at date: Date = .now,
        calendar: Calendar = .current
    ) throws {
        guard let cycleIndex = state.cycles.firstIndex(where: { $0.id == cycleID }) else {
            throw VirtueFocusCycleError.cycleNotFound
        }
        let now = nowObservation.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !now.isEmpty else { throw VirtueFocusCycleError.missingReflection }
        let cycle = state.cycles[cycleIndex]
        let weekIndex = max(1, Int(ceil(Double(cycle.dayNumber(asOf: date, calendar: calendar)) / 7)))
        let previousID = state.reviews.first {
            $0.cycleID == cycleID && $0.weekIndex == weekIndex
        }?.id
        let review = VirtueCycleReview(
            id: previousID ?? UUID(),
            cycleID: cycleID,
            weekIndex: weekIndex,
            reviewedAt: date,
            summary: try summary(
                cycleID: cycleID,
                weekIndex: weekIndex,
                in: state,
                calendar: calendar
            ),
            thenObservation: cycle.beginningReflection,
            nowObservation: now,
            graceNoticed: graceNoticed?.trimmingCharacters(in: .whitespacesAndNewlines),
            decision: decision
        )
        state.reviews.removeAll { $0.cycleID == cycleID && $0.weekIndex == weekIndex }
        state.reviews.append(review)

        if decision == .retainPractice {
            VirtueRuleOfLifeEngine.retain(cycle: cycle, in: &state, at: date)
        }

        if decision != .continuePractice {
            state.cycles[cycleIndex].status = .completed
            state.cycles[cycleIndex].pausedAt = nil
            state.cycles[cycleIndex].completedAt = date
        }
    }
}

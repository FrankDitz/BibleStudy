import Foundation

struct PlanLocalDate: Codable, Comparable, Hashable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    init(_ date: Date, calendar: Calendar) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.init(
            year: components.year ?? 1,
            month: components.month ?? 1,
            day: components.day ?? 1
        )
    }

    static func < (left: Self, right: Self) -> Bool {
        (left.year, left.month, left.day) < (right.year, right.month, right.day)
    }
}

enum PlanWeekday: Int, CaseIterable, Codable, Hashable, Sendable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    static let everyDay = Set(Self.allCases)
}

struct PlanScheduleRules: Equatable, Sendable {
    let startDate: PlanLocalDate
    let eligibleWeekdays: Set<PlanWeekday>

    init(
        startDate: PlanLocalDate,
        eligibleWeekdays: Set<PlanWeekday> = PlanWeekday.everyDay
    ) {
        self.startDate = startDate
        self.eligibleWeekdays = eligibleWeekdays
    }
}

struct PlanScheduledDay: Codable, Equatable, Hashable, Identifiable, Sendable {
    let logicalDayIndex: Int
    let scheduledDate: PlanLocalDate

    var id: Int { logicalDayIndex }
}

struct PlanDayCompletionEvent: Equatable, Hashable, Identifiable, Sendable {
    enum Action: String, Codable, Sendable {
        case completed
        case reopened
    }

    let id: UUID
    let logicalDayIndex: Int
    let action: Action
    let occurredAt: Date
    let deviceID: String

    init(
        id: UUID = UUID(),
        logicalDayIndex: Int,
        action: Action,
        occurredAt: Date,
        deviceID: String
    ) {
        self.id = id
        self.logicalDayIndex = logicalDayIndex
        self.action = action
        self.occurredAt = occurredAt
        self.deviceID = deviceID
    }
}

enum PlanPaceStatus: Equatable, Sendable {
    case ahead(days: Int)
    case onTrack
    case behind(days: Int)
    case complete
}

struct PlanProgressSnapshot: Equatable, Sendable {
    let completedDayIndices: Set<Int>
    let expectedCompletedCount: Int
    let completedCount: Int
    let totalCount: Int
    let pace: PlanPaceStatus
}

enum PlanRecoveryMode: Equatable, Sendable {
    case keepDates
    case shiftForward
    case redistribute(through: PlanLocalDate)
    case newFinishDate(PlanLocalDate)
}

enum PlanScheduleRevisionReason: Equatable, Sendable {
    case recovery(PlanRecoveryMode)
    case resumed(pausedOn: PlanLocalDate, resumesOn: PlanLocalDate)
}

struct PlanScheduleRevision: Equatable, Sendable {
    let reason: PlanScheduleRevisionReason
    let createdAt: Date
    let previousSchedule: [PlanScheduledDay]
    let revisedSchedule: [PlanScheduledDay]
}

enum ReadingPlanSchedulerError: Error, Equatable {
    case emptyEligibleWeekdays
    case invalidLogicalDayCount
    case invalidLocalDate(PlanLocalDate)
    case invalidPauseRange
    case finishDateBeforeRecoveryDate
    case noEligibleRecoveryDates
}

struct ReadingPlanScheduler: Sendable {
    private var calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func schedule(
        logicalDayCount: Int,
        rules: PlanScheduleRules
    ) throws -> [PlanScheduledDay] {
        guard logicalDayCount > 0 else {
            throw ReadingPlanSchedulerError.invalidLogicalDayCount
        }
        try validate(rules)

        var result: [PlanScheduledDay] = []
        var candidate = try firstEligibleDate(onOrAfter: rules.startDate, rules: rules)
        for logicalDayIndex in 1...logicalDayCount {
            result.append(
                PlanScheduledDay(
                    logicalDayIndex: logicalDayIndex,
                    scheduledDate: candidate
                )
            )
            candidate = try firstEligibleDate(
                onOrAfter: addingDays(1, to: candidate),
                rules: rules
            )
        }
        return result
    }

    func progress(
        schedule: [PlanScheduledDay],
        events: [PlanDayCompletionEvent],
        asOf date: PlanLocalDate
    ) -> PlanProgressSnapshot {
        let validIndices = Set(schedule.map(\.logicalDayIndex))
        let completed = completedDayIndices(from: events, validIndices: validIndices)
        let expectedCount = schedule.count { $0.scheduledDate <= date }
        let completedCount = completed.count

        let pace: PlanPaceStatus
        if !schedule.isEmpty, completedCount == schedule.count {
            pace = .complete
        } else {
            let difference = completedCount - expectedCount
            if difference > 0 {
                pace = .ahead(days: difference)
            } else if difference < 0 {
                pace = .behind(days: -difference)
            } else {
                pace = .onTrack
            }
        }

        return PlanProgressSnapshot(
            completedDayIndices: completed,
            expectedCompletedCount: expectedCount,
            completedCount: completedCount,
            totalCount: schedule.count,
            pace: pace
        )
    }

    func resume(
        schedule: [PlanScheduledDay],
        events: [PlanDayCompletionEvent],
        pausedOn: PlanLocalDate,
        resumesOn: PlanLocalDate,
        rules: PlanScheduleRules,
        createdAt: Date = .now
    ) throws -> PlanScheduleRevision {
        guard resumesOn > pausedOn else {
            throw ReadingPlanSchedulerError.invalidPauseRange
        }
        try validate(rules)

        let completed = completedDayIndices(
            from: events,
            validIndices: Set(schedule.map(\.logicalDayIndex))
        )
        let affected = Set(
            schedule.lazy
                .filter { $0.scheduledDate >= pausedOn && !completed.contains($0.logicalDayIndex) }
                .map(\.logicalDayIndex)
        )
        let revised = try reschedule(
            schedule,
            logicalDayIndices: affected,
            startingOn: resumesOn,
            rules: rules
        )
        return PlanScheduleRevision(
            reason: .resumed(pausedOn: pausedOn, resumesOn: resumesOn),
            createdAt: createdAt,
            previousSchedule: schedule,
            revisedSchedule: revised
        )
    }

    func recover(
        schedule: [PlanScheduledDay],
        events: [PlanDayCompletionEvent],
        asOf date: PlanLocalDate,
        mode: PlanRecoveryMode,
        rules: PlanScheduleRules,
        createdAt: Date = .now
    ) throws -> PlanScheduleRevision {
        try validate(rules)
        let completed = completedDayIndices(
            from: events,
            validIndices: Set(schedule.map(\.logicalDayIndex))
        )
        let remaining = schedule.filter { !completed.contains($0.logicalDayIndex) }

        let revised: [PlanScheduledDay]
        switch mode {
        case .keepDates:
            revised = schedule
        case .shiftForward:
            revised = try reschedule(
                schedule,
                logicalDayIndices: Set(remaining.map(\.logicalDayIndex)),
                startingOn: date,
                rules: rules
            )
        case .redistribute(let finishDate), .newFinishDate(let finishDate):
            revised = try redistribute(
                schedule,
                logicalDayIndices: remaining.map(\.logicalDayIndex),
                from: date,
                through: finishDate,
                rules: rules
            )
        }

        return PlanScheduleRevision(
            reason: .recovery(mode),
            createdAt: createdAt,
            previousSchedule: schedule,
            revisedSchedule: revised
        )
    }

    private func completedDayIndices(
        from events: [PlanDayCompletionEvent],
        validIndices: Set<Int>
    ) -> Set<Int> {
        let uniqueEvents = Dictionary(events.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
            .values
            .filter { validIndices.contains($0.logicalDayIndex) }
            .sorted {
                if $0.occurredAt != $1.occurredAt {
                    return $0.occurredAt < $1.occurredAt
                }
                return $0.id.uuidString < $1.id.uuidString
            }

        var state: [Int: Bool] = [:]
        for event in uniqueEvents {
            state[event.logicalDayIndex] = event.action == .completed
        }
        return Set(state.compactMap { $0.value ? $0.key : nil })
    }

    private func reschedule(
        _ schedule: [PlanScheduledDay],
        logicalDayIndices: Set<Int>,
        startingOn startDate: PlanLocalDate,
        rules: PlanScheduleRules
    ) throws -> [PlanScheduledDay] {
        guard !logicalDayIndices.isEmpty else { return schedule }

        let reservedDates = Set(
            schedule.lazy
                .filter { !logicalDayIndices.contains($0.logicalDayIndex) }
                .map(\.scheduledDate)
        )
        var nextDate = try firstEligibleDate(onOrAfter: startDate, rules: rules)
        var replacements: [Int: PlanLocalDate] = [:]

        for logicalDayIndex in logicalDayIndices.sorted() {
            while reservedDates.contains(nextDate) {
                nextDate = try firstEligibleDate(
                    onOrAfter: addingDays(1, to: nextDate),
                    rules: rules
                )
            }
            replacements[logicalDayIndex] = nextDate
            nextDate = try firstEligibleDate(
                onOrAfter: addingDays(1, to: nextDate),
                rules: rules
            )
        }

        return
            schedule
            .map { day in
                PlanScheduledDay(
                    logicalDayIndex: day.logicalDayIndex,
                    scheduledDate: replacements[day.logicalDayIndex] ?? day.scheduledDate
                )
            }
            .sorted { $0.logicalDayIndex < $1.logicalDayIndex }
    }

    private func redistribute(
        _ schedule: [PlanScheduledDay],
        logicalDayIndices: [Int],
        from startDate: PlanLocalDate,
        through finishDate: PlanLocalDate,
        rules: PlanScheduleRules
    ) throws -> [PlanScheduledDay] {
        guard finishDate >= startDate else {
            throw ReadingPlanSchedulerError.finishDateBeforeRecoveryDate
        }
        guard !logicalDayIndices.isEmpty else { return schedule }

        let candidateDates = try eligibleDates(
            from: startDate,
            through: finishDate,
            rules: rules
        )
        guard !candidateDates.isEmpty else {
            throw ReadingPlanSchedulerError.noEligibleRecoveryDates
        }

        let sortedIndices = logicalDayIndices.sorted()
        var replacements: [Int: PlanLocalDate] = [:]
        for (offset, logicalDayIndex) in sortedIndices.enumerated() {
            let dateIndex: Int
            if sortedIndices.count == 1 {
                dateIndex = 0
            } else {
                dateIndex = offset * (candidateDates.count - 1) / (sortedIndices.count - 1)
            }
            replacements[logicalDayIndex] = candidateDates[dateIndex]
        }

        return
            schedule
            .map { day in
                PlanScheduledDay(
                    logicalDayIndex: day.logicalDayIndex,
                    scheduledDate: replacements[day.logicalDayIndex] ?? day.scheduledDate
                )
            }
            .sorted { $0.logicalDayIndex < $1.logicalDayIndex }
    }

    private func eligibleDates(
        from startDate: PlanLocalDate,
        through finishDate: PlanLocalDate,
        rules: PlanScheduleRules
    ) throws -> [PlanLocalDate] {
        var dates: [PlanLocalDate] = []
        var candidate = startDate
        while candidate <= finishDate {
            if rules.eligibleWeekdays.contains(try weekday(for: candidate)) {
                dates.append(candidate)
            }
            candidate = try addingDays(1, to: candidate)
        }
        return dates
    }

    private func firstEligibleDate(
        onOrAfter startDate: PlanLocalDate,
        rules: PlanScheduleRules
    ) throws -> PlanLocalDate {
        var candidate = startDate
        for _ in 0..<7 {
            if rules.eligibleWeekdays.contains(try weekday(for: candidate)) {
                return candidate
            }
            candidate = try addingDays(1, to: candidate)
        }
        throw ReadingPlanSchedulerError.emptyEligibleWeekdays
    }

    private func validate(_ rules: PlanScheduleRules) throws {
        guard !rules.eligibleWeekdays.isEmpty else {
            throw ReadingPlanSchedulerError.emptyEligibleWeekdays
        }
        _ = try foundationDate(for: rules.startDate)
    }

    private func weekday(for localDate: PlanLocalDate) throws -> PlanWeekday {
        let rawValue = calendar.component(.weekday, from: try foundationDate(for: localDate))
        guard let weekday = PlanWeekday(rawValue: rawValue) else {
            throw ReadingPlanSchedulerError.invalidLocalDate(localDate)
        }
        return weekday
    }

    private func addingDays(_ days: Int, to localDate: PlanLocalDate) throws -> PlanLocalDate {
        let date = try foundationDate(for: localDate)
        guard let result = calendar.date(byAdding: .day, value: days, to: date) else {
            throw ReadingPlanSchedulerError.invalidLocalDate(localDate)
        }
        return PlanLocalDate(result, calendar: calendar)
    }

    private func foundationDate(for localDate: PlanLocalDate) throws -> Date {
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: localDate.year,
            month: localDate.month,
            day: localDate.day,
            hour: 12
        )
        guard
            let date = calendar.date(from: components),
            PlanLocalDate(date, calendar: calendar) == localDate
        else {
            throw ReadingPlanSchedulerError.invalidLocalDate(localDate)
        }
        return date
    }
}

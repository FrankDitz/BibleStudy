import Foundation
import SwiftData

@MainActor
struct ActiveReadingPlanRepository {
    private let modelContext: ModelContext
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        decoder = JSONDecoder()
    }

    func activeState() throws -> ActiveReadingPlanState? {
        let plans = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV2.ActiveReadingPlan>(
                sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
            )
        )
        guard
            let model = plans.first(where: {
                $0.deletedAt == nil
                    && ($0.status == .active || $0.status == .paused || $0.status == .completed)
            })
        else {
            return nil
        }
        let decodedSnapshot: ActiveReadingPlanSnapshot
        do {
            decodedSnapshot = try decoder.decode(ActiveReadingPlanSnapshot.self, from: model.payload)
        } catch {
            throw ActiveReadingPlanError.corruptPayload
        }
        let snapshot = decodedSnapshot.separatingChapterAssignments()
        let completedAssignmentIDs = try completionState(
            planID: model.id,
            validAssignmentIDs: snapshot.assignmentIDs,
            chapterAssignmentIDsByOriginalID: decodedSnapshot.chapterAssignmentIDsByOriginalID()
        )
        return ActiveReadingPlanState(
            snapshot: snapshot,
            completedAssignmentIDs: completedAssignmentIDs,
            status: model.status,
            pausedOn: model.pausedOn
        )
    }

    func activate(_ snapshot: ActiveReadingPlanSnapshot, at date: Date = .now) throws {
        let plans = try modelContext.fetch(FetchDescriptor<BibleStudySchemaV2.ActiveReadingPlan>())
        for plan in plans
        where plan.deletedAt == nil
            && (plan.status == .active || plan.status == .paused || plan.status == .completed)
        {
            plan.status = .archived
            plan.modifiedAt = date
        }
        let payload = try encoder.encode(snapshot)
        modelContext.insert(
            BibleStudySchemaV2.ActiveReadingPlan(
                id: snapshot.id,
                title: snapshot.title,
                status: .active,
                payload: payload,
                createdAt: snapshot.createdAt,
                modifiedAt: date
            )
        )
        try modelContext.save()
    }

    @discardableResult
    func toggleAssignment(
        planID: UUID,
        assignmentID: String,
        deviceID: String = Self.localDeviceID,
        at date: Date = .now
    ) throws -> Bool {
        guard var state = try activeState(), state.snapshot.id == planID else {
            throw ActiveReadingPlanError.noActivePlan
        }
        guard state.snapshot.assignmentIDs.contains(assignmentID) else {
            throw ActiveReadingPlanError.unknownAssignment
        }
        let willComplete = !state.completedAssignmentIDs.contains(assignmentID)
        modelContext.insert(
            BibleStudySchemaV2.PlanAssignmentCompletionEvent(
                planID: planID,
                assignmentID: assignmentID,
                action: willComplete ? .completed : .reopened,
                occurredAt: date,
                deviceID: deviceID
            )
        )
        if willComplete {
            state.completedAssignmentIDs.insert(assignmentID)
        } else {
            state.completedAssignmentIDs.remove(assignmentID)
        }
        if let model = try storedPlan(id: planID) {
            model.status =
                state.completedAssignmentIDs.isSuperset(of: state.snapshot.assignmentIDs)
                ? .completed : .active
            model.modifiedAt = date
        }
        try modelContext.save()
        return willComplete
    }

    func replaceSchedule(
        planID: UUID,
        with schedule: [PlanScheduledDay],
        at date: Date = .now
    ) throws {
        guard let model = try storedPlan(id: planID) else {
            throw ActiveReadingPlanError.noActivePlan
        }
        var snapshot: ActiveReadingPlanSnapshot
        do {
            snapshot = try decoder.decode(ActiveReadingPlanSnapshot.self, from: model.payload)
        } catch {
            throw ActiveReadingPlanError.corruptPayload
        }
        snapshot.schedule = schedule
        model.payload = try encoder.encode(snapshot)
        model.modifiedAt = date
        try modelContext.save()
    }

    func setStatus(
        planID: UUID,
        status: ReadingPlanStatus,
        at date: Date = .now
    ) throws {
        guard let model = try storedPlan(id: planID) else {
            throw ActiveReadingPlanError.noActivePlan
        }
        model.status = status
        if status != .paused {
            model.pausedOn = nil
        }
        model.modifiedAt = date
        try modelContext.save()
    }

    func pause(
        planID: UUID,
        on localDate: PlanLocalDate,
        at date: Date = .now
    ) throws {
        guard let model = try storedPlan(id: planID) else {
            throw ActiveReadingPlanError.noActivePlan
        }
        model.status = .paused
        model.pausedOn = localDate
        model.modifiedAt = date
        try modelContext.save()
    }

    func resume(
        planID: UUID,
        on localDate: PlanLocalDate,
        calendar: Calendar = .current,
        at date: Date = .now
    ) throws {
        guard let state = try activeState(), state.snapshot.id == planID,
            let pausedOn = state.pausedOn
        else {
            throw ActiveReadingPlanError.noActivePlan
        }
        guard localDate > pausedOn else {
            try setStatus(planID: planID, status: .active, at: date)
            return
        }
        let revision = try ReadingPlanScheduler(calendar: calendar).resume(
            schedule: state.snapshot.schedule,
            events: dayCompletionEvents(for: state),
            pausedOn: pausedOn,
            resumesOn: localDate,
            rules: PlanScheduleRules(
                startDate: state.snapshot.schedule.first?.scheduledDate ?? localDate,
                eligibleWeekdays: state.snapshot.eligibleWeekdays
            ),
            createdAt: date
        )
        try replaceSchedule(planID: planID, with: revision.revisedSchedule, at: date)
        try setStatus(planID: planID, status: .active, at: date)
    }

    func recover(
        planID: UUID,
        asOf localDate: PlanLocalDate,
        mode: PlanRecoveryMode,
        calendar: Calendar = .current,
        at date: Date = .now
    ) throws {
        guard let state = try activeState(), state.snapshot.id == planID else {
            throw ActiveReadingPlanError.noActivePlan
        }
        let revision = try ReadingPlanScheduler(calendar: calendar).recover(
            schedule: state.snapshot.schedule,
            events: dayCompletionEvents(for: state),
            asOf: localDate,
            mode: mode,
            rules: PlanScheduleRules(
                startDate: state.snapshot.schedule.first?.scheduledDate ?? localDate,
                eligibleWeekdays: state.snapshot.eligibleWeekdays
            ),
            createdAt: date
        )
        try replaceSchedule(planID: planID, with: revision.revisedSchedule, at: date)
    }

    private func completionState(
        planID: UUID,
        validAssignmentIDs: Set<String>,
        chapterAssignmentIDsByOriginalID: [String: [String]]
    ) throws -> Set<String> {
        let events = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV2.PlanAssignmentCompletionEvent>(
                sortBy: [
                    SortDescriptor(\.occurredAt),
                    SortDescriptor(\.id),
                ]
            )
        ).filter { $0.planID == planID }

        var state: [String: Bool] = [:]
        for event in events {
            let affectedIDs: [String]
            if validAssignmentIDs.contains(event.assignmentID) {
                affectedIDs = [event.assignmentID]
            } else {
                affectedIDs = chapterAssignmentIDsByOriginalID[event.assignmentID] ?? []
            }
            for assignmentID in affectedIDs where validAssignmentIDs.contains(assignmentID) {
                state[assignmentID] = event.action == .completed
            }
        }
        return Set(state.compactMap { $0.value ? $0.key : nil })
    }

    private func storedPlan(id: UUID) throws -> BibleStudySchemaV2.ActiveReadingPlan? {
        try modelContext.fetch(FetchDescriptor<BibleStudySchemaV2.ActiveReadingPlan>())
            .first { $0.id == id && $0.deletedAt == nil }
    }

    private func dayCompletionEvents(for state: ActiveReadingPlanState) -> [PlanDayCompletionEvent] {
        state.completedDayIndices.map {
            PlanDayCompletionEvent(
                logicalDayIndex: $0,
                action: .completed,
                occurredAt: .distantPast,
                deviceID: Self.localDeviceID
            )
        }
    }

    private static var localDeviceID: String {
        "local-apple-device"
    }
}

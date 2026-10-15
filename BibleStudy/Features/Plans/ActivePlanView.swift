import SwiftData
import SwiftUI

struct ActivePlanView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \BibleStudySchemaV2.ActiveReadingPlan.modifiedAt, order: .reverse)
    private var storedPlans: [BibleStudySchemaV2.ActiveReadingPlan]
    @Query(sort: \BibleStudySchemaV2.PlanAssignmentCompletionEvent.occurredAt)
    private var completionEvents: [BibleStudySchemaV2.PlanAssignmentCompletionEvent]

    let openReading: (ScriptureReference) -> Void

    @State private var selectedDayIndex: Int?
    @State private var recoverySheet: RecoverySheet?
    @State private var recoveryFinishDate = Date()
    @State private var errorMessage: String?

    private let calendar = Calendar.current

    var body: some View {
        Group {
            if let state {
                activePlanContent(state)
            } else {
                ContentUnavailableView(
                    "No Active Plan",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Choose a plan from the Plans tab to begin.")
                )
            }
        }
        .navigationTitle(state?.snapshot.title ?? "Active Plan")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar { planToolbar }
        .task { selectNextDueDayIfNeeded() }
        .onChange(of: activeFingerprint) { _, _ in selectNextDueDayIfNeeded() }
        .sheet(item: $recoverySheet) { mode in
            RecoveryDateView(
                title: mode.title,
                finishDate: $recoveryFinishDate
            ) {
                applyRecovery(mode)
            }
        }
        .alert("Plan update failed", isPresented: errorIsPresented) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "Please try again.")
        }
    }

    private func activePlanContent(_ state: ActiveReadingPlanState) -> some View {
        let selectedIndex = selectedDayIndex ?? state.nextDueDayIndex(asOf: today)
        let selectedDay = state.snapshot.day(selectedIndex)
        let progress = state.progress(asOf: today, calendar: calendar)

        return ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                PlanCoverView(
                    title: state.snapshot.title,
                    subtitle: state.snapshot.summary,
                    style: state.snapshot.coverStyle
                )
                .frame(height: 300)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Day \(selectedIndex) of \(state.snapshot.days.count)")
                            .font(.title2.bold())
                        Spacer()
                        PaceBadge(pace: displayedPace(progress.pace, state: state))
                    }
                    EmeraldProgressBar(value: state.completionFraction)
                        .accessibilityLabel("Plan completion")
                }

                DayRail(
                    snapshot: state.snapshot,
                    completedDayIndices: state.completedDayIndices,
                    selectedDayIndex: selectedIndex
                ) { selectedDayIndex = $0 }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(selectedDayTitle(selectedIndex, in: state.snapshot))
                            .font(.title2.bold())
                        Spacer()
                        if state.status == .paused {
                            Label("Paused", systemImage: "pause.fill")
                                .font(.caption.bold())
                                .foregroundStyle(AppTheme.warning)
                        }
                    }

                    if let selectedDay {
                        ForEach(selectedDay.assignments) { assignment in
                            ReadingAssignmentRow(
                                assignment: assignment,
                                versionID: state.snapshot.versionID,
                                isComplete: state.isAssignmentComplete(assignment.id),
                                toggleCompletion: { toggle(assignment.id, planID: state.snapshot.id) },
                                openReading: openReading
                            )
                        }
                    }
                }

                Button {
                    openNextReading(on: selectedIndex, state: state)
                } label: {
                    Label(
                        state.firstIncompleteAssignment(on: selectedIndex) == nil
                            ? "Read Again" : "Start Reading",
                        systemImage: "book.fill"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 32)
                }
                .buttonStyle(EmeraldActionButtonStyle())
                .disabled(selectedDay?.assignments.isEmpty != false)
                .accessibilityIdentifier("start-plan-reading")
            }
            .padding()
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .background(AppScreenBackground())
        .accessibilityIdentifier("active-plan-detail")
    }

    @ToolbarContentBuilder
    private var planToolbar: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                if state?.status == .paused {
                    Button("Resume Today", systemImage: "play.fill") { resumePlan() }
                } else {
                    Button("Pause Plan", systemImage: "pause.fill") { pausePlan() }
                }
                Divider()
                Button("Keep Original Dates", systemImage: "calendar") {
                    recover(.keepDates)
                }
                Button("Shift Unfinished to Today", systemImage: "arrow.forward") {
                    recover(.shiftForward)
                }
                Button("Redistribute Remaining…", systemImage: "arrow.left.arrow.right") {
                    presentRecovery(.redistribute)
                }
                Button("Choose New Finish Date…", systemImage: "calendar.badge.clock") {
                    presentRecovery(.newFinishDate)
                }
                Divider()
                Button("Archive Plan", systemImage: "archivebox", role: .destructive) {
                    archivePlan()
                }
            } label: {
                Label("Plan options", systemImage: "ellipsis.circle")
            }
        }
    }

    private var state: ActiveReadingPlanState? {
        _ = storedPlans.count
        _ = completionEvents.count
        return try? repository.activeState()
    }

    private var activeFingerprint: String {
        "\(storedPlans.first?.modifiedAt.timeIntervalSince1970 ?? 0)-\(completionEvents.count)"
    }

    private var repository: ActiveReadingPlanRepository {
        ActiveReadingPlanRepository(modelContext: modelContext)
    }

    private var today: PlanLocalDate {
        PlanLocalDate(Date(), calendar: calendar)
    }

    private var errorIsPresented: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )
    }

    private func selectNextDueDayIfNeeded() {
        guard let state else { return }
        if let selectedDayIndex, state.snapshot.day(selectedDayIndex) != nil { return }
        selectedDayIndex = state.nextDueDayIndex(asOf: today)
    }

    private func toggle(_ assignmentID: String, planID: UUID) {
        do {
            try repository.toggleAssignment(planID: planID, assignmentID: assignmentID)
        } catch {
            errorMessage = "The reading completion could not be saved."
        }
    }

    private func openNextReading(on dayIndex: Int, state: ActiveReadingPlanState) {
        let assignment =
            state.firstIncompleteAssignment(on: dayIndex)
            ?? state.firstAssignment(on: dayIndex)
        guard let assignment,
            let reference = try? assignment.scriptureReference(versionID: state.snapshot.versionID)
        else { return }
        openReading(reference)
    }

    private func pausePlan() {
        guard let state else { return }
        do {
            try repository.pause(planID: state.snapshot.id, on: today)
        } catch {
            errorMessage = "The plan could not be paused."
        }
    }

    private func resumePlan() {
        guard let state else { return }
        do {
            try repository.resume(planID: state.snapshot.id, on: today, calendar: calendar)
        } catch {
            errorMessage = "The plan could not be resumed."
        }
    }

    private func recover(_ mode: PlanRecoveryMode) {
        guard let state else { return }
        do {
            try repository.recover(
                planID: state.snapshot.id,
                asOf: today,
                mode: mode,
                calendar: calendar
            )
        } catch {
            errorMessage = "The remaining schedule could not be updated."
        }
    }

    private func presentRecovery(_ mode: RecoverySheet) {
        let suggested = state?.snapshot.schedule.last?.scheduledDate.foundationDate(calendar: calendar)
        recoveryFinishDate = max(suggested ?? Date(), Date())
        recoverySheet = mode
    }

    private func applyRecovery(_ mode: RecoverySheet) {
        let finishDate = PlanLocalDate(recoveryFinishDate, calendar: calendar)
        recover(mode == .redistribute ? .redistribute(through: finishDate) : .newFinishDate(finishDate))
        recoverySheet = nil
    }

    private func archivePlan() {
        guard let state else { return }
        do {
            try repository.setStatus(planID: state.snapshot.id, status: .archived)
            dismiss()
        } catch {
            errorMessage = "The plan could not be archived."
        }
    }

    private func selectedDayTitle(
        _ dayIndex: Int,
        in snapshot: ActiveReadingPlanSnapshot
    ) -> String {
        guard let date = snapshot.scheduledDay(dayIndex)?.scheduledDate else {
            return "Today's Readings"
        }
        return date == today ? "Today's Readings" : date.longFormatted
    }

    private func displayedPace(
        _ pace: PlanPaceStatus,
        state: ActiveReadingPlanState
    ) -> PlanPaceStatus {
        guard case .behind = pace else { return pace }
        let overdueCount = state.snapshot.schedule.count {
            $0.scheduledDate < today
                && !state.completedDayIndices.contains($0.logicalDayIndex)
        }
        return overdueCount == 0 ? .onTrack : .behind(days: overdueCount)
    }
}

struct PlanCoverView: View {
    let title: String
    let subtitle: String
    let style: ActiveReadingPlanCoverStyle

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [AppTheme.accent, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Text("WORD")
                .font(.system(size: 96, weight: .black, design: .serif))
                .foregroundStyle(.white.opacity(0.08))
                .offset(x: 120, y: -100)
            Image(systemName: "cross.fill")
                .font(.system(size: 90, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.13))
                .offset(x: 250, y: -110)
            VStack(alignment: .leading, spacing: 10) {
                Text("SCRIPTURE PLAN")
                    .font(.caption.bold())
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.72))
                Text(title)
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
                    .lineLimit(2)
            }
            .padding(28)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
        .shadow(color: AppTheme.accent.opacity(0.18), radius: 18, y: 8)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("active-plan-cover")
    }
}

private struct DayRail: View {
    let snapshot: ActiveReadingPlanSnapshot
    let completedDayIndices: Set<Int>
    let selectedDayIndex: Int
    let select: (Int) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(snapshot.schedule) { day in
                        Button {
                            select(day.logicalDayIndex)
                        } label: {
                            VStack(spacing: 6) {
                                HStack(spacing: 4) {
                                    Text("\(day.logicalDayIndex)")
                                        .font(.headline)
                                    if completedDayIndices.contains(day.logicalDayIndex) {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                    }
                                }
                                Text(day.scheduledDate.compactFormatted)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 76, height: 62)
                            .background(
                                selectedDayIndex == day.logicalDayIndex
                                    ? AppTheme.accent.opacity(0.18) : Color.secondary.opacity(0.09),
                                in: RoundedRectangle(cornerRadius: 14)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        selectedDayIndex == day.logicalDayIndex
                                            ? AppTheme.accent : .clear,
                                        lineWidth: 2
                                    )
                            }
                        }
                        .buttonStyle(.plain)
                        .id(day.logicalDayIndex)
                        .accessibilityLabel("Day \(day.logicalDayIndex), \(day.scheduledDate.longFormatted)")
                        .accessibilityValue(
                            completedDayIndices.contains(day.logicalDayIndex)
                                ? "Completed" : "Not completed"
                        )
                    }
                }
                .padding(.vertical, 2)
            }
            .onAppear { proxy.scrollTo(selectedDayIndex, anchor: .center) }
            .onChange(of: selectedDayIndex) { _, newValue in
                withAnimation { proxy.scrollTo(newValue, anchor: .center) }
            }
        }
        .accessibilityIdentifier("active-plan-day-rail")
    }
}

private struct ReadingAssignmentRow: View {
    let assignment: ReadingPlanAssignment
    let versionID: Int
    let isComplete: Bool
    let toggleCompletion: () -> Void
    let openReading: (ScriptureReference) -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: toggleCompletion) {
                Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isComplete ? AppTheme.success : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isComplete ? "Reopen \(title)" : "Complete \(title)")

            Button {
                guard let reference = try? assignment.scriptureReference(versionID: versionID) else {
                    return
                }
                openReading(reference)
            } label: {
                HStack {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                        .strikethrough(isComplete)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .accessibilityIdentifier("plan-reading-\(assignment.id)")
    }

    private var title: String {
        assignment.displayTitle
    }
}

private struct PaceBadge: View {
    let pace: PlanPaceStatus

    var body: some View {
        Text(title)
            .font(.caption.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.12), in: Capsule())
    }

    private var title: String {
        switch pace {
        case .ahead(let days): return "\(days) day\(days == 1 ? "" : "s") ahead"
        case .onTrack: return "On track"
        case .behind(let days): return "\(days) day\(days == 1 ? "" : "s") behind"
        case .complete: return "Complete"
        }
    }

    private var color: Color {
        switch pace {
        case .ahead, .onTrack, .complete: return AppTheme.success
        case .behind: return AppTheme.warning
        }
    }
}

private struct RecoveryDateView: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    @Binding var finishDate: Date
    let apply: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Finish date", selection: $finishDate, in: Date()..., displayedComponents: .date)
                Text("Completed readings stay fixed. Only unfinished days are rescheduled.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.supportingText)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        apply()
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 360, minHeight: 240)
    }
}

private enum RecoverySheet: String, Identifiable {
    case redistribute
    case newFinishDate

    var id: Self { self }
    var title: String {
        self == .redistribute ? "Redistribute Remaining" : "Choose New Finish Date"
    }
}

extension ActiveReadingPlanCoverStyle {
    var colors: [Color] {
        switch self {
        case .burgundy: return [Color(red: 0.40, green: 0.10, blue: 0.10), AppTheme.accent]
        case .evergreen: return [Color(red: 0.07, green: 0.28, blue: 0.22), Color(red: 0.18, green: 0.45, blue: 0.34)]
        case .midnight: return [Color(red: 0.08, green: 0.12, blue: 0.25), Color(red: 0.20, green: 0.28, blue: 0.48)]
        case .parchment: return [Color(red: 0.52, green: 0.34, blue: 0.16), Color(red: 0.72, green: 0.53, blue: 0.28)]
        }
    }
}

extension PlanLocalDate {
    var compactFormatted: String {
        foundationDate(calendar: .current)?.formatted(.dateTime.month(.abbreviated).day())
            ?? "\(month)/\(day)"
    }

    var longFormatted: String {
        foundationDate(calendar: .current)?.formatted(date: .abbreviated, time: .omitted)
            ?? "\(month)/\(day)/\(year)"
    }

    func foundationDate(calendar: Calendar) -> Date? {
        calendar.date(
            from: DateComponents(
                calendar: calendar,
                timeZone: calendar.timeZone,
                year: year,
                month: month,
                day: day,
                hour: 12
            )
        )
    }
}

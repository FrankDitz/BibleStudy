import SwiftData
import SwiftUI

struct VirtueFocusCycleSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var virtueID: VirtueIdentifier
    @State private var context: VirtuePracticeContext
    @State private var duration = VirtueCycleDuration.oneWeek
    @State private var practiceID: String
    @State private var beginningReflection = ""
    @State private var errorMessage: String?
    private let origin: VirtueCycleOrigin

    init(
        virtueID: VirtueIdentifier = .charity,
        context: VirtuePracticeContext = .relationships,
        practiceID: String = "charity-attentive-presence",
        origin: VirtueCycleOrigin = .focusCycle
    ) {
        _virtueID = State(initialValue: virtueID)
        _context = State(initialValue: context)
        _practiceID = State(initialValue: practiceID)
        self.origin = origin
    }

    var body: some View {
        Form {
            Section("Focus") {
                Picker("Virtue", selection: $virtueID) {
                    ForEach(VirtueFormationCatalog.descriptors) { descriptor in
                        Text(descriptor.title).tag(descriptor.id)
                    }
                }
                .onChange(of: virtueID) { _, _ in chooseFirstAvailablePractice() }

                Picker("Life context", selection: $context) {
                    ForEach(VirtuePracticeContext.allCases, id: \.self) { item in
                        Text(item.title).tag(item)
                    }
                }
                .onChange(of: context) { _, _ in chooseFirstAvailablePractice() }

                Picker("Duration", selection: $duration) {
                    ForEach(VirtueCycleDuration.allCases, id: \.self) { item in
                        Text(item.title).tag(item)
                    }
                }
            }

            Section("One concrete practice") {
                if availablePractices.isEmpty {
                    ContentUnavailableView(
                        "No practice for this context",
                        systemImage: "arrow.triangle.branch",
                        description: Text("Choose another context or virtue.")
                    )
                } else {
                    ForEach(availablePractices) { practice in
                        Button {
                            practiceID = practice.id
                        } label: {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(practice.title)
                                        .font(.headline)
                                    Text(practice.instruction)
                                        .foregroundStyle(AppTheme.supportingText)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                Image(systemName: practiceID == practice.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(AppTheme.accent)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section("Then — at the beginning") {
                TextField(
                    "What do you notice about this virtue in your life right now? (optional)",
                    text: $beginningReflection,
                    axis: .vertical
                )
                .lineLimit(3...6)
                .textFieldStyle(EditorialTextFieldStyle())
                Text("This private note will be placed beside your later reflection, not graded or analyzed.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.supportingText)
            }

            Section {
                Text(
                    "This cycle records participation, not holiness. Returning after a pause never erases progress or creates a penalty."
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
            }

            if let errorMessage {
                Section {
                    Label(errorMessage, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(AppTheme.danger)
                }
            }

            Section {
                Button("Start Focus Cycle", action: start)
                    .buttonStyle(EmeraldActionButtonStyle())
                    .disabled(selectedPractice == nil)
                    .accessibilityIdentifier("virtue-confirm-cycle")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("New Focus Cycle")
        .onAppear { chooseFirstAvailablePractice() }
        .accessibilityIdentifier("virtue-cycle-setup")
    }

    private var availablePractices: [VirtuePracticeDefinition] {
        VirtueFoundationLibrary.pathway(for: virtueID)?.practices.filter {
            $0.contexts.contains(context)
        } ?? []
    }

    private var selectedPractice: VirtuePracticeDefinition? {
        availablePractices.first { $0.id == practiceID }
    }

    private func chooseFirstAvailablePractice() {
        if selectedPractice == nil {
            practiceID = availablePractices.first?.id ?? ""
        }
    }

    private func start() {
        guard let selectedPractice else { return }
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                _ = try VirtueFocusCycleEngine.start(
                    in: &state,
                    virtueID: virtueID,
                    context: context,
                    practice: selectedPractice,
                    duration: duration,
                    origin: origin,
                    beginningReflection: beginningReflection
                )
            }
            dismiss()
        } catch VirtueFocusCycleError.activeCycleExists {
            errorMessage = "Close or pause your current cycle before starting another."
        } catch {
            errorMessage = "The cycle could not be started. Review the selections and try again."
        }
    }
}

struct VirtueActiveCycleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let cycleID: UUID
    @State private var errorMessage: String?
    @State private var privateObservation = ""

    var body: some View {
        ScrollView {
            if let cycle {
                VStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    FeatureCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label(
                                cycle.status == .paused ? "Cycle paused" : "Current Focus Cycle", systemImage: "scope"
                            )
                            .font(.headline)
                            .foregroundStyle(cycle.status == .paused ? AppTheme.warning : AppTheme.success)
                            Text(pathwayTitle(cycle.virtueID))
                                .font(.system(.largeTitle, design: .serif, weight: .bold))
                            Text(
                                "Day \(cycle.dayNumber(asOf: .now)) of \(cycle.duration.rawValue) · \(cycle.context.title)"
                            )
                            .font(.headline)
                            Text(cycle.targetEndDate(), style: .date)
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.supportingText)
                                .accessibilityLabel("Target end date")
                        }
                    }

                    FeatureCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your practice")
                                .font(.headline)
                            Text(cycle.practice.title)
                                .font(.title2.bold())
                            Text(cycle.practice.instruction)
                            Text("\(cycle.practice.commitment.title) · \(cycle.context.title)")
                                .font(.caption)
                                .foregroundStyle(AppTheme.supportingText)
                        }
                    }

                    if cycle.status == .active {
                        dailyCheckIn(for: cycle)
                    }

                    if cycle.status != .paused {
                        NavigationLink {
                            VirtueCycleReviewView(cycleID: cycle.id)
                        } label: {
                            Label(
                                cycle.status == .completed ? "View cycle review" : "Review this week",
                                systemImage: "text.book.closed"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(EmeraldActionButtonStyle())
                        .accessibilityIdentifier("virtue-open-review")
                    }

                    controls(for: cycle)

                    Label(
                        "Pausing preserves the cycle exactly as it is. Resume whenever you are ready; no streak is broken and no progress is lost.",
                        systemImage: "heart"
                    )
                    .font(.footnote)
                    .foregroundStyle(AppTheme.supportingText)

                    if let errorMessage {
                        Label(errorMessage, systemImage: "exclamationmark.triangle")
                            .foregroundStyle(AppTheme.danger)
                    }
                }
                .padding()
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
            } else {
                ContentUnavailableView("Cycle unavailable", systemImage: "scope")
            }
        }
        .background(AppScreenBackground())
        .navigationTitle("Focus Cycle")
        .onAppear { privateObservation = todayCheckIn?.privateObservation ?? "" }
        .accessibilityIdentifier("virtue-active-cycle")
    }

    private var todayCheckIn: VirtueCheckIn? {
        _ = formationRecords.count
        return try? VirtueFormationRepository(modelContext: modelContext).state().checkIn(
            for: cycleID,
            on: .now
        )
    }

    private func dailyCheckIn(for cycle: VirtueFocusCycle) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Notice today")
                    .font(AppTypography.sectionTitle)
                Text("Choose the statement that best describes today. This is a factual check-in, not a grade.")
                    .foregroundStyle(AppTheme.supportingText)

                ForEach(VirtueCheckInStatus.allCases, id: \.self) { status in
                    Button {
                        record(status, for: cycle)
                    } label: {
                        HStack {
                            Image(systemName: todayCheckIn?.status == status ? "checkmark.circle.fill" : "circle")
                            Text(status.title)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(todayCheckIn?.status == status ? AppTheme.accent : .primary)
                    .accessibilityIdentifier("virtue-check-in-\(status.rawValue)")
                }

                TextField(
                    "Private observation (optional)",
                    text: $privateObservation,
                    axis: .vertical
                )
                .lineLimit(3...6)
                .textFieldStyle(EditorialTextFieldStyle())
                .accessibilityIdentifier("virtue-private-observation")

                Label("Saved only in your private formation record.", systemImage: "lock.fill")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.supportingText)
            }
        }
    }

    private var cycle: VirtueFocusCycle? {
        _ = formationRecords.count
        return try? VirtueFormationRepository(modelContext: modelContext).state().cycles.first {
            $0.id == cycleID
        }
    }

    @ViewBuilder
    private func controls(for cycle: VirtueFocusCycle) -> some View {
        HStack {
            if cycle.status == .active {
                Button("Pause Cycle") { update(.pause) }
                    .buttonStyle(EditorialSecondaryButtonStyle())
                    .accessibilityIdentifier("virtue-pause-cycle")
            } else if cycle.status == .paused {
                Button("Resume Cycle") { update(.resume) }
                    .buttonStyle(EmeraldActionButtonStyle())
                    .accessibilityIdentifier("virtue-resume-cycle")
            }
            if cycle.status != .completed {
                Button("Close Cycle") { update(.close) }
                    .buttonStyle(EditorialSecondaryButtonStyle())
                    .foregroundStyle(AppTheme.danger)
                    .accessibilityIdentifier("virtue-close-cycle")
            }
        }
    }

    private func pathwayTitle(_ id: VirtueIdentifier) -> String {
        VirtueFoundationLibrary.pathway(for: id)?.title ?? "Virtue"
    }

    private func record(_ status: VirtueCheckInStatus, for cycle: VirtueFocusCycle) {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                try VirtueFocusCycleEngine.recordCheckIn(
                    cycleID: cycle.id,
                    status: status,
                    privateObservation: privateObservation,
                    in: &state
                )
            }
            errorMessage = nil
        } catch {
            errorMessage = "Today's check-in could not be saved."
        }
    }

    private enum Action { case pause, resume, close }

    private func update(_ action: Action) {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                switch action {
                case .pause: try VirtueFocusCycleEngine.pause(cycleID: cycleID, in: &state)
                case .resume: try VirtueFocusCycleEngine.resume(cycleID: cycleID, in: &state)
                case .close: try VirtueFocusCycleEngine.close(cycleID: cycleID, in: &state)
                }
            }
            if case .close = action { dismiss() }
        } catch {
            errorMessage = "The cycle could not be updated. Your saved state was not changed."
        }
    }
}

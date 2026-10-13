import SwiftData
import SwiftUI

struct VirtuePracticeLibraryView: View {
    @State private var context: VirtuePracticeContext?
    @State private var commitment: VirtuePracticeCommitment?

    private var entries: [VirtuePracticeLibraryEntry] {
        VirtuePracticeLibrary.filtered(context: context, commitment: commitment)
    }

    var body: some View {
        List {
            Section {
                Picker("Context", selection: $context) {
                    Text("All contexts").tag(Optional<VirtuePracticeContext>.none)
                    ForEach(VirtuePracticeContext.allCases, id: \.self) {
                        Text($0.title).tag(Optional($0))
                    }
                }
                Picker("Commitment", selection: $commitment) {
                    Text("All sizes").tag(Optional<VirtuePracticeCommitment>.none)
                    ForEach(VirtuePracticeCommitment.allCases, id: \.self) {
                        Text($0.title).tag(Optional($0))
                    }
                }
            }

            Section("Practices") {
                ForEach(entries) { entry in
                    NavigationLink {
                        VirtuePracticeDetailView(entry: entry, preferredContext: context)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.practice.title)
                                .font(.headline)
                            Text("\(entry.virtueTitle) · \(entry.practice.commitment.title)")
                                .font(.caption)
                                .foregroundStyle(AppTheme.supportingText)
                            Text(entry.practice.instruction)
                                .lineLimit(2)
                                .foregroundStyle(AppTheme.supportingText)
                        }
                    }
                }
            }
        }
        .navigationTitle("Practice Library")
        .accessibilityIdentifier("virtue-practice-library")
    }
}

private struct VirtuePracticeDetailView: View {
    let entry: VirtuePracticeLibraryEntry
    let preferredContext: VirtuePracticeContext?

    private var selectedContext: VirtuePracticeContext {
        if let preferredContext, entry.practice.contexts.contains(preferredContext) {
            return preferredContext
        }
        return entry.practice.contexts.sorted { $0.rawValue < $1.rawValue }.first ?? .relationships
    }

    var body: some View {
        List {
            Section(entry.virtueTitle) {
                Text(entry.practice.title)
                    .font(.title2.bold())
                Text(entry.practice.instruction)
                LabeledContent("Commitment", value: entry.practice.commitment.title)
                if let minutes = entry.practice.estimatedMinutes {
                    LabeledContent("Approximate time", value: "\(minutes) minutes")
                }
            }
            Section("Useful contexts") {
                Text(entry.practice.contexts.map(\.title).sorted().joined(separator: ", "))
            }
            Section {
                NavigationLink("Begin a Focus Cycle") {
                    VirtueFocusCycleSetupView(
                        virtueID: entry.virtueID,
                        context: selectedContext,
                        practiceID: entry.practice.id
                    )
                }
            }
        }
        .navigationTitle(entry.practice.title)
    }
}

struct VirtueThematicJourneysView: View {
    var body: some View {
        List(VirtueThematicJourneyLibrary.journeys) { journey in
            NavigationLink {
                VirtueThematicJourneyDetailView(journey: journey)
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    Text(journey.title)
                        .font(.headline)
                    Text(journey.summary)
                        .foregroundStyle(AppTheme.supportingText)
                    Text("\(journey.stages.count) practices · \(journey.context.title)")
                        .font(.caption)
                        .foregroundStyle(AppTheme.accent)
                }
            }
        }
        .navigationTitle("Thematic Journeys")
        .accessibilityIdentifier("virtue-thematic-journeys")
    }
}

private struct VirtueThematicJourneyDetailView: View {
    let journey: VirtueThematicJourney

    var body: some View {
        List {
            Section {
                Text(journey.summary)
                    .font(AppTypography.screenIntroduction)
                Label("Source-checked draft · Catholic review pending", systemImage: "checkmark.shield")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.accent)
                Text(
                    "Move through these in order or choose the practice that fits now. This is a guide for discernment, not a rigid rule or a measure of holiness."
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
            }

            Section("Journey") {
                ForEach(Array(journey.stages.enumerated()), id: \.element.id) { index, stage in
                    if let entry = VirtuePracticeLibrary.entry(
                        virtueID: stage.virtueID,
                        practiceID: stage.practiceID
                    ) {
                        NavigationLink {
                            VirtueFocusCycleSetupView(
                                virtueID: stage.virtueID,
                                context: journey.context,
                                practiceID: stage.practiceID,
                                origin: .thematicJourney
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(index + 1). \(stage.title)")
                                    .font(.headline)
                                Text("\(entry.virtueTitle) · \(entry.practice.title)")
                                    .foregroundStyle(AppTheme.accent)
                                Text(stage.reflectionPrompt)
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.supportingText)
                            }
                        }
                    }
                }
            }

            Section("Catholic sources") {
                ForEach(journey.sources) { source in
                    Link(destination: source.url) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(source.title)
                            Text(source.locator)
                                .font(.caption)
                                .foregroundStyle(AppTheme.supportingText)
                        }
                    }
                }
            }
        }
        .navigationTitle(journey.title)
    }
}

struct VirtueRuleOfLifeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    private var state: VirtueFormationState {
        _ = formationRecords.count
        return (try? VirtueFormationRepository(modelContext: modelContext).state()) ?? .empty
    }

    var body: some View {
        List {
            Section {
                Text(
                    "Your Rule of Life contains only practices you deliberately retained after reflection. Revise it as seasons and responsibilities change."
                )
                .foregroundStyle(AppTheme.supportingText)
            }

            Section("Current practices") {
                if state.rulePractices.filter(\.isActive).isEmpty {
                    ContentUnavailableView(
                        "No retained practices yet",
                        systemImage: "leaf",
                        description: Text("Complete a cycle review and choose ‘Retain in my Rule of Life.’")
                    )
                }
                ForEach(state.rulePractices.filter(\.isActive)) { item in
                    ruleRow(item, actionTitle: "Retire") {
                        update { VirtueRuleOfLifeEngine.retire(practiceID: item.id, in: &$0) }
                    }
                }
            }

            if !state.rulePractices.filter({ !$0.isActive }).isEmpty {
                Section("Retired practices") {
                    ForEach(state.rulePractices.filter { !$0.isActive }) { item in
                        ruleRow(item, actionTitle: "Restore") {
                            update { VirtueRuleOfLifeEngine.restore(practiceID: item.id, in: &$0) }
                        }
                    }
                }
            }
        }
        .navigationTitle("My Rule of Life")
        .accessibilityIdentifier("virtue-rule-of-life")
    }

    private func ruleRow(
        _ item: VirtueRulePractice,
        actionTitle: String,
        action: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(item.practice.title)
                .font(.headline)
            Text(item.practice.instruction)
                .foregroundStyle(AppTheme.supportingText)
            Text("\(pathwayTitle(item.virtueID)) · \(item.context.title)")
                .font(.caption)
                .foregroundStyle(AppTheme.accent)
            Button(actionTitle, action: action)
                .buttonStyle(.bordered)
        }
        .padding(.vertical, 3)
    }

    private func pathwayTitle(_ id: VirtueIdentifier) -> String {
        VirtueFoundationLibrary.pathway(for: id)?.title ?? "Virtue"
    }

    private func update(_ change: (inout VirtueFormationState) -> Void) {
        _ = try? VirtueFormationRepository(modelContext: modelContext).update(change)
    }
}

import SwiftData
import SwiftUI

struct VirtueCycleReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let cycleID: UUID

    @State private var nowObservation = ""
    @State private var graceNoticed = ""
    @State private var decision = VirtueReviewDecision.continuePractice
    @State private var errorMessage: String?

    var body: some View {
        Form {
            if let cycle {
                Section("A factual look back") {
                    Text("Week \(weekIndex) · \(pathwayTitle(cycle.virtueID))")
                        .font(.title2.bold())
                    summaryRows
                    Text(
                        "A blank day is simply a blank day. These facts do not measure holiness, effort, or God's grace."
                    )
                    .font(.footnote)
                    .foregroundStyle(AppTheme.supportingText)
                }

                Section("Then") {
                    Text(cycle.beginningReflection ?? "No beginning observation was written.")
                        .foregroundStyle(
                            cycle.beginningReflection == nil ? AppTheme.supportingText : .primary
                        )
                }

                Section("Now") {
                    TextField(
                        "What do you notice now about your choices, desires, or relationships?",
                        text: $nowObservation,
                        axis: .vertical
                    )
                    .lineLimit(4...8)
                    .accessibilityIdentifier("virtue-review-now")
                    TextField(
                        "Where did you notice grace, help, or an invitation to grow? (optional)",
                        text: $graceNoticed,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                }

                Section("What comes next?") {
                    Picker("Decision", selection: $decision) {
                        ForEach(VirtueReviewDecision.allCases, id: \.self) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    Text(decisionNote)
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
                    Button("Save Review", action: save)
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                        .disabled(nowObservation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .accessibilityIdentifier("virtue-save-review")
                }
            } else {
                ContentUnavailableView("Cycle unavailable", systemImage: "text.book.closed")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Weekly Review")
        .onAppear(perform: loadExistingReview)
        .accessibilityIdentifier("virtue-cycle-review")
    }

    private var state: VirtueFormationState {
        _ = formationRecords.count
        return (try? VirtueFormationRepository(modelContext: modelContext).state()) ?? .empty
    }

    private var cycle: VirtueFocusCycle? {
        state.cycles.first { $0.id == cycleID }
    }

    private var weekIndex: Int {
        guard let cycle else { return 1 }
        return max(1, Int(ceil(Double(cycle.dayNumber(asOf: .now)) / 7)))
    }

    private var summary: VirtueActivitySummary? {
        try? VirtueReviewEngine.summary(
            cycleID: cycleID,
            weekIndex: weekIndex,
            in: state
        )
    }

    private var existingReview: VirtueCycleReview? {
        state.reviews.first { $0.cycleID == cycleID && $0.weekIndex == weekIndex }
    }

    private var summaryRows: some View {
        let summary =
            summary
            ?? VirtueActivitySummary(
                practiced: 0,
                noticedOpportunity: 0,
                choseDifferently: 0,
                notApplicable: 0,
                reflectedInEcho: 0
            )
        return VStack(spacing: 8) {
            countRow("Practiced", summary.practiced)
            countRow("Noticed an opportunity", summary.noticedOpportunity)
            countRow("Missed or chose differently", summary.choseDifferently)
            countRow("Not applicable", summary.notApplicable)
            countRow("Reflected in Echo", summary.reflectedInEcho)
        }
    }

    private func countRow(_ title: String, _ count: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(count)")
                .monospacedDigit()
                .fontWeight(.semibold)
                .accessibilityLabel("\(count) check-ins")
        }
    }

    private var decisionNote: String {
        switch decision {
        case .continuePractice:
            "Keep this cycle open and continue the same practice."
        case .changePractice:
            "Close this cycle, preserve its history, and choose a different practice next."
        case .retainPractice:
            "Close this cycle and add the practice to your personal, revisable Rule of Life."
        case .closePractice:
            "Close this cycle and preserve its history without retaining the practice."
        }
    }

    private func pathwayTitle(_ id: VirtueIdentifier) -> String {
        VirtueFoundationLibrary.pathway(for: id)?.title ?? "Virtue"
    }

    private func loadExistingReview() {
        guard let existingReview else { return }
        nowObservation = existingReview.nowObservation
        graceNoticed = existingReview.graceNoticed ?? ""
        decision = existingReview.decision
    }

    private func save() {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                try VirtueReviewEngine.submit(
                    cycleID: cycleID,
                    nowObservation: nowObservation,
                    graceNoticed: graceNoticed,
                    decision: decision,
                    in: &state
                )
            }
            dismiss()
        } catch {
            errorMessage = "The review could not be saved. Your previous record was not changed."
        }
    }
}

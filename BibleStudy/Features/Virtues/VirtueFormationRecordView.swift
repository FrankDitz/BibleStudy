import SwiftData
import SwiftUI

struct VirtueFormationRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    private var state: VirtueFormationState {
        _ = formationRecords.count
        return (try? VirtueFormationRepository(modelContext: modelContext).state()) ?? .empty
    }

    private var snapshot: VirtueFormationSnapshot {
        VirtueFormationSnapshot(state: state)
    }

    var body: some View {
        List {
            Section {
                Text(
                    "This record remembers what you chose and recorded. It does not measure holiness, rank virtues, infer weakness, or decide what God is doing."
                )
                .foregroundStyle(AppTheme.supportingText)
            }

            Section("Participation") {
                LabeledContent("Focus cycles begun", value: "\(snapshot.cyclesBegun)")
                LabeledContent("Cycles closed", value: "\(snapshot.cyclesCompleted)")
                LabeledContent("Reviews written", value: "\(snapshot.reviewsWritten)")
                LabeledContent("Contexts practiced", value: "\(snapshot.contextsPracticed.count)")
                LabeledContent("Practices in Rule of Life", value: "\(snapshot.activeRulePractices)")
            }

            if !VirtueFormationRecordBuilder.milestones(for: state).isEmpty {
                Section("Quiet milestones") {
                    ForEach(VirtueFormationRecordBuilder.milestones(for: state)) { milestone in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(milestone.title)
                                .font(.headline)
                            Text(milestone.detail)
                                .foregroundStyle(AppTheme.supportingText)
                        }
                    }
                }
            }

            Section("Check-ins recorded") {
                ForEach(VirtueCheckInStatus.allCases, id: \.self) { status in
                    LabeledContent(status.title, value: "\(snapshot.checkInsByStatus[status, default: 0])")
                }
            }

            Section("Cycle history") {
                if state.cycles.isEmpty {
                    ContentUnavailableView(
                        "No focus cycles yet",
                        systemImage: "scope",
                        description: Text("Your completed and current cycles will appear here.")
                    )
                }
                ForEach(state.cycles.reversed()) { cycle in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(pathwayTitle(cycle.virtueID))
                                .font(.headline)
                            Spacer()
                            Text(statusTitle(cycle.status))
                                .font(.caption.bold())
                                .foregroundStyle(AppTheme.accent)
                        }
                        Text(cycle.practice.title)
                        Text(
                            "\(cycle.context.title) · Began \(cycle.startedAt.formatted(date: .abbreviated, time: .omitted))"
                        )
                        .font(.caption)
                        .foregroundStyle(AppTheme.supportingText)
                        ShareLink(item: echoPayload(for: cycle)) {
                            Label("Prepare Echo reflection", systemImage: "square.and.arrow.up")
                        }
                        .accessibilityHint(
                            "Shares an explicit reflection request without private check-in observations."
                        )
                    }
                    .padding(.vertical, 3)
                }
            }
        }
        .navigationTitle("Formation Record")
        .accessibilityIdentifier("virtue-formation-record")
    }

    private func pathwayTitle(_ id: VirtueIdentifier) -> String {
        VirtueFoundationLibrary.pathway(for: id)?.title ?? "Virtue"
    }

    private func statusTitle(_ status: VirtueCycleStatus) -> String {
        switch status {
        case .active: "Active"
        case .paused: "Paused"
        case .completed: "Closed"
        }
    }

    private func echoPayload(for cycle: VirtueFocusCycle) -> String {
        let request = VirtueFormationIntegration.echoRequest(for: cycle)
        guard let data = try? BibleStudyHubEventCodec.encoder().encode(request) else {
            return request.prompt
        }
        return String(decoding: data, as: UTF8.self)
    }
}

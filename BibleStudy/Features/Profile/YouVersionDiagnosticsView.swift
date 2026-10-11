import SwiftUI

struct YouVersionDiagnosticsView: View {
    @State private var result: YouVersionCapabilityProbe.Result?
    @State private var isRunning = false

    var body: some View {
        List {
            Section {
                Button {
                    runProbe()
                } label: {
                    HStack {
                        Label("Run edition audit", systemImage: "checkmark.shield")
                        Spacer()
                        if isRunning {
                            ProgressView()
                                .controlSize(.small)
                        }
                    }
                }
                .disabled(isRunning)
            } footer: {
                Text("Checks the editions licensed to this App Key. It records no Scripture text or credential.")
            }

            if let result {
                ForEach(result.reports) { report in
                    Section("\(report.abbreviation) · \(report.versionID)") {
                        statusRow("Catholic structure", passes: report.isApprovedStructure)
                        LabeledContent("Provider book resources", value: String(report.providerBookCount))
                        statusRow("Esther additions (ESG)", passes: report.hasEstherAdditions)
                        statusRow("Daniel 13–14", passes: report.hasDanielAdditions)
                        statusRow("Attribution", passes: report.hasAttribution)

                        if !report.missingProviderBookIDs.isEmpty {
                            LabeledContent(
                                "Missing provider IDs",
                                value: report.missingProviderBookIDs.joined(separator: ", ")
                            )
                        }
                    }
                }

                ForEach(result.failures) { failure in
                    Section("Edition \(failure.versionID)") {
                        Label("Audit failed", systemImage: "xmark.octagon")
                            .foregroundStyle(.red)
                        Text(failure.message)
                            .font(.footnote)
                            .textSelection(.enabled)
                    }
                }
            }
        }
        .navigationTitle("YouVersion Audit")
    }

    @ViewBuilder
    private func statusRow(_ title: String, passes: Bool) -> some View {
        LabeledContent(title) {
            Label(
                passes ? "Pass" : "Review",
                systemImage: passes ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
            )
            .foregroundStyle(passes ? AppTheme.success : .orange)
        }
    }

    private func runProbe() {
        isRunning = true
        Task {
            result = await YouVersionCapabilityProbe.run()
            isRunning = false
        }
    }
}

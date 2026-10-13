import SwiftData
import SwiftUI

struct PlansView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \BibleStudySchemaV2.ActiveReadingPlan.modifiedAt, order: .reverse)
    private var storedPlans: [BibleStudySchemaV2.ActiveReadingPlan]
    @Query(sort: \BibleStudySchemaV2.PlanAssignmentCompletionEvent.occurredAt)
    private var completionEvents: [BibleStudySchemaV2.PlanAssignmentCompletionEvent]

    let openReading: (ScriptureReference) -> Void

    @State private var isPresentingComposer = false
    @State private var previewedTemplate: ReadingPlanTemplate?
    @State private var selectedTemplate: ReadingPlanTemplate?
    @State private var isShowingActivePlan = false
    @State private var shouldOpenActivePlanAfterDismiss = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    activePlanSection

                    Text("Premade plans")
                        .font(.title2.bold())
                        .padding(.top, 4)

                    ForEach(ReadingPlanTemplate.featured) { plan in
                        PremadePlanCard(
                            plan: plan,
                            previewPlan: { previewedTemplate = plan },
                            startPlan: { selectedTemplate = plan }
                        )
                    }
                }
                .padding()
                .frame(maxWidth: 900)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Plans")
            .toolbar {
                Button {
                    isPresentingComposer = true
                } label: {
                    Label("Create plan", systemImage: "plus")
                }
                .accessibilityIdentifier("create-custom-plan")
            }
            .navigationDestination(isPresented: $isShowingActivePlan) {
                ActivePlanView(openReading: openReading)
            }
            .sheet(
                isPresented: $isPresentingComposer,
                onDismiss: openActivatedPlanIfNeeded
            ) {
                CustomPlanComposerView { preview in
                    activate(.make(preview: preview))
                }
            }
            .sheet(item: $previewedTemplate) { template in
                NavigationStack {
                    ReadingPlanPreviewView(plan: template) {
                        previewedTemplate = nil
                        Task { @MainActor in
                            try? await Task.sleep(for: .milliseconds(300))
                            selectedTemplate = template
                        }
                    }
                }
            }
            .sheet(item: $selectedTemplate, onDismiss: openActivatedPlanIfNeeded) { template in
                TemplatePlanActivationView(template: template) { snapshot in
                    activate(snapshot)
                }
            }
            .alert("Plan could not be started", isPresented: errorIsPresented) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "Please try again.")
            }
        }
    }

    @ViewBuilder
    private var activePlanSection: some View {
        if let state = activeState {
            Button {
                isShowingActivePlan = true
            } label: {
                FeatureCard {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: state.snapshot.coverStyle.colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 82, height: 96)
                            .overlay {
                                Image(systemName: "book.closed.fill")
                                    .font(.title)
                                    .foregroundStyle(.white.opacity(0.88))
                            }
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Your active plan")
                                .font(.caption.bold())
                                .foregroundStyle(AppTheme.accent)
                            Text(state.snapshot.title)
                                .font(.title3.bold())
                                .foregroundStyle(.primary)
                            Text(activePlanSummary(state))
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.supportingText)
                            ProgressView(value: state.completionFraction)
                                .tint(AppTheme.accent)
                        }
                        Spacer(minLength: 4)
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("open-active-plan")
        } else {
            FeatureCard {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Your active plan", systemImage: "calendar.badge.checkmark")
                        .font(.headline)
                    Text("No active plan yet")
                        .font(.title2.bold())
                    Text(
                        "Choose a premade plan below or create a schedule around your own reading goal."
                    )
                    .foregroundStyle(AppTheme.supportingText)
                    Button("Create a Custom Plan") { isPresentingComposer = true }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                }
            }
        }
    }

    private var activeState: ActiveReadingPlanState? {
        _ = storedPlans.count
        _ = completionEvents.count
        return try? repository.activeState()
    }

    private var repository: ActiveReadingPlanRepository {
        ActiveReadingPlanRepository(modelContext: modelContext)
    }

    private var errorIsPresented: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )
    }

    private func activate(_ snapshot: ActiveReadingPlanSnapshot) {
        do {
            try repository.activate(snapshot)
            shouldOpenActivePlanAfterDismiss = true
            isPresentingComposer = false
            selectedTemplate = nil
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(350))
                openActivatedPlanIfNeeded()
            }
        } catch {
            errorMessage = "The plan could not be saved on this device."
        }
    }

    private func openActivatedPlanIfNeeded() {
        guard shouldOpenActivePlanAfterDismiss else { return }
        shouldOpenActivePlanAfterDismiss = false
        isShowingActivePlan = true
    }

    private func activePlanSummary(_ state: ActiveReadingPlanState) -> String {
        let completed = state.completedDayIndices.count
        let total = state.snapshot.days.count
        if state.status == .paused {
            return "Paused · \(completed) of \(total) days complete"
        }
        return "\(completed) of \(total) days complete"
    }
}

private struct PremadePlanCard: View {
    let plan: ReadingPlanTemplate
    let previewPlan: () -> Void
    let startPlan: () -> Void

    var body: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(plan.title)
                    .font(.headline)
                Text(
                    "\(plan.durationDays) days · ~\(plan.estimatedDailyMinutes.lowerBound)–\(plan.estimatedDailyMinutes.upperBound) min/day"
                )
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
                Text(plan.summary)
                    .foregroundStyle(AppTheme.supportingText)
                HStack {
                    Button("Preview Plan", action: previewPlan)
                        .buttonStyle(.bordered)
                    Button("Start Plan", action: startPlan)
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                }
            }
        }
    }
}

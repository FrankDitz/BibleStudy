import SwiftData
import SwiftUI

struct PlansView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \BibleStudySchemaV2.ActiveReadingPlan.modifiedAt, order: .reverse)
    private var storedPlans: [BibleStudySchemaV2.ActiveReadingPlan]
    @Query(sort: \BibleStudySchemaV2.PlanAssignmentCompletionEvent.occurredAt)
    private var completionEvents: [BibleStudySchemaV2.PlanAssignmentCompletionEvent]

    let openReading: (ScriptureReference) -> Void
    var activePlanNavigationRequest = 0

    @State private var isPresentingComposer = false
    @State private var previewedTemplate: ReadingPlanTemplate?
    @State private var selectedTemplate: ReadingPlanTemplate?
    @State private var isShowingActivePlan = false
    @State private var shouldOpenActivePlanAfterDismiss = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    planHero

                    activePlanSection

                    EditorialSectionHeader(
                        "Premade plans",
                        eyebrow: "Choose your rhythm",
                        detail: "Preview every reading and commitment before you begin."
                    )
                    .padding(.top, 4)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 300), spacing: AppSpacing.standard)],
                        spacing: AppSpacing.standard
                    ) {
                        ForEach(ReadingPlanTemplate.featured) { plan in
                            PremadePlanCard(
                                plan: plan,
                                previewPlan: { previewedTemplate = plan },
                                startPlan: { selectedTemplate = plan }
                            )
                        }
                    }
                }
                .padding(AppSpacing.screen)
                .frame(maxWidth: 1120)
                .frame(maxWidth: .infinity)
            }
            .background(AppScreenBackground())
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
            .task(id: activePlanNavigationRequest) {
                guard activePlanNavigationRequest > 0, activeState != nil else { return }
                isShowingActivePlan = true
            }
        }
    }

    private var planHero: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [.black, AppTheme.accent.opacity(0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Text("365")
                .font(.system(size: 210, weight: .black, design: .serif))
                .foregroundStyle(.white.opacity(0.055))
                .offset(x: 130, y: 54)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 8) {
                EditorialEyebrow("Scripture formation", inverse: true)
                Text("PLAN\nTHE WORD.")
                    .font(.system(size: 47, weight: .black, design: .serif))
                    .minimumScaleFactor(0.72)
                Rectangle()
                    .fill(.white.opacity(0.8))
                    .frame(width: 42, height: 2)
                Text(
                    "Choose a clear path. Keep an honest pace. Return without shame when life interrupts the schedule."
                )
                .font(.headline)
                .foregroundStyle(.white.opacity(0.82))
                .frame(maxWidth: 560, alignment: .leading)
            }
            .foregroundStyle(.white)
            .padding(AppSpacing.spacious)
        }
        .frame(minHeight: 320)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var activePlanSection: some View {
        if let state = activeState {
            Button {
                isShowingActivePlan = true
            } label: {
                FeatureCard {
                    HStack(spacing: 16) {
                        Rectangle()
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
                            EmeraldProgressBar(value: state.completionFraction)
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
                        .buttonStyle(EmeraldActionButtonStyle())
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
            VStack(alignment: .leading, spacing: AppSpacing.standard) {
                cover.frame(height: 185)
                details
            }
        }
    }

    private var cover: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [AppTheme.accent, .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text("\(plan.durationDays)")
                .font(.system(size: 72, weight: .black, design: .serif))
                .foregroundStyle(.white.opacity(0.20))
                .offset(x: 36, y: -18)
            VStack(alignment: .leading, spacing: 5) {
                EditorialEyebrow("Reading plan", inverse: true)
                Text(plan.title)
                    .font(.system(.headline, design: .serif, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(3)
            }
            .padding(14)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.control, style: .continuous))
        .accessibilityHidden(true)
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(plan.title)
                .font(AppTypography.cardTitle)
            Text(
                "\(plan.durationDays) days · ~\(plan.estimatedDailyMinutes.lowerBound)–\(plan.estimatedDailyMinutes.upperBound) min/day"
            )
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.accent)
            Text(plan.summary)
                .foregroundStyle(AppTheme.supportingText)
            HStack {
                Button("Preview", action: previewPlan)
                    .buttonStyle(EditorialSecondaryButtonStyle())
                Button("Start Plan", action: startPlan)
                    .buttonStyle(EmeraldActionButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

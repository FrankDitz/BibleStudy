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
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    planHero
                    activePlanSection
                    planCollection(
                        title: "Start with Jesus",
                        eyebrow: "01 · A clear beginning",
                        detail:
                            "Short, focused routes through the life of Christ—ideal for beginning again or building a first daily rhythm.",
                        identifiers: ["start-with-jesus-21", "gospels-30"]
                    )
                    planCollection(
                        title: "Build a monthly rhythm",
                        eyebrow: "02 · Focused formation",
                        detail:
                            "Spend one month with prayer, wisdom, or the books unique to the Catholic canon.",
                        identifiers: ["psalms-proverbs-31", "catholic-deuterocanon-30"]
                    )
                    planCollection(
                        title: "Take the long road",
                        eyebrow: "03 · Complete journeys",
                        detail:
                            "Choose a sustained route through the New Testament, Old Testament, or the full Catholic Bible.",
                        identifiers: [
                            "new-testament-90", "catholic-old-testament-90", "catholic-bible-365",
                        ]
                    )
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
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                EditorialHeroArtwork(assetName: "PlansHero")
                    .frame(height: EditorialImageMetrics.primaryHeroHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay {
                        LinearGradient(
                            colors: [.black.opacity(0.04), .black.opacity(0.28), .black.opacity(0.92)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }

                VStack(alignment: .leading, spacing: 9) {
                    EditorialEyebrow("Scripture formation", inverse: true)
                    Text("STAY IN\nTHE WORD.")
                        .font(.system(size: 48, weight: .black, design: .serif))
                        .minimumScaleFactor(0.68)
                    Rectangle()
                        .fill(AppTheme.accent)
                        .frame(width: 48, height: 3)
                    Text("A reading rhythm gives intention to every return to Scripture.")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.86))
                        .frame(maxWidth: 480, alignment: .leading)
                }
                .foregroundStyle(.white)
                .padding(AppSpacing.spacious)
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 0) {
                    planStep("01", title: "Choose", detail: "Find your scope")
                    planStep("02", title: "Preview", detail: "See every reading")
                    planStep("03", title: "Begin", detail: "Keep an honest pace")
                }
                VStack(spacing: 0) {
                    planStep("01", title: "Choose", detail: "Find your scope")
                    planStep("02", title: "Preview", detail: "See every reading")
                    planStep("03", title: "Begin", detail: "Keep an honest pace")
                }
            }
            .background(AppTheme.surface)
            .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        }
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
        .accessibilityElement(children: .contain)
    }

    private func planStep(_ number: String, title: String, detail: String) -> some View {
        HStack(spacing: 10) {
            Text(number)
                .font(.system(.title3, design: .serif, weight: .black))
                .foregroundStyle(AppTheme.accent)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(AppTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(AppTheme.supportingText)
            }
            Spacer(minLength: 8)
        }
        .padding(.horizontal, AppSpacing.standard)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .trailing) {
            Rectangle().fill(AppTheme.hairline).frame(width: 1)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var activePlanSection: some View {
        if let state = activeState {
            Button {
                isShowingActivePlan = true
            } label: {
                VStack(spacing: 0) {
                    Rectangle().fill(AppTheme.accent).frame(height: 4)
                    HStack(spacing: AppSpacing.standard) {
                        EditorialArtwork(
                            assetName: ReadingPlanArtwork.assetName(for: state.snapshot.sourceID)
                        )
                        .frame(
                            width: EditorialImageMetrics.activePlanThumbnailSize.width,
                            height: EditorialImageMetrics.activePlanThumbnailSize.height
                        )
                        .clipped()

                        VStack(alignment: .leading, spacing: 7) {
                            EditorialEyebrow("Continue your active plan")
                            Text(state.snapshot.title)
                                .font(.system(.title2, design: .serif, weight: .bold))
                                .foregroundStyle(AppTheme.ink)
                            Text(activePlanSummary(state))
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.supportingText)
                            EmeraldProgressBar(value: state.completionFraction)
                        }
                        Spacer(minLength: 4)
                        Image(systemName: "arrow.right")
                            .font(.headline)
                            .foregroundStyle(AppTheme.accent)
                    }
                    .padding(AppSpacing.standard)
                }
                .background(AppTheme.surface)
                .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("open-active-plan")
        } else {
            VStack(alignment: .leading, spacing: 12) {
                Rectangle().fill(AppTheme.accent).frame(height: 4)
                EditorialEyebrow("Your next step")
                Text("Choose a plan or build your own.")
                    .font(.system(.title2, design: .serif, weight: .bold))
                Text(
                    "Preview a complete schedule below, or create a plan around the books and pace you already have in mind."
                )
                .foregroundStyle(AppTheme.supportingText)
                Button("Create a Custom Plan") { isPresentingComposer = true }
                    .buttonStyle(EmeraldActionButtonStyle())
            }
            .padding(AppSpacing.spacious)
            .background(AppTheme.surface)
            .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        }
    }

    private func planCollection(
        title: String,
        eyebrow: String,
        detail: String,
        identifiers: [String]
    ) -> some View {
        let plans = identifiers.compactMap { identifier in
            ReadingPlanTemplate.featured.first { $0.id == identifier }
        }

        return VStack(alignment: .leading, spacing: AppSpacing.standard) {
            HStack(alignment: .top, spacing: AppSpacing.standard) {
                Rectangle()
                    .fill(AppTheme.accent)
                    .frame(width: 4, height: 58)
                EditorialSectionHeader(title, eyebrow: eyebrow, detail: detail)
                Spacer(minLength: 8)
                Text("\(plans.count) PLANS")
                    .font(AppTypography.eyebrow)
                    .tracking(1.4)
                    .foregroundStyle(AppTheme.supportingText)
                    .padding(.top, 2)
            }

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 300), spacing: AppSpacing.standard)],
                spacing: AppSpacing.standard
            ) {
                ForEach(plans) { plan in
                    PremadePlanCard(
                        plan: plan,
                        previewPlan: { previewedTemplate = plan },
                        startPlan: { selectedTemplate = plan }
                    )
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
        VStack(spacing: 0) {
            planCover
            details
                .padding(AppSpacing.standard)
                .background(AppTheme.surface)
        }
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.card, style: .continuous))
    }

    @ViewBuilder
    private var planCover: some View {
        #if os(macOS)
            cover
                .frame(maxWidth: .infinity)
                .aspectRatio(3 / 2, contentMode: .fit)
        #else
            cover
                .frame(height: 220)
        #endif
    }

    private var cover: some View {
        ZStack(alignment: .bottomLeading) {
            EditorialArtwork(assetName: ReadingPlanArtwork.assetName(for: plan.id))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            LinearGradient(
                colors: [.clear, .black.opacity(0.18), .black.opacity(0.88)],
                startPoint: .top,
                endPoint: .bottom
            )
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    EditorialEyebrow("\(plan.durationDays) day plan", inverse: true)
                    Spacer()
                    Text("~\(plan.estimatedDailyMinutes.lowerBound)–\(plan.estimatedDailyMinutes.upperBound) MIN")
                        .font(.caption2.bold())
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.82))
                }
                Text(plan.title)
                    .font(.system(.title2, design: .serif, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
            .padding(AppSpacing.standard)
        }
        .accessibilityHidden(true)
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(plan.summary)
                .foregroundStyle(AppTheme.supportingText)
                .lineLimit(3)
            Rectangle().fill(AppTheme.hairline).frame(height: 1)
            HStack(spacing: 10) {
                Button("Preview", action: previewPlan)
                    .buttonStyle(EditorialSecondaryButtonStyle())
                Button("Start Plan", action: startPlan)
                    .buttonStyle(EmeraldActionButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private enum ReadingPlanArtwork {
    static func assetName(for identifier: String?) -> String {
        switch identifier {
        case "new-testament-90": "PlanNewTestament90"
        case "catholic-old-testament-90": "PlanOldTestament90"
        case "catholic-bible-365": "PlanBible365"
        case "gospels-30": "PlanGospels30"
        case "psalms-proverbs-31": "PlanPsalmsProverbs31"
        case "start-with-jesus-21": "PlanStartJesus21"
        case "catholic-deuterocanon-30": "PlanDeuterocanon30"
        default: "PlansHero"
        }
    }
}

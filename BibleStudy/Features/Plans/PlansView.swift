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
                #if os(macOS)
                    desktopContent
                #else
                    mobileContent
                #endif
            }
            .background(AppScreenBackground())
            #if os(macOS)
                .navigationTitle("Plans")
                .toolbar {
                    Button {
                        isPresentingComposer = true
                    } label: {
                        Label("Create plan", systemImage: "plus")
                    }
                    .accessibilityIdentifier("create-custom-plan")
                }
            #else
                .toolbar(.hidden, for: .navigationBar)
            #endif
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

    #if os(macOS)
        private var desktopContent: some View {
            LazyVStack(alignment: .leading, spacing: 40) {
                planHero
                planSections
            }
            .padding(AppSpacing.screen)
            .frame(maxWidth: 1180)
            .frame(maxWidth: .infinity)
        }
    #endif

    #if !os(macOS)
        private var mobileContent: some View {
            LazyVStack(alignment: .leading, spacing: 40) {
                planHero

                VStack(alignment: .leading, spacing: 40) {
                    planSections
                }
                .padding(.horizontal, AppSpacing.screen)
            }
            .padding(.bottom, AppSpacing.section)
            .frame(maxWidth: .infinity)
        }
    #endif

    @ViewBuilder
    private var planSections: some View {
        activePlanSection
        plansInterlude
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
        EditorialEndCap(
            title: "Read · return · grow",
            identifier: "plans-content-end"
        )
    }

    private var planHero: some View {
        VStack(spacing: 0) {
            #if os(macOS)
                HStack(spacing: 0) {
                    planHeroMessage
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    EditorialMediaSlot(assetName: "PlansHero", slot: .feature)
                        .frame(maxWidth: .infinity)
                }
                .background(.black)
            #else
                EditorialMediaSlot(assetName: "PlansHero", slot: .feature)
                planHeroMessage
            #endif

            HStack(spacing: 0) {
                planStep("01", title: "Choose", detail: "Find your pace")
                planStep("02", title: "Preview", detail: "See every day")
                planStep("03", title: "Begin", detail: "Start reading")
            }
            .background(AppTheme.surface)
        }
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        #if !os(macOS)
            .overlay(alignment: .topTrailing) {
                Button {
                    isPresentingComposer = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(.black.opacity(0.62))
                        .overlay { Rectangle().stroke(.white.opacity(0.24), lineWidth: 1) }
                }
                .buttonStyle(.plain)
                .padding(AppSpacing.standard)
                .accessibilityLabel("Create plan")
                .accessibilityIdentifier("create-custom-plan")
            }
        #endif
        .accessibilityElement(children: .contain)
    }

    private var planHeroMessage: some View {
        VStack(alignment: .leading, spacing: 10) {
            EditorialEyebrow("Plans · Scripture formation", inverse: true)
            Text("STAY IN\nTHE WORD.")
                .font(.system(size: planHeroTitleSize, weight: .black, design: .serif))
                .minimumScaleFactor(0.72)
            Rectangle()
                .fill(AppTheme.accent)
                .frame(width: 48, height: 3)
            Text(
                "Choose a complete route, preview the commitment, and return each day with purpose."
            )
            .font(planHeroBodyFont)
            .foregroundStyle(.white.opacity(0.78))
            .frame(maxWidth: 460, alignment: .leading)
        }
        .foregroundStyle(.white)
        .padding(planHeroPadding)
        .background(.black)
    }

    private var planHeroTitleSize: CGFloat {
        #if os(macOS)
            46
        #else
            34
        #endif
    }

    private var planHeroBodyFont: Font {
        #if os(macOS)
            .headline
        #else
            .subheadline
        #endif
    }

    private var planHeroPadding: CGFloat {
        #if os(macOS)
            AppSpacing.spacious
        #else
            AppSpacing.standard
        #endif
    }

    private func planStep(_ number: String, title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(number)
                .font(.system(.headline, design: .serif, weight: .black))
                .foregroundStyle(AppTheme.accent)
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(AppTheme.ink)
            Text(detail)
                .font(.caption2)
                .foregroundStyle(AppTheme.supportingText)
                .lineLimit(2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .trailing) {
            Rectangle().fill(AppTheme.hairline).frame(width: 1)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var activePlanSection: some View {
        if let state = activeState {
            VStack(spacing: 0) {
                Button {
                    isShowingActivePlan = true
                } label: {
                    VStack(spacing: 0) {
                        Rectangle().fill(AppTheme.accent).frame(height: 4)
                        HStack(spacing: AppSpacing.standard) {
                            EditorialMediaSlot(
                                assetName: ReadingPlanArtwork.assetName(for: state.snapshot.sourceID),
                                slot: .thumbnail
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

                activePlanRoute(state)
            }
        } else {
            HStack(spacing: AppSpacing.standard) {
                Image(systemName: "calendar.badge.plus")
                    .font(.title2)
                    .foregroundStyle(AppTheme.onAccent)
                    .frame(width: 52, height: 52)
                    .background(.black)

                VStack(alignment: .leading, spacing: 4) {
                    EditorialEyebrow("Make it your own")
                    Text("Build your own plan")
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .foregroundStyle(AppTheme.ink)
                    Text("Choose the books, days, and pace.")
                        .font(.caption)
                        .foregroundStyle(AppTheme.supportingText)
                        .lineLimit(1)
                }

                Spacer(minLength: 4)

                Button {
                    isPresentingComposer = true
                } label: {
                    Label("Create", systemImage: "plus")
                }
                .buttonStyle(EditorialSecondaryButtonStyle())
                .accessibilityIdentifier("create-custom-plan-inline")
            }
            .padding(AppSpacing.standard)
            .background(AppTheme.surface)
            .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
            .overlay(alignment: .leading) {
                Rectangle().fill(AppTheme.accent).frame(width: 4)
            }
        }
    }

    private func activePlanRoute(_ state: ActiveReadingPlanState) -> some View {
        let total = max(state.snapshot.days.count, 1)
        let completed = state.completedDayIndices.count
        let currentIndex = min(Int((Double(completed) / Double(total)) * 3), 2)
        let completedPhases = Set(0 ..< currentIndex)

        return EditorialRouteMap(
            eyebrow: "Your journey",
            steps: [
                EditorialRouteStep(id: "foundation", number: "01", title: "Foundation", detail: "Begin the route"),
                EditorialRouteStep(id: "discipleship", number: "02", title: "Discipleship", detail: "Build the rhythm"),
                EditorialRouteStep(id: "mission", number: "03", title: "Mission", detail: "Finish faithfully"),
            ],
            currentIndex: currentIndex,
            completedIndices: completedPhases,
            progressLabel: "Day \(min(completed + 1, total)) of \(total)"
        )
        .accessibilityIdentifier("active-plan-route-map")
    }

    private var plansInterlude: some View {
        EditorialInterlude(
            eyebrow: "Scripture for the journey",
            mark: "ROOTED",
            statement: "Walk in Christ, rooted and built up in him, established in the faith.",
            citation: "Colossians 2:6–7",
            tone: .black
        )
        .accessibilityIdentifier("plans-scripture-interlude")
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
                Text(String(eyebrow.prefix(2)))
                    .font(.system(size: 40, weight: .black, design: .serif))
                    .foregroundStyle(AppTheme.accent)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 7) {
                    EditorialEyebrow(String(eyebrow.dropFirst(5)))
                    Text(title)
                        .font(AppTypography.sectionTitle)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.supportingText)
                }
                Spacer(minLength: 4)
            }

            #if os(macOS)
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 320), spacing: AppSpacing.standard)],
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
            #else
                LazyVStack(spacing: 12) {
                    ForEach(plans) { plan in
                        PremadePlanCard(
                            plan: plan,
                            previewPlan: { previewedTemplate = plan },
                            startPlan: { selectedTemplate = plan }
                        )
                    }
                }
            #endif
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
        #if os(macOS)
            desktopCard
        #else
            mobileCard
        #endif
    }

    private var desktopCard: some View {
        VStack(spacing: 0) {
            cover
            details
                .padding(AppSpacing.standard)
                .background(AppTheme.surface)
        }
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
    }

    private var cover: some View {
        ZStack(alignment: .bottomLeading) {
            EditorialMediaSlot(
                assetName: ReadingPlanArtwork.assetName(for: plan.id),
                slot: .planCover
            )
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

    private var mobileCard: some View {
        VStack(spacing: 0) {
            Button(action: previewPlan) { cover }
                .buttonStyle(.plain)
                .accessibilityLabel("Preview \(plan.title)")

            Text(plan.summary)
                .font(.subheadline)
                .foregroundStyle(AppTheme.supportingText)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppSpacing.standard)

            HStack(spacing: 0) {
                Button("View full preview", action: previewPlan)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                    .frame(maxWidth: .infinity, minHeight: 44)
                Rectangle().fill(AppTheme.hairline).frame(width: 1, height: 44)
                Button("Start plan", action: startPlan)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.accent)
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .overlay(alignment: .top) { EditorialDivider() }
        }
        .background(AppTheme.surface)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
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

enum ReadingPlanArtwork {
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

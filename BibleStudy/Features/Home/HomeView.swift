import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \BibleStudySchemaV1.ReadingPosition.modifiedAt, order: .reverse)
    private var readingPositions: [BibleStudySchemaV1.ReadingPosition]
    @Query(sort: \BibleStudySchemaV2.ActiveReadingPlan.modifiedAt, order: .reverse)
    private var storedPlans: [BibleStudySchemaV2.ActiveReadingPlan]
    @Query(sort: \BibleStudySchemaV2.PlanAssignmentCompletionEvent.occurredAt, order: .reverse)
    private var completionEvents: [BibleStudySchemaV2.PlanAssignmentCompletionEvent]
    @Query(sort: \BibleStudySchemaV1.ScriptureAnnotation.modifiedAt, order: .reverse)
    private var annotations: [BibleStudySchemaV1.ScriptureAnnotation]
    @Query(sort: \BibleStudySchemaV1.LearningProgress.modifiedAt, order: .reverse)
    private var learningProgress: [BibleStudySchemaV1.LearningProgress]
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let openReading: (ScriptureReference) -> Void
    let openPlans: () -> Void
    let openLearning: () -> Void
    let openVirtues: () -> Void
    let openProfile: () -> Void

    @State private var now = Date.now

    var body: some View {
        let today = snapshot

        NavigationStack {
            ScrollView {
                #if os(macOS)
                    desktopContent(today)
                #else
                    mobileContent(today)
                #endif
            }
            .background(AppScreenBackground())
            #if os(macOS)
                .navigationTitle("Home")
            #else
                .toolbar(.hidden, for: .navigationBar)
            #endif
        }
        .onAppear { now = .now }
    }

    #if os(macOS)
        private func desktopContent(_ today: HomeTodaySnapshot) -> some View {
            VStack(alignment: .leading, spacing: AppSpacing.spacious) {
                HStack(alignment: .top, spacing: AppSpacing.standard) {
                    hero(reading: today.reading, height: 570, includesQuickActions: false)
                        .frame(minWidth: 480)

                    VStack(alignment: .leading, spacing: AppSpacing.standard) {
                        EditorialSectionHeader(
                            "Today",
                            eyebrow: now.formatted(.dateTime.weekday(.wide).month(.wide).day()),
                            detail: "One clear next step in Scripture, formation, and real life."
                        )
                        if let plan = today.plan { planCard(plan) } else { noPlanCard }
                        virtueCard(today.virtue)
                        learningCard(today.learning)
                    }
                    .frame(minWidth: 340, idealWidth: 400, maxWidth: 440)
                }

                activitySection(today)
            }
            .padding(AppSpacing.spacious)
            .frame(maxWidth: 1180)
            .frame(maxWidth: .infinity)
        }
    #endif

    #if !os(macOS)
        private func mobileContent(_ today: HomeTodaySnapshot) -> some View {
            LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                hero(reading: today.reading, height: 690, includesQuickActions: true)

                VStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    EditorialSectionHeader(
                        "Today",
                        eyebrow: now.formatted(.dateTime.weekday(.wide).month(.wide).day()),
                        detail: "One clear next step in Scripture, formation, and real life."
                    )

                    if let plan = today.plan { planCard(plan) } else { noPlanCard }
                    virtueCard(today.virtue)
                    learningCard(today.learning)
                    activitySection(today)
                }
                .padding(.horizontal, AppSpacing.screen)
            }
            .padding(.bottom, AppSpacing.section)
            .frame(maxWidth: .infinity)
        }
    #endif

    private var snapshot: HomeTodaySnapshot {
        _ = readingPositions.count
        _ = storedPlans.count
        _ = completionEvents.count
        _ = annotations.count
        _ = learningProgress.count
        _ = formationRecords.count

        if let snapshot = try? HomeTodayRepository(modelContext: modelContext).snapshot(asOf: now) {
            return snapshot
        }
        return fallbackSnapshot
    }

    private var fallbackSnapshot: HomeTodaySnapshot {
        let calendar = Calendar.current
        let reference = YouVersionCatalogPolicy.developmentStart
        return HomeTodaySnapshot(
            reading: HomeReadingResume(
                reference: reference,
                title: "John 1",
                updatedAt: nil,
                isSavedPosition: false
            ),
            plan: nil,
            learning: HomeTodayRecommendations.learning(
                asOf: now,
                completedTopicIDs: [],
                calendar: calendar
            ),
            virtue: HomeTodayRecommendations.virtue(asOf: now, calendar: calendar),
            recentActivity: [],
            planActivityStreak: 0
        )
    }

    private func hero(
        reading: HomeReadingResume,
        height: CGFloat,
        includesQuickActions: Bool
    ) -> some View {
        ZStack(alignment: .bottom) {
            AppHeroArtwork()
                .frame(height: height)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [.black.opacity(0.18), .clear, .black.opacity(0.82)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    EditorialEyebrow("Kingdom\natelier", inverse: true)
                        .lineSpacing(5)
                    Spacer()
                    Button(action: openProfile) {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 42, height: 42)
                            .background(.black.opacity(0.38))
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("home-open-profile")
                }
                .padding(.horizontal, AppSpacing.standard)
                .padding(.top, AppSpacing.spacious)

                Spacer(minLength: 20)

                VStack(alignment: .leading, spacing: 0) {
                    Text("LIVE")
                    Text("THE")
                    Text("WORD")
                        .foregroundStyle(AppTheme.accent)
                }
                .font(AppTypography.hero)
                .foregroundStyle(.white)
                .minimumScaleFactor(0.68)
                .shadow(color: .black.opacity(0.34), radius: 12, y: 4)
                .accessibilityElement(children: .combine)
                .padding(.horizontal, AppSpacing.standard)
                .padding(.bottom, AppSpacing.standard)

                Button {
                    openReading(reading.reference)
                } label: {
                    HStack(alignment: .center, spacing: 14) {
                        VStack(alignment: .leading, spacing: 3) {
                            EditorialEyebrow(
                                reading.isSavedPosition ? "Continue reading" : "Begin reading",
                                inverse: true
                            )
                            Text(reading.title)
                                .font(.system(.title2, design: .serif, weight: .bold))
                            Text(reading.isSavedPosition ? "Return to your place" : "The Word became flesh")
                                .font(.subheadline)
                                .opacity(0.84)
                        }
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.headline)
                            .frame(width: 40, height: 40)
                            .overlay { Rectangle().stroke(.white.opacity(0.35), lineWidth: 1) }
                    }
                    .foregroundStyle(.white)
                    .padding(AppSpacing.standard)
                    .background(AppTheme.accent)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("home-resume-reading")

                if includesQuickActions {
                    VStack(spacing: 0) {
                        heroAction(
                            title: "Formation Plan",
                            detail: "Keep today's reading rhythm",
                            systemImage: "chart.bar.fill",
                            action: openPlans,
                            identifier: "home-today-plan"
                        )
                        Divider().overlay(.white.opacity(0.22))
                        heroAction(
                            title: "Virtue Focus",
                            detail: "Put the Word into practice",
                            systemImage: "shield.fill",
                            action: openVirtues,
                            identifier: "home-open-virtues"
                        )
                        Divider().overlay(.white.opacity(0.22))
                        heroAction(
                            title: "Catholic Learning",
                            detail: "Understand the life of the Church",
                            systemImage: "books.vertical.fill",
                            action: openLearning,
                            identifier: "home-open-learning"
                        )
                    }
                    .background(.black.opacity(0.72))
                }
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
        .accessibilityElement(children: .contain)
    }

    private func heroAction(
        title: String,
        detail: String,
        systemImage: String,
        action: @escaping () -> Void,
        identifier: String
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.72))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
            }
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.standard)
            .frame(height: 64)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
    }

    private func planCard(_ plan: HomePlanToday) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    EditorialEyebrow("Formation plan")
                    Spacer()
                    Label(paceTitle(plan.pace), systemImage: paceIcon(plan.pace))
                        .font(.caption.bold())
                        .foregroundStyle(paceColor(plan.pace))
                }

                Text(plan.title)
                    .font(AppTypography.cardTitle)
                Text(
                    "Day \(plan.dayIndex) of \(plan.totalDays) · \(plan.completedReadingCount) of \(plan.totalReadingCount) readings complete"
                )
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.supportingText)

                EmeraldProgressBar(value: plan.overallCompletionFraction)

                if plan.status == .paused {
                    Label("Paused — return whenever you are ready.", systemImage: "pause.circle")
                        .foregroundStyle(AppTheme.warning)
                } else if let nextReading = plan.nextReadingTitle {
                    Label("Next: \(nextReading)", systemImage: "book.pages")
                        .font(.headline)
                }

                HStack {
                    if plan.status != .paused, let reference = plan.nextReadingReference {
                        Button("Read Next") { openReading(reference) }
                            .buttonStyle(EmeraldActionButtonStyle())
                            .accessibilityIdentifier("home-read-plan")
                    }
                    Button(plan.status == .paused ? "Review Plan" : "Open Plan", action: openPlans)
                        .buttonStyle(EditorialSecondaryButtonStyle())
                        .accessibilityIdentifier("home-open-plan")
                }
            }
        }
        .accessibilityIdentifier("home-today-plan")
    }

    private var noPlanCard: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                EditorialEyebrow("Formation plan")
                Text("Choose a reading path.")
                    .font(AppTypography.cardTitle)
                Text("Turn a broad intention into one clear reading for today.")
                    .foregroundStyle(AppTheme.supportingText)
                Button("Browse Plans", action: openPlans)
                    .buttonStyle(EmeraldActionButtonStyle())
            }
        }
    }

    private func learningCard(_ suggestion: HomeLearningSuggestion) -> some View {
        Button(action: openLearning) {
            FeatureCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        EditorialEyebrow(suggestion.eyebrow)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                    Text(suggestion.topic.title)
                        .font(AppTypography.cardTitle)
                    Text(suggestion.topic.subtitle)
                        .foregroundStyle(AppTheme.supportingText)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("home-learning-card")
    }

    private func virtueCard(_ virtue: HomeVirtueFocus) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 11) {
                HStack {
                    EditorialEyebrow("Virtue focus")
                    Spacer()
                    Image(systemName: "shield")
                        .foregroundStyle(AppTheme.accent)
                }
                Text(virtue.title)
                    .font(AppTypography.cardTitle)
                Text(virtue.practice)
                    .foregroundStyle(AppTheme.supportingText)
                if virtue.isPaused {
                    Label("Cycle paused", systemImage: "pause.circle")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.warning)
                } else if let cycleID = virtue.cycleID {
                    if let status = virtue.checkInStatus {
                        Label("Today: \(status.title)", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.success)
                    } else {
                        Button("Practiced it") {
                            recordHomeCheckIn(cycleID: cycleID, status: .practiced)
                        }
                        .buttonStyle(EmeraldActionButtonStyle())
                        .accessibilityIdentifier("home-virtue-check-in")
                    }
                }
                HStack {
                    Button("Read \(virtue.scriptureTitle)") {
                        openReading(virtue.scriptureReference)
                    }
                    .buttonStyle(EditorialSecondaryButtonStyle())
                    .accessibilityIdentifier("home-open-virtue-scripture")
                    Button("Open Virtues", action: openVirtues)
                        .buttonStyle(EditorialSecondaryButtonStyle())
                        .accessibilityIdentifier("home-virtues-card")
                }
            }
        }
        .accessibilityIdentifier("home-virtue-focus")
    }

    private func recordHomeCheckIn(cycleID: UUID, status: VirtueCheckInStatus) {
        _ = try? VirtueFormationRepository(modelContext: modelContext).update { state in
            try VirtueFocusCycleEngine.recordCheckIn(
                cycleID: cycleID,
                status: status,
                privateObservation: nil,
                in: &state
            )
        }
    }

    private func activitySection(_ today: HomeTodaySnapshot) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                EditorialSectionHeader("Recent activity", eyebrow: "Private history")
                if today.planActivityStreak > 0 {
                    Label("\(today.planActivityStreak)-day rhythm", systemImage: "checkmark.circle")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.accent)
                }
            }

            FeatureCard {
                if today.recentActivity.isEmpty {
                    Text("Your reading and plan activity will appear here as you use the app.")
                        .foregroundStyle(AppTheme.supportingText)
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(today.recentActivity.enumerated()), id: \.element.id) { offset, activity in
                            HStack(spacing: 12) {
                                Image(systemName: activity.kind.systemImage)
                                    .foregroundStyle(AppTheme.accent)
                                    .frame(width: 24)
                                Text(activity.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(activity.occurredAt, style: .relative)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.supportingText)
                            }
                            .padding(.vertical, 10)
                            if offset < today.recentActivity.count - 1 { Divider() }
                        }
                    }
                }
            }

            Label("Private note and reflection text never appears in Home activity.", systemImage: "lock.fill")
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
        }
        .accessibilityIdentifier("home-recent-activity")
    }

    private func paceTitle(_ pace: PlanPaceStatus) -> String {
        switch pace {
        case .ahead(let days): "\(days) day\(days == 1 ? "" : "s") ahead"
        case .onTrack: "On track"
        case .behind(let days): "\(days) day\(days == 1 ? "" : "s") behind"
        case .complete: "Complete"
        }
    }

    private func paceIcon(_ pace: PlanPaceStatus) -> String {
        switch pace {
        case .ahead: "arrow.up.right"
        case .onTrack: "checkmark.circle"
        case .behind: "clock"
        case .complete: "checkmark.seal.fill"
        }
    }

    private func paceColor(_ pace: PlanPaceStatus) -> Color {
        switch pace {
        case .ahead, .onTrack, .complete: AppTheme.success
        case .behind: AppTheme.warning
        }
    }
}

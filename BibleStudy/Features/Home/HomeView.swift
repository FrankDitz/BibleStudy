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
                LazyVStack(alignment: .leading, spacing: 20) {
                    header

                    if let plan = today.plan {
                        planCard(plan)
                    } else {
                        noPlanCard
                    }

                    ViewThatFits(in: .horizontal) {
                        HStack(alignment: .top, spacing: AppSpacing.standard) {
                            readingCard(today.reading)
                            learningCard(today.learning)
                        }
                        VStack(alignment: .leading, spacing: AppSpacing.standard) {
                            readingCard(today.reading)
                            learningCard(today.learning)
                        }
                    }

                    virtueCard(today.virtue)
                    activitySection(today)
                }
                .padding()
                .frame(maxWidth: 960)
                .frame(maxWidth: .infinity)
            }
            .background(AppTheme.warmSurface.opacity(0.35))
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: openProfile) {
                        Label("You", systemImage: "person.crop.circle")
                    }
                    .accessibilityIdentifier("home-open-profile")
                }
            }
        }
        .onAppear { now = .now }
    }

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

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.accent)
            Text("Your next faithful step")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text("Read, learn, and practice what matters today—without turning formation into a score.")
                .font(AppTypography.screenIntroduction)
                .foregroundStyle(AppTheme.supportingText)
        }
        .accessibilityElement(children: .combine)
    }

    private func planCard(_ plan: HomePlanToday) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Label("Today's plan", systemImage: "calendar.badge.checkmark")
                        .font(.headline)
                    Spacer()
                    Text(paceTitle(plan.pace))
                        .font(.caption.bold())
                        .foregroundStyle(paceColor(plan.pace))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(paceColor(plan.pace).opacity(0.12), in: Capsule())
                }

                Text(plan.title)
                    .font(.title2.bold())
                HStack {
                    Text("Day \(plan.dayIndex) of \(plan.totalDays)")
                    Text("•")
                    Text("\(plan.completedReadingCount) of \(plan.totalReadingCount) readings complete")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.supportingText)

                ProgressView(value: plan.overallCompletionFraction)
                    .tint(AppTheme.accent)
                    .accessibilityLabel("Overall plan completion")
                    .accessibilityValue("\(Int(plan.overallCompletionFraction * 100)) percent")

                if plan.status == .paused {
                    Label("This plan is paused. Open it to resume or adjust the schedule.", systemImage: "pause.circle")
                        .foregroundStyle(AppTheme.warning)
                } else if let nextReading = plan.nextReadingTitle {
                    Label("Next: \(nextReading)", systemImage: "book.pages")
                        .font(.headline)
                }

                HStack {
                    if plan.status != .paused, let reference = plan.nextReadingReference {
                        Button("Read Next") { openReading(reference) }
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.accent)
                            .accessibilityIdentifier("home-read-plan")
                    }
                    Button(plan.status == .paused ? "Review Plan" : "Open Plan", action: openPlans)
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("home-open-plan")
                }
            }
        }
        .accessibilityIdentifier("home-today-plan")
    }

    private var noPlanCard: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Today's plan", systemImage: "calendar.badge.plus")
                    .font(.headline)
                Text("Choose a reading path")
                    .font(.title2.bold())
                Text("A plan turns a broad intention into a specific reading for today.")
                    .foregroundStyle(AppTheme.supportingText)
                Button("Browse Plans", action: openPlans)
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.accent)
            }
        }
    }

    private func readingCard(_ reading: HomeReadingResume) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 10) {
                Label(
                    reading.isSavedPosition ? "Continue reading" : "Begin reading",
                    systemImage: "book.pages"
                )
                .font(.headline)
                Text(reading.title)
                    .font(.title.bold())
                Text(
                    reading.isSavedPosition
                        ? "Return to the last chapter you opened."
                        : "Begin with John's account of Christ."
                )
                .foregroundStyle(AppTheme.supportingText)
                if let updatedAt = reading.updatedAt {
                    Text(updatedAt, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Button("Open Bible") { openReading(reading.reference) }
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("home-resume-reading")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func learningCard(_ suggestion: HomeLearningSuggestion) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 10) {
                Label(suggestion.eyebrow, systemImage: suggestion.topic.icon)
                    .font(.headline)
                Text(suggestion.topic.title)
                    .font(.title2.bold())
                Text(suggestion.topic.subtitle)
                    .foregroundStyle(AppTheme.supportingText)
                Button("Explore Learning", action: openLearning)
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("home-open-learning")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func virtueCard(_ virtue: HomeVirtueFocus) -> some View {
        FeatureCard {
            HStack(alignment: .top, spacing: 18) {
                Image(systemName: "sparkles")
                    .font(.title)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 44, height: 44)
                    .background(AppTheme.accent.opacity(0.12), in: Circle())
                VStack(alignment: .leading, spacing: 9) {
                    Text("Virtue focus")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.accent)
                    Text(virtue.title)
                        .font(.title2.bold())
                    Text(virtue.practice)
                        .font(.title3)
                    if virtue.isPaused {
                        Label("Cycle paused — return whenever you are ready", systemImage: "pause.circle")
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
                            .buttonStyle(.borderedProminent)
                            .tint(AppTheme.accent)
                            .accessibilityIdentifier("home-virtue-check-in")
                        }
                    }
                    Button("Read \(virtue.scriptureTitle)") {
                        openReading(virtue.scriptureReference)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("home-open-virtue-scripture")
                    Button("Open Virtues", action: openVirtues)
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("home-open-virtues")
                }
                Spacer(minLength: 0)
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
                Text("Recent activity")
                    .font(.title2.bold())
                Spacer()
                if today.planActivityStreak > 0 {
                    Label(
                        "\(today.planActivityStreak)-day plan rhythm",
                        systemImage: "flame.fill"
                    )
                    .font(.caption.bold())
                    .foregroundStyle(AppTheme.accent)
                }
            }

            if today.recentActivity.isEmpty {
                FeatureCard {
                    Text("Your reading and plan activity will appear here as you use the app.")
                        .foregroundStyle(AppTheme.supportingText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                FeatureCard {
                    VStack(spacing: 0) {
                        ForEach(Array(today.recentActivity.enumerated()), id: \.element.id) {
                            offset, activity in
                            HStack(spacing: 12) {
                                Image(systemName: activity.kind.systemImage)
                                    .foregroundStyle(AppTheme.accent)
                                    .frame(width: 24)
                                Text(activity.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(activity.occurredAt, style: .relative)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 10)
                            if offset < today.recentActivity.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }

            Label(
                "Private note and reflection text is never shown in Home activity.",
                systemImage: "lock.fill"
            )
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

    private func paceColor(_ pace: PlanPaceStatus) -> Color {
        switch pace {
        case .ahead, .onTrack, .complete: AppTheme.success
        case .behind: AppTheme.warning
        }
    }
}

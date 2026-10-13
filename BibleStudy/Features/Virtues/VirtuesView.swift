import SwiftData
import SwiftUI

struct VirtuesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let openReading: (CanonicalScriptureReference) -> Void

    init(openReading: @escaping (CanonicalScriptureReference) -> Void = { _ in }) {
        self.openReading = openReading
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    introduction
                    formationJourney
                    focusCycle
                    continuingFormation
                    pathwayGrid
                    privacyNote
                }
                .padding()
                .frame(maxWidth: 960)
                .frame(maxWidth: .infinity)
            }
            .background(AppTheme.warmSurface.opacity(0.35))
            .navigationTitle("Virtues")
        }
        .accessibilityIdentifier("virtues-root")
    }

    private var continuingFormation: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continuing formation")
                .font(AppTypography.sectionTitle)
            NavigationLink {
                VirtuePracticeLibraryView()
            } label: {
                formationLink(
                    title: "Practice Library",
                    detail: "Find a concrete practice by life context and commitment.",
                    systemImage: "books.vertical"
                )
            }
            NavigationLink {
                VirtueThematicJourneysView()
            } label: {
                formationLink(
                    title: "Thematic Journeys",
                    detail:
                        "Follow source-checked practices for work, relationships, digital life, service, or a difficult season.",
                    systemImage: "map"
                )
            }
            NavigationLink {
                VirtueRuleOfLifeView()
            } label: {
                formationLink(
                    title: "My Rule of Life",
                    detail: "Keep and revise the practices you deliberately choose to carry forward.",
                    systemImage: "leaf"
                )
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("virtues-continuing-formation")
    }

    private func formationLink(title: String, detail: String, systemImage: String) -> some View {
        FeatureCard {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(detail)
                        .foregroundStyle(AppTheme.supportingText)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
        }
    }

    private var currentCycle: VirtueFocusCycle? {
        _ = formationRecords.count
        return try? VirtueFormationRepository(modelContext: modelContext).state().currentCycle
    }

    private var focusCycle: some View {
        Group {
            if let cycle = currentCycle {
                NavigationLink {
                    VirtueActiveCycleView(cycleID: cycle.id)
                } label: {
                    FeatureCard {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Label("Current Focus Cycle", systemImage: "scope")
                                    .font(.headline)
                                Spacer()
                                Text(cycle.status == .paused ? "Paused" : "Day \(cycle.dayNumber(asOf: .now))")
                                    .font(.caption.bold())
                                    .foregroundStyle(
                                        cycle.status == .paused ? AppTheme.warning : AppTheme.success
                                    )
                            }
                            Text(VirtueFoundationLibrary.pathway(for: cycle.virtueID)?.title ?? "Virtue")
                                .font(.title2.bold())
                            Text(cycle.practice.title)
                                .font(.headline)
                            Text(cycle.practice.instruction)
                                .foregroundStyle(AppTheme.supportingText)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("virtue-current-cycle")
            } else {
                NavigationLink {
                    VirtueFocusCycleSetupView()
                } label: {
                    FeatureCard {
                        HStack(spacing: 14) {
                            Image(systemName: "scope")
                                .font(.title2)
                                .foregroundStyle(AppTheme.accent)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Begin a Focus Cycle")
                                    .font(.title2.bold())
                                Text("Choose a virtue, life context, practice, and a one-, two-, or four-week rhythm.")
                                    .foregroundStyle(AppTheme.supportingText)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("virtue-start-cycle")
            }
        }
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Faith practiced in daily life")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text(
                "Learn each virtue, encounter it in Scripture, choose a concrete practice, and return to it throughout life. Formation records faithful participation—not holiness."
            )
            .font(AppTypography.screenIntroduction)
            .foregroundStyle(AppTheme.supportingText)
        }
        .accessibilityElement(children: .combine)
    }

    private var formationJourney: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Your formation journey", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                    .font(.headline)
                journeyRow(
                    number: 1,
                    title: "Foundations",
                    detail:
                        "Meet all seven virtues through source-backed teaching, Scripture, practice, and reflection."
                )
                journeyRow(
                    number: 2,
                    title: "Focus Cycles",
                    detail: "Return to one virtue for one, two, or four weeks in a context you choose."
                )
                journeyRow(
                    number: 3,
                    title: "Rule of Life",
                    detail: "Retain and revise the practices that help you live faithfully."
                )
                Label(
                    "Complete source-checked drafts are available to inspect; qualified Catholic review is still pending.",
                    systemImage: "checkmark.shield"
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityIdentifier("virtues-formation-journey")
    }

    private var pathwayGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seven pathways")
                .font(AppTypography.sectionTitle)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 250), spacing: AppSpacing.standard)],
                spacing: AppSpacing.standard
            ) {
                ForEach(VirtueFormationCatalog.descriptors) { virtue in
                    if let pathway = VirtueFoundationLibrary.pathway(for: virtue.id) {
                        NavigationLink {
                            VirtuePathwayView(pathway: pathway, openReading: openReading)
                        } label: {
                            FeatureCard {
                                HStack(alignment: .top, spacing: 14) {
                                    Image(systemName: virtue.systemImage)
                                        .font(.title2)
                                        .foregroundStyle(AppTheme.accent)
                                        .frame(width: 42, height: 42)
                                        .background(AppTheme.accent.opacity(0.12), in: Circle())
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(virtue.title)
                                            .font(.title3.bold())
                                        Text(virtue.emphasis)
                                            .foregroundStyle(AppTheme.supportingText)
                                        Text("Source-checked draft")
                                            .font(.caption.bold())
                                            .foregroundStyle(AppTheme.accent)
                                    }
                                    Spacer(minLength: 0)
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .accessibilityHidden(true)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("virtue-pathway-\(virtue.id.rawValue)")
                    }
                }
            }
        }
    }

    private var privacyNote: some View {
        Label(
            "Check-ins and observations will remain private. The app will never calculate a virtue score or infer a moral weakness.",
            systemImage: "lock.shield"
        )
        .font(.footnote)
        .foregroundStyle(AppTheme.supportingText)
        .accessibilityIdentifier("virtues-privacy-note")
    }

    private func journeyRow(number: Int, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(AppTheme.accent, in: Circle())
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

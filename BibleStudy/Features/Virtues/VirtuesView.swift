import SwiftUI

struct VirtuesView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    introduction
                    formationJourney
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
                    detail: "Meet all seven virtues through reviewed teaching, Scripture, practice, and reflection."
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
                    "Pathway content is being source-checked and reviewed before it becomes available.",
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
                                Text("Pathway in review")
                                    .font(.caption.bold())
                                    .foregroundStyle(AppTheme.accent)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                    .accessibilityIdentifier("virtue-pathway-\(virtue.id.rawValue)")
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

import SwiftUI

struct LearningView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    header
                    scopeNote
                    EditorialSectionHeader(
                        "Catholic life",
                        eyebrow: "Learn the faith",
                        detail: "Clear introductions to worship, sacraments, prayer, seasons, and life in the Church."
                    )
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 250), spacing: AppSpacing.standard)],
                        spacing: AppSpacing.standard
                    ) {
                        ForEach(Array(LearningTopicCatalog.topics.enumerated()), id: \.element.id) { index, topic in
                            topicCard(topic, index: index)
                        }
                    }
                }
                .padding(AppSpacing.screen)
                .frame(maxWidth: 1120)
                .frame(maxWidth: .infinity)
            }
            .background(AppScreenBackground())
            .navigationTitle("Learning")
        }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [AppTheme.accent, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Text("KNOW")
                .font(.system(size: 96, weight: .black, design: .serif))
                .foregroundStyle(.white.opacity(0.10))
                .offset(x: 90, y: -60)
            VStack(alignment: .leading, spacing: 10) {
                EditorialEyebrow("Formation beyond the page", inverse: true)
                Text("Know what the Church lives.")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                Text(
                    "Understand Catholic worship and practice so you can participate with confidence, reverence, and purpose."
                )
                .font(.title3)
                .foregroundStyle(.white.opacity(0.84))
            }
            .foregroundStyle(.white)
            .padding(AppSpacing.spacious)
        }
        .frame(minHeight: 260)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
    }

    private var scopeNote: some View {
        Label(
            "Initial scope: Roman Catholic practice in the United States. Every published lesson will show its sources and review status.",
            systemImage: "checkmark.shield"
        )
        .font(.footnote)
        .foregroundStyle(AppTheme.supportingText)
        .padding(.horizontal, 2)
    }

    private func topicCard(_ topic: LearningTopic, index: Int) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(String(format: "%02d", index + 1))
                        .font(.system(.title, design: .serif, weight: .black))
                        .foregroundStyle(AppTheme.accent)
                    Spacer()
                    Image(systemName: topic.icon)
                        .font(.title2)
                        .foregroundStyle(AppTheme.accent)
                }
                Text(topic.title)
                    .font(AppTypography.cardTitle)
                Text(topic.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.supportingText)
                HStack {
                    Text("COMING IN LEARNING MVP")
                        .font(AppTypography.eyebrow)
                        .tracking(1.5)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(AppTheme.accent)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

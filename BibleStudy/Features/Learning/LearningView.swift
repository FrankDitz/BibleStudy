import SwiftUI

struct LearningView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.section) {
                    header
                    learningMap
                    scopeNote
                    topicCollection(
                        number: "01",
                        title: "Worship & sacred time",
                        detail:
                            "Learn what happens at Mass and how the Church's seasons, solemnities, and holy days shape Catholic life.",
                        identifiers: ["mass", "liturgical-year"]
                    )
                    topicCollection(
                        number: "02",
                        title: "Sacraments & belonging",
                        detail:
                            "Understand the signs of grace that mark Christian initiation, healing, vocation, and life in the Church.",
                        identifiers: ["sacraments"]
                    )
                    topicCollection(
                        number: "03",
                        title: "Prayer & devotion",
                        detail:
                            "Build confidence with the Rosary, foundational prayers, devotions, and Catholic prayer beyond Sunday Mass.",
                        identifiers: ["rosary", "prayer-devotions"]
                    )
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
            EditorialHeroArtwork(assetName: "LearningHero")
                .frame(height: EditorialImageMetrics.primaryHeroHeight)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [.black.opacity(0.02), .black.opacity(0.18), .black.opacity(0.90)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }

            VStack(alignment: .leading, spacing: 9) {
                EditorialEyebrow("Formation beyond the page", inverse: true)
                Text("KNOW THE\nFAITH.")
                    .font(.system(size: 48, weight: .black, design: .serif))
                    .minimumScaleFactor(0.68)
                Rectangle()
                    .fill(AppTheme.accent)
                    .frame(width: 48, height: 3)
                Text(
                    "Understand what the Church believes, celebrates, and lives—then participate with confidence and reverence."
                )
                .font(.headline)
                .foregroundStyle(.white.opacity(0.86))
                .frame(maxWidth: 520, alignment: .leading)
            }
            .foregroundStyle(.white)
            .padding(AppSpacing.spacious)
        }
        .frame(minHeight: EditorialImageMetrics.primaryHeroHeight)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private var learningMap: some View {
        VStack(alignment: .leading, spacing: AppSpacing.standard) {
            EditorialSectionHeader(
                "A map for Catholic life",
                eyebrow: "Learn in context",
                detail:
                    "Move from the Church's public worship, through sacramental life, into the prayer practices you carry home."
            )

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 0) {
                    mapStep("01", title: "Worship", detail: "Mass & seasons")
                    mapStep("02", title: "Belong", detail: "Sacraments & initiation")
                    mapStep("03", title: "Pray", detail: "Devotions & daily life")
                }
                VStack(spacing: 0) {
                    mapStep("01", title: "Worship", detail: "Mass & seasons")
                    mapStep("02", title: "Belong", detail: "Sacraments & initiation")
                    mapStep("03", title: "Pray", detail: "Devotions & daily life")
                }
            }
            .background(AppTheme.surface)
            .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        }
    }

    private func mapStep(_ number: String, title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(number)
                .font(.system(.title2, design: .serif, weight: .black))
                .foregroundStyle(AppTheme.accent)
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.ink)
            Text(detail)
                .font(.caption)
                .foregroundStyle(AppTheme.supportingText)
        }
        .padding(AppSpacing.standard)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .trailing) {
            Rectangle().fill(AppTheme.hairline).frame(width: 1)
        }
        .accessibilityElement(children: .combine)
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

    private func topicCollection(
        number: String,
        title: String,
        detail: String,
        identifiers: [String]
    ) -> some View {
        let topics = identifiers.compactMap { LearningTopicCatalog.topic(id: $0) }

        return VStack(alignment: .leading, spacing: AppSpacing.standard) {
            HStack(alignment: .top, spacing: AppSpacing.standard) {
                Text(number)
                    .font(.system(size: 42, weight: .black, design: .serif))
                    .foregroundStyle(AppTheme.accent)
                    .accessibilityHidden(true)
                EditorialSectionHeader(title, eyebrow: "Catholic life", detail: detail)
            }

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 280), spacing: AppSpacing.standard)],
                spacing: AppSpacing.standard
            ) {
                ForEach(Array(topics.enumerated()), id: \.element.id) { index, topic in
                    topicCard(topic, index: index + 1)
                }
            }
        }
    }

    private func topicCard(_ topic: LearningTopic, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(String(format: "%02d", index))
                    .font(.system(.title, design: .serif, weight: .black))
                    .foregroundStyle(AppTheme.accent)
                Spacer()
                Image(systemName: topic.icon)
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
            }
            .padding(AppSpacing.standard)
            .background(AppTheme.elevatedSurface)

            VStack(alignment: .leading, spacing: 10) {
                Text(topic.title)
                    .font(.system(.title2, design: .serif, weight: .bold))
                Text(topic.subtitle)
                    .foregroundStyle(AppTheme.supportingText)
                Spacer(minLength: 8)
                HStack {
                    Text("COMING IN LEARNING MVP")
                        .font(AppTypography.eyebrow)
                        .tracking(1.5)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(AppTheme.accent)
            }
            .padding(AppSpacing.standard)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
            .background(AppTheme.surface)
        }
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        .accessibilityElement(children: .combine)
    }
}

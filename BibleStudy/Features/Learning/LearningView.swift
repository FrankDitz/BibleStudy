import SwiftUI

struct LearningView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 40) {
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
                    EditorialEndCap(
                        title: "Know · celebrate · live",
                        identifier: "learning-content-end"
                    )
                }
                .padding(AppSpacing.screen)
                .frame(maxWidth: 1180)
                .frame(maxWidth: .infinity)
            }
            .background(AppScreenBackground())
            .navigationTitle("Learning")
        }
    }

    private var header: some View {
        Group {
            #if os(macOS)
                HStack(spacing: 0) {
                    learningHeroMessage
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    EditorialMediaSlot(assetName: "LearningHero", slot: .feature)
                        .frame(maxWidth: .infinity)
                }
            #else
                VStack(spacing: 0) {
                    EditorialMediaSlot(assetName: "LearningHero", slot: .feature)
                    learningHeroMessage
                }
            #endif
        }
        .background(.black)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        .accessibilityElement(children: .combine)
    }

    private var learningHeroMessage: some View {
        VStack(alignment: .leading, spacing: 10) {
            EditorialEyebrow("Formation beyond the page", inverse: true)
            Text("KNOW THE\nFAITH.")
                .font(.system(size: learningHeroTitleSize, weight: .black, design: .serif))
                .minimumScaleFactor(0.72)
            Rectangle()
                .fill(AppTheme.accent)
                .frame(width: 48, height: 3)
            Text(
                "Understand what the Church believes, celebrates, and lives—then participate with confidence."
            )
            .font(learningHeroBodyFont)
            .foregroundStyle(.white.opacity(0.78))
            .frame(maxWidth: 480, alignment: .leading)
        }
        .foregroundStyle(.white)
        .padding(learningHeroPadding)
        .background(.black)
    }

    private var learningHeroTitleSize: CGFloat {
        #if os(macOS)
            46
        #else
            34
        #endif
    }

    private var learningHeroBodyFont: Font {
        #if os(macOS)
            .headline
        #else
            .subheadline
        #endif
    }

    private var learningHeroPadding: CGFloat {
        #if os(macOS)
            AppSpacing.spacious
        #else
            AppSpacing.standard
        #endif
    }

    private var learningMap: some View {
        VStack(alignment: .leading, spacing: AppSpacing.standard) {
            EditorialSectionHeader(
                "A map for Catholic life",
                eyebrow: "Learn in context",
                detail:
                    "Follow this order for a guided introduction, or open the subject that answers the question you have today."
            )

            #if os(macOS)
                HStack(spacing: 0) {
                    mapStep("01", title: "Worship", detail: "Mass & sacred time")
                    mapStep("02", title: "Belong", detail: "Sacraments & initiation")
                    mapStep("03", title: "Pray", detail: "Devotions & daily life")
                }
            #else
                VStack(spacing: 0) {
                    mapStep("01", title: "Worship", detail: "Begin with the Mass and the Church year")
                    mapStep("02", title: "Belong", detail: "Understand initiation and sacramental life")
                    mapStep("03", title: "Pray", detail: "Carry Catholic prayer into the week")
                }
            #endif
        }
    }

    private func mapStep(_ number: String, title: String, detail: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(number)
                .font(.system(.title2, design: .serif, weight: .black))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 34, alignment: .leading)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(AppTheme.supportingText)
            }
            Spacer(minLength: 0)
        }
        .padding(AppSpacing.standard)
        .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
        .background(AppTheme.surface)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
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

            #if os(macOS)
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 340), spacing: AppSpacing.standard)],
                    spacing: AppSpacing.standard
                ) {
                    ForEach(Array(topics.enumerated()), id: \.element.id) { index, topic in
                        topicCard(topic, index: index + 1)
                    }
                }
            #else
                LazyVStack(spacing: 12) {
                    ForEach(Array(topics.enumerated()), id: \.element.id) { index, topic in
                        topicCard(topic, index: index + 1)
                    }
                }
            #endif
        }
    }

    private func topicCard(_ topic: LearningTopic, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            topicVisual(topic, index: index)

            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    EditorialEyebrow("Topic \(String(format: "%02d", index))")
                    Spacer(minLength: 12)
                    EditorialStatusBadge(text: "Planned")
                }
                Text(topic.title)
                    .font(.system(.title2, design: .serif, weight: .bold))
                    .foregroundStyle(AppTheme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Text(topic.subtitle)
                    .foregroundStyle(AppTheme.supportingText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(AppSpacing.standard)

            EditorialDivider()

            VStack(alignment: .leading, spacing: 9) {
                EditorialEyebrow("Curriculum outline")
                ForEach(curriculumOutline(for: topic), id: \.self) { lesson in
                    HStack(alignment: .firstTextBaseline, spacing: 9) {
                        Rectangle()
                            .fill(AppTheme.accent)
                            .frame(width: 14, height: 2)
                        Text(lesson)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.ink)
                    }
                }
            }
            .padding(AppSpacing.standard)
            .background(AppTheme.elevatedSurface)
        }
        .background(AppTheme.surface)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        .accessibilityElement(children: .combine)
    }

    private func topicVisual(_ topic: LearningTopic, index: Int) -> some View {
        ZStack {
            LinearGradient(
                colors: [.black, AppTheme.accent.opacity(0.72)],
                startPoint: .leading,
                endPoint: .trailing
            )

            Text(String(format: "%02d", index))
                .font(.system(size: 92, weight: .black, design: .serif))
                .foregroundStyle(.white.opacity(0.10))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .offset(x: 8, y: 13)

            HStack(spacing: 16) {
                Image(systemName: topic.icon)
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 58, height: 58)
                    .background(.white)
                VStack(alignment: .leading, spacing: 5) {
                    EditorialEyebrow("Catholic life", inverse: true)
                    Text(topicVisualTitle(topic))
                        .font(.system(.title2, design: .serif, weight: .black))
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            .padding(AppSpacing.standard)
        }
        .frame(height: 104)
        .clipped()
        .accessibilityHidden(true)
    }

    private func topicVisualTitle(_ topic: LearningTopic) -> String {
        switch topic.id {
        case "mass": "THE MASS"
        case "liturgical-year": "SACRED TIME"
        case "sacraments": "SIGNS OF GRACE"
        case "rosary": "PRAY WITH MARY"
        default: "DAILY PRAYER"
        }
    }

    private func curriculumOutline(for topic: LearningTopic) -> [String] {
        switch topic.id {
        case "mass":
            [
                "Before Mass: preparation, space, and posture", "The Liturgy of the Word",
                "The Liturgy of the Eucharist and being sent",
            ]
        case "liturgical-year":
            [
                "The seasons and their purpose", "Solemnities, feasts, and memorials",
                "Holy days and the rhythm of a Catholic year",
            ]
        case "sacraments":
            [
                "The seven sacraments as signs of grace", "Baptism, Confirmation, and Eucharist",
                "Adult formation, sponsors, and parish preparation",
            ]
        case "rosary":
            ["The prayers and the beads", "The four sets of mysteries", "How to pray slowly and with attention"]
        default:
            [
                "Foundational Catholic prayers", "Creeds, chaplets, and devotions",
                "Building a sustainable daily prayer rule",
            ]
        }
    }
}

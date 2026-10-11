import SwiftUI

struct LearningView: View {
    private let topics = [
        LearningTopic(title: "The Mass", subtitle: "Parts of the liturgy, posture, and responses", icon: "building.columns"),
        LearningTopic(title: "The Rosary", subtitle: "Prayers, mysteries, and how to begin", icon: "circle.hexagongrid"),
        LearningTopic(title: "The Sacraments", subtitle: "Signs of grace in Catholic life", icon: "drop"),
        LearningTopic(title: "The Liturgical Year", subtitle: "Seasons, solemnities, and holy days", icon: "calendar"),
        LearningTopic(title: "Prayer & Devotions", subtitle: "Practices inside and outside the church", icon: "hands.sparkles"),
    ]

    var body: some View {
        NavigationStack {
            List(topics) { topic in
                HStack(spacing: 14) {
                    Image(systemName: topic.icon)
                        .font(.title2)
                        .foregroundStyle(AppTheme.accent)
                        .frame(width: 34)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(topic.title)
                            .font(.headline)
                        Text(topic.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("Learning")
            .safeAreaInset(edge: .bottom) {
                Text("Initial editorial scope: Roman Catholic practice in the United States. Sources and review status will be displayed on every lesson.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
            }
        }
    }
}

private struct LearningTopic: Identifiable {
    let title: String
    let subtitle: String
    let icon: String

    var id: String { title }
}

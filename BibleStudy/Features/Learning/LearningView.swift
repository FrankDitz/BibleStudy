import SwiftUI

struct LearningView: View {
    var body: some View {
        NavigationStack {
            List(LearningTopicCatalog.topics) { topic in
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
                            .foregroundStyle(AppTheme.supportingText)
                    }
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("Learning")
            .safeAreaInset(edge: .bottom) {
                Text(
                    "Initial editorial scope: Roman Catholic practice in the United States. Sources and review status will be displayed on every lesson."
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
            }
        }
    }
}

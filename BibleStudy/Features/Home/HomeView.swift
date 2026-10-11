import SwiftUI

struct HomeView: View {
    let continueReading: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("A quiet place to read, learn, and grow.")
                        .font(.title2.weight(.medium))
                        .foregroundStyle(.secondary)

                    FeatureCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Label("Continue reading", systemImage: "book.pages")
                                .font(.headline)
                            Text("John 1")
                                .font(.largeTitle.bold())
                            Text("Begin with the Word and carry one truth into the rest of your day.")
                                .foregroundStyle(.secondary)
                            Button("Open Bible", action: continueReading)
                                .buttonStyle(.borderedProminent)
                                .tint(AppTheme.accent)
                        }
                    }

                    HStack(alignment: .top, spacing: 14) {
                        summaryCard(
                            title: "Current plan",
                            value: "Not started",
                            icon: "checklist"
                        )
                        summaryCard(
                            title: "Reading streak",
                            value: "0 days",
                            icon: "flame"
                        )
                    }

                    FeatureCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Daily reflection", systemImage: "quote.bubble")
                                .font(.headline)
                            Text("What is one action today that would make your faith visible?")
                                .font(.title3)
                            Text("Reflection capture will connect to Echo in a later hub-integration phase.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 900)
                .frame(maxWidth: .infinity)
            }
            .background(AppTheme.warmSurface.opacity(0.35))
            .navigationTitle("Home")
        }
    }

    private func summaryCard(title: String, value: String, icon: String) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 8) {
                Label(title, systemImage: icon)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline)
            }
        }
    }
}

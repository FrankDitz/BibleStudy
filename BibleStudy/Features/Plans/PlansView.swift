import SwiftUI

struct PlansView: View {
    let openReading: (ScriptureReference) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    FeatureCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Your active plan", systemImage: "calendar.badge.checkmark")
                                .font(.headline)
                            Text("No active plan yet")
                                .font(.title2.bold())
                            Text("Choose a plan below or create a custom schedule. Progress, streaks, grace days, and completion history will live here.")
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text("Premade plans")
                        .font(.title2.bold())
                        .padding(.top, 4)

                    ForEach(ReadingPlanTemplate.featured) { plan in
                        FeatureCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(plan.title)
                                    .font(.headline)
                                Text("\(plan.durationDays) days")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.accent)
                                Text(plan.summary)
                                    .foregroundStyle(.secondary)
                                Button("Preview first reading") {
                                    openReading(plan.firstReading)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 900)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Plans")
            .toolbar {
                Button {
                    // Custom plan creation is a Phase 3 deliverable.
                } label: {
                    Label("Create plan", systemImage: "plus")
                }
                .disabled(true)
            }
        }
    }
}

import SwiftUI

struct PlansView: View {
    let openReading: (ScriptureReference) -> Void
    @State private var isPresentingComposer = false

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
                            Text(
                                "Choose a plan below or create a custom schedule. Progress, streaks, grace days, and completion history will live here."
                            )
                            .foregroundStyle(AppTheme.supportingText)
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
                                Text(
                                    "\(plan.durationDays) days · ~\(plan.estimatedDailyMinutes.lowerBound)–\(plan.estimatedDailyMinutes.upperBound) min/day"
                                )
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(AppTheme.accent)
                                Text(plan.summary)
                                    .foregroundStyle(AppTheme.supportingText)
                                Button("Preview first reading") {
                                    if let firstReading = plan.firstReading {
                                        openReading(firstReading)
                                    }
                                }
                                .buttonStyle(.bordered)
                                .disabled(plan.firstReading == nil)
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
                    isPresentingComposer = true
                } label: {
                    Label("Create plan", systemImage: "plus")
                }
                .accessibilityIdentifier("create-custom-plan")
            }
            .sheet(isPresented: $isPresentingComposer) {
                CustomPlanComposerView()
            }
        }
    }
}

import SwiftUI

struct TemplatePlanActivationView: View {
    @Environment(\.dismiss) private var dismiss

    let template: ReadingPlanTemplate
    let onActivate: (ActiveReadingPlanSnapshot) -> Void

    @State private var startDate = Date()
    @State private var eligibleWeekdays = PlanWeekday.everyDay

    private let calendar = Calendar.current

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PlanCoverView(
                        title: template.title,
                        subtitle: template.summary,
                        style: ActiveReadingPlanSnapshot.coverStyle(for: template.id)
                    )
                    .frame(height: 250)
                    .listRowInsets(EdgeInsets())
                }

                Section("Schedule") {
                    DatePicker("Start", selection: $startDate, displayedComponents: .date)
                    WeekdaySelector(selection: $eligibleWeekdays)
                    if eligibleWeekdays.count < PlanWeekday.allCases.count {
                        Text("Unselected weekdays become rest days.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.supportingText)
                    }
                }

                Section("Preview") {
                    LabeledContent("Reading days", value: "\(template.durationDays)")
                    LabeledContent(
                        "Daily time",
                        value:
                            "\(template.estimatedDailyMinutes.lowerBound)–\(template.estimatedDailyMinutes.upperBound) min"
                    )
                    if let finishDate = snapshot?.schedule.last?.scheduledDate {
                        LabeledContent("Finish", value: finishDate.longFormatted)
                    }
                }

                Section {
                    Button {
                        guard let snapshot else { return }
                        onActivate(snapshot)
                        dismiss()
                    } label: {
                        Label("Start This Plan", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.accent)
                    .disabled(snapshot == nil)
                    .accessibilityIdentifier("activate-template-plan")
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Start Plan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .frame(minWidth: 380, idealWidth: 600, minHeight: 560, idealHeight: 740)
    }

    private var snapshot: ActiveReadingPlanSnapshot? {
        try? ActiveReadingPlanSnapshot.make(
            template: template,
            startDate: PlanLocalDate(startDate, calendar: calendar),
            eligibleWeekdays: eligibleWeekdays,
            calendar: calendar
        )
    }
}

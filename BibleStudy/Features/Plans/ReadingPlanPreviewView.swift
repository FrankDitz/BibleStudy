import SwiftUI

struct ReadingPlanPreviewView: View {
    @Environment(\.dismiss) private var dismiss

    let plan: ReadingPlanTemplate
    let startPlan: () -> Void

    @State private var expandedDays: Set<Int> = [1]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                PlanCoverView(
                    title: plan.title,
                    subtitle: plan.summary,
                    style: ActiveReadingPlanSnapshot.coverStyle(for: plan.id)
                )
                .frame(height: 280)

                overviewMetrics

                previewSection(
                    title: "Why this plan exists",
                    systemImage: "lightbulb.fill",
                    text: purpose
                )

                previewSection(
                    title: "What you are committing to",
                    systemImage: "checklist",
                    text: commitment
                )

                VStack(alignment: .leading, spacing: 12) {
                    Label("How the plan is broken up", systemImage: "calendar")
                        .font(.title2.bold())
                    Text(
                        "Every chapter below is a separate reading you can open and check off. A day is complete only after every listed chapter is finished."
                    )
                    .foregroundStyle(AppTheme.supportingText)

                    ForEach(plan.days) { day in
                        dayDisclosure(day)
                    }
                }

                Button(action: startPlan) {
                    Label("Choose This Plan", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
                .accessibilityIdentifier("choose-previewed-plan")
            }
            .padding()
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Plan Preview")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") { dismiss() }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Choose Plan", action: startPlan)
                    .accessibilityIdentifier("choose-previewed-plan-toolbar")
            }
        }
        .accessibilityIdentifier("reading-plan-preview")
    }

    private var overviewMetrics: some View {
        let dailyCounts = plan.days.map(\.chapterCount)
        let minimum = dailyCounts.min() ?? 0
        let maximum = dailyCounts.max() ?? 0
        let books = Set(plan.days.flatMap(\.assignments).map(\.bookID)).count

        return LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 130), spacing: 12)],
            spacing: 12
        ) {
            metric("Duration", "\(plan.durationDays) days")
            metric("Total reading", "\(plan.chapterCount) chapters")
            metric("Daily load", dailyLoad(minimum: minimum, maximum: maximum))
            metric(
                "Time",
                "\(plan.estimatedDailyMinutes.lowerBound)–\(plan.estimatedDailyMinutes.upperBound) min/day"
            )
            metric("Books covered", "\(books)")
            metric("Tradition", "Catholic 73-book canon")
        }
    }

    private func metric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(AppTheme.supportingText)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
        .padding(12)
        .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
    }

    private func previewSection(
        title: String,
        systemImage: String,
        text: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.title2.bold())
            Text(text)
                .foregroundStyle(AppTheme.supportingText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func dayDisclosure(_ day: ReadingPlanTemplateDay) -> some View {
        DisclosureGroup(
            isExpanded: Binding(
                get: { expandedDays.contains(day.logicalDayIndex) },
                set: { isExpanded in
                    if isExpanded {
                        expandedDays.insert(day.logicalDayIndex)
                    } else {
                        expandedDays.remove(day.logicalDayIndex)
                    }
                }
            )
        ) {
            VStack(alignment: .leading, spacing: 9) {
                ForEach(day.assignments) { assignment in
                    Label(assignment.displayTitle, systemImage: "circle")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }
            .padding(.top, 10)
            .padding(.leading, 4)
        } label: {
            HStack {
                Text("Day \(day.logicalDayIndex)")
                    .font(.headline)
                Spacer()
                Text("\(day.chapterCount) chapter\(day.chapterCount == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(AppTheme.supportingText)
            }
        }
        .padding(14)
        .background(Color.secondary.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
        .accessibilityIdentifier("preview-plan-day-\(day.logicalDayIndex)")
    }

    private func dailyLoad(minimum: Int, maximum: Int) -> String {
        minimum == maximum ? "\(maximum) chapters/day" : "\(minimum)–\(maximum) chapters/day"
    }

    private var commitment: String {
        let dailyCounts = plan.days.map(\.chapterCount)
        let minimum = dailyCounts.min() ?? 0
        let maximum = dailyCounts.max() ?? 0
        let load = dailyLoad(minimum: minimum, maximum: maximum)
        return
            "This is a \(plan.durationDays)-reading-day commitment covering \(plan.chapterCount) chapters. Expect \(load) and about \(plan.estimatedDailyMinutes.lowerBound)–\(plan.estimatedDailyMinutes.upperBound) minutes on most reading days. The sequence does not hide skipped chapters or count opening a passage as completion."
    }

    private var purpose: String {
        switch plan.id {
        case "new-testament-90":
            return
                "This plan is for building a concentrated understanding of Jesus, the early Church, and the apostolic letters. Ninety days keeps the pace purposeful without compressing the New Testament into an unrealistic sprint."
        case "catholic-old-testament-90":
            return
                "This is an intensive Old Testament plan for readers prepared for a heavy daily workload. It keeps all 46 Catholic Old Testament books in view, including the deuterocanonical books, so the story of salvation is not reduced to a shorter Protestant canon."
        case "catholic-bible-365":
            return
                "This plan exists for a complete, sustainable reading of the Catholic Bible. It spreads all 1,333 chapters across a year so breadth and consistency matter more than rushing through difficult books."
        case "gospels-30":
            return
                "This plan centers a month on the four accounts of Christ's life, teaching, Passion, and Resurrection. It is useful when you want the person of Jesus—not a broad survey—to be the focus of daily reading."
        case "psalms-proverbs-31":
            return
                "This plan combines prayer and practical wisdom: the Psalms give language for worship, sorrow, repentance, and praise, while Proverbs forms daily judgment and conduct."
        case "start-with-jesus-21":
            return
                "This is the gentlest starting plan. One chapter of John each day creates a manageable habit while presenting who Jesus is before asking for a larger Bible-reading commitment."
        case "catholic-deuterocanon-30":
            return
                "This plan highlights Scripture that is often missing from non-Catholic reading plans. It gives focused attention to the seven deuterocanonical books and the Catholic portions of Esther and Daniel."
        default:
            return plan.summary
        }
    }
}

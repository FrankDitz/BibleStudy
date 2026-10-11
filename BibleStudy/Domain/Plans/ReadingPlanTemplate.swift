import Foundation

struct ReadingPlanTemplate: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let durationDays: Int
    let summary: String
    let firstReading: ScriptureReference

    static let featured: [ReadingPlanTemplate] = [
        ReadingPlanTemplate(
            id: "new-testament-90",
            title: "New Testament in 90 Days",
            durationDays: 90,
            summary: "A focused daily path through the life of Christ and the early Church.",
            firstReading: try! ScriptureReference(versionID: 55, bookID: "MATT", chapter: 1)
        ),
        ReadingPlanTemplate(
            id: "old-testament-90",
            title: "Old Testament in 90 Days",
            durationDays: 90,
            summary: "A brisk survey of salvation history before the coming of Christ.",
            firstReading: try! ScriptureReference(versionID: 55, bookID: "GEN", chapter: 1)
        ),
        ReadingPlanTemplate(
            id: "bible-365",
            title: "Bible in a Year",
            durationDays: 365,
            summary: "A sustainable whole-Bible plan with daily accountability.",
            firstReading: try! ScriptureReference(versionID: 55, bookID: "GEN", chapter: 1)
        ),
    ]
}

import Foundation

struct LearningTopic: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
}

enum LearningTopicCatalog {
    static let topics: [LearningTopic] = [
        LearningTopic(
            id: "mass",
            title: "The Mass",
            subtitle: "Parts of the liturgy, posture, and responses",
            icon: "building.columns"
        ),
        LearningTopic(
            id: "rosary",
            title: "The Rosary",
            subtitle: "Prayers, mysteries, and how to begin",
            icon: "circle.hexagongrid"
        ),
        LearningTopic(
            id: "sacraments",
            title: "The Sacraments",
            subtitle: "Signs of grace in Catholic life",
            icon: "drop"
        ),
        LearningTopic(
            id: "liturgical-year",
            title: "The Liturgical Year",
            subtitle: "Seasons, solemnities, and holy days",
            icon: "calendar"
        ),
        LearningTopic(
            id: "prayer-devotions",
            title: "Prayer & Devotions",
            subtitle: "Practices inside and outside the church",
            icon: "hands.sparkles"
        ),
    ]

    static func topic(id: String) -> LearningTopic? {
        topics.first { $0.id == id }
    }
}

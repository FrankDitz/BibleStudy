import SwiftUI

enum AppDestination: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case home
    case bible
    case plans
    case virtues
    case learning
    case you

    static let primaryTabs: [AppDestination] = [.home, .bible, .plans, .virtues, .learning]

    var id: Self { self }

    var title: String {
        switch self {
        case .home: "Home"
        case .bible: "Bible"
        case .plans: "Plans"
        case .virtues: "Virtues"
        case .learning: "Learning"
        case .you: "You"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house"
        case .bible: "book.closed"
        case .plans: "checkmark.square"
        case .virtues: "shield"
        case .learning: "books.vertical"
        case .you: "person.crop.circle"
        }
    }
}

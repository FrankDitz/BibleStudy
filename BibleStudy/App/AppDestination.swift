import SwiftUI

enum AppDestination: String, CaseIterable, Identifiable, Hashable {
    case home
    case bible
    case plans
    case learning
    case you

    var id: Self { self }

    var title: String {
        switch self {
        case .home: "Home"
        case .bible: "Bible"
        case .plans: "Plans"
        case .learning: "Learning"
        case .you: "You"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house"
        case .bible: "book.closed"
        case .plans: "checkmark.square"
        case .learning: "graduationcap"
        case .you: "person.crop.circle"
        }
    }
}

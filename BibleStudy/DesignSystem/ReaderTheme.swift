import SwiftUI

enum ReaderTheme: String, CaseIterable, Codable, Identifiable, Sendable {
    case automatic
    case light
    case sepia
    case dark

    var id: Self { self }

    var title: String {
        switch self {
        case .automatic: "App"
        case .light: "Light"
        case .sepia: "Sepia"
        case .dark: "Dark"
        }
    }

    func resolved(for colorScheme: ColorScheme) -> ReaderTheme {
        guard self == .automatic else { return self }
        return colorScheme == .dark ? .dark : .light
    }

    var backgroundColor: Color {
        switch self {
        case .automatic: Color("AppBackground")
        case .light: Color(red: 1.00, green: 1.00, blue: 0.99)
        case .sepia: Color(red: 0.95, green: 0.90, blue: 0.78)
        case .dark: Color(red: 0.025, green: 0.035, blue: 0.028)
        }
    }

    var textColor: Color {
        switch self {
        case .automatic: Color("AppInk")
        case .light: Color(red: 0.10, green: 0.10, blue: 0.11)
        case .sepia: Color(red: 0.20, green: 0.15, blue: 0.10)
        case .dark: Color(red: 0.95, green: 0.97, blue: 0.95)
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch self {
        case .automatic: nil
        case .dark: .dark
        case .light, .sepia: .light
        }
    }
}

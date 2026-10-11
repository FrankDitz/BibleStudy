import SwiftUI

enum ReaderTheme: String, CaseIterable, Codable, Identifiable, Sendable {
    case light
    case sepia
    case dark

    var id: Self { self }

    var title: String {
        switch self {
        case .light: "Light"
        case .sepia: "Sepia"
        case .dark: "Dark"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .light: Color(red: 0.98, green: 0.98, blue: 0.97)
        case .sepia: Color(red: 0.95, green: 0.90, blue: 0.78)
        case .dark: Color(red: 0.07, green: 0.07, blue: 0.08)
        }
    }

    var textColor: Color {
        switch self {
        case .light: Color(red: 0.10, green: 0.10, blue: 0.11)
        case .sepia: Color(red: 0.20, green: 0.15, blue: 0.10)
        case .dark: Color(red: 0.92, green: 0.92, blue: 0.91)
        }
    }

    var preferredColorScheme: ColorScheme? {
        self == .dark ? .dark : .light
    }
}

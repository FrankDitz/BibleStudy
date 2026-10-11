import SwiftUI

enum AppTheme {
    static let accent = Color(red: 0.48, green: 0.20, blue: 0.16)
    static let warmSurface = Color(red: 0.96, green: 0.93, blue: 0.87)
    static let supportingText = Color.primary.opacity(0.78)
    static let success = Color(red: 0.20, green: 0.46, blue: 0.30)
    static let warning = Color(red: 0.65, green: 0.38, blue: 0.08)
    static let danger = Color(red: 0.70, green: 0.16, blue: 0.14)
}

enum AppSpacing {
    static let compact: CGFloat = 8
    static let standard: CGFloat = 16
    static let spacious: CGFloat = 24
    static let section: CGFloat = 32
}

enum AppCornerRadius {
    static let control: CGFloat = 12
    static let card: CGFloat = 20
}

enum AppTypography {
    static let screenIntroduction = Font.title2.weight(.medium)
    static let sectionTitle = Font.title2.bold()
    static let cardTitle = Font.headline
    static let supporting = Font.subheadline
}

struct FeatureCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(AppSpacing.standard)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: AppCornerRadius.card)
            )
    }
}

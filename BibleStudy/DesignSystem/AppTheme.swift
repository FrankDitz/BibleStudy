import SwiftUI

enum AppAppearance: String, CaseIterable, Identifiable, Sendable {
    case system
    case emeraldLight
    case emeraldAfterDark

    static let storageKey = "app-appearance"

    var id: Self { self }

    var title: String {
        switch self {
        case .system: "System"
        case .emeraldLight: "Emerald Light"
        case .emeraldAfterDark: "Emerald After Dark"
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .emeraldLight: .light
        case .emeraldAfterDark: .dark
        }
    }
}

enum AppTheme {
    static let accent = Color("AppEmerald")
    static let background = Color("AppBackground")
    static let surface = Color("AppSurface")
    static let elevatedSurface = Color("AppElevatedSurface")
    static let ink = Color("AppInk")
    static let supportingText = Color("AppMutedInk")
    static let hairline = Color("AppHairline")

    static let warmSurface = background
    static let success = Color("AppEmerald")
    static let warning = Color(red: 0.84, green: 0.50, blue: 0.10)
    static let danger = Color(red: 0.78, green: 0.16, blue: 0.16)
    static let onAccent = Color.white
}

enum AppSpacing {
    static let compact: CGFloat = 8
    static let standard: CGFloat = 16
    static let spacious: CGFloat = 24
    static let section: CGFloat = 32
    static let screen: CGFloat = 20
}

enum AppCornerRadius {
    static let control: CGFloat = 10
    static let card: CGFloat = 16
    static let hero: CGFloat = 22
}

enum AppTypography {
    static let hero = Font.system(size: 48, weight: .black, design: .serif)
    static let screenTitle = Font.system(.largeTitle, design: .serif, weight: .bold)
    static let screenIntroduction = Font.title3.weight(.regular)
    static let sectionTitle = Font.system(.title2, design: .serif, weight: .bold)
    static let cardTitle = Font.system(.title3, design: .serif, weight: .semibold)
    static let supporting = Font.subheadline
    static let eyebrow = Font.caption2.weight(.bold)
}

struct EditorialEyebrow: View {
    let text: String
    var inverse = false

    init(_ text: String, inverse: Bool = false) {
        self.text = text
        self.inverse = inverse
    }

    var body: some View {
        Text(text.uppercased())
            .font(AppTypography.eyebrow)
            .tracking(3)
            .foregroundStyle(inverse ? AppTheme.onAccent.opacity(0.82) : AppTheme.accent)
            .accessibilityLabel(text)
    }
}

struct EditorialSectionHeader: View {
    let eyebrow: String?
    let title: String
    let detail: String?

    init(_ title: String, eyebrow: String? = nil, detail: String? = nil) {
        self.eyebrow = eyebrow
        self.title = title
        self.detail = detail
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.compact) {
            if let eyebrow {
                EditorialEyebrow(eyebrow)
            }
            Text(title)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(AppTheme.ink)
            if let detail {
                Text(detail)
                    .font(AppTypography.supporting)
                    .foregroundStyle(AppTheme.supportingText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

struct FeatureCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(AppSpacing.standard)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.card, style: .continuous)
                    .fill(AppTheme.surface)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AppCornerRadius.card, style: .continuous)
                    .stroke(AppTheme.hairline, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.045), radius: 12, y: 5)
    }
}

struct EmeraldActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(AppTheme.onAccent)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.standard)
            .padding(.vertical, 14)
            .background(
                AppTheme.accent.opacity(isEnabled ? (configuration.isPressed ? 0.78 : 1) : 0.42),
                in: RoundedRectangle(cornerRadius: AppCornerRadius.control, style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
    }
}

struct EmeraldProgressBar: View {
    let value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().fill(AppTheme.elevatedSurface)
                Rectangle()
                    .fill(AppTheme.accent)
                    .frame(width: geometry.size.width * min(max(value, 0), 1))
            }
        }
        .frame(height: 7)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .accessibilityElement()
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(min(max(value, 0), 1) * 100)) percent")
    }
}

struct AppHeroArtwork: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Image(colorScheme == .dark ? "AppHeroDark" : "AppHeroLight")
            .resizable()
            .scaledToFill()
            .accessibilityHidden(true)
    }
}

struct AppScreenBackground: View {
    var body: some View {
        AppTheme.background.ignoresSafeArea()
    }
}

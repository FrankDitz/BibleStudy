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
    static let night = Color(red: 0.008, green: 0.012, blue: 0.009)
    static let graphite = Color(red: 0.035, green: 0.047, blue: 0.039)
    static let onDark = Color(red: 0.975, green: 0.980, blue: 0.976)
}

enum AppSpacing {
    static let compact: CGFloat = 8
    static let standard: CGFloat = 16
    static let spacious: CGFloat = 24
    static let section: CGFloat = 32
    static let screen: CGFloat = 20
}

enum AppCornerRadius {
    static let control: CGFloat = 3
    static let card: CGFloat = 4
    static let hero: CGFloat = 6
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

struct EditorialSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isEnabled ? AppTheme.ink : AppTheme.supportingText)
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(configuration.isPressed ? AppTheme.elevatedSurface : AppTheme.surface)
            .overlay {
                Rectangle()
                    .stroke(AppTheme.hairline, lineWidth: 1)
            }
            .contentShape(Rectangle())
    }
}

struct EditorialTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(AppTheme.elevatedSurface)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(AppTheme.accent)
                    .frame(height: 2)
            }
    }
}

struct EditorialMetric: View {
    let eyebrow: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.system(.title3, design: .serif, weight: .bold))
                .foregroundStyle(AppTheme.ink)
            Text(eyebrow.uppercased())
                .font(.caption2.weight(.bold))
                .tracking(1.5)
                .foregroundStyle(AppTheme.supportingText)
        }
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
        #if os(macOS)
            GeometryReader { geometry in
                ZStack(alignment: .trailing) {
                    Color.black
                    Image(colorScheme == .dark ? "AppHeroDark" : "AppHeroLight")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height,
                            alignment: .trailing
                        )
                }
            }
            .accessibilityHidden(true)
        #else
            Image(colorScheme == .dark ? "AppHeroDark" : "AppHeroLight")
                .resizable()
                .scaledToFill()
                .accessibilityHidden(true)
        #endif
    }
}

struct EditorialArtwork: View {
    let assetName: String

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFill()
            .accessibilityHidden(true)
    }
}

enum EditorialArtworkSlot {
    /// Primary section artwork. Future artwork should be composed at 16:9 with its subject
    /// inside the center 60% so the same asset remains useful at compact widths.
    case feature
    /// Reading-plan cover artwork. Future artwork should be delivered at 3:2.
    case planCover
    /// Small supporting artwork used beside progress and continuation content.
    case thumbnail

    var aspectRatio: CGFloat {
        switch self {
        case .feature:
            16 / 9
        case .planCover:
            3 / 2
        case .thumbnail:
            1
        }
    }
}

/// A predictable media frame used to design the interface before final artwork is made.
/// Images intentionally fill the declared slot; the slot—not an existing image's shape—
/// defines the composition required of replacement artwork.
struct EditorialMediaSlot: View {
    let assetName: String
    let slot: EditorialArtworkSlot
    var alignment: Alignment = .center

    var body: some View {
        GeometryReader { geometry in
            Image(assetName)
                .resizable()
                .scaledToFill()
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: alignment
                )
                .clipped()
        }
        .aspectRatio(slot.aspectRatio, contentMode: .fit)
        .background(Color.black)
        .accessibilityHidden(true)
    }
}

struct EditorialStatusBadge: View {
    let text: String
    var systemImage: String?
    var emphasized = false

    var body: some View {
        HStack(spacing: 5) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(text.uppercased())
        }
        .font(.caption2.weight(.bold))
        .tracking(1.1)
        .foregroundStyle(emphasized ? AppTheme.onAccent : AppTheme.supportingText)
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(emphasized ? AppTheme.accent : AppTheme.elevatedSurface)
        .overlay {
            Rectangle().stroke(emphasized ? AppTheme.accent : AppTheme.hairline, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

struct EditorialDivider: View {
    var body: some View {
        Rectangle()
            .fill(AppTheme.hairline)
            .frame(height: 1)
    }
}

struct EditorialEndCap: View {
    let title: String
    let identifier: String

    var body: some View {
        HStack(spacing: 14) {
            Rectangle()
                .fill(AppTheme.accent)
                .frame(width: 34, height: 3)
            Text(title.uppercased())
                .font(.caption.weight(.black))
                .tracking(2.4)
            Spacer()
            Image(systemName: "cross.fill")
                .font(.headline)
                .foregroundStyle(AppTheme.accent)
        }
        .foregroundStyle(.white)
        .padding(AppSpacing.standard)
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(.black)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). End of content")
        .accessibilityIdentifier(identifier)
    }
}

enum EditorialImageMetrics {
    static var activePlanThumbnailSize: CGSize {
        #if os(macOS)
            CGSize(width: 132, height: 132)
        #else
            CGSize(width: 92, height: 92)
        #endif
    }
}

struct AppScreenBackground: View {
    var body: some View {
        AppTheme.background.ignoresSafeArea()
    }
}

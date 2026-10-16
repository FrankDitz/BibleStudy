import SwiftUI

enum EditorialLayout {
    static let desktopMaxWidth: CGFloat = 1180
    static let desktopMinimumColumnWidth: CGFloat = 320
    static let phoneContentReferenceWidth: CGFloat = 350
    static let phoneRouteMapMinimumHeight: CGFloat = 122
    static let desktopRouteMapMinimumHeight: CGFloat = 144
    static let phoneInterludeMinimumHeight: CGFloat = 168
    static let desktopInterludeMinimumHeight: CGFloat = 196
    static let phoneIdentityTileSize = CGSize(width: 112, height: 128)
    static let desktopIdentityTileMinimumHeight: CGFloat = 150
    static let phoneMetricMinimumHeight: CGFloat = 108
    static let desktopMetricMinimumHeight: CGFloat = 124
}

enum EditorialPanelTone {
    case surface
    case elevated
    case graphite
    case black
    case emerald

    var background: Color {
        switch self {
        case .surface: AppTheme.surface
        case .elevated: AppTheme.elevatedSurface
        case .graphite: AppTheme.graphite
        case .black: AppTheme.night
        case .emerald: AppTheme.accent
        }
    }

    var foreground: Color {
        switch self {
        case .surface, .elevated: AppTheme.ink
        case .graphite, .black, .emerald: AppTheme.onDark
        }
    }

    var supporting: Color {
        switch self {
        case .surface, .elevated: AppTheme.supportingText
        case .graphite, .black, .emerald: AppTheme.onDark.opacity(0.72)
        }
    }
}

struct EditorialPanel<Content: View>: View {
    let tone: EditorialPanelTone
    let leadingRule: Bool
    @ViewBuilder let content: Content

    init(
        tone: EditorialPanelTone = .surface,
        leadingRule: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.tone = tone
        self.leadingRule = leadingRule
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.standard)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(tone.foreground)
            .background(tone.background)
            .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
            .overlay(alignment: .leading) {
                if leadingRule {
                    Rectangle()
                        .fill(AppTheme.accent)
                        .frame(width: 4)
                }
            }
    }
}

struct EditorialInterlude: View {
    let eyebrow: String
    let mark: String
    let statement: String
    let citation: String?
    var tone: EditorialPanelTone = .black

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(mark.uppercased())
                .font(.system(size: mark.count > 4 ? 58 : 76, weight: .black, design: .serif))
                .foregroundStyle(tone.foreground.opacity(0.07))
                .lineLimit(1)
                .minimumScaleFactor(0.55)
                .padding(12)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 12) {
                Text(eyebrow.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(2.6)
                    .foregroundStyle(tone == .emerald ? .white.opacity(0.8) : AppTheme.accent)
                Rectangle()
                    .fill(tone == .emerald ? Color.white : AppTheme.accent)
                    .frame(width: 32, height: 3)
                Text(statement)
                    .font(.system(.title2, design: .serif, weight: .semibold))
                    .fixedSize(horizontal: false, vertical: true)
                if let citation {
                    Text(citation.uppercased())
                        .font(.caption2.weight(.bold))
                        .tracking(2)
                        .foregroundStyle(tone.supporting)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.screen)
        }
        .foregroundStyle(tone.foreground)
        .frame(
            maxWidth: .infinity,
            minHeight: interludeMinimumHeight,
            alignment: .leading
        )
        .background(tone.background)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        .accessibilityElement(children: .combine)
    }

    private var interludeMinimumHeight: CGFloat {
        #if os(macOS)
            EditorialLayout.desktopInterludeMinimumHeight
        #else
            EditorialLayout.phoneInterludeMinimumHeight
        #endif
    }
}

struct EditorialRouteStep: Identifiable, Equatable {
    let id: String
    let number: String
    let title: String
    let detail: String
}

struct EditorialRouteMap: View {
    let eyebrow: String
    let steps: [EditorialRouteStep]
    let currentIndex: Int
    let completedIndices: Set<Int>
    let progressLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                EditorialEyebrow(eyebrow)
                Spacer()
                Text(progressLabel.uppercased())
                    .font(.caption2.bold())
                    .tracking(1.2)
                    .foregroundStyle(AppTheme.supportingText)
            }

            HStack(alignment: .top, spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                    routeStep(step, index: index)
                    if index < steps.count - 1 {
                        Rectangle()
                            .fill(index < currentIndex ? AppTheme.accent : AppTheme.hairline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .padding(.top, 20)
                    }
                }
            }
        }
        .padding(AppSpacing.standard)
        .frame(maxWidth: .infinity, minHeight: routeMinimumHeight, alignment: .leading)
        .background(AppTheme.surface)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        .accessibilityElement(children: .contain)
    }

    private func routeStep(_ step: EditorialRouteStep, index: Int) -> some View {
        let isComplete = completedIndices.contains(index)
        let isCurrent = index == currentIndex

        return VStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .fill(isComplete || isCurrent ? AppTheme.accent : AppTheme.elevatedSurface)
                Rectangle()
                    .stroke(isCurrent ? AppTheme.accent : AppTheme.hairline, lineWidth: isCurrent ? 2 : 1)
                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.onAccent)
                } else {
                    Text(step.number)
                        .font(.system(.headline, design: .serif, weight: .black))
                        .foregroundStyle(isCurrent ? AppTheme.onAccent : AppTheme.ink)
                }
            }
            .frame(width: 40, height: 40)

            Text(step.title.uppercased())
                .font(.caption2.weight(.black))
                .tracking(1)
                .foregroundStyle(AppTheme.ink)
                .lineLimit(1)
            Text(step.detail)
                .font(.caption2)
                .foregroundStyle(AppTheme.supportingText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityValue(isComplete ? "Completed" : isCurrent ? "Current" : "Upcoming")
    }

    private var routeMinimumHeight: CGFloat {
        #if os(macOS)
            EditorialLayout.desktopRouteMapMinimumHeight
        #else
            EditorialLayout.phoneRouteMapMinimumHeight
        #endif
    }
}

struct EditorialProgressSegments: View {
    let total: Int
    let completed: Int
    var current: Int? = nil

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0 ..< max(total, 1), id: \.self) { index in
                Rectangle()
                    .fill(index < completed ? AppTheme.accent : AppTheme.elevatedSurface)
                    .overlay {
                        if index == current, index >= completed {
                            Rectangle().stroke(AppTheme.accent, lineWidth: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: segmentHeight)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Progress")
        .accessibilityValue("\(min(completed, total)) of \(total) complete")
    }

    private var segmentHeight: CGFloat {
        #if os(macOS)
            10
        #else
            8
        #endif
    }
}

struct EditorialIdentity: Identifiable, Equatable {
    let id: String
    let title: String
    let verb: String
    let systemImage: String
}

struct EditorialIdentityRail: View {
    let identities: [EditorialIdentity]
    let activeID: String?

    var body: some View {
        #if os(macOS)
            HStack(spacing: 0) {
                ForEach(identities) { identity in
                    identityTile(identity)
                        .frame(maxWidth: .infinity)
                }
            }
        #else
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(identities) { identity in
                        identityTile(identity)
                            .frame(
                                width: EditorialLayout.phoneIdentityTileSize.width,
                                height: EditorialLayout.phoneIdentityTileSize.height
                            )
                    }
                }
            }
        #endif
    }

    private func identityTile(_ identity: EditorialIdentity) -> some View {
        let isActive = activeID == identity.id
        return VStack(alignment: .leading, spacing: 9) {
            Image(systemName: identity.systemImage)
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(isActive ? AppTheme.onAccent : AppTheme.accent)
            Spacer(minLength: 4)
            Text(identity.title.uppercased())
                .font(.caption.weight(.black))
                .tracking(1.1)
            Text(identity.verb.uppercased())
                .font(.caption2.weight(.medium))
                .tracking(0.8)
                .foregroundStyle(isActive ? AppTheme.onAccent.opacity(0.76) : AppTheme.supportingText)
                .lineLimit(2)
        }
        .padding(14)
        .frame(
            maxWidth: .infinity,
            minHeight: EditorialLayout.desktopIdentityTileMinimumHeight,
            alignment: .leading
        )
        .foregroundStyle(AppTheme.onDark)
        .background(isActive ? AppTheme.accent : AppTheme.night)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
}

struct EditorialMediaStory<Content: View>: View {
    let assetName: String
    let alignment: Alignment
    @ViewBuilder let content: Content

    init(
        assetName: String,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.assetName = assetName
        self.alignment = alignment
        self.content = content()
    }

    var body: some View {
        Group {
            #if os(macOS)
                HStack(spacing: 0) {
                    EditorialMediaSlot(assetName: assetName, slot: .planCover, alignment: alignment)
                        .frame(maxWidth: .infinity)
                    content
                        .padding(AppSpacing.spacious)
                        .frame(maxWidth: .infinity, minHeight: 250, alignment: .leading)
                        .background(AppTheme.night)
                }
            #else
                VStack(spacing: 0) {
                    EditorialMediaSlot(assetName: assetName, slot: .planCover, alignment: alignment)
                    content
                        .padding(AppSpacing.standard)
                        .frame(maxWidth: .infinity, minHeight: 116, alignment: .leading)
                        .background(AppTheme.night)
                }
            #endif
        }
        .foregroundStyle(AppTheme.onDark)
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
    }
}

struct EditorialMetricItem: Identifiable, Equatable {
    let id: String
    let value: String
    let label: String
    let detail: String
    let progress: Double?
}

struct EditorialMetricMatrix: View {
    let metrics: [EditorialMetricItem]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(metrics) { metric in
                VStack(alignment: .leading, spacing: 7) {
                    Text(metric.value)
                        .font(.system(size: 34, weight: .black, design: .serif))
                        .foregroundStyle(AppTheme.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.45)
                        .allowsTightening(true)
                    Text(metric.label.uppercased())
                        .font(.caption2.weight(.black))
                        .tracking(1.4)
                    Text(metric.detail)
                        .font(.caption)
                        .foregroundStyle(AppTheme.supportingText)
                    if let progress = metric.progress {
                        EmeraldProgressBar(value: progress)
                            .padding(.top, 2)
                    }
                }
                .padding(AppSpacing.standard)
                .frame(maxWidth: .infinity, minHeight: metricMinimumHeight, alignment: .topLeading)
                .background(AppTheme.surface)
                .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private var columns: [GridItem] {
        #if os(macOS)
            Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
        #else
            Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
        #endif
    }

    private var metricMinimumHeight: CGFloat {
        #if os(macOS)
            EditorialLayout.desktopMetricMinimumHeight
        #else
            EditorialLayout.phoneMetricMinimumHeight
        #endif
    }
}

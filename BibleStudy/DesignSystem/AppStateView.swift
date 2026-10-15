import SwiftUI

enum AppStateKind: String, CaseIterable, Codable, Sendable {
    case loading
    case empty
    case error
    case offline
    case rightsLocked
    case stale

    var defaultIcon: String {
        switch self {
        case .loading: "hourglass"
        case .empty: "tray"
        case .error: "exclamationmark.triangle"
        case .offline: "wifi.slash"
        case .rightsLocked: "lock.shield"
        case .stale: "clock.badge.exclamationmark"
        }
    }
}

struct AppStateDescriptor: Equatable, Sendable {
    let kind: AppStateKind
    let title: String
    let message: String
    let icon: String

    init(
        kind: AppStateKind,
        title: String,
        message: String,
        icon: String? = nil
    ) {
        self.kind = kind
        self.title = title
        self.message = message
        self.icon = icon ?? kind.defaultIcon
    }
}

struct AppStateView: View {
    let descriptor: AppStateDescriptor
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        _ descriptor: AppStateDescriptor,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.descriptor = descriptor
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        ContentUnavailableView {
            if descriptor.kind == .loading {
                ProgressView()
                    .controlSize(.large)
                    .accessibilityLabel(descriptor.title)
            } else {
                Label(descriptor.title, systemImage: descriptor.icon)
            }
        } description: {
            Text(descriptor.message)
        } actions: {
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(EmeraldActionButtonStyle())
            }
        }
        .accessibilityElement(children: .contain)
    }
}

struct AppStatusBanner: View {
    let descriptor: AppStateDescriptor

    var body: some View {
        Label(descriptor.message, systemImage: descriptor.icon)
            .font(.footnote.weight(.medium))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.compact)
            .background(tint.opacity(0.14), in: Rectangle())
            .overlay { Rectangle().stroke(tint.opacity(0.32), lineWidth: 1) }
            .accessibilityLabel("\(descriptor.title). \(descriptor.message)")
    }

    private var tint: Color {
        switch descriptor.kind {
        case .error, .rightsLocked: AppTheme.danger
        case .offline, .stale: AppTheme.warning
        case .loading, .empty: AppTheme.accent
        }
    }
}

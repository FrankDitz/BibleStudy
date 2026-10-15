import SwiftUI

struct ProfileView: View {
    let isYouVersionConfigured: Bool

    @AppStorage(AppAppearance.storageKey) private var appearance = AppAppearance.system

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    profileHeader
                    appearanceCard
                    journeyCard
                    integrationCard
                    privacyCard
                }
                .padding(AppSpacing.screen)
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
            }
            .background(AppScreenBackground())
            .navigationTitle("You")
        }
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            EditorialEyebrow("Private formation")
            Text("Your journey.")
                .font(AppTypography.screenTitle)
            Text("Preferences and progress belong to you. Nothing here ranks faith or turns formation into a competition.")
                .font(AppTypography.screenIntroduction)
                .foregroundStyle(AppTheme.supportingText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var appearanceCard: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 14) {
                EditorialSectionHeader(
                    "Appearance",
                    eyebrow: "Emerald",
                    detail: "Follow the device or keep either approved appearance active."
                )
                Picker("Appearance", selection: $appearance) {
                    ForEach(AppAppearance.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityIdentifier("appearance-picker")
            }
        }
    }

    private var journeyCard: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 16) {
                EditorialSectionHeader("Journey", eyebrow: "This week")
                metric("Reading days", value: "0")
                Divider()
                metric("Current rhythm", value: "0 days")
                Divider()
                metric("Plans completed", value: "0")
                NavigationLink {
                    VirtueFormationRecordView()
                } label: {
                    Label("Open Virtue Formation Record", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private var integrationCard: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 14) {
                EditorialSectionHeader("Integrations", eyebrow: "Connected services")
                HStack {
                    Text("YouVersion Platform")
                    Spacer()
                    Label(
                        isYouVersionConfigured ? "Configured" : "Needs App Key",
                        systemImage: isYouVersionConfigured ? "checkmark.circle.fill" : "exclamationmark.circle"
                    )
                    .foregroundStyle(isYouVersionConfigured ? AppTheme.success : AppTheme.supportingText)
                }
                Divider()
                metric("YouVersion sign-in", value: "Off")
                Divider()
                metric("iCloud sync", value: "Planned")
                if isYouVersionConfigured {
                    NavigationLink("Audit licensed editions") {
                        YouVersionDiagnosticsView()
                    }
                }
            }
        }
    }

    private var privacyCard: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                EditorialSectionHeader("Private by design", eyebrow: "Privacy")
                Label(
                    "Plans, completion history, notes, highlights, bookmarks, and reflections remain private app data.",
                    systemImage: "lock.shield"
                )
                .foregroundStyle(AppTheme.supportingText)
                Text("This build is scoped for one-person use. Public distribution requires a new content-license, privacy, attribution, and distribution review.")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.supportingText)
            }
        }
    }

    private func metric(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(AppTheme.accent)
        }
    }
}

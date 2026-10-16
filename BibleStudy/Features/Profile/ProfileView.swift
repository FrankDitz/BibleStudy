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
        EditorialMediaStory(assetName: "ProfileJourney", alignment: .center) {
            VStack(alignment: .leading, spacing: 10) {
                EditorialEyebrow("Private formation", inverse: true)
                Text("YOUR\nJOURNEY.")
                    .font(.system(size: 38, weight: .black, design: .serif))
                    .minimumScaleFactor(0.72)
                Rectangle()
                    .fill(AppTheme.accent)
                    .frame(width: 36, height: 3)
                Text("Preferences and progress belong to you. Formation is a path, never a competition.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.onDark.opacity(0.76))
            }
        }
        .accessibilityIdentifier("you-editorial-header")
    }

    private var appearanceCard: some View {
        EditorialPanel {
            VStack(alignment: .leading, spacing: 14) {
                EditorialSectionHeader(
                    "Appearance",
                    eyebrow: "Emerald",
                    detail: "Follow the device or keep either approved appearance active."
                )
                HStack(spacing: 0) {
                    ForEach(AppAppearance.allCases) { option in
                        Button {
                            appearance = option
                        } label: {
                            Text(option.title)
                                .font(.caption.bold())
                                .foregroundStyle(appearance == option ? AppTheme.onAccent : AppTheme.ink)
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(appearance == option ? AppTheme.accent : AppTheme.elevatedSurface)
                                .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(appearance == option ? .isSelected : [])
                    }
                }
                .accessibilityIdentifier("appearance-picker")
            }
        }
    }

    private var journeyCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.standard) {
            EditorialSectionHeader(
                "Your rhythm",
                eyebrow: "This week",
                detail: "A private record of returning—not a score of spiritual worth."
            )
            EditorialMetricMatrix(
                metrics: [
                    EditorialMetricItem(
                        id: "reading-days",
                        value: "0",
                        label: "Reading days",
                        detail: "Scripture opened this week",
                        progress: 0
                    ),
                    EditorialMetricItem(
                        id: "current-rhythm",
                        value: "0",
                        label: "Day rhythm",
                        detail: "Current plan continuity",
                        progress: 0
                    ),
                    EditorialMetricItem(
                        id: "plans-completed",
                        value: "0",
                        label: "Plans complete",
                        detail: "Finished reading journeys",
                        progress: nil
                    ),
                    EditorialMetricItem(
                        id: "formation-record",
                        value: "PRIVATE",
                        label: "Formation",
                        detail: "Lessons and practices remain yours",
                        progress: nil
                    ),
                ]
            )
            NavigationLink {
                VirtueFormationRecordView()
            } label: {
                HStack {
                    Label("Open Virtue Formation Record", systemImage: "lock.shield")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(.subheadline.bold())
                .foregroundStyle(AppTheme.onDark)
                .padding(AppSpacing.standard)
                .background(AppTheme.night)
            }
        }
        .accessibilityIdentifier("you-journey-metrics")
    }

    private var integrationCard: some View {
        EditorialPanel {
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
        EditorialPanel(leadingRule: true) {
            VStack(alignment: .leading, spacing: 12) {
                EditorialSectionHeader("Private by design", eyebrow: "Privacy")
                Label(
                    "Plans, completion history, notes, highlights, bookmarks, and reflections remain private app data.",
                    systemImage: "lock.shield"
                )
                .foregroundStyle(AppTheme.supportingText)
                Text(
                    "This build is scoped for one-person use. Public distribution requires a new content-license, privacy, attribution, and distribution review."
                )
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

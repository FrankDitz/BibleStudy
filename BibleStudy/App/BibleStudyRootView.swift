import SwiftUI

struct BibleStudyRootView: View {
    let dependencies: AppDependencies

    @State private var selection: AppDestination = .home
    @State private var scriptureNavigation = ScriptureNavigationController()
    @State private var catalogApproval = YouVersionCatalogApproval()
    @State private var didApplyLaunchRoute = false
    @State private var activePlanNavigationRequest = 0
    @State private var isPresentingProfile = false
    @State private var presentedVirtueReading: ScriptureReference?
    @AppStorage(AppAppearance.storageKey) private var appearance = AppAppearance.system

    var body: some View {
        Group {
            #if os(macOS)
                NavigationSplitView {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            EditorialEyebrow("Kingdom atelier")
                            Text("KINGDOM")
                                .font(.system(size: 25, weight: .black, design: .serif))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 22)

                        Divider()

                        VStack(spacing: 4) {
                            ForEach(AppDestination.allCases) { destination in
                                Button {
                                    selection = destination
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(
                                            systemName: selection == destination
                                                ? destination.selectedSystemImage : destination.systemImage
                                        )
                                        .frame(width: 22)
                                        Text(destination.title)
                                            .font(.body.weight(.semibold))
                                        Spacer()
                                    }
                                    .foregroundStyle(selection == destination ? AppTheme.onAccent : AppTheme.ink)
                                    .padding(.horizontal, 14)
                                    .frame(height: 46)
                                    .background(selection == destination ? AppTheme.accent : .clear)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("navigation-\(destination.rawValue)")
                            }
                        }
                        .padding(10)

                        Spacer()

                        Text("SCRIPTURE · FORMATION · LIFE")
                            .font(.caption2.bold())
                            .tracking(1.5)
                            .foregroundStyle(AppTheme.supportingText)
                            .padding(18)
                    }
                    .background(AppTheme.surface)
                    .navigationSplitViewColumnWidth(min: 190, ideal: 210, max: 230)
                } detail: {
                    destinationView(selection)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            #else
                destinationView(selection)
                    .contentMargins(
                        .bottom,
                        AppSpacing.section + AppSpacing.standard,
                        for: .scrollContent
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        KingdomTabBar(selection: $selection)
                    }
            #endif
        }
        .preferredColorScheme(appearance.preferredColorScheme)
        .tint(AppTheme.accent)
        .foregroundStyle(AppTheme.ink)
        .background(AppTheme.background)
        #if !os(macOS)
            .sheet(isPresented: $isPresentingProfile) {
                ProfileView(
                    isYouVersionConfigured: dependencies.configuration.isYouVersionConfigured
                )
            }
        #endif
        .sheet(item: $presentedVirtueReading) { _ in
            BibleTabView(
                configuration: dependencies.configuration,
                navigation: scriptureNavigation,
                catalogApproval: catalogApproval,
                returnTitle: "Back to Virtues"
            ) {
                presentedVirtueReading = nil
            }
            #if os(macOS)
                .frame(minWidth: 720, minHeight: 620)
            #endif
        }
        .task {
            guard !didApplyLaunchRoute else { return }
            didApplyLaunchRoute = true
            if let route = dependencies.launchContext.initialRoute {
                handle(route)
            }
        }
        .onOpenURL { url in
            guard let route = BibleStudyDeepLink.parse(url) else {
                AppLog.integration.warning("Ignored invalid Bible Study deep link")
                return
            }
            handle(route)
        }
    }

    @ViewBuilder
    private func destinationView(_ destination: AppDestination) -> some View {
        switch destination {
        case .home:
            HomeView(
                openReading: openScripture,
                openPlans: openActivePlan,
                openLearning: { selection = .learning },
                openVirtues: { selection = .virtues },
                openProfile: openProfile
            )
        case .bible:
            BibleTabView(
                configuration: dependencies.configuration,
                navigation: scriptureNavigation,
                catalogApproval: catalogApproval
            )
        case .plans:
            PlansView(
                openReading: openScripture,
                activePlanNavigationRequest: activePlanNavigationRequest
            )
        case .virtues:
            VirtuesView(openReading: openVirtueScripture)
        case .learning:
            LearningView()
        case .you:
            ProfileView(
                isYouVersionConfigured: dependencies.configuration.isYouVersionConfigured
            )
        }
    }

    private func openScripture(_ reference: ScriptureReference) {
        scriptureNavigation.open(reference)
        selection = .bible
    }

    private func openVirtueScripture(_ reference: CanonicalScriptureReference) {
        guard
            let scriptureReference = try? ScriptureReference(
                versionID: YouVersionCatalogPolicy.developmentDefaultVersionID,
                bookID: reference.bookID,
                chapter: reference.chapter,
                verseStart: reference.verseStart,
                verseEnd: reference.verseEnd
            )
        else { return }
        scriptureNavigation.open(scriptureReference)
        presentedVirtueReading = scriptureReference
    }

    private func openActivePlan() {
        activePlanNavigationRequest += 1
        selection = .plans
    }

    private func openProfile() {
        #if os(macOS)
            selection = .you
        #else
            isPresentingProfile = true
        #endif
    }

    private func handle(_ route: BibleStudyRoute) {
        switch route {
        case .destination(let destination):
            if destination == .you {
                openProfile()
            } else {
                selection = destination
            }
        case .scripture(let reference):
            openScripture(reference)
        }
    }
}

#if !os(macOS)
    private struct KingdomTabBar: View {
        @Binding var selection: AppDestination

        var body: some View {
            HStack(spacing: 0) {
                ForEach(AppDestination.primaryTabs) { destination in
                    Button {
                        selection = destination
                    } label: {
                        VStack(spacing: 4) {
                            Image(
                                systemName: selection == destination
                                    ? destination.selectedSystemImage : destination.systemImage
                            )
                            .font(.system(size: 18, weight: .semibold))
                            Text(destination.title)
                                .font(.caption2.weight(selection == destination ? .bold : .medium))
                        }
                        .foregroundStyle(selection == destination ? AppTheme.accent : AppTheme.ink)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("navigation-\(destination.rawValue)")
                }
            }
            .padding(.top, 4)
            .background(AppTheme.surface)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(AppTheme.hairline)
                    .frame(height: 1)
            }
        }
    }
#endif

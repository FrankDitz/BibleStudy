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
                    List(AppDestination.allCases, selection: $selection) { destination in
                        Label(destination.title, systemImage: destination.systemImage)
                            .tag(destination)
                            .accessibilityIdentifier("navigation-\(destination.rawValue)")
                    }
                    .navigationTitle("Kingdom")
                    .navigationSplitViewColumnWidth(min: 190, ideal: 220)
                } detail: {
                    destinationView(selection)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            #else
                TabView(selection: $selection) {
                    ForEach(AppDestination.primaryTabs) { destination in
                        destinationView(destination)
                            .tabItem {
                                Label(destination.title, systemImage: destination.systemImage)
                            }
                            .tag(destination)
                    }
                }
                .toolbarBackground(AppTheme.surface, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
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

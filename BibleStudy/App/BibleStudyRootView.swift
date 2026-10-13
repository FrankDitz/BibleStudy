import SwiftUI

struct BibleStudyRootView: View {
    let dependencies: AppDependencies

    @State private var selection: AppDestination = .home
    @State private var scriptureNavigation = ScriptureNavigationController()
    @State private var catalogApproval = YouVersionCatalogApproval()
    @State private var didApplyLaunchRoute = false
    @State private var activePlanNavigationRequest = 0

    var body: some View {
        Group {
            #if os(macOS)
                NavigationSplitView {
                    List(AppDestination.allCases, selection: $selection) { destination in
                        Label(destination.title, systemImage: destination.systemImage)
                            .tag(destination)
                    }
                    .navigationTitle("Bible Study")
                    .navigationSplitViewColumnWidth(min: 190, ideal: 220)
                } detail: {
                    destinationView(selection)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            #else
                TabView(selection: $selection) {
                    ForEach(AppDestination.allCases) { destination in
                        destinationView(destination)
                            .tabItem {
                                Label(destination.title, systemImage: destination.systemImage)
                            }
                            .tag(destination)
                    }
                }
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
                openLearning: { selection = .learning }
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

    private func openActivePlan() {
        activePlanNavigationRequest += 1
        selection = .plans
    }

    private func handle(_ route: BibleStudyRoute) {
        switch route {
        case .destination(let destination):
            selection = destination
        case .scripture(let reference):
            openScripture(reference)
        }
    }
}

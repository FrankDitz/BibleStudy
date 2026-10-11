import SwiftUI

struct BibleStudyRootView: View {
    let configuration: AppConfiguration

    @State private var selection: AppDestination = .home
    @State private var scriptureNavigation = ScriptureNavigationController()

    var body: some View {
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

    @ViewBuilder
    private func destinationView(_ destination: AppDestination) -> some View {
        switch destination {
        case .home:
            HomeView {
                openScripture(YouVersionCatalogPolicy.developmentStart)
            }
        case .bible:
            BibleTabView(
                isPlatformConfigured: configuration.isYouVersionConfigured,
                navigation: scriptureNavigation
            )
        case .plans:
            PlansView { reference in
                openScripture(reference)
            }
        case .learning:
            LearningView()
        case .you:
            ProfileView(isYouVersionConfigured: configuration.isYouVersionConfigured)
        }
    }

    private func openScripture(_ reference: ScriptureReference) {
        scriptureNavigation.open(reference)
        selection = .bible
    }
}

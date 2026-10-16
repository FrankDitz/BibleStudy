import SwiftData
import SwiftUI

@main
struct BibleStudyApp: App {
    private let dependencies: AppDependencies
    private let modelContainer: ModelContainer

    init() {
        let arguments = ProcessInfo.processInfo.arguments
        let configuration =
            arguments.contains("-ui-testing-unconfigured-provider")
            ? AppConfiguration(infoDictionary: [:])
            : AppConfiguration.current
        dependencies = .production(
            configuration: configuration,
            launchContext: Self.testingLaunchContext(from: arguments)
        )
        do {
            modelContainer = try BibleStudyModelContainer.make(
                inMemory: arguments.contains("-ui-testing")
            )
        } catch {
            fatalError("Unable to create the Bible Study data store: \(error)")
        }
        YouVersionBootstrap.configureIfAvailable(using: configuration)
    }

    private static func testingLaunchContext(from arguments: [String]) -> BibleStudyLaunchContext {
        guard
            arguments.contains("-ui-testing"),
            let flagIndex = arguments.firstIndex(of: "-ui-testing-destination"),
            arguments.indices.contains(flagIndex + 1),
            let destination = AppDestination(rawValue: arguments[flagIndex + 1])
        else {
            return .standalone
        }

        return .hub(
            BibleStudyHubLaunchRequest(
                profile: nil,
                initialRoute: .destination(destination)
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            BibleStudyRootView(dependencies: dependencies)
                .modelContainer(modelContainer)
        }

        #if os(macOS)
            .defaultSize(width: 1_080, height: 760)
        #endif
    }
}

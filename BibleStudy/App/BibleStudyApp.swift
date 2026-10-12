import SwiftData
import SwiftUI

@main
struct BibleStudyApp: App {
    private let dependencies: AppDependencies
    private let modelContainer: ModelContainer

    init() {
        let configuration = AppConfiguration.current
        dependencies = .production(configuration: configuration)
        do {
            modelContainer = try BibleStudyModelContainer.make(
                inMemory: ProcessInfo.processInfo.arguments.contains("-ui-testing")
            )
        } catch {
            fatalError("Unable to create the Bible Study data store: \(error)")
        }
        YouVersionBootstrap.configureIfAvailable(using: configuration)
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

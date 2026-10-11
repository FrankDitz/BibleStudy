import SwiftUI
import SwiftData

@main
struct BibleStudyApp: App {
    private let configuration: AppConfiguration
    private let modelContainer: ModelContainer

    init() {
        let configuration = AppConfiguration.current
        self.configuration = configuration
        do {
            modelContainer = try BibleStudyModelContainer.make()
        } catch {
            fatalError("Unable to create the Bible Study data store: \(error)")
        }
        YouVersionBootstrap.configureIfAvailable(using: configuration)
    }

    var body: some Scene {
        WindowGroup {
            BibleStudyRootView(configuration: configuration)
                .modelContainer(modelContainer)
        }

        #if os(macOS)
        .defaultSize(width: 1_080, height: 760)
        #endif
    }
}

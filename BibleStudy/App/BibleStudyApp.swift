import SwiftUI

@main
struct BibleStudyApp: App {
    private let configuration: AppConfiguration

    init() {
        let configuration = AppConfiguration.current
        self.configuration = configuration
        YouVersionBootstrap.configureIfAvailable(using: configuration)
    }

    var body: some Scene {
        WindowGroup {
            BibleStudyRootView(configuration: configuration)
        }

        #if os(macOS)
        .defaultSize(width: 1_080, height: 760)
        #endif
    }
}

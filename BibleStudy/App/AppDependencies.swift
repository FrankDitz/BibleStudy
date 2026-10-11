import Foundation

struct AppFeatureFlags: Equatable, Sendable {
    let providerDiagnostics: Bool
    let cloudSync: Bool
    let audioPlayback: Bool

    static func production(configuration: AppConfiguration) -> Self {
        Self(
            providerDiagnostics: configuration.isYouVersionConfigured,
            cloudSync: false,
            audioPlayback: false
        )
    }
}

struct AppDependencies: Sendable {
    let configuration: AppConfiguration
    let scriptureProvider: any ScriptureProvider
    let featureFlags: AppFeatureFlags
    let launchContext: BibleStudyLaunchContext

    static func production(
        configuration: AppConfiguration,
        launchContext: BibleStudyLaunchContext = .standalone
    ) -> Self {
        Self(
            configuration: configuration,
            scriptureProvider: YouVersionScriptureAdapter(),
            featureFlags: .production(configuration: configuration),
            launchContext: launchContext
        )
    }
}

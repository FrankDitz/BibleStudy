import YouVersionPlatform

enum YouVersionBootstrap {
    @MainActor
    static func configureIfAvailable(using configuration: AppConfiguration) {
        guard let appKey = configuration.youVersionAppKey else { return }

        YouVersionPlatformConfiguration.configure(
            appKey: appKey,
            appName: "Bible Study",
            isSignInEnabled: false,
            permittedLanguageTags: YouVersionCatalogPolicy.permittedLanguageTags,
            permittedVersionIds: YouVersionCatalogPolicy.permittedVersionIDs
        )
    }
}

import YouVersionPlatform

enum YouVersionBootstrap {
    @MainActor
    static func configureIfAvailable(
        using configuration: AppConfiguration,
        permittedVersionIDs: Set<Int> = YouVersionCatalogPolicy.permittedVersionIDs
    ) {
        guard let appKey = configuration.youVersionAppKey else { return }

        YouVersionPlatformConfiguration.configure(
            appKey: appKey,
            appName: "Bible Study",
            isSignInEnabled: false,
            permittedLanguageTags: YouVersionCatalogPolicy.permittedLanguageTags,
            permittedVersionIds: permittedVersionIDs
        )
    }
}

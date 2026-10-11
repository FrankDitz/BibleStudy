import Foundation
import YouVersionPlatform

struct YouVersionScriptureAdapter: ScriptureProvider {
    typealias VersionLoader = @Sendable () async throws -> [BibleVersion]

    let identifier = ScriptureProviderIdentifier.youVersion

    private let permittedVersionIDs: Set<Int>
    private let loadVersions: VersionLoader

    init(
        permittedVersionIDs: Set<Int> = YouVersionCatalogPolicy.permittedVersionIDs,
        languageTag: String = "en"
    ) {
        self.permittedVersionIDs = permittedVersionIDs
        loadVersions = {
            try await YouVersionAPI.Bible.versions(forLanguageTag: languageTag)
        }
    }

    init(
        permittedVersionIDs: Set<Int>,
        loadVersions: @escaping VersionLoader
    ) {
        self.permittedVersionIDs = permittedVersionIDs
        self.loadVersions = loadVersions
    }

    func editions() async throws -> [ScriptureEdition] {
        try await loadVersions()
            .filter { permittedVersionIDs.contains($0.id) }
            .map(Self.map)
            .sorted { left, right in
                let leftIndex = YouVersionCatalogPolicy.preferredVersionIDs.firstIndex {
                    String($0) == left.id.value
                } ?? .max
                let rightIndex = YouVersionCatalogPolicy.preferredVersionIDs.firstIndex {
                    String($0) == right.id.value
                } ?? .max
                return leftIndex < rightIndex
            }
    }

    static func map(_ version: BibleVersion) -> ScriptureEdition {
        let attribution = version.copyright ?? version.promotionalContent
        return ScriptureEdition(
            id: .init(provider: .youVersion, value: String(version.id)),
            title: version.localizedTitle ?? version.title ?? "Bible \(version.id)",
            abbreviation: version.localizedAbbreviation
                ?? version.abbreviation
                ?? String(version.id),
            languageTag: version.languageTag ?? "und",
            providerBookIDs: Set(version.bookIds.map { $0.uppercased() }),
            attribution: attribution,
            rights: ScriptureRights(
                status: .pendingLiveAudit,
                capabilities: [.catalog, .chapterReading, .providerManagedCache],
                requiresAttribution: true,
                offlineStorage: .providerManaged,
                maximumCacheAge: nil,
                confirmationDate: nil
            )
        )
    }
}

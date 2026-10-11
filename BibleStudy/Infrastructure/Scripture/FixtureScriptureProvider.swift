import Foundation

struct FixtureScriptureProvider: ScriptureProvider {
    let identifier = ScriptureProviderIdentifier.fixture
    let suppliedEditions: [ScriptureEdition]

    init(editions: [ScriptureEdition] = [.fixtureCatholicEdition]) {
        suppliedEditions = editions
    }

    func editions() async throws -> [ScriptureEdition] {
        suppliedEditions
    }
}

extension ScriptureEdition {
    static let fixtureCatholicEdition = ScriptureEdition(
        id: .init(provider: .fixture, value: "catholic-complete"),
        title: "Catholic Fixture Bible",
        abbreviation: "CFB",
        languageTag: "en",
        providerBookIDs: Set(CatholicCanon.books.map(\.osisID)),
        attribution: "Fixture content — not Scripture",
        rights: ScriptureRights(
            status: .fixtureOnly,
            capabilities: [.catalog, .chapterReading, .search, .persistentOfflineStorage],
            requiresAttribution: true,
            offlineStorage: .appManaged,
            maximumCacheAge: nil,
            confirmationDate: nil
        )
    )
}

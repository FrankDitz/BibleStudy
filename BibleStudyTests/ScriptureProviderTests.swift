import XCTest
import YouVersionPlatform
@testable import BibleStudy

final class ScriptureProviderTests: XCTestCase {
    func testFixtureProviderReturnsDeterministicNonProductionEdition() async throws {
        let provider = FixtureScriptureProvider()
        let editions = try await provider.editions()

        XCTAssertEqual(provider.identifier, .fixture)
        XCTAssertEqual(editions, [.fixtureCatholicEdition])
        XCTAssertFalse(editions[0].isEligibleForProduction)
        XCTAssertTrue(editions[0].rights.allows(.persistentOfflineStorage))
    }

    func testYouVersionAdapterFiltersAndMapsWithoutExposingVendorModel() async throws {
        let adapter = YouVersionScriptureAdapter(
            permittedVersionIDs: [BibleVersion.preview.id],
            loadVersions: { [.preview] }
        )

        let editions = try await adapter.editions()

        XCTAssertEqual(editions.count, 1)
        XCTAssertEqual(editions[0].id.provider, .youVersion)
        XCTAssertEqual(editions[0].id.value, String(BibleVersion.preview.id))
        XCTAssertEqual(editions[0].title, BibleVersion.preview.localizedTitle)
        XCTAssertEqual(editions[0].rights.status, .pendingLiveAudit)
        XCTAssertFalse(editions[0].isEligibleForProduction)
    }

    func testRightsRequireApprovalAndAttributionForProduction() {
        let rights = ScriptureRights(
            status: .approved,
            capabilities: [.catalog, .chapterReading],
            requiresAttribution: true,
            offlineStorage: .unavailable,
            maximumCacheAge: nil,
            confirmationDate: Date(timeIntervalSince1970: 1)
        )
        let edition = ScriptureEdition(
            id: .init(provider: .fixture, value: "approved"),
            title: "Approved fixture",
            abbreviation: "AF",
            languageTag: "en",
            providerBookIDs: [],
            attribution: "Required notice",
            rights: rights
        )

        XCTAssertTrue(edition.isEligibleForProduction)
    }

    func testMissingRequiredAttributionFailsClosed() {
        let rights = ScriptureRights(
            status: .approved,
            capabilities: [.chapterReading],
            requiresAttribution: true,
            offlineStorage: .unavailable,
            maximumCacheAge: nil,
            confirmationDate: nil
        )
        let edition = ScriptureEdition(
            id: .init(provider: .fixture, value: "missing-attribution"),
            title: "Missing attribution",
            abbreviation: "MA",
            languageTag: "en",
            providerBookIDs: [],
            attribution: " ",
            rights: rights
        )

        XCTAssertFalse(edition.isEligibleForProduction)
    }
}

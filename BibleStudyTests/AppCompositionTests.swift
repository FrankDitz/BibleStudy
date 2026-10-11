import XCTest

@testable import BibleStudy

final class AppCompositionTests: XCTestCase {
    func testConfigurationRejectsPlaceholdersAndAcceptsTrimmedKey() {
        XCTAssertNil(
            AppConfiguration(infoDictionary: ["YVPAppKey": "replace-with-key"])
                .youVersionAppKey
        )
        XCTAssertNil(
            AppConfiguration(infoDictionary: ["YVPAppKey": "$(YVP_APP_KEY)"])
                .youVersionAppKey
        )
        XCTAssertEqual(
            AppConfiguration(infoDictionary: ["YVPAppKey": "  local-key  "])
                .youVersionAppKey,
            "local-key"
        )
    }

    func testDestinationDeepLinkParses() throws {
        let url = try XCTUnwrap(URL(string: "biblestudy://destination/plans"))
        XCTAssertEqual(BibleStudyDeepLink.parse(url), .destination(.plans))
    }

    func testScriptureDeepLinkRoundTrips() throws {
        let reference = try ScriptureReference(
            versionID: 55,
            bookID: "JOHN",
            chapter: 3,
            verseStart: 16,
            verseEnd: 18
        )
        let route = BibleStudyRoute.scripture(reference)
        let url = try XCTUnwrap(BibleStudyDeepLink.url(for: route))

        XCTAssertEqual(BibleStudyDeepLink.parse(url), route)
    }

    func testDeepLinkRejectsUnknownSchemeAndInvalidReference() throws {
        XCTAssertNil(BibleStudyDeepLink.parse(try XCTUnwrap(URL(string: "https://destination/plans"))))
        XCTAssertNil(
            BibleStudyDeepLink.parse(
                try XCTUnwrap(URL(string: "biblestudy://scripture/JHN/0?version=55"))
            )
        )
    }

    func testHubAdapterKeepsProfileAndCreatesProviderNeutralHandoff() throws {
        let profile = BibleStudyProfileContext(
            profileID: UUID(),
            preferredName: "Owner",
            localeIdentifier: "en_US",
            timeZoneIdentifier: "America/New_York",
            jurisdiction: CatholicJurisdiction(
                countryCode: "US",
                subdivisionCode: "PA",
                dioceseName: nil
            )
        )
        let canonicalReference = try CanonicalScriptureReference(
            bookID: "MATT",
            chapter: 5,
            verseStart: 3,
            verseEnd: 12
        )

        let request = try BibleStudyLaunchAdapter.hubRequest(
            profile: profile,
            reference: canonicalReference,
            preferredVersionID: 55
        )

        XCTAssertEqual(request.profile, profile)
        XCTAssertEqual(
            request.initialRoute,
            .scripture(
                try ScriptureReference(
                    versionID: 55,
                    bookID: "MATT",
                    chapter: 5,
                    verseStart: 3,
                    verseEnd: 12
                )
            )
        )
    }

    func testProductionFlagsKeepUnfinishedCapabilitiesOff() {
        let configuration = AppConfiguration(infoDictionary: [:])
        let flags = AppFeatureFlags.production(configuration: configuration)

        XCTAssertFalse(flags.providerDiagnostics)
        XCTAssertFalse(flags.cloudSync)
        XCTAssertFalse(flags.audioPlayback)
    }
}

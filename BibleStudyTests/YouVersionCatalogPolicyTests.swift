import XCTest

@testable import BibleStudy

final class YouVersionCatalogPolicyTests: XCTestCase {
    func testPreferredCatalogOrderPrioritizesCatholicTranslations() {
        XCTAssertEqual(
            YouVersionCatalogPolicy.preferredVersionIDs,
            [463, 2015, 55, 42]
        )
    }

    func testDevelopmentDefaultIsPermitted() {
        XCTAssertTrue(
            YouVersionCatalogPolicy.permittedVersionIDs.contains(
                YouVersionCatalogPolicy.developmentDefaultVersionID
            )
        )
    }

    func testPreferredApprovedVersionUsesCatalogPriority() {
        XCTAssertEqual(
            YouVersionCatalogPolicy.preferredApprovedVersionID(in: [42, 55]),
            55
        )
        XCTAssertNil(YouVersionCatalogPolicy.preferredApprovedVersionID(in: []))
    }

    func testCPDVHasAStableFallbackNoticeWhenProviderCopyrightIsEmpty() {
        XCTAssertEqual(
            YouVersionCatalogPolicy.attribution(for: 42, providerAttribution: nil),
            "Catholic Public Domain Version · Scripture supplied by YouVersion"
        )
        XCTAssertEqual(
            YouVersionCatalogPolicy.attribution(
                for: 463,
                providerAttribution: "  Publisher notice  "
            ),
            "Publisher notice"
        )
        XCTAssertNil(YouVersionCatalogPolicy.attribution(for: 463, providerAttribution: nil))
    }
}

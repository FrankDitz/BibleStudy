import XCTest
@testable import BibleStudy

final class YouVersionCatalogPolicyTests: XCTestCase {
    func testPreferredCatalogOrderPrioritizesCatholicTranslations() {
        XCTAssertEqual(
            YouVersionCatalogPolicy.preferredVersionIDs,
            [463, 2015, 55]
        )
    }

    func testDevelopmentDefaultIsPermitted() {
        XCTAssertTrue(
            YouVersionCatalogPolicy.permittedVersionIDs.contains(
                YouVersionCatalogPolicy.developmentDefaultVersionID
            )
        )
    }
}

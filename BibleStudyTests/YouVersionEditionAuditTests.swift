import XCTest

@testable import BibleStudy

final class YouVersionEditionAuditTests: XCTestCase {
    func testMappingCoversEveryCatholicBookAcrossSeventyFourProviderResources() {
        XCTAssertEqual(YouVersionCatholicBookMapping.providerIDsByCanonicalID.count, 73)
        XCTAssertEqual(YouVersionCatholicBookMapping.expectedProviderBookIDs.count, 74)
        XCTAssertEqual(
            Set(YouVersionCatholicBookMapping.providerIDsByCanonicalID.keys),
            Set(CatholicCanon.books.map(\.osisID))
        )
        XCTAssertEqual(
            YouVersionCatholicBookMapping.providerIDsByCanonicalID["ESTH"],
            ["EST", "ESG"]
        )
    }

    func testCompleteEditionPassesStructuralAudit() {
        let snapshot = YouVersionEditionSnapshot(
            versionID: 463,
            title: "New American Bible, revised edition",
            abbreviation: "NABRE",
            attribution: "Required attribution",
            providerBookIDs: YouVersionCatholicBookMapping.expectedProviderBookIDs,
            chapterIDsByBook: ["DAN": ["1", "2", "3", "13", "14"]]
        )

        let report = YouVersionEditionAuditor.audit(snapshot)

        XCTAssertTrue(report.isApprovedStructure)
        XCTAssertTrue(report.missingCanonicalBookIDs.isEmpty)
        XCTAssertEqual(report.providerBookCount, 74)
    }

    func testSixtySixBookEditionFailsWithCatholicBooksMissing() {
        let catholicOnlyProviderIDs: Set<String> = [
            "TOB", "JDT", "ESG", "1MA", "2MA", "WIS", "SIR", "BAR",
        ]
        let protestantProviderIDs = YouVersionCatholicBookMapping.expectedProviderBookIDs
            .subtracting(catholicOnlyProviderIDs)
        let snapshot = YouVersionEditionSnapshot(
            versionID: 1,
            title: "Incomplete fixture",
            abbreviation: "FIX",
            attribution: "Fixture attribution",
            providerBookIDs: protestantProviderIDs,
            chapterIDsByBook: ["DAN": Set((1...12).map(String.init))]
        )

        let report = YouVersionEditionAuditor.audit(snapshot)

        XCTAssertFalse(report.isApprovedStructure)
        XCTAssertTrue(report.missingCanonicalBookIDs.contains("TOB"))
        XCTAssertFalse(report.hasEstherAdditions)
        XCTAssertFalse(report.hasDanielAdditions)
    }

    func testMissingAttributionFailsClosed() {
        let snapshot = YouVersionEditionSnapshot(
            versionID: 55,
            title: "Douay-Rheims",
            abbreviation: "DRC1752",
            attribution: "   ",
            providerBookIDs: YouVersionCatholicBookMapping.expectedProviderBookIDs,
            chapterIDsByBook: ["DAN": ["13", "14"]]
        )

        XCTAssertFalse(YouVersionEditionAuditor.audit(snapshot).isApprovedStructure)
    }
}

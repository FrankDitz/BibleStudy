import XCTest

@testable import BibleStudy

final class YouVersionEditionAuditTests: XCTestCase {
    func testCatalogGateApprovesOnlyStructurallyApprovedEditions() {
        let approved = YouVersionEditionAuditReport(
            versionID: 55,
            title: "Approved",
            abbreviation: "OK",
            providerBookCount: 74,
            missingProviderBookIDs: [],
            missingCanonicalBookIDs: [],
            hasEstherAdditions: true,
            hasDanielAdditions: true,
            hasAttribution: true
        )
        let rejected = YouVersionEditionAuditReport(
            versionID: 463,
            title: "Incomplete",
            abbreviation: "NO",
            providerBookCount: 66,
            missingProviderBookIDs: ["TOB"],
            missingCanonicalBookIDs: ["TOB"],
            hasEstherAdditions: false,
            hasDanielAdditions: false,
            hasAttribution: true
        )
        let result = YouVersionCapabilityProbe.Result(
            reports: [approved, rejected],
            failures: []
        )

        XCTAssertEqual(
            YouVersionCatalogGateDecision.evaluate(result),
            .approved([55])
        )
    }

    func testCatalogGateRejectsReachableCatalogWithoutApprovedEdition() {
        let report = YouVersionEditionAuditReport(
            versionID: 55,
            title: "Incomplete",
            abbreviation: "NO",
            providerBookCount: 66,
            missingProviderBookIDs: ["ESG"],
            missingCanonicalBookIDs: [],
            hasEstherAdditions: false,
            hasDanielAdditions: true,
            hasAttribution: true
        )

        XCTAssertEqual(
            YouVersionCatalogGateDecision.evaluate(
                .init(reports: [report], failures: [])
            ),
            .rejected
        )
    }

    func testCatalogGateTreatsTotalProbeFailureAsUnavailable() {
        XCTAssertEqual(
            YouVersionCatalogGateDecision.evaluate(
                .init(
                    reports: [],
                    failures: [.init(versionID: 55, message: "Offline")]
                )
            ),
            .unavailable
        )
    }

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

    func testIntegratedEstherAdditionsPassWithoutSeparateESGResource() {
        let providerBookIDs = YouVersionCatholicBookMapping.expectedProviderBookIDs
            .subtracting(["ESG"])
        let snapshot = YouVersionEditionSnapshot(
            versionID: 42,
            title: "Catholic Public Domain Version",
            abbreviation: "CPDV",
            attribution: "Catholic Public Domain Version · Scripture supplied by YouVersion",
            providerBookIDs: providerBookIDs,
            chapterIDsByBook: [
                "EST": Set((1...15).map(String.init)),
                "DAN": Set((1...14).map(String.init)),
            ]
        )

        let report = YouVersionEditionAuditor.audit(snapshot)

        XCTAssertTrue(report.isApprovedStructure)
        XCTAssertTrue(report.hasEstherAdditions)
        XCTAssertFalse(report.missingProviderBookIDs.contains("ESG"))
        XCTAssertEqual(report.providerBookCount, 73)
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

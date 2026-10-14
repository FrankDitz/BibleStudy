import XCTest

@testable import BibleStudy

@MainActor
final class YouVersionBibleReaderViewTests: XCTestCase {
    func testApprovedReferencePreservesLicensedEdition() throws {
        let reference = try ScriptureReference(
            versionID: 42,
            bookID: "JOHN",
            chapter: 3,
            verseStart: 16
        )

        XCTAssertEqual(
            YouVersionBibleReaderView.approvedReference(
                reference,
                approvedVersionIDs: [42]
            ),
            reference
        )
    }

    func testApprovedReferenceReplacesUnlicensedEditionWithoutChangingPassage() throws {
        let reference = try ScriptureReference(
            versionID: 3034,
            bookID: "JOHN",
            chapter: 3,
            verseStart: 16
        )

        let approved = try XCTUnwrap(
            YouVersionBibleReaderView.approvedReference(
                reference,
                approvedVersionIDs: [42]
            )
        )

        XCTAssertEqual(approved.versionID, 42)
        XCTAssertEqual(approved.bookID, "JOHN")
        XCTAssertEqual(approved.chapter, 3)
        XCTAssertEqual(approved.verseStart, 16)
        XCTAssertEqual(approved.verseEnd, 16)
    }

    func testApprovedReferencePreservesCompletePassageRange() throws {
        let reference = try ScriptureReference(
            versionID: 3034,
            bookID: "MATT",
            chapter: 5,
            verseStart: 1,
            verseEnd: 12
        )

        let approved = try XCTUnwrap(
            YouVersionBibleReaderView.approvedReference(
                reference,
                approvedVersionIDs: [42]
            )
        )

        XCTAssertEqual(approved.versionID, 42)
        XCTAssertEqual(approved.verseStart, 1)
        XCTAssertEqual(approved.verseEnd, 12)
    }

    func testApprovedReferenceFailsClosedWithoutApprovedEdition() {
        XCTAssertNil(
            YouVersionBibleReaderView.approvedReference(
                YouVersionCatalogPolicy.developmentStart,
                approvedVersionIDs: []
            )
        )
    }
}

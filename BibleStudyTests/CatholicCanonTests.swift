import XCTest
@testable import BibleStudy

final class CatholicCanonTests: XCTestCase {
    func testCanonContainsFortySixOldAndTwentySevenNewTestamentBooks() {
        XCTAssertEqual(CatholicCanon.books.count, 73)
        XCTAssertEqual(CatholicCanon.books.filter { $0.testament == .old }.count, 46)
        XCTAssertEqual(CatholicCanon.books.filter { $0.testament == .new }.count, 27)
    }

    func testOrderAndIdentifiersAreUniqueAndContiguous() {
        XCTAssertEqual(CatholicCanon.books.map(\.order), Array(1...73))
        XCTAssertEqual(Set(CatholicCanon.books.map(\.osisID)).count, 73)
        XCTAssertEqual(CatholicCanon.books.first?.osisID, "GEN")
        XCTAssertEqual(CatholicCanon.books.last?.osisID, "REV")
    }

    func testDeuterocanonicalBooksAreExplicit() {
        let flagged = Set(
            CatholicCanon.books
                .filter(\.isDeuterocanonical)
                .map(\.osisID)
        )

        XCTAssertEqual(flagged, CatholicCanon.deuterocanonicalBookIDs)
        XCTAssertEqual(flagged, ["TOB", "JDT", "1MACC", "2MACC", "WIS", "SIR", "BAR"])
    }

    func testCanonicalReferenceRejectsNonCatholicOrProviderSpecificBookIDs() throws {
        XCTAssertThrowsError(
            try CanonicalScriptureReference(bookID: "MAT", chapter: 1)
        )
        XCTAssertThrowsError(
            try CanonicalScriptureReference(bookID: "3MACC", chapter: 1)
        )
        XCTAssertEqual(
            try CanonicalScriptureReference(bookID: " Matt ", chapter: 1).osis,
            "MATT.1"
        )
    }

    func testEstherAndDanielRequireContentLevelCatholicVerification() {
        XCTAssertTrue(CatholicCanon.contains(osisID: "ESTH"))
        XCTAssertTrue(CatholicCanon.contains(osisID: "DAN"))
        XCTAssertFalse(CatholicCanon.deuterocanonicalBookIDs.contains("ESTH"))
        XCTAssertFalse(CatholicCanon.deuterocanonicalBookIDs.contains("DAN"))
    }
}

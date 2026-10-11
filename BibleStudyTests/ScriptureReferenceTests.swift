import XCTest
@testable import BibleStudy

final class ScriptureReferenceTests: XCTestCase {
    func testNormalizesBookAndSingleVerse() throws {
        let reference = try ScriptureReference(
            versionID: 55,
            bookID: " jhn ",
            chapter: 3,
            verseStart: 16
        )

        XCTAssertEqual(reference.bookID, "JHN")
        XCTAssertEqual(reference.passageID, "JHN.3.16")
        XCTAssertEqual(reference.verseEnd, 16)
    }

    func testRangePassageIdentifier() throws {
        let reference = try ScriptureReference(
            versionID: 55,
            bookID: "PSA",
            chapter: 23,
            verseStart: 1,
            verseEnd: 4
        )

        XCTAssertEqual(reference.id, "55:PSA.23.1-4")
    }

    func testRejectsEndVerseWithoutStartVerse() {
        XCTAssertThrowsError(
            try ScriptureReference(
                versionID: 55,
                bookID: "MAT",
                chapter: 1,
                verseEnd: 3
            )
        )
    }
}

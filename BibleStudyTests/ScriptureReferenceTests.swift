import XCTest

@testable import BibleStudy

final class ScriptureReferenceTests: XCTestCase {
    func testNormalizesBookAndSingleVerse() throws {
        let reference = try ScriptureReference(
            versionID: 55,
            bookID: " john ",
            chapter: 3,
            verseStart: 16
        )

        XCTAssertEqual(reference.bookID, "JOHN")
        XCTAssertEqual(reference.passageID, "JOHN.3.16")
        XCTAssertEqual(reference.verseEnd, 16)
    }

    func testRangePassageIdentifier() throws {
        let reference = try ScriptureReference(
            versionID: 55,
            bookID: "PS",
            chapter: 23,
            verseStart: 1,
            verseEnd: 4
        )

        XCTAssertEqual(reference.id, "55:PS.23.1-4")
    }

    func testRejectsEndVerseWithoutStartVerse() {
        XCTAssertThrowsError(
            try ScriptureReference(
                versionID: 55,
                bookID: "MATT",
                chapter: 1,
                verseEnd: 3
            )
        )
    }
}

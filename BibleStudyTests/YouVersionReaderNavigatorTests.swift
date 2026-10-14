import XCTest

@testable import BibleStudy

final class YouVersionReaderNavigatorTests: XCTestCase {
    private let edition = YouVersionReaderEdition(
        id: 42,
        title: "Catholic Public Domain Version",
        abbreviation: "CPDV",
        books: [
            YouVersionReaderBook(
                providerID: "REV",
                canonicalID: "REV",
                title: "Revelation",
                chapters: [21, 22]
            ),
            YouVersionReaderBook(
                providerID: "GEN",
                canonicalID: "GEN",
                title: "Genesis",
                chapters: [1, 2]
            ),
            YouVersionReaderBook(
                providerID: "TOB",
                canonicalID: "TOB",
                title: "Tobit",
                chapters: [1, 2, 3]
            ),
        ]
    )

    func testNextMovesAcrossBookBoundaryInCatholicCanonOrder() {
        let genesisTwo = YouVersionReaderLocation(
            versionID: 42,
            providerBookID: "GEN",
            canonicalBookID: "GEN",
            chapter: 2,
            verse: 12
        )

        XCTAssertEqual(
            YouVersionReaderNavigator.adjacentLocation(
                to: genesisTwo,
                direction: 1,
                in: edition
            ),
            YouVersionReaderLocation(
                versionID: 42,
                providerBookID: "TOB",
                canonicalBookID: "TOB",
                chapter: 1,
                verse: nil
            )
        )
    }

    func testPreviousMovesToLastChapterOfPreviousBook() {
        let revelationTwentyOne = YouVersionReaderLocation(
            versionID: 42,
            providerBookID: "REV",
            canonicalBookID: "REV",
            chapter: 21,
            verse: nil
        )

        XCTAssertEqual(
            YouVersionReaderNavigator.adjacentLocation(
                to: revelationTwentyOne,
                direction: -1,
                in: edition
            )?.providerReference,
            YouVersionReaderLocation(
                versionID: 42,
                providerBookID: "TOB",
                canonicalBookID: "TOB",
                chapter: 3,
                verse: nil
            ).providerReference
        )
    }

    func testCanonEndpointsDoNotWrap() {
        let first = edition.firstLocation!
        let last = YouVersionReaderLocation(
            versionID: 42,
            providerBookID: "REV",
            canonicalBookID: "REV",
            chapter: 22,
            verse: nil
        )

        XCTAssertNil(
            YouVersionReaderNavigator.adjacentLocation(
                to: first,
                direction: -1,
                in: edition
            )
        )
        XCTAssertNil(
            YouVersionReaderNavigator.adjacentLocation(
                to: last,
                direction: 1,
                in: edition
            )
        )
    }

    func testLocationMatchesOnlyValidBookAndChapter() throws {
        let valid = try ScriptureReference(versionID: 42, bookID: "TOB", chapter: 2)
        let invalidChapter = try ScriptureReference(versionID: 42, bookID: "TOB", chapter: 4)

        XCTAssertNotNil(
            edition.location(matching: valid)
        )
        XCTAssertNil(
            edition.location(matching: invalidChapter)
        )
    }

    func testLocationPreservesACompletePassageRange() throws {
        let passage = try ScriptureReference(
            versionID: 42,
            bookID: "TOB",
            chapter: 2,
            verseStart: 1,
            verseEnd: 8
        )

        let location = try XCTUnwrap(edition.location(matching: passage))

        XCTAssertEqual(location.verse, 1)
        XCTAssertEqual(location.verseEnd, 8)
        XCTAssertEqual(location.canonicalReference, passage)
        XCTAssertEqual(location.providerReference.verseStart, 1)
        XCTAssertEqual(location.providerReference.verseEnd, 8)
    }
}

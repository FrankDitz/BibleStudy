import Foundation

struct CanonicalChapter: Codable, Hashable, Sendable {
    let bookID: String
    let chapter: Int
}

struct CatholicChapterManifest: Hashable, Sendable {
    let id: String
    let revision: Int
    let compatibleVersionIDs: Set<Int>
    let chapterCountByBookID: [String: Int]

    var allChapters: [CanonicalChapter] {
        CatholicCanon.books.flatMap { book in
            chapters(in: book.osisID)
        }
    }

    func chapters(in bookID: String) -> [CanonicalChapter] {
        guard let count = chapterCountByBookID[bookID] else { return [] }
        return (1...count).map { CanonicalChapter(bookID: bookID, chapter: $0) }
    }

    func chapters(in testament: BiblicalTestament) -> [CanonicalChapter] {
        CatholicCanon.books
            .filter { $0.testament == testament }
            .flatMap { chapters(in: $0.osisID) }
    }

    func chapters(inBookIDs bookIDs: Set<String>) -> [CanonicalChapter] {
        CatholicCanon.books
            .filter { bookIDs.contains($0.osisID) }
            .flatMap { chapters(in: $0.osisID) }
    }

    func contains(_ chapter: CanonicalChapter) -> Bool {
        guard let chapterCount = chapterCountByBookID[chapter.bookID] else { return false }
        return (1...chapterCount).contains(chapter.chapter)
    }

    /// Snapshot of the licensed CPDV chapter layout returned by YouVersion version 42.
    /// Esther's additions are integrated as chapters 11–15 and Daniel's as 13–14.
    static let cpdvV1 = CatholicChapterManifest(
        id: "youversion.cpdv.42.catholic-canon",
        revision: 1,
        compatibleVersionIDs: [YouVersionCatalogPolicy.developmentDefaultVersionID],
        chapterCountByBookID: [
            "GEN": 50, "EXOD": 40, "LEV": 27, "NUM": 36, "DEUT": 34,
            "JOSH": 24, "JUDG": 21, "RUTH": 4, "1SAM": 31, "2SAM": 24,
            "1KGS": 22, "2KGS": 25, "1CHR": 29, "2CHR": 36, "EZRA": 10,
            "NEH": 13, "TOB": 14, "JDT": 16, "ESTH": 15, "1MACC": 16,
            "2MACC": 15, "JOB": 42, "PS": 150, "PROV": 31, "ECCL": 12,
            "SONG": 8, "WIS": 19, "SIR": 51, "ISA": 66, "JER": 52,
            "LAM": 5, "BAR": 6, "EZEK": 48, "DAN": 14, "HOS": 14,
            "JOEL": 3, "AMOS": 9, "OBAD": 1, "JONAH": 4, "MIC": 7,
            "NAH": 3, "HAB": 3, "ZEPH": 3, "HAG": 2, "ZECH": 14,
            "MAL": 4, "MATT": 28, "MARK": 16, "LUKE": 24, "JOHN": 21,
            "ACTS": 28, "ROM": 16, "1COR": 16, "2COR": 13, "GAL": 6,
            "EPH": 6, "PHIL": 4, "COL": 4, "1THESS": 5, "2THESS": 3,
            "1TIM": 6, "2TIM": 4, "TITUS": 3, "PHLM": 1, "HEB": 13,
            "JAS": 5, "1PET": 5, "2PET": 3, "1JOHN": 5, "2JOHN": 1,
            "3JOHN": 1, "JUDE": 1, "REV": 22,
        ]
    )
}

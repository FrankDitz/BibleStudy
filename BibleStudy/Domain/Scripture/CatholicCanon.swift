import Foundation

enum BiblicalTestament: String, Codable, CaseIterable, Sendable {
    case old
    case new
}

enum CatholicCanonSection: String, Codable, CaseIterable, Sendable {
    case pentateuch
    case historical
    case biblicalNovellas
    case wisdom
    case prophetic
    case gospels
    case acts
    case paulineLetters
    case catholicLetters
    case revelation
}

struct CatholicCanonBook: Codable, Equatable, Hashable, Identifiable, Sendable {
    let order: Int
    let osisID: String
    let displayName: String
    let testament: BiblicalTestament
    let section: CatholicCanonSection
    let isDeuterocanonical: Bool

    var id: String { osisID }
}

enum CatholicCanon {
    /// USCCB canonical order: 46 Old Testament books followed by 27 New Testament books.
    static let books: [CatholicCanonBook] = [
        book(1, "GEN", "Genesis", .old, .pentateuch),
        book(2, "EXOD", "Exodus", .old, .pentateuch),
        book(3, "LEV", "Leviticus", .old, .pentateuch),
        book(4, "NUM", "Numbers", .old, .pentateuch),
        book(5, "DEUT", "Deuteronomy", .old, .pentateuch),
        book(6, "JOSH", "Joshua", .old, .historical),
        book(7, "JUDG", "Judges", .old, .historical),
        book(8, "RUTH", "Ruth", .old, .historical),
        book(9, "1SAM", "1 Samuel", .old, .historical),
        book(10, "2SAM", "2 Samuel", .old, .historical),
        book(11, "1KGS", "1 Kings", .old, .historical),
        book(12, "2KGS", "2 Kings", .old, .historical),
        book(13, "1CHR", "1 Chronicles", .old, .historical),
        book(14, "2CHR", "2 Chronicles", .old, .historical),
        book(15, "EZRA", "Ezra", .old, .historical),
        book(16, "NEH", "Nehemiah", .old, .historical),
        book(17, "TOB", "Tobit", .old, .biblicalNovellas, deuterocanonical: true),
        book(18, "JDT", "Judith", .old, .biblicalNovellas, deuterocanonical: true),
        book(19, "ESTH", "Esther", .old, .biblicalNovellas),
        book(20, "1MACC", "1 Maccabees", .old, .biblicalNovellas, deuterocanonical: true),
        book(21, "2MACC", "2 Maccabees", .old, .biblicalNovellas, deuterocanonical: true),
        book(22, "JOB", "Job", .old, .wisdom),
        book(23, "PS", "Psalms", .old, .wisdom),
        book(24, "PROV", "Proverbs", .old, .wisdom),
        book(25, "ECCL", "Ecclesiastes", .old, .wisdom),
        book(26, "SONG", "Song of Songs", .old, .wisdom),
        book(27, "WIS", "Wisdom", .old, .wisdom, deuterocanonical: true),
        book(28, "SIR", "Sirach", .old, .wisdom, deuterocanonical: true),
        book(29, "ISA", "Isaiah", .old, .prophetic),
        book(30, "JER", "Jeremiah", .old, .prophetic),
        book(31, "LAM", "Lamentations", .old, .prophetic),
        book(32, "BAR", "Baruch", .old, .prophetic, deuterocanonical: true),
        book(33, "EZEK", "Ezekiel", .old, .prophetic),
        book(34, "DAN", "Daniel", .old, .prophetic),
        book(35, "HOS", "Hosea", .old, .prophetic),
        book(36, "JOEL", "Joel", .old, .prophetic),
        book(37, "AMOS", "Amos", .old, .prophetic),
        book(38, "OBAD", "Obadiah", .old, .prophetic),
        book(39, "JONAH", "Jonah", .old, .prophetic),
        book(40, "MIC", "Micah", .old, .prophetic),
        book(41, "NAH", "Nahum", .old, .prophetic),
        book(42, "HAB", "Habakkuk", .old, .prophetic),
        book(43, "ZEPH", "Zephaniah", .old, .prophetic),
        book(44, "HAG", "Haggai", .old, .prophetic),
        book(45, "ZECH", "Zechariah", .old, .prophetic),
        book(46, "MAL", "Malachi", .old, .prophetic),
        book(47, "MATT", "Matthew", .new, .gospels),
        book(48, "MARK", "Mark", .new, .gospels),
        book(49, "LUKE", "Luke", .new, .gospels),
        book(50, "JOHN", "John", .new, .gospels),
        book(51, "ACTS", "Acts of the Apostles", .new, .acts),
        book(52, "ROM", "Romans", .new, .paulineLetters),
        book(53, "1COR", "1 Corinthians", .new, .paulineLetters),
        book(54, "2COR", "2 Corinthians", .new, .paulineLetters),
        book(55, "GAL", "Galatians", .new, .paulineLetters),
        book(56, "EPH", "Ephesians", .new, .paulineLetters),
        book(57, "PHIL", "Philippians", .new, .paulineLetters),
        book(58, "COL", "Colossians", .new, .paulineLetters),
        book(59, "1THESS", "1 Thessalonians", .new, .paulineLetters),
        book(60, "2THESS", "2 Thessalonians", .new, .paulineLetters),
        book(61, "1TIM", "1 Timothy", .new, .paulineLetters),
        book(62, "2TIM", "2 Timothy", .new, .paulineLetters),
        book(63, "TITUS", "Titus", .new, .paulineLetters),
        book(64, "PHLM", "Philemon", .new, .paulineLetters),
        book(65, "HEB", "Hebrews", .new, .paulineLetters),
        book(66, "JAS", "James", .new, .catholicLetters),
        book(67, "1PET", "1 Peter", .new, .catholicLetters),
        book(68, "2PET", "2 Peter", .new, .catholicLetters),
        book(69, "1JOHN", "1 John", .new, .catholicLetters),
        book(70, "2JOHN", "2 John", .new, .catholicLetters),
        book(71, "3JOHN", "3 John", .new, .catholicLetters),
        book(72, "JUDE", "Jude", .new, .catholicLetters),
        book(73, "REV", "Revelation", .new, .revelation),
    ]

    static let deuterocanonicalBookIDs: Set<String> = [
        "TOB", "JDT", "1MACC", "2MACC", "WIS", "SIR", "BAR",
    ]

    static func book(osisID: String) -> CatholicCanonBook? {
        booksByID[normalized(osisID)]
    }

    static func contains(osisID: String) -> Bool {
        book(osisID: osisID) != nil
    }

    private static let booksByID = Dictionary(uniqueKeysWithValues: books.map { ($0.osisID, $0) })

    private static func normalized(_ identifier: String) -> String {
        identifier.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }

    private static func book(
        _ order: Int,
        _ osisID: String,
        _ displayName: String,
        _ testament: BiblicalTestament,
        _ section: CatholicCanonSection,
        deuterocanonical: Bool = false
    ) -> CatholicCanonBook {
        CatholicCanonBook(
            order: order,
            osisID: osisID,
            displayName: displayName,
            testament: testament,
            section: section,
            isDeuterocanonical: deuterocanonical
        )
    }
}

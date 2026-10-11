import Foundation

struct ScriptureReference: Codable, Hashable, Identifiable, Sendable {
    enum ValidationError: Error, Equatable {
        case invalidVersion
        case invalidBook
        case invalidChapter
        case invalidVerseRange
    }

    let versionID: Int
    let bookID: String
    let chapter: Int
    let verseStart: Int?
    let verseEnd: Int?

    init(
        versionID: Int,
        bookID: String,
        chapter: Int,
        verseStart: Int? = nil,
        verseEnd: Int? = nil
    ) throws {
        guard versionID > 0 else { throw ValidationError.invalidVersion }

        let normalizedBook =
            bookID
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        guard CatholicCanon.contains(osisID: normalizedBook) else {
            throw ValidationError.invalidBook
        }
        guard chapter > 0 else { throw ValidationError.invalidChapter }

        if let verseStart {
            let normalizedEnd = verseEnd ?? verseStart
            guard verseStart > 0, normalizedEnd >= verseStart else {
                throw ValidationError.invalidVerseRange
            }
        } else if verseEnd != nil {
            throw ValidationError.invalidVerseRange
        }

        self.versionID = versionID
        self.bookID = normalizedBook
        self.chapter = chapter
        self.verseStart = verseStart
        self.verseEnd = verseEnd ?? verseStart
    }

    var id: String {
        "\(versionID):\(passageID)"
    }

    var passageID: String {
        guard let verseStart else {
            return "\(bookID).\(chapter)"
        }

        if let verseEnd, verseEnd != verseStart {
            return "\(bookID).\(chapter).\(verseStart)-\(verseEnd)"
        }

        return "\(bookID).\(chapter).\(verseStart)"
    }
}

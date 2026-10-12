import Foundation
import YouVersionPlatform

struct YouVersionReaderBook: Equatable, Identifiable, Sendable {
    let providerID: String
    let canonicalID: String
    let title: String
    let chapters: [Int]

    var id: String { providerID }
}

struct YouVersionReaderEdition: Equatable, Identifiable, Sendable {
    let id: Int
    let title: String
    let abbreviation: String
    let books: [YouVersionReaderBook]

    init(
        id: Int,
        title: String,
        abbreviation: String,
        books: [YouVersionReaderBook]
    ) {
        self.id = id
        self.title = title
        self.abbreviation = abbreviation
        self.books = Self.canonicallyOrdered(books)
    }

    init?(version: BibleVersion) {
        let mappedBooks = (version.books ?? []).compactMap { book -> YouVersionReaderBook? in
            guard
                let providerID = book.id?.uppercased(),
                let canonicalID = YouVersionCatholicBookMapping.canonicalID(
                    forProviderID: providerID
                )
            else {
                return nil
            }

            let chapters = (book.chapters ?? []).compactMap { chapter -> Int? in
                if let id = chapter.id, let number = Int(id) {
                    return number
                }
                if let title = chapter.title, let number = Int(title) {
                    return number
                }
                return nil
            }
            guard !chapters.isEmpty else { return nil }

            return YouVersionReaderBook(
                providerID: providerID,
                canonicalID: canonicalID,
                title: book.fullTitle ?? book.title ?? providerID,
                chapters: chapters
            )
        }
        guard !mappedBooks.isEmpty else { return nil }

        self.init(
            id: version.id,
            title: version.localizedTitle ?? version.title ?? "Bible \(version.id)",
            abbreviation:
                version.localizedAbbreviation ?? version.abbreviation ?? String(version.id),
            books: mappedBooks
        )
    }

    func location(matching reference: ScriptureReference) -> YouVersionReaderLocation? {
        guard reference.versionID == id else { return nil }
        guard
            let book = books.first(where: { $0.canonicalID == reference.bookID }),
            book.chapters.contains(reference.chapter)
        else {
            return nil
        }
        return YouVersionReaderLocation(
            versionID: id,
            providerBookID: book.providerID,
            canonicalBookID: book.canonicalID,
            chapter: reference.chapter,
            verse: reference.verseStart
        )
    }

    var firstLocation: YouVersionReaderLocation? {
        guard let book = books.first, let chapter = book.chapters.first else { return nil }
        return YouVersionReaderLocation(
            versionID: id,
            providerBookID: book.providerID,
            canonicalBookID: book.canonicalID,
            chapter: chapter,
            verse: nil
        )
    }

    private static func canonicallyOrdered(
        _ books: [YouVersionReaderBook]
    ) -> [YouVersionReaderBook] {
        let sourceIndexes = Dictionary(
            uniqueKeysWithValues: books.enumerated().map { ($0.element.providerID, $0.offset) }
        )
        return books.sorted { left, right in
            let leftOrder = CatholicCanon.book(osisID: left.canonicalID)?.order ?? .max
            let rightOrder = CatholicCanon.book(osisID: right.canonicalID)?.order ?? .max
            if leftOrder != rightOrder {
                return leftOrder < rightOrder
            }

            let primaryProviderID = YouVersionCatholicBookMapping.primaryProviderID(
                forCanonicalID: left.canonicalID
            )
            if left.providerID == primaryProviderID {
                return true
            }
            if right.providerID == primaryProviderID {
                return false
            }
            return (sourceIndexes[left.providerID] ?? .max)
                < (sourceIndexes[right.providerID] ?? .max)
        }
    }
}

struct YouVersionReaderLocation: Equatable, Identifiable, Sendable {
    let versionID: Int
    let providerBookID: String
    let canonicalBookID: String
    let chapter: Int
    let verse: Int?

    var id: String {
        "\(versionID):\(providerBookID).\(chapter).\(verse.map(String.init) ?? "all")"
    }

    var canonicalReference: ScriptureReference? {
        try? ScriptureReference(
            versionID: versionID,
            bookID: canonicalBookID,
            chapter: chapter,
            verseStart: verse
        )
    }

    var providerReference: BibleReference {
        BibleReference(
            versionId: versionID,
            bookId: providerBookID,
            chapter: chapter,
            verse: verse
        )
    }
}

enum YouVersionReaderNavigator {
    static func adjacentLocation(
        to location: YouVersionReaderLocation,
        direction: Int,
        in edition: YouVersionReaderEdition
    ) -> YouVersionReaderLocation? {
        guard direction == -1 || direction == 1 else { return nil }
        guard
            let bookIndex = edition.books.firstIndex(where: {
                $0.providerID == location.providerBookID
            }),
            let chapterIndex = edition.books[bookIndex].chapters.firstIndex(
                of: location.chapter
            )
        else {
            return nil
        }

        let book = edition.books[bookIndex]
        let nextChapterIndex = chapterIndex + direction
        if book.chapters.indices.contains(nextChapterIndex) {
            return Self.location(
                editionID: edition.id,
                book: book,
                chapter: book.chapters[nextChapterIndex]
            )
        }

        let nextBookIndex = bookIndex + direction
        guard edition.books.indices.contains(nextBookIndex) else { return nil }
        let nextBook = edition.books[nextBookIndex]
        let chapter = direction > 0 ? nextBook.chapters.first : nextBook.chapters.last
        guard let chapter else { return nil }
        return Self.location(editionID: edition.id, book: nextBook, chapter: chapter)
    }

    static func location(
        editionID: Int,
        book: YouVersionReaderBook,
        chapter: Int,
        verse: Int? = nil
    ) -> YouVersionReaderLocation {
        YouVersionReaderLocation(
            versionID: editionID,
            providerBookID: book.providerID,
            canonicalBookID: book.canonicalID,
            chapter: chapter,
            verse: verse
        )
    }
}

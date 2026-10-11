import SwiftData
import XCTest

@testable import BibleStudy

@MainActor
final class ScriptureAnnotationRepositoryTests: XCTestCase {
    func testAnnotationStateSurvivesDiskContainerReopen() throws {
        let storeDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("BibleStudyAnnotationTests", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: storeDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: storeDirectory) }

        let storeURL = storeDirectory.appendingPathComponent("BibleStudy.store")
        let reference = try makeReference()
        try writeAnnotationState(for: reference, to: storeURL)

        let reopenedContainer = try BibleStudyModelContainer.make(storeURL: storeURL)
        let reopenedRepository = ScriptureAnnotationRepository(
            modelContext: ModelContext(reopenedContainer)
        )
        let restoredState = try reopenedRepository.state(for: reference)

        XCTAssertEqual(
            restoredState,
            ScriptureAnnotationState(
                isBookmarked: true,
                highlightColor: .green,
                noteText: "Persist across launch"
            )
        )
    }

    func testBookmarkCanBeAddedRemovedAndRestoredWithoutDuplicateRows() throws {
        let (repository, context) = try makeRepository()
        let reference = try makeReference()

        XCTAssertTrue(try repository.toggleBookmark(for: reference))
        XCTAssertTrue(try repository.state(for: reference).isBookmarked)
        XCTAssertFalse(try repository.toggleBookmark(for: reference))
        XCTAssertFalse(try repository.state(for: reference).isBookmarked)
        XCTAssertTrue(try repository.toggleBookmark(for: reference))

        let stored = try context.fetch(FetchDescriptor<BibleStudySchemaV1.ScriptureAnnotation>())
        XCTAssertEqual(stored.count, 1)
        XCTAssertNil(stored.first?.deletedAt)
    }

    func testHighlightCanBeChangedAndRemoved() throws {
        let (repository, _) = try makeRepository()
        let reference = try makeReference()

        try repository.setHighlight(.gold, for: reference)
        XCTAssertEqual(try repository.state(for: reference).highlightColor, .gold)

        try repository.setHighlight(.blue, for: reference)
        XCTAssertEqual(try repository.state(for: reference).highlightColor, .blue)

        try repository.setHighlight(nil, for: reference)
        XCTAssertNil(try repository.state(for: reference).highlightColor)
    }

    func testNoteIsTrimmedUpdatedAndSoftDeletedWhenCleared() throws {
        let (repository, context) = try makeRepository()
        let reference = try makeReference()

        try repository.saveNote("  A private reflection.  ", for: reference)
        XCTAssertEqual(try repository.state(for: reference).noteText, "A private reflection.")

        try repository.saveNote("A revised reflection.", for: reference)
        XCTAssertEqual(try repository.state(for: reference).noteText, "A revised reflection.")

        try repository.saveNote("   ", for: reference)
        XCTAssertEqual(try repository.state(for: reference).noteText, "")

        let stored = try context.fetch(FetchDescriptor<BibleStudySchemaV1.ScriptureAnnotation>())
        XCTAssertEqual(stored.count, 1)
        XCTAssertNotNil(stored.first?.deletedAt)
    }

    func testAnnotationsAreScopedToTranslationAndPassage() throws {
        let (repository, _) = try makeRepository()
        let john = try makeReference(versionID: 55, bookID: "JOHN", chapter: 3, verse: 16)
        let anotherTranslation = try makeReference(
            versionID: 463,
            bookID: "JOHN",
            chapter: 3,
            verse: 16
        )
        let anotherVerse = try makeReference(versionID: 55, bookID: "JOHN", chapter: 3, verse: 17)

        try repository.saveNote("Only here", for: john)

        XCTAssertEqual(try repository.state(for: john).noteText, "Only here")
        XCTAssertEqual(try repository.state(for: anotherTranslation), .empty)
        XCTAssertEqual(try repository.state(for: anotherVerse), .empty)
    }

    private func makeRepository() throws -> (ScriptureAnnotationRepository, ModelContext) {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        return (ScriptureAnnotationRepository(modelContext: context), context)
    }

    private func writeAnnotationState(
        for reference: ScriptureReference,
        to storeURL: URL
    ) throws {
        let container = try BibleStudyModelContainer.make(storeURL: storeURL)
        let repository = ScriptureAnnotationRepository(modelContext: ModelContext(container))
        try repository.toggleBookmark(for: reference)
        try repository.setHighlight(.green, for: reference)
        try repository.saveNote("Persist across launch", for: reference)
    }

    private func makeReference(
        versionID: Int = 55,
        bookID: String = "JOHN",
        chapter: Int = 3,
        verse: Int = 16
    ) throws -> ScriptureReference {
        try ScriptureReference(
            versionID: versionID,
            bookID: bookID,
            chapter: chapter,
            verseStart: verse
        )
    }
}

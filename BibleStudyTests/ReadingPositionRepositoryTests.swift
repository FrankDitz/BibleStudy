import SwiftData
import XCTest

@testable import BibleStudy

@MainActor
final class ReadingPositionRepositoryTests: XCTestCase {
    func testSaveCreatesAndUpdatesSingleActiveProviderPosition() throws {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        let repository = ReadingPositionRepository(modelContext: context)
        let first = try ScriptureReference(versionID: 42, bookID: "JOHN", chapter: 1)
        let second = try ScriptureReference(
            versionID: 42,
            bookID: "JOHN",
            chapter: 3,
            verseStart: 16
        )

        try repository.save(
            first,
            provider: .youVersion,
            at: Date(timeIntervalSince1970: 1)
        )
        try repository.save(
            second,
            provider: .youVersion,
            at: Date(timeIntervalSince1970: 2)
        )

        let positions = try context.fetch(FetchDescriptor<BibleStudySchemaV1.ReadingPosition>())
        XCTAssertEqual(positions.count, 1)
        XCTAssertEqual(positions.first?.editionValue, "42")
        XCTAssertEqual(positions.first?.canonicalBookID, "JOHN")
        XCTAssertEqual(positions.first?.chapter, 3)
        XCTAssertEqual(positions.first?.verse, 16)
    }

    func testRestoreReturnsLatestApprovedProviderReference() throws {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        context.insert(
            BibleStudySchemaV1.ReadingPosition(
                editionProviderID: ScriptureProviderIdentifier.fixture.rawValue,
                editionValue: "42",
                canonicalBookID: "GEN",
                chapter: 1,
                modifiedAt: Date(timeIntervalSince1970: 3)
            )
        )
        context.insert(
            BibleStudySchemaV1.ReadingPosition(
                editionProviderID: ScriptureProviderIdentifier.youVersion.rawValue,
                editionValue: "2015",
                canonicalBookID: "MAT",
                chapter: 5,
                modifiedAt: Date(timeIntervalSince1970: 2)
            )
        )
        context.insert(
            BibleStudySchemaV1.ReadingPosition(
                editionProviderID: ScriptureProviderIdentifier.youVersion.rawValue,
                editionValue: "42",
                canonicalBookID: "TOB",
                chapter: 4,
                verse: 7,
                modifiedAt: Date(timeIntervalSince1970: 1)
            )
        )
        try context.save()

        let restored = try ReadingPositionRepository(modelContext: context)
            .restoredReference(provider: .youVersion, approvedVersionIDs: [42])

        XCTAssertEqual(
            restored,
            try ScriptureReference(
                versionID: 42,
                bookID: "TOB",
                chapter: 4,
                verseStart: 7
            )
        )
    }

    func testRestoreFailsClosedWhenStoredEditionIsNotApproved() throws {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        let repository = ReadingPositionRepository(modelContext: context)
        try repository.save(
            ScriptureReference(versionID: 3034, bookID: "JOHN", chapter: 1),
            provider: .youVersion
        )

        XCTAssertNil(
            try repository.restoredReference(
                provider: .youVersion,
                approvedVersionIDs: [42]
            )
        )
    }
}

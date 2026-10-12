import Foundation
import SwiftData

@MainActor
struct ReadingPositionRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func restoredReference(
        provider: ScriptureProviderIdentifier,
        approvedVersionIDs: Set<Int>
    ) throws -> ScriptureReference? {
        let providerID = provider.rawValue
        let descriptor = FetchDescriptor<BibleStudySchemaV1.ReadingPosition>(
            predicate: #Predicate { position in
                position.editionProviderID == providerID && position.deletedAt == nil
            },
            sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
        )

        return try modelContext.fetch(descriptor).lazy.compactMap { position in
            guard
                let versionID = Int(position.editionValue),
                approvedVersionIDs.contains(versionID)
            else {
                return nil
            }

            return try? ScriptureReference(
                versionID: versionID,
                bookID: position.canonicalBookID,
                chapter: position.chapter,
                verseStart: position.verse
            )
        }.first
    }

    func save(
        _ reference: ScriptureReference,
        provider: ScriptureProviderIdentifier,
        at date: Date = .now
    ) throws {
        let providerID = provider.rawValue
        let descriptor = FetchDescriptor<BibleStudySchemaV1.ReadingPosition>(
            predicate: #Predicate { position in
                position.editionProviderID == providerID && position.deletedAt == nil
            },
            sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
        )
        let positions = try modelContext.fetch(descriptor)

        if let position = positions.first {
            position.editionValue = String(reference.versionID)
            position.canonicalBookID = reference.bookID
            position.chapter = reference.chapter
            position.verse = reference.verseStart
            position.modifiedAt = date

            for duplicate in positions.dropFirst() {
                duplicate.deletedAt = date
                duplicate.modifiedAt = date
            }
        } else {
            modelContext.insert(
                BibleStudySchemaV1.ReadingPosition(
                    editionProviderID: providerID,
                    editionValue: String(reference.versionID),
                    canonicalBookID: reference.bookID,
                    chapter: reference.chapter,
                    verse: reference.verseStart,
                    modifiedAt: date
                )
            )
        }

        try modelContext.save()
    }
}

import Foundation
import SwiftData

enum ScriptureHighlightColor: String, CaseIterable, Identifiable, Sendable {
    case gold
    case blue
    case green
    case rose

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}

struct ScriptureAnnotationState: Equatable, Sendable {
    var isBookmarked: Bool
    var highlightColor: ScriptureHighlightColor?
    var noteText: String

    static let empty = ScriptureAnnotationState(
        isBookmarked: false,
        highlightColor: nil,
        noteText: ""
    )
}

@MainActor
struct ScriptureAnnotationRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func state(for reference: ScriptureReference) throws -> ScriptureAnnotationState {
        let annotations = try matchingAnnotations(for: reference, includesDeleted: false)

        return ScriptureAnnotationState(
            isBookmarked: annotations.contains { $0.kind == .bookmark },
            highlightColor:
                annotations
                .first { $0.kind == .highlight }
                .flatMap { $0.colorName }
                .flatMap(ScriptureHighlightColor.init(rawValue:)),
            noteText:
                annotations
                .first { $0.kind == .note }?
                .noteText ?? ""
        )
    }

    @discardableResult
    func toggleBookmark(for reference: ScriptureReference, at date: Date = .now) throws -> Bool {
        let annotation = try annotation(
            ofKind: .bookmark,
            for: reference,
            includesDeleted: true
        )

        if let annotation {
            annotation.deletedAt = annotation.deletedAt == nil ? date : nil
            annotation.modifiedAt = date
        } else {
            modelContext.insert(makeAnnotation(kind: .bookmark, for: reference, at: date))
        }

        try modelContext.save()
        return try state(for: reference).isBookmarked
    }

    func setHighlight(
        _ color: ScriptureHighlightColor?,
        for reference: ScriptureReference,
        at date: Date = .now
    ) throws {
        let annotation = try annotation(
            ofKind: .highlight,
            for: reference,
            includesDeleted: true
        )

        if let annotation {
            annotation.colorName = color?.rawValue
            annotation.deletedAt = color == nil ? date : nil
            annotation.modifiedAt = date
        } else if let color {
            let newAnnotation = makeAnnotation(kind: .highlight, for: reference, at: date)
            newAnnotation.colorName = color.rawValue
            modelContext.insert(newAnnotation)
        }

        try modelContext.save()
    }

    func saveNote(
        _ text: String,
        for reference: ScriptureReference,
        at date: Date = .now
    ) throws {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let annotation = try annotation(
            ofKind: .note,
            for: reference,
            includesDeleted: true
        )

        if let annotation {
            annotation.noteText = trimmedText.isEmpty ? nil : trimmedText
            annotation.deletedAt = trimmedText.isEmpty ? date : nil
            annotation.modifiedAt = date
        } else if !trimmedText.isEmpty {
            let newAnnotation = makeAnnotation(kind: .note, for: reference, at: date)
            newAnnotation.noteText = trimmedText
            modelContext.insert(newAnnotation)
        }

        try modelContext.save()
    }

    private func annotation(
        ofKind kind: ScriptureAnnotationKind,
        for reference: ScriptureReference,
        includesDeleted: Bool
    ) throws -> BibleStudySchemaV1.ScriptureAnnotation? {
        try matchingAnnotations(for: reference, includesDeleted: includesDeleted)
            .first { $0.kind == kind }
    }

    private func matchingAnnotations(
        for reference: ScriptureReference,
        includesDeleted: Bool
    ) throws -> [BibleStudySchemaV1.ScriptureAnnotation] {
        let bookID = reference.bookID
        let chapter = reference.chapter
        let verseStart = reference.verseStart
        let verseEnd = reference.verseEnd
        let providerID = ScriptureProviderIdentifier.youVersion.rawValue
        let editionValue = String(reference.versionID)
        let descriptor = FetchDescriptor<BibleStudySchemaV1.ScriptureAnnotation>(
            predicate: #Predicate { annotation in
                annotation.canonicalBookID == bookID
                    && annotation.chapter == chapter
                    && annotation.verseStart == verseStart
                    && annotation.verseEnd == verseEnd
                    && annotation.editionProviderID == providerID
                    && annotation.editionValue == editionValue
            }
        )

        let annotations = try modelContext.fetch(descriptor)
        if includesDeleted {
            return annotations
        }
        return annotations.filter { $0.deletedAt == nil }
    }

    private func makeAnnotation(
        kind: ScriptureAnnotationKind,
        for reference: ScriptureReference,
        at date: Date
    ) -> BibleStudySchemaV1.ScriptureAnnotation {
        BibleStudySchemaV1.ScriptureAnnotation(
            kind: kind,
            canonicalBookID: reference.bookID,
            chapter: reference.chapter,
            verseStart: reference.verseStart,
            verseEnd: reference.verseEnd,
            editionProviderID: ScriptureProviderIdentifier.youVersion.rawValue,
            editionValue: String(reference.versionID),
            createdAt: date,
            modifiedAt: date
        )
    }
}

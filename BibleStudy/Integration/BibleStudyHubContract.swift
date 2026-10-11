import Foundation

enum BibleStudyIntegrationVersion {
    static let current = 1
}

/// A provider-neutral Scripture location using OSIS book identifiers.
struct CanonicalScriptureReference: Codable, Equatable, Hashable, Sendable {
    enum ValidationError: Error, Equatable {
        case invalidBook
        case invalidChapter
        case invalidVerseRange
    }

    let bookID: String
    let chapter: Int
    let verseStart: Int?
    let verseEnd: Int?

    init(
        bookID: String,
        chapter: Int,
        verseStart: Int? = nil,
        verseEnd: Int? = nil
    ) throws {
        let normalizedBookID =
            bookID
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        guard CatholicCanon.contains(osisID: normalizedBookID) else {
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

        self.bookID = normalizedBookID
        self.chapter = chapter
        self.verseStart = verseStart
        self.verseEnd = verseEnd ?? verseStart
    }

    var osis: String {
        guard let verseStart else { return "\(bookID).\(chapter)" }
        guard let verseEnd, verseEnd != verseStart else {
            return "\(bookID).\(chapter).\(verseStart)"
        }
        return "\(bookID).\(chapter).\(verseStart)-\(verseEnd)"
    }
}

/// The small, privacy-conscious profile projection the Hub may supply.
struct BibleStudyProfileContext: Codable, Equatable, Sendable {
    let profileID: UUID
    let preferredName: String?
    let localeIdentifier: String
    let timeZoneIdentifier: String
    let jurisdiction: CatholicJurisdiction
}

struct CatholicJurisdiction: Codable, Equatable, Sendable {
    let countryCode: String
    let subdivisionCode: String?
    let dioceseName: String?
}

/// Extensible identifiers keep the taxonomy additive across independently released modules.
struct VirtueIdentifier: RawRepresentable, Codable, Equatable, Hashable, Sendable {
    let rawValue: String

    static let chastity = VirtueIdentifier(rawValue: "christian.chastity")
    static let temperance = VirtueIdentifier(rawValue: "christian.temperance")
    static let charity = VirtueIdentifier(rawValue: "christian.charity")
    static let diligence = VirtueIdentifier(rawValue: "christian.diligence")
    static let patience = VirtueIdentifier(rawValue: "christian.patience")
    static let kindness = VirtueIdentifier(rawValue: "christian.kindness")
    static let humility = VirtueIdentifier(rawValue: "christian.humility")

    static let prudence = VirtueIdentifier(rawValue: "cardinal.prudence")
    static let justice = VirtueIdentifier(rawValue: "cardinal.justice")
    static let fortitude = VirtueIdentifier(rawValue: "cardinal.fortitude")
    static let cardinalTemperance = VirtueIdentifier(rawValue: "cardinal.temperance")

    static let supported: Set<VirtueIdentifier> = [
        .chastity,
        .temperance,
        .charity,
        .diligence,
        .patience,
        .kindness,
        .humility,
        .prudence,
        .justice,
        .fortitude,
        .cardinalTemperance,
    ]
}

/// A transport-neutral event. Constructing it never sends it or writes Hub state.
struct BibleStudyHubEvent: Codable, Equatable, Sendable {
    static let currentSchemaVersion = BibleStudyIntegrationVersion.current

    let id: UUID
    let schemaVersion: Int
    let sourceApp: String
    let type: BibleStudyHubEventType
    let occurredAt: Date
    let entityID: UUID
    let payload: BibleStudyHubEventPayload

    init(
        id: UUID,
        type: BibleStudyHubEventType,
        occurredAt: Date,
        entityID: UUID,
        payload: BibleStudyHubEventPayload
    ) {
        self.id = id
        self.schemaVersion = Self.currentSchemaVersion
        self.sourceApp = "bible-study"
        self.type = type
        self.occurredAt = occurredAt
        self.entityID = entityID
        self.payload = payload
    }
}

struct BibleStudyHubEventType: RawRepresentable, Codable, Equatable, Hashable, Sendable {
    let rawValue: String

    static let readingProgressUpdated = Self(rawValue: "bible-study.reading.progress-updated")
    static let planAssignmentCompleted = Self(rawValue: "bible-study.plan.assignment-completed")
    static let learningItemCompleted = Self(rawValue: "bible-study.learning.item-completed")
    static let milestoneEarned = Self(rawValue: "bible-study.milestone.earned")
}

/// Metadata only. Notes, annotations, reading history, and learning-body text are excluded.
struct BibleStudyHubEventPayload: Codable, Equatable, Sendable {
    let scriptureReference: CanonicalScriptureReference?
    let planID: UUID?
    let learningItemID: String?
    let milestoneID: String?
    let virtueIDs: [VirtueIdentifier]

    init(
        scriptureReference: CanonicalScriptureReference? = nil,
        planID: UUID? = nil,
        learningItemID: String? = nil,
        milestoneID: String? = nil,
        virtueIDs: [VirtueIdentifier] = []
    ) {
        self.scriptureReference = scriptureReference
        self.planID = planID
        self.learningItemID = learningItemID
        self.milestoneID = milestoneID
        self.virtueIDs = Self.normalized(virtueIDs)
    }

    private static func normalized(_ identifiers: [VirtueIdentifier]) -> [VirtueIdentifier] {
        Array(Set(identifiers)).sorted { $0.rawValue < $1.rawValue }
    }
}

/// An explicit handoff into Echo. Echo remains the owner of any resulting journal entry.
struct BibleStudyEchoReflectionRequest: Codable, Equatable, Sendable {
    static let currentSchemaVersion = BibleStudyIntegrationVersion.current

    let id: UUID
    let schemaVersion: Int
    let sourceApp: String
    let createdAt: Date
    let prompt: String
    let scriptureReference: CanonicalScriptureReference?
    let planID: UUID?
    let learningItemID: String?
    let virtueIDs: [VirtueIdentifier]

    init(
        id: UUID,
        createdAt: Date,
        prompt: String,
        scriptureReference: CanonicalScriptureReference? = nil,
        planID: UUID? = nil,
        learningItemID: String? = nil,
        virtueIDs: [VirtueIdentifier] = []
    ) {
        self.id = id
        self.schemaVersion = Self.currentSchemaVersion
        self.sourceApp = "bible-study"
        self.createdAt = createdAt
        self.prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        self.scriptureReference = scriptureReference
        self.planID = planID
        self.learningItemID = learningItemID
        self.virtueIDs = Array(Set(virtueIDs)).sorted { $0.rawValue < $1.rawValue }
    }
}

enum BibleStudyHubEventCodec {
    static func encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }

    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

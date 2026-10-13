import Foundation

enum VirtueSourceClass: String, Codable, CaseIterable, Sendable {
    case scripture
    case catechism
    case universalChurch
    case episcopalConference
    case reviewedSecondary
}

struct VirtueContentSource: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let url: URL
    let locator: String
    let sourceClass: VirtueSourceClass
    let checkedAt: Date
}

enum VirtueReviewState: String, Codable, CaseIterable, Sendable {
    case draft
    case inReview
    case approved
    case superseded
}

struct VirtueContentReview: Codable, Equatable, Sendable {
    let state: VirtueReviewState
    let reviewerRole: String?
    let reviewedAt: Date?
    let reviewBy: Date?
}

enum VirtuePracticeContext: String, Codable, CaseIterable, Sendable {
    case prayer
    case work
    case family
    case relationships
    case speechAndConflict
    case digitalLife
    case healthAndAppetite
    case serviceAndCommunity
    case difficultSeason

    var title: String {
        switch self {
        case .prayer: "Prayer"
        case .work: "Work"
        case .family: "Family"
        case .relationships: "Relationships"
        case .speechAndConflict: "Speech and conflict"
        case .digitalLife: "Digital life"
        case .healthAndAppetite: "Health and appetite"
        case .serviceAndCommunity: "Service and community"
        case .difficultSeason: "Difficult season"
        }
    }
}

enum VirtuePracticeCommitment: String, Codable, CaseIterable, Sendable {
    case small
    case ordinary
    case demanding

    var title: String {
        switch self {
        case .small: "Small"
        case .ordinary: "Ordinary"
        case .demanding: "Demanding"
        }
    }
}

struct VirtuePracticeDefinition: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let instruction: String
    let contexts: Set<VirtuePracticeContext>
    let commitment: VirtuePracticeCommitment
    let estimatedMinutes: Int?
}

struct VirtueExamenPrompt: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let text: String
}

struct VirtueScriptureEncounter: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let context: String
    let reference: CanonicalScriptureReference
}

struct VirtueFormationPathway: Identifiable, Codable, Equatable, Sendable {
    let id: VirtueIdentifier
    let contentVersion: Int
    let title: String
    let summary: String
    let catholicRelationship: String
    let teaching: String
    let whatItIsNot: [String]
    let sources: [VirtueContentSource]
    let scriptureEncounters: [VirtueScriptureEncounter]
    let practices: [VirtuePracticeDefinition]
    let examenPrompts: [VirtueExamenPrompt]
    let prayer: String
    let pastoralBoundaries: [String]
    let review: VirtueContentReview

    func publicationIssues(asOf date: Date) -> Set<VirtuePathwayPublicationIssue> {
        var issues: Set<VirtuePathwayPublicationIssue> = []
        if !VirtueFormationCatalog.supportedIdentifiers.contains(id) {
            issues.insert(.unsupportedVirtue)
        }
        if contentVersion < 1 { issues.insert(.invalidContentVersion) }
        if title.trimmed.isEmpty { issues.insert(.missingTitle) }
        if summary.trimmed.isEmpty || catholicRelationship.trimmed.isEmpty || teaching.trimmed.isEmpty {
            issues.insert(.missingTeaching)
        }
        if sources.isEmpty { issues.insert(.missingSource) }
        if sources.contains(where: { $0.title.trimmed.isEmpty || $0.locator.trimmed.isEmpty }) {
            issues.insert(.incompleteSource)
        }
        if sources.contains(where: { $0.checkedAt > date }) {
            issues.insert(.invalidSourceDate)
        }
        if whatItIsNot.isEmpty { issues.insert(.missingTeaching) }
        if scriptureEncounters.isEmpty { issues.insert(.missingScripture) }
        if practices.isEmpty { issues.insert(.missingPractice) }
        if examenPrompts.isEmpty { issues.insert(.missingExamen) }
        if prayer.trimmed.isEmpty { issues.insert(.missingPrayer) }
        if pastoralBoundaries.isEmpty { issues.insert(.missingPastoralBoundary) }
        if review.state != .approved { issues.insert(.notApproved) }
        if review.reviewerRole?.trimmed.isEmpty != false { issues.insert(.missingReviewerRole) }
        guard let reviewedAt = review.reviewedAt, let reviewBy = review.reviewBy else {
            issues.insert(.missingReviewDates)
            return issues
        }
        if reviewedAt > date || reviewBy <= reviewedAt { issues.insert(.invalidReviewDates) }
        if reviewBy < date { issues.insert(.staleReview) }
        if Set(practices.map(\.id)).count != practices.count
            || Set(examenPrompts.map(\.id)).count != examenPrompts.count
            || Set(sources.map(\.id)).count != sources.count
            || Set(scriptureEncounters.map(\.id)).count != scriptureEncounters.count
        {
            issues.insert(.duplicateContentIdentifier)
        }
        return issues
    }

    func isPublishable(asOf date: Date) -> Bool {
        publicationIssues(asOf: date).isEmpty
    }
}

enum VirtuePathwayPublicationIssue: String, Codable, Hashable, Sendable {
    case unsupportedVirtue
    case invalidContentVersion
    case missingTitle
    case missingTeaching
    case missingSource
    case incompleteSource
    case invalidSourceDate
    case missingScripture
    case missingPractice
    case missingExamen
    case missingPrayer
    case missingPastoralBoundary
    case notApproved
    case missingReviewerRole
    case missingReviewDates
    case invalidReviewDates
    case staleReview
    case duplicateContentIdentifier
}

enum VirtueCheckInStatus: String, Codable, CaseIterable, Sendable {
    case practiced
    case noticedOpportunity
    case choseDifferently
    case notApplicable
    case reflectedInEcho

    var title: String {
        switch self {
        case .practiced: "Practiced it"
        case .noticedOpportunity: "Noticed an opportunity"
        case .choseDifferently: "Missed or chose differently"
        case .notApplicable: "Not applicable today"
        case .reflectedInEcho: "Reflected in Echo"
        }
    }
}

struct VirtueCheckIn: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let cycleID: UUID
    let virtueID: VirtueIdentifier
    let practiceID: String
    let status: VirtueCheckInStatus
    let occurredAt: Date
    let privateObservation: String?
    let cycleDay: Int?

    init(
        id: UUID,
        cycleID: UUID,
        virtueID: VirtueIdentifier,
        practiceID: String,
        status: VirtueCheckInStatus,
        occurredAt: Date,
        privateObservation: String?,
        cycleDay: Int? = nil
    ) {
        self.id = id
        self.cycleID = cycleID
        self.virtueID = virtueID
        self.practiceID = practiceID
        self.status = status
        self.occurredAt = occurredAt
        self.privateObservation = privateObservation
        self.cycleDay = cycleDay
    }

    var shareableMetadata: VirtueCheckInMetadata {
        VirtueCheckInMetadata(
            id: id,
            cycleID: cycleID,
            virtueID: virtueID,
            practiceID: practiceID,
            status: status,
            occurredAt: occurredAt
        )
    }
}

/// The maximum check-in surface allowed outside the owner's private virtue store.
/// Private observations and any Echo text deliberately have no representation here.
struct VirtueCheckInMetadata: Codable, Equatable, Sendable {
    let id: UUID
    let cycleID: UUID
    let virtueID: VirtueIdentifier
    let practiceID: String
    let status: VirtueCheckInStatus
    let occurredAt: Date
}

extension String {
    fileprivate var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

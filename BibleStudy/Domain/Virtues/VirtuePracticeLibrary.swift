import Foundation

struct VirtuePracticeLibraryEntry: Identifiable, Equatable, Sendable {
    var id: String { "\(virtueID.rawValue).\(practice.id)" }

    let virtueID: VirtueIdentifier
    let virtueTitle: String
    let practice: VirtuePracticeDefinition
}

enum VirtuePracticeLibrary {
    static let entries: [VirtuePracticeLibraryEntry] =
        VirtueFoundationLibrary.pathways.flatMap { pathway in
            pathway.practices.map {
                VirtuePracticeLibraryEntry(
                    virtueID: pathway.id,
                    virtueTitle: pathway.title,
                    practice: $0
                )
            }
        }

    static func filtered(
        context: VirtuePracticeContext?,
        commitment: VirtuePracticeCommitment?
    ) -> [VirtuePracticeLibraryEntry] {
        entries.filter { entry in
            (context == nil || entry.practice.contexts.contains(context!))
                && (commitment == nil || entry.practice.commitment == commitment)
        }
    }

    static func entry(virtueID: VirtueIdentifier, practiceID: String)
        -> VirtuePracticeLibraryEntry?
    {
        entries.first { $0.virtueID == virtueID && $0.practice.id == practiceID }
    }
}

struct VirtueJourneyStage: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let virtueID: VirtueIdentifier
    let practiceID: String
    let reflectionPrompt: String
}

struct VirtueThematicJourney: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let title: String
    let summary: String
    let context: VirtuePracticeContext
    let stages: [VirtueJourneyStage]
    let sources: [VirtueContentSource]
    let review: VirtueContentReview
}

enum VirtueThematicJourneyLibrary {
    private static let checkedAt = Date(timeIntervalSince1970: 1_760_313_600)

    private static let catechismSource = VirtueContentSource(
        id: "ccc-human-virtues",
        title: "Catechism of the Catholic Church: The Human Virtues",
        url: URL(
            string:
                "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/i_the_human_virtues.html"
        )!,
        locator: "§§1803–1811",
        sourceClass: .catechism,
        checkedAt: checkedAt
    )

    private static let discernmentSource = VirtueContentSource(
        id: "gaudete-discernment",
        title: "Gaudete et Exsultate: Discernment",
        url: URL(
            string:
                "https://www.vatican.va/content/francesco/en/apost_exhortations/documents/papa-francesco_esortazione-ap_20180319_gaudete-et-exsultate.html"
        )!,
        locator: "§§166–175",
        sourceClass: .universalChurch,
        checkedAt: checkedAt
    )

    private static let draftReview = VirtueContentReview(
        state: .draft,
        reviewerRole: nil,
        reviewedAt: nil,
        reviewBy: nil
    )

    static let journeys: [VirtueThematicJourney] = [
        journey(
            id: "faithful-work",
            title: "Faithful Work",
            summary: "Bring steady effort, wise judgment, and humility to ordinary responsibilities.",
            context: .work,
            stages: [
                stage(
                    "begin-well", "Begin with intention", .diligence, "diligence-next-duty",
                    "What work deserves faithful attention today?"),
                stage(
                    "encourage-good", "Strengthen the good", .kindness, "kindness-specific-encouragement",
                    "Whose faithful work can you name and encourage?"),
                stage(
                    "receive-limits", "Receive your limits", .humility, "humility-ask-help",
                    "Where can you ask for help or accept correction?"),
            ]
        ),
        journey(
            id: "speech-relationships",
            title: "Speech and Relationships",
            summary: "Practice truthful, patient, and charitable presence in conversation and conflict.",
            context: .speechAndConflict,
            stages: [
                stage(
                    "listen-first", "Listen before answering", .patience, "patience-one-breath",
                    "Can you make room for the other person before responding?"),
                stage(
                    "speak-gently", "Speak with gentleness", .kindness, "kindness-repair-speech",
                    "What truthful words would also protect the other person's dignity?"),
                stage(
                    "receive-correction", "Receive correction", .humility, "humility-receive-correction",
                    "What truth can you receive without self-defense or self-contempt?"),
            ]
        ),
        journey(
            id: "digital-freedom",
            title: "Digital Freedom",
            summary: "Use technology deliberately so attention and relationships remain ordered toward the good.",
            context: .digitalLife,
            stages: [
                stage(
                    "pause-choice", "Pause before choosing", .temperance, "temperance-pause",
                    "Is this use free and purposeful, or merely automatic?"),
                stage(
                    "guard-person", "Honor every person", .chastity, "chastity-person-not-object",
                    "Does what you view recognize persons rather than reduce them to objects?"),
            ]
        ),
        journey(
            id: "service-community",
            title: "Service and Community",
            summary: "Grow through concrete service that respects the dignity and agency of others.",
            context: .serviceAndCommunity,
            stages: [
                stage(
                    "notice-need", "Notice a real need", .charity, "charity-hidden-service",
                    "Whose good is God inviting you to seek concretely?"),
                stage(
                    "small-service", "Offer ordinary help", .kindness, "kindness-practical-care",
                    "What quiet act would lighten another person's burden?"),
            ]
        ),
        journey(
            id: "difficult-season",
            title: "A Difficult Season",
            summary:
                "Practice patient faithfulness without pretending suffering is simple or self-sufficiency is required.",
            context: .difficultSeason,
            stages: [
                stage(
                    "one-day", "Receive this day", .patience, "patience-faithful-wait",
                    "What can be borne faithfully today, without solving everything at once?"),
                stage(
                    "next-duty", "Take the next faithful step", .diligence, "diligence-small-start",
                    "What small responsibility is actually yours now?"),
                stage(
                    "receive-help", "Receive help", .humility, "humility-ask-help",
                    "Who can accompany you without requiring you to carry this alone?"),
            ]
        ),
    ]

    private static func journey(
        id: String,
        title: String,
        summary: String,
        context: VirtuePracticeContext,
        stages: [VirtueJourneyStage]
    ) -> VirtueThematicJourney {
        VirtueThematicJourney(
            id: id,
            title: title,
            summary: summary,
            context: context,
            stages: stages,
            sources: [catechismSource, discernmentSource],
            review: draftReview
        )
    }

    private static func stage(
        _ id: String,
        _ title: String,
        _ virtueID: VirtueIdentifier,
        _ practiceID: String,
        _ reflectionPrompt: String
    ) -> VirtueJourneyStage {
        return VirtueJourneyStage(
            id: id,
            title: title,
            virtueID: virtueID,
            practiceID: practiceID,
            reflectionPrompt: reflectionPrompt
        )
    }
}

struct VirtueRulePractice: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let virtueID: VirtueIdentifier
    let practice: VirtuePracticeDefinition
    let context: VirtuePracticeContext
    let retainedAt: Date
    var retiredAt: Date?

    var isActive: Bool { retiredAt == nil }
}

enum VirtueRuleRevisionAction: String, Codable, Sendable {
    case retained
    case retired
    case restored
}

struct VirtueRuleRevision: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let practiceID: UUID
    let action: VirtueRuleRevisionAction
    let occurredAt: Date
}

enum VirtueRuleOfLifeEngine {
    static func retain(
        cycle: VirtueFocusCycle,
        in state: inout VirtueFormationState,
        at date: Date
    ) {
        if let existing = state.rulePractices.firstIndex(where: {
            $0.virtueID == cycle.virtueID && $0.practice.id == cycle.practice.id
                && $0.context == cycle.context
        }) {
            guard state.rulePractices[existing].retiredAt != nil else { return }
            state.rulePractices[existing].retiredAt = nil
            state.ruleRevisions.append(
                VirtueRuleRevision(
                    id: UUID(),
                    practiceID: state.rulePractices[existing].id,
                    action: .restored,
                    occurredAt: date
                )
            )
            return
        }

        let retained = VirtueRulePractice(
            id: UUID(),
            virtueID: cycle.virtueID,
            practice: cycle.practice,
            context: cycle.context,
            retainedAt: date,
            retiredAt: nil
        )
        state.rulePractices.append(retained)
        state.ruleRevisions.append(
            VirtueRuleRevision(
                id: UUID(),
                practiceID: retained.id,
                action: .retained,
                occurredAt: date
            )
        )
    }

    static func retire(
        practiceID: UUID,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) {
        guard let index = state.rulePractices.firstIndex(where: { $0.id == practiceID }),
            state.rulePractices[index].isActive
        else { return }
        state.rulePractices[index].retiredAt = date
        state.ruleRevisions.append(
            VirtueRuleRevision(id: UUID(), practiceID: practiceID, action: .retired, occurredAt: date)
        )
    }

    static func restore(
        practiceID: UUID,
        in state: inout VirtueFormationState,
        at date: Date = .now
    ) {
        guard let index = state.rulePractices.firstIndex(where: { $0.id == practiceID }),
            !state.rulePractices[index].isActive
        else { return }
        state.rulePractices[index].retiredAt = nil
        state.ruleRevisions.append(
            VirtueRuleRevision(id: UUID(), practiceID: practiceID, action: .restored, occurredAt: date)
        )
    }
}

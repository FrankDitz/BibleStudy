import Foundation

struct HomeReadingResume: Equatable, Sendable {
    let reference: ScriptureReference
    let title: String
    let updatedAt: Date?
    let isSavedPosition: Bool
}

struct HomePlanToday: Equatable, Sendable {
    let planID: UUID
    let title: String
    let dayIndex: Int
    let totalDays: Int
    let scheduledDate: PlanLocalDate
    let completedReadingCount: Int
    let totalReadingCount: Int
    let overallCompletionFraction: Double
    let nextReadingTitle: String?
    let nextReadingReference: ScriptureReference?
    let status: ReadingPlanStatus
    let pace: PlanPaceStatus
}

struct HomeLearningSuggestion: Equatable, Sendable {
    let topic: LearningTopic
    let eyebrow: String
}

struct HomeVirtueFocus: Equatable, Sendable {
    let cycleID: UUID?
    let identifier: VirtueIdentifier
    let title: String
    let practice: String
    let scriptureTitle: String
    let scriptureReference: ScriptureReference
    let checkInStatus: VirtueCheckInStatus?
    let isPaused: Bool
}

enum HomeActivityKind: String, Equatable, Sendable {
    case scripture
    case plan
    case annotation
    case learning

    var systemImage: String {
        switch self {
        case .scripture: "book.pages"
        case .plan: "checkmark.circle"
        case .annotation: "lock.fill"
        case .learning: "graduationcap"
        }
    }
}

struct HomeRecentActivity: Identifiable, Equatable, Sendable {
    let id: String
    let kind: HomeActivityKind
    let title: String
    let occurredAt: Date
}

struct HomeTodaySnapshot: Equatable, Sendable {
    let reading: HomeReadingResume
    let plan: HomePlanToday?
    let learning: HomeLearningSuggestion
    let virtue: HomeVirtueFocus
    let recentActivity: [HomeRecentActivity]
    let planActivityStreak: Int
}

enum HomeTodayRecommendations {
    static func learning(
        asOf date: Date,
        completedTopicIDs: Set<String>,
        calendar: Calendar
    ) -> HomeLearningSuggestion {
        let unfinished = LearningTopicCatalog.topics.filter {
            !completedTopicIDs.contains($0.id)
        }
        let candidates = unfinished.isEmpty ? LearningTopicCatalog.topics : unfinished
        let day = max(1, calendar.ordinality(of: .day, in: .year, for: date) ?? 1)
        let topic = candidates[(day - 1) % candidates.count]
        return HomeLearningSuggestion(
            topic: topic,
            eyebrow: unfinished.isEmpty ? "Review a Catholic practice" : "Learn something today"
        )
    }

    static func virtue(asOf date: Date, calendar: Calendar) -> HomeVirtueFocus {
        let anchorComponents = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: 2026,
            month: 10,
            day: 12,
            hour: 12
        )
        let anchor = calendar.date(from: anchorComponents) ?? date
        let weekOffset = calendar.dateComponents([.weekOfYear], from: anchor, to: date).weekOfYear ?? 0
        let index = ((weekOffset % virtues.count) + virtues.count) % virtues.count
        return virtues[index]
    }

    static func virtue(
        asOf date: Date,
        calendar: Calendar,
        formation: VirtueFormationState
    ) -> HomeVirtueFocus {
        guard let cycle = formation.currentCycle,
            let pathway = VirtueFoundationLibrary.pathway(for: cycle.virtueID),
            let encounter = pathway.scriptureEncounters.first,
            let reference = try? ScriptureReference(
                versionID: YouVersionCatalogPolicy.developmentDefaultVersionID,
                bookID: encounter.reference.bookID,
                chapter: encounter.reference.chapter,
                verseStart: encounter.reference.verseStart,
                verseEnd: encounter.reference.verseEnd
            )
        else {
            return virtue(asOf: date, calendar: calendar)
        }
        return HomeVirtueFocus(
            cycleID: cycle.id,
            identifier: cycle.virtueID,
            title: pathway.title,
            practice: cycle.practice.instruction,
            scriptureTitle: encounter.reference.homeDisplayName,
            scriptureReference: reference,
            checkInStatus: formation.checkIn(for: cycle.id, on: date, calendar: calendar)?.status,
            isPaused: cycle.status == .paused
        )
    }

    private static let virtues: [HomeVirtueFocus] = [
        focus(
            .diligence,
            "Diligence",
            "Complete one necessary task promptly and offer the effort to God.",
            "Colossians 3",
            "COL",
            3
        ),
        focus(
            .patience,
            "Patience",
            "Meet one delay or interruption without resentment.",
            "James 5",
            "JAS",
            5
        ),
        focus(
            .kindness,
            "Kindness",
            "Choose one concrete act that makes another person's burden lighter.",
            "Ephesians 4",
            "EPH",
            4
        ),
        focus(
            .humility,
            "Humility",
            "Listen fully before defending your own position.",
            "Philippians 2",
            "PHIL",
            2
        ),
        focus(
            .chastity,
            "Chastity",
            "Treat each person you encounter as someone made for love, never use.",
            "Matthew 5",
            "MATT",
            5
        ),
        focus(
            .temperance,
            "Temperance",
            "Freely stop one appetite before it begins directing your choices.",
            "Galatians 5",
            "GAL",
            5
        ),
        focus(
            .charity,
            "Charity",
            "Do one good thing today without seeking recognition or repayment.",
            "1 Corinthians 13",
            "1COR",
            13
        ),
    ]

    private static func focus(
        _ identifier: VirtueIdentifier,
        _ title: String,
        _ practice: String,
        _ scriptureTitle: String,
        _ bookID: String,
        _ chapter: Int
    ) -> HomeVirtueFocus {
        let reference: ScriptureReference
        do {
            reference = try ScriptureReference(
                versionID: YouVersionCatalogPolicy.developmentDefaultVersionID,
                bookID: bookID,
                chapter: chapter
            )
        } catch {
            preconditionFailure("Invalid bundled virtue Scripture reference: \(bookID) \(chapter)")
        }
        return HomeVirtueFocus(
            cycleID: nil,
            identifier: identifier,
            title: title,
            practice: practice,
            scriptureTitle: scriptureTitle,
            scriptureReference: reference,
            checkInStatus: nil,
            isPaused: false
        )
    }
}

extension CanonicalScriptureReference {
    fileprivate var homeDisplayName: String {
        let book = CatholicCanon.book(osisID: bookID)?.displayName ?? bookID
        guard let verseStart else { return "\(book) \(chapter)" }
        guard let verseEnd, verseEnd != verseStart else {
            return "\(book) \(chapter):\(verseStart)"
        }
        return "\(book) \(chapter):\(verseStart)–\(verseEnd)"
    }
}

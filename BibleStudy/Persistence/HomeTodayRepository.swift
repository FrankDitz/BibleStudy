import Foundation
import SwiftData

@MainActor
struct HomeTodayRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func snapshot(
        asOf date: Date = .now,
        calendar: Calendar = .current
    ) throws -> HomeTodaySnapshot {
        let localDate = PlanLocalDate(date, calendar: calendar)
        let planState = try ActiveReadingPlanRepository(modelContext: modelContext).activeState()
        let learningProgress = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV1.LearningProgress>(
                sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
            )
        ).filter { $0.deletedAt == nil }
        let completedTopicIDs = Set(
            learningProgress.filter { $0.status == .completed }.map(\.contentID)
        )

        return HomeTodaySnapshot(
            reading: try readingResume(),
            plan: planState.flatMap {
                planToday(from: $0, asOf: localDate, calendar: calendar)
            },
            learning: HomeTodayRecommendations.learning(
                asOf: date,
                completedTopicIDs: completedTopicIDs,
                calendar: calendar
            ),
            virtue: HomeTodayRecommendations.virtue(asOf: date, calendar: calendar),
            recentActivity: try recentActivity(planState: planState),
            planActivityStreak: try planActivityStreak(
                planID: planState?.snapshot.id,
                asOf: date,
                calendar: calendar
            )
        )
    }

    private func readingResume() throws -> HomeReadingResume {
        let providerID = ScriptureProviderIdentifier.youVersion.rawValue
        let positions = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV1.ReadingPosition>(
                sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
            )
        )
        for position in positions
        where position.deletedAt == nil && position.editionProviderID == providerID {
            guard let versionID = Int(position.editionValue),
                YouVersionCatalogPolicy.permittedVersionIDs.contains(versionID),
                let reference = try? ScriptureReference(
                    versionID: versionID,
                    bookID: position.canonicalBookID,
                    chapter: position.chapter,
                    verseStart: position.verse
                )
            else {
                continue
            }
            return HomeReadingResume(
                reference: reference,
                title: referenceTitle(reference),
                updatedAt: position.modifiedAt,
                isSavedPosition: true
            )
        }

        let reference = YouVersionCatalogPolicy.developmentStart
        return HomeReadingResume(
            reference: reference,
            title: referenceTitle(reference),
            updatedAt: nil,
            isSavedPosition: false
        )
    }

    private func planToday(
        from state: ActiveReadingPlanState,
        asOf localDate: PlanLocalDate,
        calendar: Calendar
    ) -> HomePlanToday? {
        let dayIndex = state.nextDueDayIndex(asOf: localDate)
        guard let day = state.snapshot.day(dayIndex),
            let scheduledDay = state.snapshot.scheduledDay(dayIndex)
        else {
            return nil
        }
        let nextAssignment =
            state.firstIncompleteAssignment(on: dayIndex)
            ?? state.firstAssignment(on: dayIndex)
        let completed = day.assignments.count {
            state.isAssignmentComplete($0.id)
        }
        let rawPace = state.progress(asOf: localDate, calendar: calendar).pace
        let overdueCount = state.snapshot.schedule.count {
            $0.scheduledDate < localDate
                && !state.completedDayIndices.contains($0.logicalDayIndex)
        }
        let pace: PlanPaceStatus
        if case .behind = rawPace {
            pace = overdueCount == 0 ? .onTrack : .behind(days: overdueCount)
        } else {
            pace = rawPace
        }

        return HomePlanToday(
            planID: state.snapshot.id,
            title: state.snapshot.title,
            dayIndex: dayIndex,
            totalDays: state.snapshot.days.count,
            scheduledDate: scheduledDay.scheduledDate,
            completedReadingCount: completed,
            totalReadingCount: day.assignments.count,
            overallCompletionFraction: state.completionFraction,
            nextReadingTitle: nextAssignment?.displayTitle,
            nextReadingReference: nextAssignment.flatMap {
                try? $0.scriptureReference(versionID: state.snapshot.versionID)
            },
            status: state.status,
            pace: pace
        )
    }

    private func recentActivity(
        planState: ActiveReadingPlanState?
    ) throws -> [HomeRecentActivity] {
        var activity: [HomeRecentActivity] = []

        let providerID = ScriptureProviderIdentifier.youVersion.rawValue
        if let position = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV1.ReadingPosition>(
                sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
            )
        ).first(where: {
            $0.deletedAt == nil && $0.editionProviderID == providerID
        }) {
            let book =
                CatholicCanon.book(osisID: position.canonicalBookID)?.displayName
                ?? position.canonicalBookID
            activity.append(
                HomeRecentActivity(
                    id: "reading-\(position.id.uuidString)",
                    kind: .scripture,
                    title: "Last read \(book) \(position.chapter)",
                    occurredAt: position.modifiedAt
                )
            )
        }

        let assignmentTitles = Dictionary(
            uniqueKeysWithValues: planState?.snapshot.days.flatMap { day in
                day.assignments.map { ($0.id, $0.displayTitle) }
            } ?? []
        )
        let planEvents = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV2.PlanAssignmentCompletionEvent>(
                sortBy: [SortDescriptor(\.occurredAt, order: .reverse)]
            )
        ).filter { planState == nil || $0.planID == planState?.snapshot.id }
        var seenPlanAssignments: Set<String> = []
        for event in planEvents where seenPlanAssignments.insert(event.assignmentID).inserted {
            let reading = assignmentTitles[event.assignmentID] ?? "a plan reading"
            let verb = event.action == .completed ? "Completed" : "Reopened"
            activity.append(
                HomeRecentActivity(
                    id: "plan-\(event.id.uuidString)",
                    kind: .plan,
                    title: "\(verb) \(reading)",
                    occurredAt: event.occurredAt
                )
            )
        }

        let annotations = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV1.ScriptureAnnotation>(
                sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
            )
        )
        for annotation in annotations.prefix(3) {
            activity.append(
                HomeRecentActivity(
                    id: "annotation-\(annotation.id.uuidString)",
                    kind: .annotation,
                    title: annotationActivityTitle(annotation),
                    occurredAt: annotation.modifiedAt
                )
            )
        }

        let learning = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV1.LearningProgress>(
                sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
            )
        ).filter { $0.deletedAt == nil }
        for progress in learning.prefix(3) {
            let topic = LearningTopicCatalog.topic(id: progress.contentID)?.title ?? "a learning topic"
            let verb = progress.status == .completed ? "Completed" : "Continued"
            activity.append(
                HomeRecentActivity(
                    id: "learning-\(progress.id.uuidString)",
                    kind: .learning,
                    title: "\(verb) \(topic)",
                    occurredAt: progress.modifiedAt
                )
            )
        }

        return Array(
            activity.sorted {
                if $0.occurredAt == $1.occurredAt { return $0.id < $1.id }
                return $0.occurredAt > $1.occurredAt
            }.prefix(5)
        )
    }

    private func annotationActivityTitle(
        _ annotation: BibleStudySchemaV1.ScriptureAnnotation
    ) -> String {
        let action = annotation.deletedAt == nil ? "Updated" : "Removed"
        switch annotation.kind {
        case .bookmark: return "\(action) a private bookmark"
        case .highlight: return "\(action) a private highlight"
        case .note: return "\(action) a private note"
        }
    }

    private func planActivityStreak(
        planID: UUID?,
        asOf date: Date,
        calendar: Calendar
    ) throws -> Int {
        guard let planID else { return 0 }
        let events = try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV2.PlanAssignmentCompletionEvent>(
                sortBy: [SortDescriptor(\.occurredAt), SortDescriptor(\.id)]
            )
        ).filter { $0.planID == planID && $0.occurredAt <= date }

        var latestByAssignment: [String: BibleStudySchemaV2.PlanAssignmentCompletionEvent] = [:]
        for event in events {
            latestByAssignment[event.assignmentID] = event
        }
        let activeDates = Set(
            latestByAssignment.values.compactMap { event in
                event.action == .completed ? calendar.startOfDay(for: event.occurredAt) : nil
            }
        )
        guard !activeDates.isEmpty else { return 0 }

        let today = calendar.startOfDay(for: date)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        var cursor: Date
        if activeDates.contains(today) {
            cursor = today
        } else if activeDates.contains(yesterday) {
            cursor = yesterday
        } else {
            return 0
        }

        var streak = 0
        while activeDates.contains(cursor) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previous
        }
        return streak
    }

    private func referenceTitle(_ reference: ScriptureReference) -> String {
        let book = CatholicCanon.book(osisID: reference.bookID)?.displayName ?? reference.bookID
        guard let verse = reference.verseStart else {
            return "\(book) \(reference.chapter)"
        }
        return "\(book) \(reference.chapter):\(verse)"
    }
}

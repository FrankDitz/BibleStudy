import Foundation

enum ActiveReadingPlanSource: String, Codable, Hashable, Sendable {
    case template
    case custom
}

enum ActiveReadingPlanCoverStyle: String, CaseIterable, Codable, Hashable, Sendable {
    case burgundy
    case evergreen
    case midnight
    case parchment
}

struct ActiveReadingPlanSnapshot: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let source: ActiveReadingPlanSource
    let sourceID: String?
    let sourceRevision: Int?
    let title: String
    let summary: String
    let versionID: Int
    let canonManifestID: String
    let canonManifestRevision: Int
    let days: [ReadingPlanTemplateDay]
    var schedule: [PlanScheduledDay]
    let eligibleWeekdays: Set<PlanWeekday>
    let recoveryPreference: CustomPlanRecoveryPreference
    let reminderTime: PlanReminderTime?
    let coverStyle: ActiveReadingPlanCoverStyle
    let createdAt: Date

    var assignmentIDs: Set<String> {
        Set(days.flatMap(\.assignments).map(\.id))
    }

    func day(_ logicalDayIndex: Int) -> ReadingPlanTemplateDay? {
        days.first { $0.logicalDayIndex == logicalDayIndex }
    }

    func scheduledDay(_ logicalDayIndex: Int) -> PlanScheduledDay? {
        schedule.first { $0.logicalDayIndex == logicalDayIndex }
    }

    /// Converts snapshots made before chapter-level completion into the current checklist shape.
    /// The original payload can remain readable while new completion events target one chapter.
    func separatingChapterAssignments() -> ActiveReadingPlanSnapshot {
        ActiveReadingPlanSnapshot(
            id: id,
            source: source,
            sourceID: sourceID,
            sourceRevision: sourceRevision,
            title: title,
            summary: summary,
            versionID: versionID,
            canonManifestID: canonManifestID,
            canonManifestRevision: canonManifestRevision,
            days: days.map { day in
                let assignments = day.assignments.flatMap { assignment in
                    separatedAssignments(for: assignment)
                }.enumerated().map { offset, assignment in
                    ReadingPlanAssignment(
                        id: assignment.id,
                        position: offset + 1,
                        bookID: assignment.bookID,
                        startChapter: assignment.startChapter,
                        endChapter: assignment.endChapter,
                        verseStart: assignment.verseStart,
                        verseEnd: assignment.verseEnd
                    )
                }
                return ReadingPlanTemplateDay(
                    logicalDayIndex: day.logicalDayIndex,
                    assignments: assignments
                )
            },
            schedule: schedule,
            eligibleWeekdays: eligibleWeekdays,
            recoveryPreference: recoveryPreference,
            reminderTime: reminderTime,
            coverStyle: coverStyle,
            createdAt: createdAt
        )
    }

    func chapterAssignmentIDsByOriginalID() -> [String: [String]] {
        Dictionary(
            uniqueKeysWithValues: days.flatMap { day in
                day.assignments.map { assignment in
                    (assignment.id, separatedAssignments(for: assignment).map(\.id))
                }
            })
    }

    private func separatedAssignments(
        for assignment: ReadingPlanAssignment
    ) -> [ReadingPlanAssignment] {
        guard assignment.startChapter < assignment.endChapter,
            assignment.verseStart == nil
        else {
            return [assignment]
        }
        return (assignment.startChapter...assignment.endChapter).map { chapter in
            ReadingPlanAssignment(
                id: "\(assignment.id).chapter-\(chapter)",
                position: assignment.position,
                bookID: assignment.bookID,
                startChapter: chapter,
                endChapter: chapter
            )
        }
    }

    static func make(
        template: ReadingPlanTemplate,
        startDate: PlanLocalDate,
        eligibleWeekdays: Set<PlanWeekday>,
        calendar: Calendar = .current,
        id: UUID = UUID(),
        createdAt: Date = .now
    ) throws -> ActiveReadingPlanSnapshot {
        let schedule = try ReadingPlanScheduler(calendar: calendar).schedule(
            logicalDayCount: template.days.count,
            rules: PlanScheduleRules(
                startDate: startDate,
                eligibleWeekdays: eligibleWeekdays
            )
        )
        guard let versionID = template.compatibleVersionIDs.min() else {
            throw ActiveReadingPlanError.noCompatibleVersion
        }
        return ActiveReadingPlanSnapshot(
            id: id,
            source: .template,
            sourceID: template.id,
            sourceRevision: template.revision,
            title: template.title,
            summary: template.summary,
            versionID: versionID,
            canonManifestID: template.canonManifestID,
            canonManifestRevision: template.canonManifestRevision,
            days: template.days,
            schedule: schedule,
            eligibleWeekdays: eligibleWeekdays,
            recoveryPreference: .keepDates,
            reminderTime: nil,
            coverStyle: coverStyle(for: template.id),
            createdAt: createdAt
        ).separatingChapterAssignments()
    }

    static func make(
        preview: CustomReadingPlanPreview,
        versionID: Int = YouVersionCatalogPolicy.developmentDefaultVersionID,
        id: UUID = UUID(),
        createdAt: Date = .now
    ) -> ActiveReadingPlanSnapshot {
        ActiveReadingPlanSnapshot(
            id: id,
            source: .custom,
            sourceID: nil,
            sourceRevision: nil,
            title: preview.normalizedTitle,
            summary: "A personal Scripture plan built around your chosen scope and pace.",
            versionID: versionID,
            canonManifestID: CatholicChapterManifest.cpdvV1.id,
            canonManifestRevision: CatholicChapterManifest.cpdvV1.revision,
            days: preview.days,
            schedule: preview.schedule,
            eligibleWeekdays: preview.draft.eligibleWeekdays,
            recoveryPreference: preview.draft.recoveryPreference,
            reminderTime: preview.draft.reminderTime,
            coverStyle: .burgundy,
            createdAt: createdAt
        ).separatingChapterAssignments()
    }

    static func coverStyle(for identifier: String) -> ActiveReadingPlanCoverStyle {
        let styles = ActiveReadingPlanCoverStyle.allCases
        let checksum = identifier.utf8.reduce(0) { $0 + Int($1) }
        return styles[checksum % styles.count]
    }
}

struct ActiveReadingPlanState: Hashable, Sendable {
    var snapshot: ActiveReadingPlanSnapshot
    var completedAssignmentIDs: Set<String>
    var status: ReadingPlanStatus
    var pausedOn: PlanLocalDate?

    var completedDayIndices: Set<Int> {
        Set(
            snapshot.days.compactMap { day in
                guard !day.assignments.isEmpty,
                    day.assignments.allSatisfy({ completedAssignmentIDs.contains($0.id) })
                else {
                    return nil
                }
                return day.logicalDayIndex
            }
        )
    }

    var completedAssignmentCount: Int {
        completedAssignmentIDs.intersection(snapshot.assignmentIDs).count
    }

    var totalAssignmentCount: Int {
        snapshot.assignmentIDs.count
    }

    var completionFraction: Double {
        guard totalAssignmentCount > 0 else { return 0 }
        return Double(completedAssignmentCount) / Double(totalAssignmentCount)
    }

    func isAssignmentComplete(_ assignmentID: String) -> Bool {
        completedAssignmentIDs.contains(assignmentID)
    }

    func firstIncompleteAssignment(on logicalDayIndex: Int) -> ReadingPlanAssignment? {
        snapshot.day(logicalDayIndex)?.assignments.first {
            !completedAssignmentIDs.contains($0.id)
        }
    }

    func firstAssignment(on logicalDayIndex: Int) -> ReadingPlanAssignment? {
        snapshot.day(logicalDayIndex)?.assignments.first
    }

    func nextDueDayIndex(asOf date: PlanLocalDate) -> Int {
        if let overdueOrToday = snapshot.schedule.first(where: {
            $0.scheduledDate <= date && !completedDayIndices.contains($0.logicalDayIndex)
        }) {
            return overdueOrToday.logicalDayIndex
        }
        if let next = snapshot.schedule.first(where: {
            !completedDayIndices.contains($0.logicalDayIndex)
        }) {
            return next.logicalDayIndex
        }
        return snapshot.schedule.last?.logicalDayIndex ?? 1
    }

    func progress(asOf date: PlanLocalDate, calendar: Calendar = .current) -> PlanProgressSnapshot {
        let events = completedDayIndices.map {
            PlanDayCompletionEvent(
                logicalDayIndex: $0,
                action: .completed,
                occurredAt: .distantPast,
                deviceID: "derived-assignment-state"
            )
        }
        return ReadingPlanScheduler(calendar: calendar).progress(
            schedule: snapshot.schedule,
            events: events,
            asOf: date
        )
    }
}

enum ActiveReadingPlanError: Error, Equatable {
    case noCompatibleVersion
    case corruptPayload
    case noActivePlan
    case unknownAssignment
}

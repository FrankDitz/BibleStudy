import Foundation

struct CustomPlanPassage: Hashable, Sendable {
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
        guard chapter > 0 else {
            throw ValidationError.invalidChapter
        }
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
}

enum CustomReadingPlanScope: Hashable, Sendable {
    case catholicBible
    case testament(BiblicalTestament)
    case books(Set<String>)
    case passage(CustomPlanPassage)
}

enum CustomPlanPace: Hashable, Sendable {
    case chaptersPerReadingDay(Int)
    case finishBy(PlanLocalDate)
}

enum CustomPlanOrdering: String, CaseIterable, Hashable, Sendable {
    case canonical
    case interleaveTestaments
}

enum CustomPlanRecoveryPreference: String, CaseIterable, Codable, Hashable, Sendable {
    case keepDates
    case shiftForward
    case redistribute
    case chooseNewFinishDate
}

struct PlanReminderTime: Codable, Hashable, Sendable {
    let hour: Int
    let minute: Int
}

struct CustomReadingPlanDraft: Hashable, Sendable {
    let title: String
    let scope: CustomReadingPlanScope
    let pace: CustomPlanPace
    let startDate: PlanLocalDate
    let eligibleWeekdays: Set<PlanWeekday>
    let ordering: CustomPlanOrdering
    let recoveryPreference: CustomPlanRecoveryPreference
    let reminderTime: PlanReminderTime?
}

enum CustomPlanPreviewWarning: Hashable, Sendable {
    case demandingDailyLoad(maximumChapters: Int)
}

struct CustomReadingPlanPreview: Hashable, Sendable {
    let draft: CustomReadingPlanDraft
    let normalizedTitle: String
    let days: [ReadingPlanTemplateDay]
    let schedule: [PlanScheduledDay]
    let totalChapterCount: Int
    let minimumDailyChapters: Int
    let maximumDailyChapters: Int
    let averageDailyChapters: Double
    let estimatedDailyMinutes: ClosedRange<Int>
    let calendarDaySpan: Int
    let restDayCount: Int
    let warnings: Set<CustomPlanPreviewWarning>

    var readingDayCount: Int { days.count }
    var scheduledStartDate: PlanLocalDate? { schedule.first?.scheduledDate }
    var scheduledFinishDate: PlanLocalDate? { schedule.last?.scheduledDate }
}

enum ReadingPlanComposerError: Error, Equatable {
    case blankTitle
    case titleTooLong
    case emptyScope
    case invalidScopeBook(String)
    case passageOutsideManifest
    case emptyEligibleWeekdays
    case invalidChapterPace
    case finishDateBeforeStartDate
    case invalidReminderTime
    case interleavingRequiresBothTestaments
    case noEligibleDates
    case invalidSchedule
}

struct ReadingPlanComposer: Sendable {
    private let calendar: Calendar
    private let manifest: CatholicChapterManifest

    init(
        calendar: Calendar = .current,
        manifest: CatholicChapterManifest = .cpdvV1
    ) {
        self.calendar = calendar
        self.manifest = manifest
    }

    func preview(_ draft: CustomReadingPlanDraft) throws -> CustomReadingPlanPreview {
        let normalizedTitle = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedTitle.isEmpty else { throw ReadingPlanComposerError.blankTitle }
        guard normalizedTitle.count <= 80 else { throw ReadingPlanComposerError.titleTooLong }
        guard !draft.eligibleWeekdays.isEmpty else {
            throw ReadingPlanComposerError.emptyEligibleWeekdays
        }
        if let reminder = draft.reminderTime {
            guard (0...23).contains(reminder.hour), (0...59).contains(reminder.minute) else {
                throw ReadingPlanComposerError.invalidReminderTime
            }
        }

        let orderedUnits = try readingUnits(for: draft.scope, ordering: draft.ordering)
        guard !orderedUnits.isEmpty else { throw ReadingPlanComposerError.emptyScope }

        let rules = PlanScheduleRules(
            startDate: draft.startDate,
            eligibleWeekdays: draft.eligibleWeekdays
        )
        let scheduler = ReadingPlanScheduler(calendar: calendar)
        let unitGroups: [[ReadingUnit]]
        let schedule: [PlanScheduledDay]

        switch draft.pace {
        case .chaptersPerReadingDay(let chapterCount):
            guard (1...50).contains(chapterCount) else {
                throw ReadingPlanComposerError.invalidChapterPace
            }
            unitGroups = orderedUnits.chunked(maximumCount: chapterCount)
            do {
                schedule = try scheduler.schedule(
                    logicalDayCount: unitGroups.count,
                    rules: rules
                )
            } catch {
                throw mapScheduleError(error)
            }

        case .finishBy(let finishDate):
            guard finishDate >= draft.startDate else {
                throw ReadingPlanComposerError.finishDateBeforeStartDate
            }
            let eligibleDates: [PlanLocalDate]
            do {
                eligibleDates = try scheduler.eligibleDates(
                    from: draft.startDate,
                    through: finishDate,
                    rules: rules
                )
            } catch {
                throw mapScheduleError(error)
            }
            guard !eligibleDates.isEmpty else { throw ReadingPlanComposerError.noEligibleDates }

            let readingDayCount = min(orderedUnits.count, eligibleDates.count)
            unitGroups = orderedUnits.balancedGroups(count: readingDayCount)
            do {
                schedule = try scheduler.schedule(
                    logicalDayCount: readingDayCount,
                    rules: rules,
                    through: finishDate
                )
            } catch {
                throw mapScheduleError(error)
            }
        }

        let days = makeDays(from: unitGroups)
        guard days.count == schedule.count else {
            throw ReadingPlanComposerError.invalidSchedule
        }

        let dailyChapterCounts = days.map(\.chapterCount)
        guard let minimumDailyChapters = dailyChapterCounts.min(),
            let maximumDailyChapters = dailyChapterCounts.max(),
            let scheduledStartDate = schedule.first?.scheduledDate,
            let scheduledFinishDate = schedule.last?.scheduledDate
        else {
            throw ReadingPlanComposerError.invalidSchedule
        }

        let totalChapterCount = dailyChapterCounts.reduce(0, +)
        let averageDailyChapters = Double(totalChapterCount) / Double(days.count)
        let estimatedDailyMinutes =
            max(
                3, minimumDailyChapters * 4)...max(
                8,
                maximumDailyChapters * 6
            )
        let calendarDaySpan = try inclusiveDayCount(
            from: scheduledStartDate,
            through: scheduledFinishDate
        )
        var warnings: Set<CustomPlanPreviewWarning> = []
        if maximumDailyChapters >= 10 {
            warnings.insert(.demandingDailyLoad(maximumChapters: maximumDailyChapters))
        }

        return CustomReadingPlanPreview(
            draft: draft,
            normalizedTitle: normalizedTitle,
            days: days,
            schedule: schedule,
            totalChapterCount: totalChapterCount,
            minimumDailyChapters: minimumDailyChapters,
            maximumDailyChapters: maximumDailyChapters,
            averageDailyChapters: averageDailyChapters,
            estimatedDailyMinutes: estimatedDailyMinutes,
            calendarDaySpan: calendarDaySpan,
            restDayCount: max(0, calendarDaySpan - days.count),
            warnings: warnings
        )
    }

    private func readingUnits(
        for scope: CustomReadingPlanScope,
        ordering: CustomPlanOrdering
    ) throws -> [ReadingUnit] {
        let canonicalUnits: [ReadingUnit]
        switch scope {
        case .catholicBible:
            canonicalUnits = manifest.allChapters.map(ReadingUnit.init)
        case .testament(let testament):
            canonicalUnits = manifest.chapters(in: testament).map(ReadingUnit.init)
        case .books(let bookIDs):
            guard !bookIDs.isEmpty else { throw ReadingPlanComposerError.emptyScope }
            let normalizedBookIDs = Set(
                bookIDs.map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                }
            )
            for bookID in normalizedBookIDs
            where !manifest.chapterCountByBookID.keys.contains(bookID) {
                throw ReadingPlanComposerError.invalidScopeBook(bookID)
            }
            canonicalUnits = manifest.chapters(inBookIDs: normalizedBookIDs).map(ReadingUnit.init)
        case .passage(let passage):
            let chapter = CanonicalChapter(bookID: passage.bookID, chapter: passage.chapter)
            guard manifest.contains(chapter) else {
                throw ReadingPlanComposerError.passageOutsideManifest
            }
            canonicalUnits = [
                ReadingUnit(
                    bookID: passage.bookID,
                    chapter: passage.chapter,
                    verseStart: passage.verseStart,
                    verseEnd: passage.verseEnd
                )
            ]
        }

        guard ordering == .interleaveTestaments else { return canonicalUnits }
        let oldTestament = canonicalUnits.filter { unit in
            CatholicCanon.book(osisID: unit.bookID)?.testament == .old
        }
        let newTestament = canonicalUnits.filter { unit in
            CatholicCanon.book(osisID: unit.bookID)?.testament == .new
        }
        guard !oldTestament.isEmpty, !newTestament.isEmpty else {
            throw ReadingPlanComposerError.interleavingRequiresBothTestaments
        }
        return proportionallyInterleave(oldTestament, newTestament)
    }

    private func proportionallyInterleave(
        _ oldTestament: [ReadingUnit],
        _ newTestament: [ReadingUnit]
    ) -> [ReadingUnit] {
        let totalCount = oldTestament.count + newTestament.count
        var oldIndex = 0
        var newIndex = 0
        var result: [ReadingUnit] = []
        result.reserveCapacity(totalCount)

        for position in 0..<totalCount {
            let expectedNewCount = (position + 1) * newTestament.count / totalCount
            if newIndex < expectedNewCount {
                result.append(newTestament[newIndex])
                newIndex += 1
            } else {
                result.append(oldTestament[oldIndex])
                oldIndex += 1
            }
        }
        return result
    }

    private func makeDays(from groups: [[ReadingUnit]]) -> [ReadingPlanTemplateDay] {
        groups.enumerated().map { dayOffset, units in
            let logicalDayIndex = dayOffset + 1
            let assignments = assignmentRuns(in: units).enumerated().map {
                assignmentOffset, run in
                let position = assignmentOffset + 1
                return ReadingPlanAssignment(
                    id: "custom-preview.d\(logicalDayIndex).a\(position)",
                    position: position,
                    bookID: run.bookID,
                    startChapter: run.startChapter,
                    endChapter: run.endChapter,
                    verseStart: run.verseStart,
                    verseEnd: run.verseEnd
                )
            }
            return ReadingPlanTemplateDay(
                logicalDayIndex: logicalDayIndex,
                assignments: assignments
            )
        }
    }

    private func assignmentRuns(in units: [ReadingUnit]) -> [AssignmentRun] {
        units.reduce(into: []) { runs, unit in
            if let lastIndex = runs.indices.last,
                runs[lastIndex].verseStart == nil,
                unit.verseStart == nil,
                runs[lastIndex].bookID == unit.bookID,
                runs[lastIndex].endChapter + 1 == unit.chapter
            {
                runs[lastIndex].endChapter = unit.chapter
            } else {
                runs.append(
                    AssignmentRun(
                        bookID: unit.bookID,
                        startChapter: unit.chapter,
                        endChapter: unit.chapter,
                        verseStart: unit.verseStart,
                        verseEnd: unit.verseEnd
                    )
                )
            }
        }
    }

    private func inclusiveDayCount(
        from startDate: PlanLocalDate,
        through finishDate: PlanLocalDate
    ) throws -> Int {
        let start = try foundationDate(for: startDate)
        let finish = try foundationDate(for: finishDate)
        let difference = calendar.dateComponents([.day], from: start, to: finish).day
        guard let difference, difference >= 0 else {
            throw ReadingPlanComposerError.invalidSchedule
        }
        return difference + 1
    }

    private func foundationDate(for localDate: PlanLocalDate) throws -> Date {
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: localDate.year,
            month: localDate.month,
            day: localDate.day,
            hour: 12
        )
        guard let date = calendar.date(from: components),
            PlanLocalDate(date, calendar: calendar) == localDate
        else {
            throw ReadingPlanComposerError.invalidSchedule
        }
        return date
    }

    private func mapScheduleError(_ error: Error) -> ReadingPlanComposerError {
        guard let schedulerError = error as? ReadingPlanSchedulerError else {
            return .invalidSchedule
        }
        switch schedulerError {
        case .emptyEligibleWeekdays:
            return .emptyEligibleWeekdays
        case .finishDateBeforeRecoveryDate:
            return .finishDateBeforeStartDate
        case .noEligibleRecoveryDates:
            return .noEligibleDates
        case .invalidLogicalDayCount, .invalidLocalDate, .invalidPauseRange:
            return .invalidSchedule
        }
    }

    private struct ReadingUnit: Hashable {
        let bookID: String
        let chapter: Int
        let verseStart: Int?
        let verseEnd: Int?

        init(_ chapter: CanonicalChapter) {
            self.init(
                bookID: chapter.bookID,
                chapter: chapter.chapter,
                verseStart: nil,
                verseEnd: nil
            )
        }

        init(
            bookID: String,
            chapter: Int,
            verseStart: Int?,
            verseEnd: Int?
        ) {
            self.bookID = bookID
            self.chapter = chapter
            self.verseStart = verseStart
            self.verseEnd = verseEnd
        }
    }

    private struct AssignmentRun {
        let bookID: String
        let startChapter: Int
        var endChapter: Int
        let verseStart: Int?
        let verseEnd: Int?
    }
}

extension Array {
    fileprivate func chunked(maximumCount: Int) -> [[Element]] {
        stride(from: 0, to: count, by: maximumCount).map { startIndex in
            Array(self[startIndex..<Swift.min(startIndex + maximumCount, count)])
        }
    }

    fileprivate func balancedGroups(count groupCount: Int) -> [[Element]] {
        precondition(groupCount > 0 && groupCount <= count)
        let baseCount = count / groupCount
        let groupsWithExtraElement = count % groupCount
        var nextIndex = 0

        return (0..<groupCount).map { groupIndex in
            let elementCount = baseCount + (groupIndex < groupsWithExtraElement ? 1 : 0)
            defer { nextIndex += elementCount }
            return Array(self[nextIndex..<(nextIndex + elementCount)])
        }
    }
}

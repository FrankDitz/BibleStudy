import Foundation

enum ReadingPlanScope: Hashable, Sendable {
    case catholicBible
    case testament(BiblicalTestament)
    case books(Set<String>)
    case deuterocanonicalBooksAndAdditions

    func chapters(in manifest: CatholicChapterManifest) -> [CanonicalChapter] {
        switch self {
        case .catholicBible:
            return manifest.allChapters
        case .testament(let testament):
            return manifest.chapters(in: testament)
        case .books(let bookIDs):
            return manifest.chapters(inBookIDs: bookIDs)
        case .deuterocanonicalBooksAndAdditions:
            return manifest.allChapters.filter { chapter in
                let isDeuterocanonical =
                    CatholicCanon.book(osisID: chapter.bookID)?
                    .isDeuterocanonical == true
                let isEstherAddition = chapter.bookID == "ESTH" && chapter.chapter >= 11
                let isDanielAddition = chapter.bookID == "DAN" && chapter.chapter >= 13
                return isDeuterocanonical || isEstherAddition || isDanielAddition
            }
        }
    }
}

enum ReadingPlanCanonRequirement: String, Hashable, Sendable {
    case catholic73Book
}

struct ReadingPlanTemplateProvenance: Hashable, Sendable {
    let author: String
    let reviewer: String
    let revisionDate: PlanLocalDate
}

struct ReadingPlanAssignment: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let position: Int
    let bookID: String
    let startChapter: Int
    let endChapter: Int
    let verseStart: Int?
    let verseEnd: Int?

    init(
        id: String,
        position: Int,
        bookID: String,
        startChapter: Int,
        endChapter: Int,
        verseStart: Int? = nil,
        verseEnd: Int? = nil
    ) {
        self.id = id
        self.position = position
        self.bookID = bookID
        self.startChapter = startChapter
        self.endChapter = endChapter
        self.verseStart = verseStart
        self.verseEnd = verseEnd ?? verseStart
    }

    var chapterCount: Int {
        max(0, endChapter - startChapter + 1)
    }

    var chapters: [CanonicalChapter] {
        guard startChapter > 0, endChapter >= startChapter else { return [] }
        return (startChapter...endChapter).map {
            CanonicalChapter(bookID: bookID, chapter: $0)
        }
    }

    func scriptureReference(versionID: Int) throws -> ScriptureReference {
        try ScriptureReference(
            versionID: versionID,
            bookID: bookID,
            chapter: startChapter,
            verseStart: verseStart,
            verseEnd: verseEnd
        )
    }
}

struct ReadingPlanTemplateDay: Codable, Identifiable, Hashable, Sendable {
    let logicalDayIndex: Int
    let assignments: [ReadingPlanAssignment]

    var id: Int { logicalDayIndex }

    var chapterCount: Int {
        assignments.reduce(0) { $0 + $1.chapterCount }
    }
}

struct ReadingPlanTemplate: Identifiable, Hashable, Sendable {
    let id: String
    let revision: Int
    let title: String
    let summary: String
    let estimatedDailyMinutes: ClosedRange<Int>
    let scope: ReadingPlanScope
    let canonRequirement: ReadingPlanCanonRequirement
    let canonManifestID: String
    let canonManifestRevision: Int
    let compatibleVersionIDs: Set<Int>
    let suggestedCatchUpDayIndices: Set<Int>
    let provenance: ReadingPlanTemplateProvenance
    let days: [ReadingPlanTemplateDay]

    var durationDays: Int { days.count }

    var chapterCount: Int {
        days.reduce(0) { $0 + $1.chapterCount }
    }

    /// Stable snapshot used by tests to require a revision bump when assignments change.
    var assignmentFingerprint: String {
        let serializedAssignments = days.flatMap { day in
            day.assignments.map { assignment in
                let verseSuffix: String
                if let verseStart = assignment.verseStart {
                    verseSuffix = ":\(verseStart)-\(assignment.verseEnd ?? verseStart)"
                } else {
                    verseSuffix = ""
                }
                return
                    "\(day.logicalDayIndex):\(assignment.position):\(assignment.bookID):\(assignment.startChapter)-\(assignment.endChapter)\(verseSuffix)"
            }
        }.joined(separator: ";")
        let snapshot = "\(id).v\(revision)|\(canonManifestID).v\(canonManifestRevision)|\(serializedAssignments)"
        let hash = snapshot.utf8.reduce(into: UInt64(14_695_981_039_346_656_037)) {
            result, byte in
            result ^= UInt64(byte)
            result &*= 1_099_511_628_211
        }
        return String(format: "%016llx", hash)
    }

    var firstReading: ScriptureReference? {
        guard let versionID = compatibleVersionIDs.min() else { return nil }
        return previewReference(versionID: versionID)
    }

    func previewReference(versionID: Int) -> ScriptureReference? {
        guard compatibleVersionIDs.contains(versionID),
            let firstAssignment = days.first?.assignments.first
        else {
            return nil
        }
        return try? firstAssignment.scriptureReference(versionID: versionID)
    }

    static let featured = ReadingPlanTemplateCatalog.all
}

enum ReadingPlanTemplateValidationIssue: Hashable, Sendable {
    case invalidTemplateRevision
    case invalidEstimatedDailyMinutes
    case manifestIdentityMismatch
    case noCompatibleVersion
    case incompatibleVersion(Int)
    case unknownScopeBook(String)
    case invalidCatchUpDay(Int)
    case nonsequentialDay(expected: Int, actual: Int)
    case emptyDay(Int)
    case nonsequentialAssignment(day: Int, expected: Int, actual: Int)
    case invalidAssignment(String)
    case duplicateChapter(CanonicalChapter)
    case missingChapter(CanonicalChapter)
    case unexpectedChapter(CanonicalChapter)
}

enum ReadingPlanTemplateValidator {
    static func validate(
        _ template: ReadingPlanTemplate,
        against manifest: CatholicChapterManifest
    ) -> Set<ReadingPlanTemplateValidationIssue> {
        var issues: Set<ReadingPlanTemplateValidationIssue> = []

        if template.revision < 1 {
            issues.insert(.invalidTemplateRevision)
        }
        if template.estimatedDailyMinutes.lowerBound < 1
            || template.estimatedDailyMinutes.upperBound
                < template.estimatedDailyMinutes.lowerBound
        {
            issues.insert(.invalidEstimatedDailyMinutes)
        }
        if template.canonManifestID != manifest.id
            || template.canonManifestRevision != manifest.revision
        {
            issues.insert(.manifestIdentityMismatch)
        }
        if template.compatibleVersionIDs.isEmpty {
            issues.insert(.noCompatibleVersion)
        }
        for versionID in template.compatibleVersionIDs
        where !manifest.compatibleVersionIDs.contains(versionID) {
            issues.insert(.incompatibleVersion(versionID))
        }
        if case .books(let bookIDs) = template.scope {
            for bookID in bookIDs where !manifest.chapterCountByBookID.keys.contains(bookID) {
                issues.insert(.unknownScopeBook(bookID))
            }
        }
        for dayIndex in template.suggestedCatchUpDayIndices
        where !(1...template.days.count).contains(dayIndex) {
            issues.insert(.invalidCatchUpDay(dayIndex))
        }

        var assignedChapterCounts: [CanonicalChapter: Int] = [:]
        for (dayOffset, day) in template.days.enumerated() {
            let expectedDay = dayOffset + 1
            if day.logicalDayIndex != expectedDay {
                issues.insert(
                    .nonsequentialDay(expected: expectedDay, actual: day.logicalDayIndex)
                )
            }
            if day.assignments.isEmpty {
                issues.insert(.emptyDay(day.logicalDayIndex))
            }

            for (assignmentOffset, assignment) in day.assignments.enumerated() {
                let expectedPosition = assignmentOffset + 1
                if assignment.position != expectedPosition {
                    issues.insert(
                        .nonsequentialAssignment(
                            day: day.logicalDayIndex,
                            expected: expectedPosition,
                            actual: assignment.position
                        )
                    )
                }

                guard assignment.startChapter > 0,
                    assignment.endChapter >= assignment.startChapter,
                    !assignment.chapters.isEmpty,
                    assignment.chapters.allSatisfy(manifest.contains),
                    assignment.verseStart.map({ $0 > 0 }) ?? true,
                    assignment.verseEnd.map({ end in
                        guard let start = assignment.verseStart else { return false }
                        return end >= start && assignment.startChapter == assignment.endChapter
                    }) ?? (assignment.verseStart == nil)
                else {
                    issues.insert(.invalidAssignment(assignment.id))
                    continue
                }

                for chapter in assignment.chapters {
                    assignedChapterCounts[chapter, default: 0] += 1
                }
            }
        }

        let expectedChapters = Set(template.scope.chapters(in: manifest))
        let assignedChapters = Set(assignedChapterCounts.keys)

        for (chapter, count) in assignedChapterCounts where count > 1 {
            issues.insert(.duplicateChapter(chapter))
        }
        for chapter in expectedChapters.subtracting(assignedChapters) {
            issues.insert(.missingChapter(chapter))
        }
        for chapter in assignedChapters.subtracting(expectedChapters) {
            issues.insert(.unexpectedChapter(chapter))
        }

        return issues
    }
}

enum ReadingPlanTemplateCatalog {
    private static let manifest = CatholicChapterManifest.cpdvV1

    static let all: [ReadingPlanTemplate] = [
        balancedTemplate(
            id: "new-testament-90",
            title: "New Testament in 90 Days",
            summary: "A focused daily path through the life of Christ and the early Church.",
            scope: .testament(.new),
            estimatedDailyMinutes: 12...18,
            dayCount: 90
        ),
        balancedTemplate(
            id: "catholic-old-testament-90",
            title: "Catholic Old Testament in 90 Days",
            summary: "A brisk path through all 46 Old Testament books in the Catholic canon.",
            scope: .testament(.old),
            estimatedDailyMinutes: 45...60,
            dayCount: 90
        ),
        balancedTemplate(
            id: "catholic-bible-365",
            title: "Catholic Bible in a Year",
            summary: "Read every chapter of the 73-book Catholic Bible with daily accountability.",
            scope: .catholicBible,
            estimatedDailyMinutes: 15...25,
            dayCount: 365
        ),
        balancedTemplate(
            id: "gospels-30",
            title: "The Gospels in 30 Days",
            summary: "Walk through Matthew, Mark, Luke, and John in one focused month.",
            scope: .books(["MATT", "MARK", "LUKE", "JOHN"]),
            estimatedDailyMinutes: 12...18,
            dayCount: 30
        ),
        psalmsAndProverbsTemplate(),
        balancedTemplate(
            id: "start-with-jesus-21",
            title: "Start with Jesus",
            summary: "Begin with one chapter of John's Gospel each day for three weeks.",
            scope: .books(["JOHN"]),
            estimatedDailyMinutes: 5...10,
            dayCount: 21
        ),
        balancedTemplate(
            id: "catholic-deuterocanon-30",
            title: "Catholic Deuterocanon in 30 Days",
            summary:
                "Read the seven deuterocanonical books plus the Catholic additions to Esther and Daniel.",
            scope: .deuterocanonicalBooksAndAdditions,
            estimatedDailyMinutes: 20...30,
            dayCount: 30
        ),
    ]

    private static func balancedTemplate(
        id: String,
        title: String,
        summary: String,
        scope: ReadingPlanScope,
        estimatedDailyMinutes: ClosedRange<Int>,
        dayCount: Int
    ) -> ReadingPlanTemplate {
        let chapters = scope.chapters(in: manifest)
        precondition(dayCount > 0 && chapters.count >= dayCount)

        let baseChapterCount = chapters.count / dayCount
        let daysWithExtraChapter = chapters.count % dayCount
        var nextChapterIndex = 0
        var dayChapters: [[CanonicalChapter]] = []

        for dayOffset in 0..<dayCount {
            let count = baseChapterCount + (dayOffset < daysWithExtraChapter ? 1 : 0)
            let endIndex = nextChapterIndex + count
            dayChapters.append(Array(chapters[nextChapterIndex..<endIndex]))
            nextChapterIndex = endIndex
        }

        return template(
            id: id,
            title: title,
            summary: summary,
            scope: scope,
            estimatedDailyMinutes: estimatedDailyMinutes,
            dayChapters: dayChapters
        )
    }

    private static func psalmsAndProverbsTemplate() -> ReadingPlanTemplate {
        let scope = ReadingPlanScope.books(["PS", "PROV"])
        let dayChapters = (1...31).map { day -> [CanonicalChapter] in
            var chapters: [CanonicalChapter] = []
            if day <= 30 {
                let firstPsalm = ((day - 1) * 5) + 1
                chapters.append(
                    contentsOf: (firstPsalm...(firstPsalm + 4)).map {
                        CanonicalChapter(bookID: "PS", chapter: $0)
                    }
                )
            }
            chapters.append(CanonicalChapter(bookID: "PROV", chapter: day))
            return chapters
        }

        return template(
            id: "psalms-proverbs-31",
            title: "Psalms and Proverbs in 31 Days",
            summary: "Pray five psalms and read one chapter of Proverbs on most days.",
            scope: scope,
            estimatedDailyMinutes: 15...25,
            dayChapters: dayChapters
        )
    }

    private static func template(
        id: String,
        title: String,
        summary: String,
        scope: ReadingPlanScope,
        estimatedDailyMinutes: ClosedRange<Int>,
        dayChapters: [[CanonicalChapter]]
    ) -> ReadingPlanTemplate {
        let revision = 1
        let days = dayChapters.enumerated().map { dayOffset, chapters in
            let logicalDayIndex = dayOffset + 1
            let runs = chapterRuns(in: chapters)
            let assignments = runs.enumerated().map { assignmentOffset, run in
                let position = assignmentOffset + 1
                return ReadingPlanAssignment(
                    id: "\(id).v\(revision).d\(logicalDayIndex).a\(position)",
                    position: position,
                    bookID: run.bookID,
                    startChapter: run.startChapter,
                    endChapter: run.endChapter
                )
            }
            return ReadingPlanTemplateDay(
                logicalDayIndex: logicalDayIndex,
                assignments: assignments
            )
        }

        return ReadingPlanTemplate(
            id: id,
            revision: revision,
            title: title,
            summary: summary,
            estimatedDailyMinutes: estimatedDailyMinutes,
            scope: scope,
            canonRequirement: .catholic73Book,
            canonManifestID: manifest.id,
            canonManifestRevision: manifest.revision,
            compatibleVersionIDs: manifest.compatibleVersionIDs,
            suggestedCatchUpDayIndices: [],
            provenance: ReadingPlanTemplateProvenance(
                author: "Bible Study",
                reviewer: "Catholic canon validator",
                revisionDate: PlanLocalDate(year: 2026, month: 10, day: 12)
            ),
            days: days
        )
    }

    private static func chapterRuns(in chapters: [CanonicalChapter]) -> [ChapterRun] {
        chapters.reduce(into: []) { runs, chapter in
            if let lastIndex = runs.indices.last,
                runs[lastIndex].bookID == chapter.bookID,
                runs[lastIndex].endChapter + 1 == chapter.chapter
            {
                runs[lastIndex].endChapter = chapter.chapter
            } else {
                runs.append(
                    ChapterRun(
                        bookID: chapter.bookID,
                        startChapter: chapter.chapter,
                        endChapter: chapter.chapter
                    )
                )
            }
        }
    }

    private struct ChapterRun {
        let bookID: String
        let startChapter: Int
        var endChapter: Int
    }
}

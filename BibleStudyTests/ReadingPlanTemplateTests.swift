import XCTest

@testable import BibleStudy

final class ReadingPlanTemplateTests: XCTestCase {
    private let manifest = CatholicChapterManifest.cpdvV1

    func testCPDVManifestMatchesLicensedCatholicChapterLayout() {
        XCTAssertEqual(manifest.revision, 1)
        XCTAssertEqual(manifest.compatibleVersionIDs, [42])
        XCTAssertEqual(
            Set(manifest.chapterCountByBookID.keys),
            Set(CatholicCanon.books.map(\.osisID))
        )
        XCTAssertEqual(manifest.chapterCountByBookID.count, 73)
        XCTAssertEqual(manifest.allChapters.count, 1_333)
        XCTAssertEqual(manifest.chapterCountByBookID["ESTH"], 15)
        XCTAssertEqual(manifest.chapterCountByBookID["DAN"], 14)
    }

    func testEveryBundledTemplateHasExactValidCoverage() throws {
        XCTAssertEqual(ReadingPlanTemplateCatalog.all.count, 7)
        XCTAssertEqual(
            Set(ReadingPlanTemplateCatalog.all.map(\.id)).count,
            ReadingPlanTemplateCatalog.all.count
        )

        for template in ReadingPlanTemplateCatalog.all {
            XCTAssertEqual(template.revision, 2, template.id)
            XCTAssertEqual(template.canonRequirement, .catholic73Book, template.id)
            XCTAssertGreaterThan(template.estimatedDailyMinutes.lowerBound, 0, template.id)
            XCTAssertFalse(template.provenance.author.isEmpty, template.id)
            XCTAssertFalse(template.provenance.reviewer.isEmpty, template.id)
            XCTAssertEqual(
                template.provenance.revisionDate,
                PlanLocalDate(year: 2026, month: 10, day: 13),
                template.id
            )
            XCTAssertEqual(
                ReadingPlanTemplateValidator.validate(template, against: manifest),
                [],
                template.id
            )
            XCTAssertEqual(
                Set(template.days.flatMap(\.assignments).map(\.id)).count,
                template.days.flatMap(\.assignments).count,
                template.id
            )
            XCTAssertNotNil(template.firstReading, template.id)
            XCTAssertTrue(
                template.days.flatMap(\.assignments).allSatisfy { $0.chapterCount == 1 },
                "Every reading must be independently completable: \(template.id)"
            )
        }
    }

    func testTemplateDurationsAndChapterTotalsAreStable() throws {
        let expected: [String: (days: Int, chapters: Int)] = [
            "new-testament-90": (90, 260),
            "catholic-old-testament-90": (90, 1_073),
            "catholic-bible-365": (365, 1_333),
            "gospels-30": (30, 89),
            "psalms-proverbs-31": (31, 181),
            "start-with-jesus-21": (21, 21),
            "catholic-deuterocanon-30": (30, 144),
        ]

        for (id, totals) in expected {
            let template = try XCTUnwrap(template(id))
            XCTAssertEqual(template.durationDays, totals.days, id)
            XCTAssertEqual(template.chapterCount, totals.chapters, id)
        }
    }

    func testAssignmentFingerprintsRequireARevisionForContentChanges() {
        let fingerprints = Dictionary(
            uniqueKeysWithValues: ReadingPlanTemplateCatalog.all.map {
                ($0.id, $0.assignmentFingerprint)
            }
        )
        XCTAssertEqual(
            fingerprints,
            [
                "new-testament-90": "1895269d0a4ff495",
                "catholic-old-testament-90": "0a17bf7f272f24bb",
                "catholic-bible-365": "b7db1c00168817fa",
                "gospels-30": "cecc847b44bc6532",
                "psalms-proverbs-31": "4cf005a94853c71d",
                "start-with-jesus-21": "eb3b174ed0fd6c4d",
                "catholic-deuterocanon-30": "fab40e4ced4929f4",
            ]
        )
    }

    func testBalancedTemplatesVaryByAtMostOneChapterPerDay() throws {
        let ids = [
            "new-testament-90",
            "catholic-old-testament-90",
            "catholic-bible-365",
            "gospels-30",
            "start-with-jesus-21",
            "catholic-deuterocanon-30",
        ]

        for id in ids {
            let counts = try XCTUnwrap(template(id)).days.map(\.chapterCount)
            XCTAssertLessThanOrEqual(
                try XCTUnwrap(counts.max()) - XCTUnwrap(counts.min()),
                1,
                id
            )
        }
    }

    func testPsalmsAndProverbsUsesAnIntentionalDailyWisdomRhythm() throws {
        let plan = try XCTUnwrap(template("psalms-proverbs-31"))

        XCTAssertEqual(
            plan.days[0].assignments.flatMap(\.chapters),
            (1...5).map { CanonicalChapter(bookID: "PS", chapter: $0) }
                + [CanonicalChapter(bookID: "PROV", chapter: 1)]
        )
        XCTAssertEqual(
            plan.days[29].assignments.flatMap(\.chapters),
            (146...150).map { CanonicalChapter(bookID: "PS", chapter: $0) }
                + [CanonicalChapter(bookID: "PROV", chapter: 30)]
        )
        XCTAssertEqual(
            plan.days[30].assignments.flatMap(\.chapters),
            [CanonicalChapter(bookID: "PROV", chapter: 31)]
        )
    }

    func testDeuterocanonPlanIncludesCatholicAdditionsWithoutOtherEstherOrDanielChapters()
        throws
    {
        let plan = try XCTUnwrap(template("catholic-deuterocanon-30"))
        let chapters = Set(plan.days.flatMap(\.assignments).flatMap(\.chapters))

        XCTAssertTrue(chapters.contains(CanonicalChapter(bookID: "TOB", chapter: 1)))
        XCTAssertTrue(chapters.contains(CanonicalChapter(bookID: "BAR", chapter: 6)))
        XCTAssertTrue(chapters.contains(CanonicalChapter(bookID: "ESTH", chapter: 11)))
        XCTAssertTrue(chapters.contains(CanonicalChapter(bookID: "ESTH", chapter: 15)))
        XCTAssertTrue(chapters.contains(CanonicalChapter(bookID: "DAN", chapter: 13)))
        XCTAssertTrue(chapters.contains(CanonicalChapter(bookID: "DAN", chapter: 14)))
        XCTAssertFalse(chapters.contains(CanonicalChapter(bookID: "ESTH", chapter: 10)))
        XCTAssertFalse(chapters.contains(CanonicalChapter(bookID: "DAN", chapter: 12)))
    }

    func testPreviewReferenceUsesOnlyACompatibleEdition() throws {
        let plan = try XCTUnwrap(template("new-testament-90"))

        XCTAssertEqual(plan.previewReference(versionID: 42)?.bookID, "MATT")
        XCTAssertEqual(plan.previewReference(versionID: 42)?.chapter, 1)
        XCTAssertNil(plan.previewReference(versionID: 999))
    }

    func testValidatorDetectsAnAccidentalDuplicateChapter() throws {
        let plan = try XCTUnwrap(template("start-with-jesus-21"))
        let firstDay = try XCTUnwrap(plan.days.first)
        let firstAssignment = try XCTUnwrap(firstDay.assignments.first)
        let duplicate = ReadingPlanAssignment(
            id: "accidental-duplicate",
            position: 2,
            bookID: firstAssignment.bookID,
            startChapter: firstAssignment.startChapter,
            endChapter: firstAssignment.endChapter
        )
        var days = plan.days
        days[0] = ReadingPlanTemplateDay(
            logicalDayIndex: firstDay.logicalDayIndex,
            assignments: firstDay.assignments + [duplicate]
        )
        let brokenPlan = ReadingPlanTemplate(
            id: plan.id,
            revision: plan.revision,
            title: plan.title,
            summary: plan.summary,
            estimatedDailyMinutes: plan.estimatedDailyMinutes,
            scope: plan.scope,
            canonRequirement: plan.canonRequirement,
            canonManifestID: plan.canonManifestID,
            canonManifestRevision: plan.canonManifestRevision,
            compatibleVersionIDs: plan.compatibleVersionIDs,
            suggestedCatchUpDayIndices: plan.suggestedCatchUpDayIndices,
            provenance: plan.provenance,
            days: days
        )

        XCTAssertTrue(
            ReadingPlanTemplateValidator.validate(brokenPlan, against: manifest)
                .contains(.duplicateChapter(CanonicalChapter(bookID: "JOHN", chapter: 1)))
        )
    }

    private func template(_ id: String) -> ReadingPlanTemplate? {
        ReadingPlanTemplateCatalog.all.first { $0.id == id }
    }
}

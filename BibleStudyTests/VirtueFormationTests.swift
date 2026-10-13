import Foundation
import XCTest

@testable import BibleStudy

final class VirtueFormationTests: XCTestCase {
    func testCatalogContainsExactlyTheSevenChristianPathways() {
        XCTAssertEqual(VirtueFormationCatalog.descriptors.count, 7)
        XCTAssertEqual(
            VirtueFormationCatalog.supportedIdentifiers,
            Set([
                .chastity,
                .temperance,
                .charity,
                .diligence,
                .patience,
                .kindness,
                .humility,
            ])
        )
        XCTAssertFalse(VirtueFormationCatalog.supportedIdentifiers.contains(.cardinalTemperance))
    }

    func testCompleteApprovedPathwayPassesPublicationGate() throws {
        let asOf = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-10-13T12:00:00Z"))
        let pathway = try makePathway(reviewBy: asOf.addingTimeInterval(86_400))

        XCTAssertTrue(pathway.isPublishable(asOf: asOf))
        XCTAssertTrue(pathway.publicationIssues(asOf: asOf).isEmpty)
    }

    func testDraftStaleAndIncompletePathwaysFailClosed() throws {
        let asOf = try XCTUnwrap(ISO8601DateFormatter().date(from: "2026-10-13T12:00:00Z"))
        let approved = try makePathway(reviewBy: asOf.addingTimeInterval(-1))
        XCTAssertTrue(approved.publicationIssues(asOf: asOf).contains(.staleReview))

        let draft = VirtueFormationPathway(
            id: .diligence,
            contentVersion: 0,
            title: " ",
            summary: "",
            catholicRelationship: "",
            teaching: "",
            sources: [],
            scriptureReferences: [],
            practices: [],
            examenPrompts: [],
            pastoralBoundaries: [],
            review: VirtueContentReview(
                state: .draft,
                reviewerRole: nil,
                reviewedAt: nil,
                reviewBy: nil
            )
        )
        let issues = draft.publicationIssues(asOf: asOf)
        XCTAssertTrue(issues.contains(.notApproved))
        XCTAssertTrue(issues.contains(.missingSource))
        XCTAssertTrue(issues.contains(.missingScripture))
        XCTAssertTrue(issues.contains(.missingPractice))
        XCTAssertTrue(issues.contains(.missingExamen))
        XCTAssertTrue(issues.contains(.missingPastoralBoundary))
    }

    func testShareableCheckInMetadataCannotContainPrivateObservation() throws {
        let privateText = "A private observation that must never cross the boundary"
        let checkIn = VirtueCheckIn(
            id: UUID(),
            cycleID: UUID(),
            virtueID: .patience,
            practiceID: "patient-response",
            status: .noticedOpportunity,
            occurredAt: .now,
            privateObservation: privateText
        )

        let encoded = try JSONEncoder().encode(checkIn.shareableMetadata)
        let payload = try XCTUnwrap(String(data: encoded, encoding: .utf8))
        XCTAssertFalse(payload.contains(privateText))
        XCTAssertFalse(payload.lowercased().contains("observation"))
        XCTAssertTrue(payload.contains(VirtueIdentifier.patience.rawValue))
    }

    func testPrimaryTabsGiveVirtuesPermanentPlacementWithoutYouMoreTab() {
        XCTAssertEqual(AppDestination.primaryTabs, [.home, .bible, .plans, .virtues, .learning])
        XCTAssertFalse(AppDestination.primaryTabs.contains(.you))
        XCTAssertTrue(AppDestination.allCases.contains(.you))
    }

    private func makePathway(reviewBy: Date) throws -> VirtueFormationPathway {
        let reviewedAt = reviewBy.addingTimeInterval(-86_400)
        return VirtueFormationPathway(
            id: .diligence,
            contentVersion: 1,
            title: "Diligence",
            summary: "A reviewed summary.",
            catholicRelationship: "A reviewed relationship to Catholic virtue teaching.",
            teaching: "Reviewed pathway teaching.",
            sources: [
                VirtueContentSource(
                    id: "ccc-1803",
                    title: "Catechism of the Catholic Church",
                    url: try XCTUnwrap(URL(string: "https://www.vatican.va/")),
                    locator: "1803–1845",
                    sourceClass: .catechism,
                    checkedAt: reviewedAt
                )
            ],
            scriptureReferences: [
                try CanonicalScriptureReference(bookID: "COL", chapter: 3, verseStart: 23)
            ],
            practices: [
                VirtuePracticeDefinition(
                    id: "complete-duty",
                    title: "Complete one duty",
                    instruction: "Complete one necessary task promptly.",
                    contexts: [.work],
                    commitment: .ordinary,
                    estimatedMinutes: 20
                )
            ],
            examenPrompts: [
                VirtueExamenPrompt(id: "notice-resistance", text: "Where did resistance appear?")
            ],
            pastoralBoundaries: ["Diligence is not productivity obsession."],
            review: VirtueContentReview(
                state: .approved,
                reviewerRole: "Catholic formation reviewer",
                reviewedAt: reviewedAt,
                reviewBy: reviewBy
            )
        )
    }
}

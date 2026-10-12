import Foundation
import SwiftData
import XCTest

@testable import BibleStudy

@MainActor
final class PersistenceSchemaTests: XCTestCase {
    func testDiskContainerRestoresSampleStateAfterReopen() throws {
        let storeDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("BibleStudyPersistenceTests", isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: storeDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: storeDirectory) }

        let storeURL = storeDirectory.appendingPathComponent("BibleStudy.store")
        try writeSampleState(to: storeURL)

        XCTAssertTrue(FileManager.default.fileExists(atPath: storeURL.path))

        let reopenedContainer = try BibleStudyModelContainer.make(storeURL: storeURL)
        let reopenedContext = ModelContext(reopenedContainer)
        let profile = try reopenedContext.fetch(FetchDescriptor<BibleStudySchemaV1.Profile>()).first
        let position = try reopenedContext.fetch(FetchDescriptor<BibleStudySchemaV1.ReadingPosition>()).first

        XCTAssertEqual(profile?.displayName, "Owner")
        XCTAssertEqual(position?.canonicalBookID, "JOHN")
        XCTAssertEqual(position?.chapter, 3)
        XCTAssertEqual(position?.verse, 16)
    }

    func testInMemoryContainerPersistsFoundationRecordsAcrossContexts() throws {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let planID = UUID()
        let context = ModelContext(container)

        context.insert(BibleStudySchemaV1.Profile(displayName: "Owner"))
        context.insert(
            BibleStudySchemaV1.ReadingPosition(
                editionProviderID: ScriptureProviderIdentifier.fixture.rawValue,
                editionValue: "catholic-complete",
                canonicalBookID: "JOHN",
                chapter: 1,
                verse: 1
            )
        )
        context.insert(
            BibleStudySchemaV1.ReadingPlan(
                id: planID,
                templateID: "bible-365",
                title: "Bible in a Year",
                startDate: Date(timeIntervalSince1970: 1),
                status: .active
            )
        )
        context.insert(
            BibleStudySchemaV1.PlanCompletionEvent(
                planID: planID,
                dayIndex: 1,
                action: .completed,
                deviceID: "test-device"
            )
        )
        try context.save()

        let verificationContext = ModelContext(container)
        XCTAssertEqual(try verificationContext.fetch(FetchDescriptor<BibleStudySchemaV1.Profile>()).count, 1)
        XCTAssertEqual(
            try verificationContext.fetch(FetchDescriptor<BibleStudySchemaV1.ReadingPosition>()).first?.canonicalBookID,
            "JOHN"
        )
        XCTAssertEqual(
            try verificationContext.fetch(FetchDescriptor<BibleStudySchemaV1.ReadingPlan>()).first?.status,
            .active
        )
        XCTAssertEqual(
            try verificationContext.fetch(FetchDescriptor<BibleStudySchemaV1.PlanCompletionEvent>()).first?.action,
            .completed
        )
    }

    func testPrivateAnnotationRoundTripsWithoutVendorTypes() throws {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        let annotation = BibleStudySchemaV1.ScriptureAnnotation(
            kind: .note,
            canonicalBookID: "MAT",
            chapter: 5,
            verseStart: 3,
            verseEnd: 12,
            noteText: "Private fixture note"
        )
        context.insert(annotation)
        try context.save()

        let stored = try ModelContext(container)
            .fetch(FetchDescriptor<BibleStudySchemaV1.ScriptureAnnotation>())
            .first

        XCTAssertEqual(stored?.kind, .note)
        XCTAssertEqual(stored?.canonicalBookID, "MAT")
        XCTAssertEqual(stored?.noteText, "Private fixture note")
        XCTAssertNil(stored?.editionProviderID)
    }

    func testContentProvenanceStoresReviewAndJurisdictionMetadata() throws {
        let container = try BibleStudyModelContainer.make(inMemory: true)
        let context = ModelContext(container)
        let sourceDate = Date(timeIntervalSince1970: 100)
        context.insert(
            BibleStudySchemaV1.ContentProvenance(
                contentID: "mass.introduction",
                contentVersion: 1,
                sourceURL: "https://www.vatican.va/",
                sourceLocator: "GIRM 27–28",
                jurisdictionRawValue: "latin-roman",
                sourceCheckedAt: sourceDate,
                reviewerRole: "Catholic liturgy reviewer"
            )
        )
        try context.save()

        let stored = try ModelContext(container)
            .fetch(FetchDescriptor<BibleStudySchemaV1.ContentProvenance>())
            .first
        XCTAssertEqual(stored?.sourceCheckedAt, sourceDate)
        XCTAssertEqual(stored?.jurisdictionRawValue, "latin-roman")
    }

    func testMigrationPlanPreservesVersionOneAndAddsPlanStateInVersionTwo() {
        XCTAssertEqual(BibleStudyMigrationPlan.schemas.count, 2)
        XCTAssertEqual(BibleStudySchemaV1.versionIdentifier, Schema.Version(1, 0, 0))
        XCTAssertEqual(BibleStudySchemaV2.versionIdentifier, Schema.Version(2, 0, 0))
        XCTAssertEqual(BibleStudyMigrationPlan.stages.count, 1)
    }

    private func writeSampleState(to storeURL: URL) throws {
        let container = try BibleStudyModelContainer.make(storeURL: storeURL)
        let context = ModelContext(container)
        context.insert(BibleStudySchemaV1.Profile(displayName: "Owner"))
        context.insert(
            BibleStudySchemaV1.ReadingPosition(
                editionProviderID: ScriptureProviderIdentifier.fixture.rawValue,
                editionValue: "catholic-complete",
                canonicalBookID: "JOHN",
                chapter: 3,
                verse: 16
            )
        )
        try context.save()
    }
}

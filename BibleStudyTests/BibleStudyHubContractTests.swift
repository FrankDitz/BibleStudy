import XCTest
@testable import BibleStudy

final class BibleStudyHubContractTests: XCTestCase {
    func testEventEnvelopeMatchesEchoContractConventions() throws {
        let eventID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        let entityID = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
        let occurredAt = Date(timeIntervalSince1970: 1_700_000_000)
        let reference = try CanonicalScriptureReference(
            bookID: "mat",
            chapter: 5,
            verseStart: 3,
            verseEnd: 10
        )
        let payload = BibleStudyHubEventPayload(
            scriptureReference: reference,
            virtueIDs: [.humility, .diligence, .humility]
        )
        let event = BibleStudyHubEvent(
            id: eventID,
            type: .readingProgressUpdated,
            occurredAt: occurredAt,
            entityID: entityID,
            payload: payload
        )

        let data = try BibleStudyHubEventCodec.encoder().encode(event)
        let decoded = try BibleStudyHubEventCodec.decoder().decode(
            BibleStudyHubEvent.self,
            from: data
        )

        XCTAssertEqual(decoded, event)
        XCTAssertEqual(decoded.schemaVersion, 1)
        XCTAssertEqual(decoded.sourceApp, "bible-study")
        XCTAssertEqual(decoded.payload.scriptureReference?.osis, "MAT.5.3-10")
        XCTAssertEqual(
            decoded.payload.virtueIDs.map(\.rawValue),
            ["christian.diligence", "christian.humility"]
        )
    }

    func testEventDoesNotExposePrivateReadingContent() throws {
        let privateText = "A private note that must remain inside Bible Study"
        let event = BibleStudyHubEvent(
            id: UUID(),
            type: .planAssignmentCompleted,
            occurredAt: Date(timeIntervalSince1970: 1_700_000_000),
            entityID: UUID(),
            payload: BibleStudyHubEventPayload(planID: UUID())
        )

        let data = try BibleStudyHubEventCodec.encoder().encode(event)
        let json = String(decoding: data, as: UTF8.self)

        XCTAssertFalse(json.contains(privateText))
        XCTAssertFalse(json.contains("journalText"))
        XCTAssertFalse(json.contains("noteText"))
        XCTAssertFalse(json.contains("annotationText"))
    }

    func testEchoRequestSharesOnlyExplicitPromptAndContext() throws {
        let request = BibleStudyEchoReflectionRequest(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            createdAt: Date(timeIntervalSince1970: 1_700_000_000),
            prompt: "  Where can I practice patience today?  ",
            scriptureReference: try CanonicalScriptureReference(
                bookID: "jas",
                chapter: 1,
                verseStart: 2,
                verseEnd: 4
            ),
            virtueIDs: [.patience]
        )

        let data = try BibleStudyHubEventCodec.encoder().encode(request)
        let json = String(decoding: data, as: UTF8.self)
        let decoded = try BibleStudyHubEventCodec.decoder().decode(
            BibleStudyEchoReflectionRequest.self,
            from: data
        )

        XCTAssertEqual(decoded.prompt, "Where can I practice patience today?")
        XCTAssertEqual(decoded.scriptureReference?.osis, "JAS.1.2-4")
        XCTAssertFalse(json.contains("journalText"))
        XCTAssertFalse(json.contains("originalCapture"))
    }

    func testProfileProjectionRoundTripsWithoutUnneededPersonalFields() throws {
        let profile = BibleStudyProfileContext(
            profileID: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
            preferredName: "Frank",
            localeIdentifier: "en_US",
            timeZoneIdentifier: "America/New_York",
            jurisdiction: CatholicJurisdiction(
                countryCode: "US",
                subdivisionCode: "PA",
                dioceseName: nil
            )
        )

        let data = try BibleStudyHubEventCodec.encoder().encode(profile)
        let json = String(decoding: data, as: UTF8.self)
        let decoded = try BibleStudyHubEventCodec.decoder().decode(
            BibleStudyProfileContext.self,
            from: data
        )

        XCTAssertEqual(decoded, profile)
        XCTAssertFalse(json.contains("email"))
        XCTAssertFalse(json.contains("birthday"))
        XCTAssertFalse(json.contains("credential"))
    }

    func testUnknownEventTypeRemainsDecodable() throws {
        let futureType = BibleStudyHubEventType(rawValue: "bible-study.future.event")
        let data = try BibleStudyHubEventCodec.encoder().encode(futureType)
        let decoded = try BibleStudyHubEventCodec.decoder().decode(
            BibleStudyHubEventType.self,
            from: data
        )

        XCTAssertEqual(decoded, futureType)
    }

    func testVirtueTaxonomyHasElevenDistinctQualifiedIdentifiers() {
        XCTAssertEqual(VirtueIdentifier.supported.count, 11)
        XCTAssertTrue(VirtueIdentifier.supported.contains(.temperance))
        XCTAssertTrue(VirtueIdentifier.supported.contains(.cardinalTemperance))
        XCTAssertNotEqual(VirtueIdentifier.temperance, .cardinalTemperance)
    }
}

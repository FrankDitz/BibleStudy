import XCTest
@testable import BibleStudy

final class APIBibleCapabilityAuditTests: XCTestCase {
    func testBuildsDocumentedEndpointsWithoutInterpolatingUnsafePathCharacters() {
        XCTAssertEqual(
            APIBibleEndpoint.audioBibles.url().absoluteString,
            "https://rest.api.bible/v1/audio-bibles"
        )
        XCTAssertEqual(
            APIBibleEndpoint.audioChapter(
                bibleID: "sample audio",
                chapterID: "JHN.3"
            ).url().absoluteString,
            "https://rest.api.bible/v1/audio-bibles/sample%20audio/chapters/JHN.3"
        )
    }

    func testDecodesDocumentedAudioChapterShapeAndApprovesTierA() throws {
        let data = Data(audioChapterFixture.utf8)
        let envelope = try JSONDecoder().decode(APIBibleAudioChapterEnvelope.self, from: data)
        let now = Date(timeIntervalSince1970: 2_000_000_000)
        let report = APIBibleAudioAuditor.audit(envelope.data, now: now)

        XCTAssertEqual(envelope.data.id, "JHN.3")
        XCTAssertEqual(envelope.data.timecodes?.first?.verseID, "JHN.3.1")
        XCTAssertTrue(report.isEligibleForTierAPrototype)
        XCTAssertTrue(report.supportsVerseFollowAlong)
        XCTAssertTrue(report.invalidTimecodeVerseIDs.isEmpty)
    }

    func testRejectsExpiredInsecureAudioAndInvalidTimecodes() throws {
        let chapter = APIBibleAudioChapter(
            id: "JHN.3",
            bibleID: "audio-id",
            number: "3",
            bookID: "JHN",
            resourceURL: "http://example.com/audio.mp3",
            timecodes: [.init(start: "12", end: "10", verseID: "JHN.3.1")],
            expiresAt: 1_000,
            reference: "John 3",
            copyright: " "
        )
        let report = APIBibleAudioAuditor.audit(
            chapter,
            now: Date(timeIntervalSince1970: 2_000)
        )

        XCTAssertFalse(report.isEligibleForTierAPrototype)
        XCTAssertFalse(report.supportsVerseFollowAlong)
        XCTAssertEqual(report.invalidTimecodeVerseIDs, ["JHN.3.1"])
    }

    func testCachePolicyRecommendsFourteenDaysAndRequiresRefreshByThirtyDays() {
        XCTAssertEqual(APIBibleCachePolicy.recommendedRefreshInterval, 1_209_600)
        XCTAssertEqual(APIBibleCachePolicy.maximumRefreshInterval, 2_592_000)

        let cachedAt = Date(timeIntervalSince1970: 1_000)
        XCTAssertFalse(
            APIBibleCachePolicy.isRefreshRequired(
                cachedAt: cachedAt,
                now: cachedAt.addingTimeInterval(2_591_999)
            )
        )
        XCTAssertTrue(
            APIBibleCachePolicy.isRefreshRequired(
                cachedAt: cachedAt,
                now: cachedAt.addingTimeInterval(2_592_000)
            )
        )
    }

    private let audioChapterFixture = #"""
    {
      "data": {
        "id": "JHN.3",
        "bibleId": "audio-id",
        "number": "3",
        "bookId": "JHN",
        "resourceUrl": "https://cdn.example.com/JHN.3.mp3",
        "timecodes": [
          { "start": "00:00:01.5", "end": "12.25", "verseId": "JHN.3.1" }
        ],
        "expiresAt": 2000003600,
        "reference": "John 3",
        "copyright": "Fixture attribution"
      },
      "meta": { "fums": "fixture", "fumsId": "fixture-id" }
    }
    """#
}

import XCTest
import YouVersionPlatform

@testable import BibleStudy

@MainActor
final class YouVersionLocalHighlightBridgeTests: XCTestCase {
    func testLocalHighlightsReplaceReaderCacheUsingProviderReferences() throws {
        YouVersionPlatformConfiguration.configure(
            appKey: nil,
            isSignInEnabled: false
        )
        let cache = BibleHighlightsCache()
        let reference = try ScriptureReference(
            versionID: 42,
            bookID: "JOHN",
            chapter: 3,
            verseStart: 16
        )

        YouVersionLocalHighlightBridge(cache: cache).replaceCachedHighlights(
            with: [ScriptureHighlightSnapshot(reference: reference, color: .gold)]
        )

        XCTAssertEqual(cache.cachedHighlights.count, 1)
        XCTAssertEqual(cache.cachedHighlights.first?.highlight.reference.versionId, 42)
        XCTAssertEqual(cache.cachedHighlights.first?.highlight.reference.passageId, "JHN.3.16")
        XCTAssertEqual(cache.cachedHighlights.first?.highlight.color, "#FFDE59")
    }
}

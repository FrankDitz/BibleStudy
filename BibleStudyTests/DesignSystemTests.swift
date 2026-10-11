import XCTest
@testable import BibleStudy

final class DesignSystemTests: XCTestCase {
    func testReaderThemesHaveStableUniqueIdentifiersAndTitles() {
        XCTAssertEqual(Set(ReaderTheme.allCases.map(\.rawValue)).count, 3)
        XCTAssertEqual(Set(ReaderTheme.allCases.map(\.title)).count, 3)
    }

    func testEveryStateKindHasAVisibleDefaultIcon() {
        XCTAssertEqual(AppStateKind.allCases.count, 6)
        XCTAssertTrue(AppStateKind.allCases.allSatisfy { !$0.defaultIcon.isEmpty })
    }

    func testDescriptorUsesKindIconUnlessExplicitlyOverridden() {
        let automatic = AppStateDescriptor(kind: .offline, title: "Offline", message: "Try again")
        let overridden = AppStateDescriptor(
            kind: .offline,
            title: "Offline",
            message: "Try again",
            icon: "network.slash"
        )

        XCTAssertEqual(automatic.icon, AppStateKind.offline.defaultIcon)
        XCTAssertEqual(overridden.icon, "network.slash")
    }
}

import XCTest

@testable import BibleStudy

final class DesignSystemTests: XCTestCase {
    func testAppAppearancesMapToExpectedColorSchemes() {
        XCTAssertNil(AppAppearance.system.preferredColorScheme)
        XCTAssertEqual(AppAppearance.emeraldLight.preferredColorScheme, .light)
        XCTAssertEqual(AppAppearance.emeraldAfterDark.preferredColorScheme, .dark)
        XCTAssertEqual(Set(AppAppearance.allCases.map(\.rawValue)).count, 3)
    }

    func testReaderThemesHaveStableUniqueIdentifiersAndTitles() {
        XCTAssertEqual(Set(ReaderTheme.allCases.map(\.rawValue)).count, 4)
        XCTAssertEqual(Set(ReaderTheme.allCases.map(\.title)).count, 4)
        XCTAssertEqual(ReaderTheme.automatic.resolved(for: .light), .light)
        XCTAssertEqual(ReaderTheme.automatic.resolved(for: .dark), .dark)
    }

    func testEditorialArtworkSlotsKeepStableProductionRatios() {
        XCTAssertEqual(EditorialArtworkSlot.feature.aspectRatio, 16.0 / 9.0, accuracy: 0.0001)
        XCTAssertEqual(EditorialArtworkSlot.planCover.aspectRatio, 3.0 / 2.0, accuracy: 0.0001)
        XCTAssertEqual(EditorialArtworkSlot.thumbnail.aspectRatio, 1, accuracy: 0.0001)
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

import XCTest

final class BibleStudyUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testFiveDestinationsAreReachable() {
        let app = launchApplication()
        for destination in ["Home", "Bible", "Plans", "Learning", "You"] {
            XCTAssertTrue(navigationElement(destination, in: app).waitForExistence(timeout: 3))
        }
    }

    @MainActor
    func testMissingProviderShowsRightsLockedState() {
        let app = launchApplication()
        navigationElement("Bible", in: app).tap()
        XCTAssertTrue(app.staticTexts["Bible provider setup required"].waitForExistence(timeout: 3))
    }

    @MainActor
    func testNavigationAtLargestAccessibilityTextSize() {
        let app = launchApplication(
            additionalArguments: [
                "-UIPreferredContentSizeCategoryName",
                "UICTContentSizeCategoryAccessibilityExtraExtraExtraLarge",
            ])

        for destination in ["Home", "Bible", "Plans", "Learning", "You"] {
            let element = navigationElement(destination, in: app)
            XCTAssertTrue(element.waitForExistence(timeout: 3))
            element.tap()
        }
    }

    @MainActor
    func testNavigationDestinationsExposeLabelsAndHitTargets() {
        let app = launchApplication()
        for destination in ["Home", "Bible", "Plans", "Learning", "You"] {
            let element = navigationElement(destination, in: app)
            XCTAssertEqual(element.label, destination)
            XCTAssertTrue(element.isHittable)
        }
    }

    @MainActor
    func testCustomPlanComposerIsReachableAndShowsAValidPreview() {
        let app = launchApplication()
        navigationElement("Plans", in: app).tap()

        let createPlan = app.buttons["create-custom-plan"]
        XCTAssertTrue(createPlan.waitForExistence(timeout: 3))
        createPlan.tap()

        XCTAssertTrue(app.textFields["custom-plan-title"].waitForExistence(timeout: 3))
        XCTAssertTrue(
            app.descendants(matching: .any)["custom-plan-preview"].waitForExistence(timeout: 3)
        )
        XCTAssertTrue(app.staticTexts["Schedule ready"].exists)
    }

    @MainActor
    func testHomeTodayExposesUsefulPrivateEntryPoints() {
        let app = launchApplication()

        XCTAssertTrue(app.buttons["home-resume-reading"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["home-open-learning"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["home-virtue-focus"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["home-recent-activity"].exists)
        XCTAssertFalse(app.staticTexts["Daily reflection"].exists)
    }

    @MainActor
    private func launchApplication(additionalArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"] + additionalArguments
        app.launch()
        return app
    }

    @MainActor
    private func navigationElement(_ title: String, in app: XCUIApplication) -> XCUIElement {
        #if os(macOS)
            app.staticTexts[title]
        #else
            app.tabBars.buttons[title]
        #endif
    }
}

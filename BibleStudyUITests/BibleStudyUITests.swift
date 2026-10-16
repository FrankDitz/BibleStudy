import XCTest

final class BibleStudyUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testPrimaryDestinationsAreReachable() {
        let app = launchApplication()
        for destination in navigationTitles {
            XCTAssertTrue(navigationElement(destination, in: app).waitForExistence(timeout: 3))
        }
    }

    @MainActor
    func testMissingProviderShowsRightsLockedState() {
        let app = launchApplication(additionalArguments: ["-ui-testing-unconfigured-provider"])
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

        for destination in navigationTitles {
            let element = navigationElement(destination, in: app)
            XCTAssertTrue(element.waitForExistence(timeout: 3))
            element.tap()
        }
    }

    @MainActor
    func testNavigationDestinationsExposeLabelsAndHitTargets() {
        let app = launchApplication()
        for destination in navigationTitles {
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
        let preview = app.staticTexts["Schedule ready"]
        scrollToExistence(preview, in: app)
        XCTAssertTrue(preview.exists)
    }

    @MainActor
    func testHomeTodayExposesUsefulPrivateEntryPoints() {
        let app = launchApplication()

        XCTAssertTrue(app.buttons["home-resume-reading"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["home-open-learning"].exists)
        XCTAssertTrue(app.buttons["home-open-virtues"].exists)
        XCTAssertTrue(app.buttons["home-open-profile"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["home-virtue-focus"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["home-recent-activity"].exists)
        XCTAssertFalse(app.staticTexts["Daily reflection"].exists)
    }

    @MainActor
    func testVirtuesHasAFirstClassPrivateFormationDestination() {
        let app = launchApplication()
        navigationElement("Virtues", in: app).tap()

        XCTAssertTrue(app.descendants(matching: .any)["virtues-root"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.descendants(matching: .any)["virtues-formation-journey"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["virtues-privacy-note"].exists)
    }

    @MainActor
    func testVirtueCourseOpensWithHonestPreviewOutlineAndSources() {
        let app = launchApplication()
        navigationElement("Virtues", in: app).tap()

        let foundations = app.buttons["virtue-foundation-course"]
        XCTAssertTrue(foundations.waitForExistence(timeout: 3))
        foundations.tap()

        XCTAssertTrue(
            app.descendants(matching: .any)["virtue-course-virtue-foundations"]
                .waitForExistence(timeout: 3)
        )
        XCTAssertTrue(app.descendants(matching: .any)["virtue-course-review-status"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["virtue-course-progress"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["virtue-course-overview"].exists)

        let outline = app.descendants(matching: .any)["virtue-course-outline"]
        scrollToExistence(outline, in: app)
        XCTAssertTrue(outline.exists)

        let sources = app.descendants(matching: .any)["virtue-course-sources"]
        scrollToExistence(sources, in: app, attempts: 12)
        XCTAssertTrue(sources.exists)
    }

    #if !os(macOS)
        @MainActor
        func testLongFormationDestinationsScrollFullyAboveTheTabBar() {
            let app = launchApplication()
            let destinations = [
                ("Plans", "plans-content-end"),
                ("Virtues", "virtues-content-end"),
                ("Learning", "learning-content-end"),
            ]

            for (destination, endIdentifier) in destinations {
                navigationElement(destination, in: app).tap()
                let endMarker = app.descendants(matching: .any)[endIdentifier]
                let tab = navigationElement(destination, in: app)
                scrollAboveTabBar(endMarker, tab: tab, in: app, attempts: 24)
                XCTAssertTrue(endMarker.isHittable, "\(destination) end cap is not visible")
                XCTAssertLessThanOrEqual(
                    endMarker.frame.maxY,
                    tab.frame.minY,
                    "\(destination) content did not clear the tab bar"
                )
                XCTAssertTrue(tab.isHittable)

                let screenshot = XCTAttachment(screenshot: app.screenshot())
                screenshot.name = "\(destination)-content-end"
                screenshot.lifetime = .keepAlways
                add(screenshot)
            }
        }
    #endif

    @MainActor
    private func launchApplication(additionalArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"] + additionalArguments
        app.launch()
        return app
    }

    @MainActor
    private func navigationElement(_ title: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)["navigation-\(title.lowercased())"]
    }

    @MainActor
    private func scrollToExistence(
        _ element: XCUIElement,
        in app: XCUIApplication,
        attempts: Int = 6
    ) {
        for _ in 0..<attempts where !element.exists {
            app.swipeUp()
        }
    }

    @MainActor
    private func scrollAboveTabBar(
        _ element: XCUIElement,
        tab: XCUIElement,
        in app: XCUIApplication,
        attempts: Int
    ) {
        for _ in 0..<attempts {
            if element.isHittable, element.frame.maxY <= tab.frame.minY {
                return
            }
            app.swipeUp()
        }
    }

    private var navigationTitles: [String] {
        #if os(macOS)
            ["Home", "Bible", "Plans", "Virtues", "Learning", "You"]
        #else
            ["Home", "Bible", "Plans", "Virtues", "Learning"]
        #endif
    }
}

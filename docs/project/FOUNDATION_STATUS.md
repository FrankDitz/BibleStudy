# Foundation Status

**Implementation status:** complete  
**Phase-exit status:** pending owner accessibility sign-off  
**Verified:** 2026-10-11

The foundation deliverables are implemented, tested, and merged. The application fails closed when no licensed Scripture provider key is present, so foundation work does not claim that the separate live-provider gate has passed.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0101 | Provider-neutral Scripture capability boundary, fixture provider, YouVersion adapter, and rights model | `ScriptureProvider`, `FixtureScriptureProvider`, `YouVersionScriptureAdapter`, ADR-004 | Complete |
| BS-0102 | SwiftData schema v1, migration plan, in-memory fixtures, and disk reopen coverage | `BibleStudySchemaV1`, `BibleStudyMigrationPlan`, `PersistenceSchemaTests` | Complete |
| BS-0103 | Dependency container and enforced vendor-import boundary | `AppDependencies`, `scripts/check-provider-boundaries.sh`, CI | Complete |
| BS-0104 | Semantic tokens, reader themes, cards, and loading/empty/error/offline/rights/stale states | `DesignSystem`, `AppStateView`, design-system tests | Complete |
| BS-0105 | Five-destination standalone/hub shell and deep links | `BibleStudyRootView`, route/launch adapters, contract tests | Complete |
| BS-0106 | Privacy-aware OSLog categories and production-safe feature flags | `AppLog`, `FeatureFlags`, composition tests | Complete |
| BS-0107 | Formatting, branch, secret, provider-boundary, macOS test, and iOS build gates | `.github/workflows/ci.yml`, `.swift-format`, UI-test target, quality scripts | Complete |
| BS-0108 | Accessibility matrix, largest-text UI test, semantic labels/hit targets, contrast correction | `ACCESSIBILITY_PREVIEW_MATRIX.md`, `BibleStudyUITests`, `AppTheme.supportingText` | Owner sign-off pending |

The YouVersion SDK baseline is resolved to 5.5.0, its notice is recorded, and compatible/major updates are controlled by `DEPENDENCY_UPGRADE_POLICY.md`.

## Verification evidence

- 42 macOS unit and contract tests pass, including a temporary on-disk store close/reopen round trip.
- The generic iOS Simulator `build-for-testing` succeeds and builds the app, unit tests, and UI-test runner.
- Four UI tests pass on an iPhone 16e simulator running iOS 18.5: all destinations, missing-provider rights state, accessibility labels/hit targets, and navigation at the largest accessibility text size.
- The native Mac app builds and launches. Direct accessibility-tree interaction verified Home, Bible, Plans, Learning, and You in the sidebar and the expected content for each destination.
- Formatting, branch-name, tracked-secret, provider-boundary, and diff checks pass.
- The SDK resolves from the committed lockfile to YouVersion Platform 5.5.0.

The macOS XCTest UI runner could not initialize automation on this host because macOS did not grant Xcode automation mode. A normal signed rebuild reached the system permission boundary; direct app verification succeeded independently.

## Remaining owner gates

Phase 1 should be marked closed after the owner records the manual accessibility matrix on a physical iPhone and Mac:

- VoiceOver spoken order and control labels across all five destinations;
- largest accessibility text on physical iPhone and minimum-size Mac window;
- Mac keyboard focus/sidebar movement;
- light/dark contrast and Reduce Motion behavior; and
- whether Xcode/Codex should receive macOS Accessibility/Automation permission for repeatable Mac UI tests.

These checks require physical-device or macOS privacy interaction and are not inferred from compilation. Enabling a system privacy permission is optional; a recorded manual pass is sufficient.

## Separate external gates

These do not invalidate the completed provider-neutral foundation, but they still block a production Scripture reader or final phase closure where applicable:

- owner YouVersion App Key registration, edition-license acceptance, and live Catholic edition audit;
- selection of an approved complete Catholic text path and explicit audio decision;
- sending the optional STREETLIGHTS inquiry; and
- recording the Catholic content reviewer route before Learning material is published.

No App Key, licensed Scripture payload, private correspondence, or personal content is committed.

# Bible Study

Bible Study is a personal, Apple-native Catholic Scripture and formation module for the local self-improvement hub. It targets iPhone and Mac with SwiftUI.

The implementation roadmap lives in [PRODUCT_ROADMAP.md](PRODUCT_ROADMAP.md). Current delivery gates are summarized in [Phase 0 status](docs/project/PHASE_0_STATUS.md), with the [initial backlog](docs/project/INITIAL_BACKLOG.md), [risk register](docs/project/RISK_REGISTER.md), and [Definition of Done](docs/project/DEFINITION_OF_DONE.md). The YouVersion integration decision is recorded in [ADR-001](docs/architecture/ADR-001-youversion-platform.md), dependency changes follow the [SDK upgrade policy](docs/architecture/DEPENDENCY_UPGRADE_POLICY.md), and third-party notices are tracked in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## Current foundation

- SwiftUI multi-platform app target: iOS 17+ and macOS 15+
- YouVersion Platform Swift SDK 5.5.x for Scripture text and reader infrastructure
- Five feature destinations: Home, Bible, Plans, Learning, and You
- App-owned domain references and routing, with plans, annotations, and private iCloud state scheduled in the roadmap
- YouVersion sign-in disabled; personal data stays in the app

## Local setup

1. Register a personal-use application at [YouVersion Platform](https://platform.youversion.com/).
2. In the portal, accept the licenses available to the App Key for the desired Catholic editions.
3. Copy `Config/Secrets.example.xcconfig` to `Config/Secrets.xcconfig`.
4. Replace the placeholder with the App Key.
5. Open `BibleStudy.xcodeproj` and run the `BibleStudy` scheme on iPhone or Mac.

Without a local App Key, the app still builds and opens a setup screen in the Bible tab.

## Catholic translation policy

The intended preference order is:

1. NABRE (`463`)
2. NRSV Catholic Interconfessional (`2015`)
3. Douay-Rheims Challoner 1752 (`55`)

The active catalog is restricted to editions licensed to this app and verified to contain the expected Catholic canon. Douay-Rheims is the development default until the App Key catalog is verified.

## Verification

```sh
xcodebuild \
  -project BibleStudy.xcodeproj \
  -scheme BibleStudy \
  -destination 'platform=macOS' \
  CODE_SIGNING_ALLOWED=NO \
  test
```

## Distribution boundary

This repository is currently planned for owner-only personal use. Before any TestFlight, App Store, multi-user, organizational, or commercial distribution, re-review YouVersion Platform terms, every Scripture/audio license, privacy disclosures, Catholic content review, and Apple distribution requirements.

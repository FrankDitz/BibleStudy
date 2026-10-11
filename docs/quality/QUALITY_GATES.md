# Quality Gates

Phase 1 establishes repository-enforced checks for every merge:

- enterprise-style capability branch name on pull requests;
- tracked-secret scan and ignored local credential file;
- YouVersion import boundary;
- `swift-format` lint using the Xcode toolchain and repository configuration;
- macOS unit/contract tests;
- iOS Simulator app build; and
- iOS Simulator UI-test bundle build.

GitHub Actions uses the GA `macos-26` runner so the default Xcode 26 toolchain can compile YouVersion Platform 5.5.x. The older `macos-15` default is Xcode 16.4, which does not provide the SwiftUI toolbar API used by that reviewed SDK release.

The UI target contains smoke coverage for launch, all five destinations, accessible labels and hit targets, the missing-provider rights state, and largest accessibility text. Dynamic Type uses the explicit largest-text navigation test because the iOS 18.5 audit reports a false positive for a native SwiftUI `.headline` while the maximum-size launch passes. The audit still identified a real supporting-text contrast issue; that was fixed with the semantic `AppTheme.supportingText` token. A successful audit then exposed an Xcode 27 result-finalization hang, so the flaky audit API is diagnostic rather than a merge gate. Running UI tests on a concrete simulator is required before phase exit and for navigation changes; CI builds the bundle on every change and can add device execution when the runner image is pinned to a known simulator runtime.

Run the local checks with:

```sh
scripts/check-branch-name.sh "$(git branch --show-current)"
scripts/check-provider-boundaries.sh
scripts/check-secrets.sh
xcrun swift-format lint --recursive BibleStudy BibleStudyTests BibleStudyUITests
xcodebuild test -project BibleStudy.xcodeproj -scheme BibleStudy -destination 'platform=macOS' -only-testing:BibleStudyTests CODE_SIGNING_ALLOWED=NO
xcodebuild build-for-testing -project BibleStudy.xcodeproj -scheme BibleStudy -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO
```

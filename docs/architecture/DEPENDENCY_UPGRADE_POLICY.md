# Dependency Upgrade Policy

## Current reviewed baseline

The application declares the official YouVersion Swift package with the compatible-major requirement `5.5.0..<6.0.0`. The checked-in Swift Package Manager lockfile is the build authority and currently resolves:

- package: `https://github.com/youversion/platform-sdk-swift.git`;
- version: `5.5.0`;
- revision: `1fd5b08120601966a9be127e2f459be329ec4e2a`;
- SDK license: Apache License 2.0; and
- product/content permission: governed separately by the YouVersion Platform terms and each enabled Bible edition.

CI must use the committed `Package.resolved`. A compatible version becoming available does not authorize an automatic lockfile update or merge.

## Upgrade workflow

Every dependency change uses a dedicated `chore/sdk-upgrade` branch, or the equivalent real work-item branch when a tracker exists. The change must:

1. identify the old and proposed version and revision;
2. review the upstream release notes, API diff, minimum OS/toolchain changes, transitive dependencies, and license files;
3. re-review YouVersion Platform terms and content-license implications if behavior, telemetry, caching, attribution, authentication, or distribution language changed;
4. update `Package.resolved`, `THIRD_PARTY_NOTICES.md`, the relevant ADR, and the rights/risk records when facts changed;
5. compile only through the app-owned provider adapter and approved reader boundary;
6. pass formatting, secret, provider-boundary, macOS unit/contract, iOS build-for-testing, and concrete-simulator UI checks; and
7. record all live checks that require the owner's local App Key without committing the key or licensed content.

## Scripture-specific regression review

Before accepting a new YouVersion SDK resolution, verify with an entitled local App Key:

- the exact approved edition allowlist and required attribution;
- all expected Catholic canonical resources, including `ESG` and Daniel additions;
- book/chapter navigation, restoration, search handoff, deep links, and provider failures;
- cache/offline behavior and any SDK usage reporting;
- iPhone and Mac rendering, largest Dynamic Type, VoiceOver, keyboard behavior, and Reduce Motion; and
- that notes, plans, reading history, Learning progress, Echo data, and local analytics remain outside the provider boundary.

An SDK-only compile is not enough evidence for these checks.

## Version policy

- Patch and minor updates within major version 5 may be proposed through the review workflow; they are never auto-merged.
- Major-version changes require a new or superseding architecture decision record because provider APIs, terms, data flow, and minimum platforms may change.
- Urgent security fixes still require the smallest relevant build/test/rights review; urgency does not waive credential, attribution, or privacy controls.
- If an update fails review, restore the previous committed lockfile resolution and record the blocker. Do not patch around provider licensing or attribution requirements.

## Distribution trigger

Any move beyond owner-only personal use triggers a fresh SDK-license, Platform-terms, translation-rights, privacy, attribution, and product-positioning review even when the package version has not changed.

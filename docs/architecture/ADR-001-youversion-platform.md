# ADR-001: Use YouVersion Platform for Scripture text and reader infrastructure

- Status: accepted for the owner-only personal build
- Date: 2026-10-11
- Decision owners: repository owner and Bible Study module

## Context

Bible Study needs a reliable Catholic-aware reader on iPhone and Mac without recreating translation licensing, Scripture formatting, book/chapter navigation, search, and attribution infrastructure. The YouVersion Platform supplies a native Swift package and licensed Bible catalog, but it is not a complete backend for our custom reading plans, Catholic Learning content, personal notes, or requested narrated-audio experience.

The product is for one owner's personal devices. Any future distribution is a material scope change.

## Decision

Use `YouVersionPlatform` 5.5.x behind an app-owned adapter for:

- `BibleReaderView` as the first complete reader;
- `BibleReaderNavigation` for Home, Plan, and Learning passage handoffs;
- the version catalog and per-version book manifests;
- an allowlist of licensed Catholic editions;
- online reference, text, and topical search, suggestions, and corrections;
- passage formatting, headings, footnotes, copyright, and attribution;
- last-passage restoration and provider-managed HTTP caching;
- Verse of the Day reference for an optional **Scripture of the Day** Home card.

Initial desired version order:

1. NABRE — `463`
2. NRSV-CI — `2015`
3. DRC1752 — `55`

DRC1752 is the development default until the App Key's licensed catalog and 73-book manifests are verified.

Configure the SDK with English and those three version IDs only. Disable YouVersion sign-in for the initial build and intercept verse taps for app-owned actions.

## Explicitly not delegated to YouVersion

- reading plans, schedules, completions, reminders, or plan analytics;
- notes, bookmarks, local highlights, reading history, or Echo reflections;
- hub identity, profile, achievements, or iCloud sync;
- Catholic Learning content or liturgical guidance;
- Bible audio, background playback, downloads, or verse timecodes;
- local analytics and private progress reporting.

No public reading-plan or audio developer API was found in the reviewed Platform surface. Current sign-in documentation exposes a user-data permission for highlights, not notes or bookmarks.

## Data and privacy boundary

Scripture catalog, passage, search, attribution, and required SDK usage reporting may reach YouVersion. Personal annotations, plan state, history, Learning progress, Echo content, and app analytics must not.

The local App Key is supplied through ignored `Config/Secrets.xcconfig`. No credential is committed.

## Failure and fallback

All app features use canonical `ScriptureReference` values and an app-owned navigation controller. If an edition is unlicensed, the SDK is unavailable, or the integration no longer meets the product's needs, replace the provider adapter with API.Bible or a verified public-domain Catholic source without migrating plan or personal data.

## Consequences

Positive:

- significantly less reader, formatting, search, and attribution code;
- official SwiftUI support and a maintained Scripture model;
- rapid plan-to-reader integration through canonical references;
- cleaner licensing discovery than copying Bible text into the repository.

Tradeoffs:

- online Scripture availability and search depend on the provider;
- full offline-version behavior remains license/capability dependent;
- provider caching and usage reporting must remain enabled and disclosed;
- SDK updates require regression tests on iPhone, Mac, accessibility, attribution, and the 73-book manifest.

The compatible-major declaration, exact resolved revision, and required upgrade review are governed by [`DEPENDENCY_UPGRADE_POLICY.md`](DEPENDENCY_UPGRADE_POLICY.md). Compatible releases are not auto-merged.

## Distribution constraint

This acceptance applies to owner-only personal use. TestFlight, App Store, multi-user, organizational, or commercial distribution is blocked until the YouVersion Platform terms, translation rights, privacy disclosures, and product positioning are reviewed again.

# ADR-003: Platform Support and Data Migration Policy

- **Status:** Accepted
- **Date:** 2026-10-11
- **Decision owners:** Product owner and application maintainer

## Context

Bible Study is a native SwiftUI module for iPhone and Mac. Its core value is long-lived personal history: plan completion, annotations, reading position, learning progress, settings, and private analytics. Platform targets must support the chosen YouVersion SDK, and application updates must not treat personal-use data as disposable.

The pinned YouVersion Swift SDK 5.5.0 declares iOS 17 and macOS 15 as its minimum supported Apple platforms. The Xcode project currently declares the same minimums.

## Platform decision

Bible Study supports:

- **iPhone and iPad:** iOS/iPadOS 17.0 or later;
- **Mac:** macOS 15.0 or later; and
- **language/toolchain:** Swift 6 with complete strict-concurrency checking.

The iPhone remains the primary daily-use surface. iPad is supported through the iOS target and must use responsive layouts. Mac is a first-class reading, planning, learning, and data-management surface rather than a scaled iPhone window.

The app does not support Catalyst, visionOS, watchOS, tvOS, or a web client in the initial roadmap. Adding a platform requires a separate decision covering interaction design, provider SDK support, storage, and verification.

## Support-window policy

Minimum OS versions are not raised automatically when Apple releases a new OS. They are reviewed at most once per major development phase and before a public-distribution review.

A minimum may be raised only when all of the following are true:

1. a required dependency or essential platform capability no longer supports the current minimum;
2. the owner has confirmed every actively used device can run the proposed minimum;
3. a clean build, migration rehearsal, and critical-flow regression suite pass on the new minimum; and
4. the change is recorded in this ADR, release notes, and CI destinations before merging.

Security or provider-enforced changes can trigger an earlier review. Convenience alone is not sufficient reason to strand a device holding the only copy of personal data.

## Data ownership and categories

App-owned data is grouped so migration and deletion behavior stays explicit:

- **irreplaceable user data:** notes, bookmarks, highlights, custom plans, manual completions, learning saves, and user-authored labels;
- **reconstructable state:** reading position, generated schedules, progress projections, cached analytics, and search indexes;
- **preferences:** selected edition, reader appearance, notification settings, jurisdiction, and privacy choices; and
- **provider cache:** Scripture responses, artwork, and audio cached only within provider terms.

Irreplaceable data receives the strongest migration guarantees. Provider caches never substitute for app-owned records and may be purged when licenses or cache directives require it.

## Schema-version policy

The first persistent model introduced in Phase 1 is schema version 1. Every durable model change must be classified before implementation:

- **additive/lightweight:** optional fields, new entities, or fields with deterministic defaults;
- **transforming:** rename, split, merge, type conversion, relationship change, or recomputation; or
- **destructive:** deletion or irreversible loss of user-authored meaning.

Each shipped schema has an immutable version identifier and an explicit path from every previously shipped version. Transforming migrations use a staged migration with deterministic mapping code. Destructive migrations are prohibited unless the owner explicitly approves a documented export/backup and loss plan.

Schema versions are application concepts. They must not be coupled to YouVersion SDK, provider API, app marketing, or Hub contract versions.

## Migration workflow

For every persistent-schema change:

1. preserve a sanitized fixture store for each previously shipped schema;
2. document the semantic change, defaults, rollback limits, and affected analytics;
3. create a pre-migration backup or export before the first irreversible write;
4. run the migration off the main actor where the persistence framework permits;
5. validate record counts, stable IDs, relationships, and user-authored fields;
6. rebuild reconstructable indexes and projections after the authoritative data succeeds; and
7. show a recoverable error instead of opening an empty replacement store when validation fails.

Automated tests must open and migrate every fixture to the current schema. A clean-install test is not evidence that an upgrade is safe.

## Sync and Hub compatibility

Local persistence is implemented before optional iCloud sync. Stable UUIDs and explicit timestamps are required from schema version 1 so later sync does not require identity replacement. Conflict rules are defined per entity before CloudKit is enabled.

The Hub and Echo receive versioned transfer objects, never SwiftData model instances or direct store access. A Hub contract change does not itself require a local schema migration, and a local schema change must not silently change emitted contract semantics.

## Recovery and rollback

- A failed migration retains the original store and its backup.
- The app must never silently reset, overwrite, or create an apparently empty store over a failed store.
- Downgrading the app after a schema upgrade is unsupported unless that release explicitly supplies a reverse migration.
- User-readable export is required before public distribution and before any approved destructive migration.
- Provider cache failures may fall back to refetching; irreplaceable records may not.

## Verification

This policy is enforced incrementally:

- current build settings must remain iOS 17.0, macOS 15.0, and Swift 6;
- CI builds iOS and macOS targets;
- Phase 1 adds schema v1, fixture stores, and migration tests before feature data accumulates; and
- every later schema PR includes old-store-to-current migration results and a manual recovery check.

## Consequences

The project accepts additional fixture maintenance and staged-migration work in exchange for protecting long-lived personal data. Supporting older hardware may constrain use of newer APIs, but availability checks and adapters are preferred until a documented support review approves a minimum change.

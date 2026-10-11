# ADR-005: Version user data with a sync-ready SwiftData schema

- Status: accepted
- Date: 2026-10-11
- Current schema: `1.0.0`

## Decision

Use SwiftData with an explicit `VersionedSchema` and `SchemaMigrationPlan`. Schema v1 contains flat records for profile, reading position, reading plans, immutable completion/reopen events, Scripture annotations, Learning progress, and Learning content provenance.

Every user record has a stable UUID. Mutable or removable records carry modification timestamps and optional tombstone dates so a later CloudKit adapter can merge rather than overwrite ambiguous state. Plan completion changes are append-only events; reopening creates another event instead of deleting history.

Canonical book/chapter/verse fields remain app-owned. Provider and edition IDs are optional metadata on annotations and explicit fields on reader position, never foreign SDK model objects. Private note text is not copied into Hub events, logs, or provider calls.

The initial store is local-only (`cloudKitDatabase: .none`). This is deliberate: CloudKit entitlement, container setup, conflict tests, and account-state UX must be completed before sync is enabled.

## Migration policy

- Never edit a released schema version in place.
- Add `BibleStudySchemaV2` and a migration stage for structural changes.
- Test migrations with representative old stores before changing the app's active schema.
- Prefer additive optional/defaulted fields and stable identifiers.
- Never resolve migration or sync ambiguity by deleting private user data.

## Testing

Unit tests use the same schema and migration plan with an in-memory configuration. Tests must cover round trips for each new record family and migration fixtures beginning with the first schema change.

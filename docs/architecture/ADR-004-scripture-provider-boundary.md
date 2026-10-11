# ADR-004: Keep Scripture vendors behind app-owned capabilities

- Status: accepted
- Date: 2026-10-11

## Decision

Feature and persistence code depends on app-owned `ScriptureProvider`, `ScriptureEdition`, identifier, rights, capability, and failure types. Concrete SDK/API models remain inside their provider adapter or dedicated reader boundary.

The first catalog adapter is `YouVersionScriptureAdapter`. `FixtureScriptureProvider` supplies deterministic, explicitly non-Scripture fixtures for previews and tests. A future API.Bible adapter can use its string edition IDs without changing the neutral edition identifier.

The YouVersion SwiftUI reader is an intentional exception: `YouVersionBibleReaderView` may import the SDK because it is the dedicated rendering boundary. The YouVersion audit/diagnostics implementation may also import it. Home, Plans, Learning, Profile presentation, app persistence, and Hub integration must not import `YouVersionPlatform`.

## Rights behavior

Capabilities are affirmative. An edition may be considered production-eligible only when its exact account license has status `approved`, chapter reading is allowed, and required attribution is present. Pending, blocked, and fixture editions fail closed.

Provider-managed cache does not imply app-managed download rights. Audio, timecodes, search, excerpt sharing, and persistent offline storage are separate capabilities.

## Consequences

- Provider IDs and response models no longer need to leak through feature code.
- A vendor can be replaced without migrating plans, Learning links, or private user content.
- Rights are testable domain state instead of comments or UI assumptions.
- The existing YouVersion reader remains isolated while Phase 2 resolves Catholic chapter navigation.

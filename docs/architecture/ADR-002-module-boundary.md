# ADR-002: Standalone Development Target and Hub Module Boundary

- **Status:** Accepted
- **Date:** 2026-10-11
- **Decision owners:** Product owner and application maintainer

## Context

Bible Study will ultimately live inside a private self-improvement hub alongside Ambition and Echo. The hub application and its final navigation/container APIs do not yet exist in this repository. Bible Study still needs to launch, test, and ship to the owner independently while its product flows mature.

The feature has five internal destinations—Home, Bible, Plans, Learning, and You. Presenting another five-item tab bar inside a future hub tab would create nested navigation, unclear back behavior, and an unnecessarily tight dependency on a container that is still evolving.

## Decision

Bible Study is developed as a self-contained feature module with a standalone Apple application target as its reference host.

The module owns:

- its five internal destinations and all navigation among them;
- its domain models, persistence, provider adapters, plan engine, learning content, and analytics;
- its visual system and responsive iPhone/Mac presentation; and
- its route handling after a route has been handed to the module.

The standalone target owns only process-level composition: launch, configuration, dependency construction, scene lifecycle, and installation of the Bible Study root view.

When the hub is available, it will host the same Bible Study root feature through a thin adapter. The hub will provide one top-level entry point named **Bible Study** and must not wrap the module in another persistent tab bar. On iPhone, entering Bible Study replaces or pushes the hub's primary content so the module's five-tab navigation remains the only tab bar visible. On Mac, the hub may present Bible Study in its content area, but only one navigation sidebar may be visible at a time.

## Public integration surface

The module will expose a small, versioned boundary rather than exposing feature views or vendor SDK objects directly:

- `BibleStudyModuleView`: the composed root view supplied with module dependencies;
- `BibleStudyRoute`: a typed route for Home, Scripture references, plans, learning items, and You;
- `BibleStudyHostContext`: minimal profile/preferences and hub capabilities needed at launch;
- `BibleStudyEvent`: metadata-only events emitted for explicitly supported hub workflows; and
- `BibleStudyIntegrationVersion`: the contract version used for compatibility checks.

These names describe the intended public surface. Their concrete implementation belongs to the hub-contract deliverable and may evolve additively before Phase 1 exits.

The module must not expose `YouVersionPlatform`, YouVersion view types, provider Bible IDs, SwiftData model objects, or internal navigation paths through its public boundary.

## Route ownership

The canonical external URL prefix is `hub://bible-study/`. Initial route shapes are:

- `hub://bible-study/home`
- `hub://bible-study/bible/{OSIS-reference}`
- `hub://bible-study/plans/{plan-id}`
- `hub://bible-study/learning/{article-id}`
- `hub://bible-study/you`

URLs are transport conveniences, not the in-process domain model. They must be parsed into `BibleStudyRoute`, validated, and rejected safely when unknown. Bible edition selection is a user preference or explicit route option; a provider-specific ID is never the permanent identity of a Scripture reference.

## Data ownership

Bible Study is the source of truth for reading position, plans and assignments, local Scripture actions, learning progress, module preferences, and its derived analytics. Echo remains the source of truth for journal entries. The hub may aggregate summaries, but it does not mutate Bible Study storage directly.

Cross-module exchange uses identifiers, canonical Scripture references, timestamps, and deliberately selected prompt/context metadata. It does not share database files, persistence model instances, service singletons, or journal text by default.

## Dependency direction

Dependencies point inward:

```text
Standalone App ─┐
                ├─> Hub Adapter ─> Bible Study public contract ─> Features/Domain
Future Hub ─────┘                                      │
                                                       └─> provider protocols ─> vendor adapters
```

The future hub may depend on the Bible Study public contract. Bible Study domain and feature code must not import the hub application. Vendor adapters may depend on provider SDKs; the public contract and app-owned domain may not.

## Standalone parity rule

Every feature must remain exercisable in the standalone target using local host context and fixture integrations. A feature is not complete if it works only when embedded in the future hub. CI builds the standalone iOS and macOS destinations throughout development.

## Consequences

### Positive

- Work can proceed before the hub implementation is finalized.
- The same product is testable in isolation and embeddable later.
- Provider changes cannot leak into the hub contract.
- Navigation remains understandable on both iPhone and Mac.

### Costs

- A small adapter layer is required for standalone and hub hosts.
- Shared profile/preferences need explicit mapping and conflict rules.
- The hub cannot reach into module internals for quick one-off behavior.

## Rejected alternatives

- **Build directly inside the hub now:** rejected because there is no stable hub contract or repository to target, and it would slow independent testing.
- **Launch Bible Study as a separate process forever:** rejected because it breaks the intended integrated daily loop and makes handoffs feel external.
- **Show the module's five tabs inside a hub tab:** rejected because nested persistent navigation is confusing and reduces usable space.
- **Share one database among all apps:** rejected because it couples migrations, weakens privacy boundaries, and makes ownership ambiguous.

## Validation

This decision is considered implemented when:

- the standalone app launches the same root module intended for the hub;
- contract tests prove routes fail safely and remain provider-neutral;
- dependency tests prevent the public contract from importing provider SDKs; and
- an integration fixture can enter Bible Study at each supported route without a nested tab bar.

Revisit this ADR only if the hub adopts a navigation architecture that cannot host the module without violating these guarantees.

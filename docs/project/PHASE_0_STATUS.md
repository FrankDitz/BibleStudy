# Phase 0 Status

**Status:** Repository work complete; external provider/owner gates remain open  
**Updated:** 2026-10-11

## Completed and merged

| Deliverable | Evidence |
| --- | --- |
| Owner-only product brief and distribution trigger | [`PRODUCT_BRIEF.md`](../product/PRODUCT_BRIEF.md) |
| Standalone/module-in-hub decision | [`ADR-002-module-boundary.md`](../architecture/ADR-002-module-boundary.md) |
| Hub, Echo, profile, virtue, and event contracts | [`HUB_INTEGRATION.md`](../architecture/HUB_INTEGRATION.md) plus contract tests |
| Catholic canon manifest and naming/order policy | [`CATHOLIC_CANON_POLICY.md`](../content/CATHOLIC_CANON_POLICY.md) plus canon tests |
| Provider/translation/audio rights matrix | [`PROVIDER_RIGHTS_MATRIX.md`](../content/PROVIDER_RIGHTS_MATRIX.md) |
| YouVersion stable-SDK spike and live audit harness | [`YOUVERSION_SWIFT_SPIKE.md`](../spikes/YOUVERSION_SWIFT_SPIKE.md) plus audit tests/UI |
| API.Bible audio/fallback contract spike | [`API_BIBLE_AUDIO_FALLBACK_SPIKE.md`](../spikes/API_BIBLE_AUDIO_FALLBACK_SPIKE.md) plus contract tests |
| STREETLIGHTS permission inquiry | [`STREETLIGHTS_PARTNERSHIP_INQUIRY.md`](../content/STREETLIGHTS_PARTNERSHIP_INQUIRY.md), ready but unsent |
| Catholic Learning editorial/source/reviewer policy | [`LEARNING_EDITORIAL_GUIDE.md`](../content/LEARNING_EDITORIAL_GUIDE.md) |
| OS/support and migration policy | [`ADR-003-platform-support-and-data-migrations.md`](../architecture/ADR-003-platform-support-and-data-migrations.md) |
| Backlog, risk register, and Definition of Done | [`INITIAL_BACKLOG.md`](INITIAL_BACKLOG.md), [`RISK_REGISTER.md`](RISK_REGISTER.md), [`DEFINITION_OF_DONE.md`](DEFINITION_OF_DONE.md) |

## Owner/provider actions required to close Phase 0

1. **YouVersion:** register the personal native app, accept the desired Catholic edition licenses, store the App Key only in local `Config/Secrets.xcconfig`, run the in-app edition audit, and perform the manual `ESG`/Daniel/navigation/accessibility/offline/error checklist.
2. **API.Bible:** create the owner account/key, inspect the live licensed Catholic text and audio catalogs, request special audio licensing if desired, and record exact IDs/rights. This is optional if YouVersion passes and audio is deferred.
3. **STREETLIGHTS:** replace the owner placeholders and send the prepared inquiry. A response is not required to close Phase 0 if STREETLIGHTS remains deferred.
4. **Content review:** identify the Catholic reviewer or review route that will approve Learning articles before Phase 5 publication.
5. **Decision record update:** mark the approved primary edition, secondary allowlist, fallback decision, audio decision/deferment, and confirmation dates in the rights matrix.

## Exit-criteria assessment

| Exit criterion | State | Reason |
| --- | --- | --- |
| One legally usable complete Catholic text path for beta | **Open** | Candidate editions exist publicly, but the owner's App Key entitlement/license has not been demonstrated |
| App Key retrieves a complete Catholic edition and attribution | **Open** | Audit harness is ready; live credential and manual Catholic-content checks are pending |
| Primary provider, exact allowlist, audio candidate, and fallback chosen | **Partial** | YouVersion is primary candidate; preferred IDs are known; audio/fallback remain gated or may be explicitly deferred |
| Hub/Echo boundaries accepted | **Complete** | Versioned contracts and tests are merged |
| No unresolved assumption can force a reader/data-model rewrite | **Open** | Stable SDK handling of nonstandard `ESG` chapters requires the live test before reader architecture is locked |

## Go/no-go

Do not declare Phase 0 closed or begin the production reader slice until the YouVersion live gate passes or a licensed fallback is selected. Work on provider-neutral Phase 1 foundation can begin without waiting, but it must not encode a concrete provider assumption or represent any edition/audio source as approved.

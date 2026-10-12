# Phase 0 Status

**Status:** Closed for the text-reader path; optional audio/content-review follow-ups remain
**Updated:** 2026-10-12

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

## Remaining owner/provider follow-ups

1. **YouVersion:** the personal App Key is configured locally and CPDV `42` passed the 73-book audit and live Esther/Daniel navigation checks. Continue the support request for NRSV-CI `2015`; it can be added only after the same runtime audit passes.
2. **API.Bible:** create the owner account/key, inspect the live licensed Catholic text and audio catalogs, request special audio licensing if desired, and record exact IDs/rights. This is optional if YouVersion passes and audio is deferred.
3. **STREETLIGHTS:** replace the owner placeholders and send the prepared inquiry. A response is not required to close Phase 0 if STREETLIGHTS remains deferred.
4. **Content review:** identify the Catholic reviewer or review route that will approve Learning articles before Phase 5 publication.
5. **Decision record update:** mark the approved primary edition, secondary allowlist, fallback decision, audio decision/deferment, and confirmation dates in the rights matrix.

## Exit-criteria assessment

| Exit criterion | State | Reason |
| --- | --- | --- |
| One legally usable complete Catholic text path for beta | **Complete** | The owner’s App Key exposes CPDV `42`, a public-domain Catholic edition, through the licensed YouVersion Platform path |
| App Key retrieves a complete Catholic edition and attribution | **Complete** | CPDV passed the live 73-book, Esther 11–15, Daniel 13–14, and attribution gates on 2026-10-12 |
| Primary provider, exact allowlist, audio candidate, and fallback chosen | **Complete for text** | YouVersion/CPDV `42` is active; NRSV-CI is pending provider access; independent text fallback and audio are explicitly deferred |
| Hub/Echo boundaries accepted | **Complete** | Versioned contracts and tests are merged |
| No unresolved assumption can force a reader/data-model rewrite | **Complete for CPDV** | The app owns canonical navigation/restoration while YouVersion supplies licensed rendering; integrated Esther and Daniel boundaries pass live |

## Go/no-go

The production text-reader gate is cleared for CPDV `42`. NRSV-CI, another text provider, audio, public distribution, or monetization each require a new rights and capability review; none is implied by the CPDV approval.

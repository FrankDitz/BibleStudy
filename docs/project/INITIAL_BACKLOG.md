# Initial Product Backlog

**Planning baseline:** 2026-10-11  
**Source of scope:** [`PRODUCT_ROADMAP.md`](../../PRODUCT_ROADMAP.md)  
**Ordering rule:** rights and data-model risks precede polished feature depth

This backlog is intentionally small enough to steer delivery. The roadmap remains the complete product plan; backlog items are decomposed again immediately before implementation.

## Priority definitions

- **P0:** blocks the next phase or prevents a safe/legal beta.
- **P1:** required for the phase exit but can follow its enabling work.
- **P2:** valuable after the vertical slice is stable.
- **P3:** optional or dependent on an external opportunity.

## Phase 0 gates

| ID | Pri | Backlog item | Acceptance signal | Dependency/status |
| --- | --- | --- | --- | --- |
| BS-0001 | P0 | Register the owner-only YouVersion application and accept candidate edition licenses | App Key remains local; portal record names the personal native app and accepted editions | **Owner action** |
| BS-0002 | P0 | Execute the live YouVersion Catholic edition audit | At least one edition passes attribution, `ESG`, Daniel 13–14, navigation, offline, error, Mac, and accessibility checks | BS-0001; harness merged |
| BS-0003 | P0 | Inspect the owner's API.Bible text/audio catalog | Exact IDs, coverage, license scope, attribution, timecodes, and cache/offline rights are recorded | **Owner/provider action**; harness merged |
| BS-0004 | P1 | Submit the STREETLIGHTS permission inquiry | Sent date and non-secret response summary are recorded; no positive response required | **Owner action**; draft merged |
| BS-0005 | P0 | Select beta Scripture and audio paths | Rights matrix marks one Catholic text path approved; audio is either approved or explicitly deferred | BS-0002/3 |
| BS-0006 | P1 | Appoint the Catholic content reviewer role | Reviewer or review route is recorded outside public content; no article ships without approval | Editorial policy merged |

## Phase 1 — foundation

| ID | Pri | Backlog item | Acceptance signal | Depends on |
| --- | --- | --- | --- | --- |
| BS-0101 | P0 | Define provider-neutral Scripture/audio capability protocols | Feature modules compile against protocols; concrete vendors remain in adapters | BS-0005 |
| BS-0102 | P0 | Create SwiftData schema v1 and migration test harness | In-memory and disk tests cover profile, reading state, plans, annotations, and content provenance | Phase 0 data policies |
| BS-0103 | P0 | Establish dependency container and feature boundaries | Tests prevent vendor imports outside approved adapter/reader locations | BS-0101 |
| BS-0104 | P1 | Finish the design-system state library | Loading, empty, error, offline, locked-rights, and stale-content states render on iPhone/Mac | None |
| BS-0105 | P1 | Complete standalone and hub routing adapters | Five destinations deep-link in both modes without duplicating state | Hub contract |
| BS-0106 | P1 | Add privacy-aware logging and feature flags | Provider failures are diagnosable without credentials, Scripture cache, notes, or reflections in logs | BS-0101 |
| BS-0107 | P0 | Add CI quality gates | macOS tests, iOS build, formatting/lint, secret scan, and dependency-boundary checks run on changes | BS-0101–3 |
| BS-0108 | P1 | Establish accessibility preview/test matrix | Navigation shell passes VoiceOver, largest text, keyboard, contrast, and Reduce Motion checks | BS-0104 |

## Phase 2 — reader vertical slice

**Status:** Closed 2026-10-12. The owner approved moving physical-device accessibility and live offline/error-recovery acceptance to Phase 7 hardening; those checks remain unverified rather than waived permanently.

| ID | Pri | Backlog item | Acceptance signal | Depends on |
| --- | --- | --- | --- | --- |
| BS-0201 | P0 | Implement approved edition catalog and fail-closed attribution | Only licensed/audited editions render; required notice is always visible | BS-0002, BS-0101 |
| BS-0202 | P0 | Resolve `ESG` and nonstandard Catholic chapter navigation | Every approved Esther/Daniel resource opens and crosses boundaries correctly | BS-0002 |
| BS-0203 | P0 | Ship front-to-back reader navigation and restoration | User reads all available books in order and resumes after termination | BS-0201/2, BS-0102 |
| BS-0204 | P1 | Add bookmarks, highlights, and private notes | State survives relaunch and never crosses into provider or Hub events | BS-0102, BS-0203 |
| BS-0205 | P1 | Implement licensed search adapter | Reference/text/topic searches show version, attribution, paging, corrections, and provider errors | BS-0005, BS-0101 |
| BS-0206 | P1 | Complete reader accessibility and theme controls | Largest text, VoiceOver, keyboard, contrast, and Reduce Motion pass on both platforms | BS-0203 |

## Phase 3 — plans

| ID | Pri | Backlog item | Acceptance signal | Depends on |
| --- | --- | --- | --- | --- |
| BS-0301 | P0 | Implement deterministic plan scheduler | Unit tests cover DST, leap years, missed days, pause/resume, ahead/behind, and completion reversal | BS-0102 |
| BS-0302 | P0 | Validate bundled 90-day/year templates | Every canonical assignment exists exactly as designed and template totals are tested | Canon manifest, BS-0301 |
| BS-0303 | P1 | Build custom plan composer | User selects scope, pace, start date, rest days, and recovery behavior with a valid preview | BS-0301 |
| BS-0304 | P1 | Add accountable daily plan flow | Day cards route to reading, save atomically, recover missed days, and expose truthful progress | BS-0203, BS-0301 |

## Phases 4–7

| ID | Pri | Backlog item | Acceptance signal | Depends on |
| --- | --- | --- | --- | --- |
| BS-0401 | P1 | Home “Today” orchestration | Resume, plan, learning, virtue, and recent activity are useful without exposing private text | Phases 2–3 |
| BS-0451 | P0 | Define the seven-virtues formation and provenance model | Namespaced identifiers, sources, review state, freshness, practices, check-ins, and privacy rules are testable | Phase 4 Learning model, hub contract |
| BS-0452 | P0 | Publish seven reviewed virtue pathways | Chastity, temperance, charity, diligence, patience, kindness, and humility each complete the formation loop with approved sources | BS-0451, Catholic reviewer |
| BS-0453 | P1 | Build virtue focus, practices, check-ins, and weekly review | The owner can practice and review without scores, public comparison, punitive streaks, or inferred moral judgment | BS-0451/2 |
| BS-0454 | P1 | Connect virtue formation to Scripture, Plans, Echo, and Home | One namespaced virtue identity crosses allowlisted contracts; no private reflection/check-in text leaves its owner | BS-0401, BS-0451, hub/Echo contracts |
| BS-0455 | P1 | Complete virtue privacy, accessibility, export, and deletion acceptance | iPhone/Mac checks pass and virtue data can be exported/deleted independently | BS-0453/4, Phase 5 data controls |
| BS-0501 | P0 | Implement provenance-aware Learning model | Every item enforces source, scope, reviewer, rights, freshness, and correction metadata | Learning editorial guide, BS-0102 |
| BS-0502 | P1 | Publish first reviewed Learning collection | Mass, sacraments, liturgical year, and prayer modules pass Catholic/content QA | BS-0006, BS-0501 |
| BS-0601 | P1 | Build You analytics and data controls | Streaks/progress are accurate; export/delete and integration status are understandable | BS-0102, Phase 3 |
| BS-0701 | P2 | Implement licensed chapter audio Tier A | Background playback, interruptions, expiry, attribution, position, and provider failures pass | BS-0003/5 |
| BS-0702 | P2 | Add verse follow-along Tier B | Only verified timecodes/versification highlight; motion can be disabled | BS-0701 |
| BS-0703 | P3 | Add permitted offline audio Tier C | Storage, expiry, deletion, and revocation exactly match written rights | Explicit provider permission |

## Backlog hygiene

Before work starts, every item receives an owner, target phase, concrete acceptance tests, privacy/content-rights notes, and dependencies. Split work that cannot be reviewed safely in one change. Close or rewrite an item when provider facts invalidate its premise; do not preserve obsolete scope merely because it appears in this baseline.

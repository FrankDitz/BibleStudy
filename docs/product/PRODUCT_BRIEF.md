# Bible Study — Product Brief

**Status:** Accepted for Phase 0  
**Owner:** Frank Ditz  
**Audience:** Owner-only personal use  
**Last reviewed:** 2026-10-11

## Purpose

Bible Study is an Apple-native Catholic Scripture, formation, and accountability module for Frank's private self-improvement hub. It should make the next faithful action obvious: read Scripture, complete today's plan, learn a Catholic practice, or reflect in Echo.

The product supports growth in the seven Christian virtues and four cardinal virtues without turning prayer or formation into a score. Progress exists to encourage consistency and honest reflection, not comparison.

## Daily loop

1. Open Home and see the most useful next action.
2. Read or listen to an assigned Scripture passage.
3. Mark plan assignments complete and recover gracefully after missed days.
4. Learn a Catholic teaching, ritual, holy day, prayer, or practice from reviewed material.
5. Optionally hand a prompt and Scripture context to Echo for private reflection.

## Product areas

- **Home:** Continue reading, today's plan, seasonal learning, recent progress, and reflection prompts.
- **Bible:** Catholic-canon-aware reading, edition selection, search, navigation, local annotations, attribution, and audio where licensed.
- **Plans:** Premade and custom schedules, daily assignments, completion, recovery, reminders, and accountability analytics.
- **Virtues:** Seven lifelong Christian-formation pathways with Foundations, repeatable Focus Cycles, concrete practices, private review, and an owner-selected Rule of Life.
- **Learning:** Reviewed guides to Catholic worship, sacraments, initiation, prayer, rituals, holy days, devotions, and practical Church life, with sources, jurisdiction, and review status.
- **You:** Private profile, preferences, milestones, analytics, privacy controls, and data management.

## V1 outcome

The owner can use one iPhone or Mac to read a complete licensed Catholic Bible, follow a reliable reading plan, learn core Catholic practices, and reflect through Echo. State persists locally, provider rights are honored, and important flows remain understandable when offline or when a provider is unavailable.

## Product principles

- **Catholic completeness:** Never present a 66-book catalog as a complete Catholic Bible. Canon coverage and edition capability are explicit.
- **Private by default:** Reading history, notes, plan activity, learning progress, and reflections stay local unless the owner deliberately enables a supported sync or handoff.
- **Formation before gamification:** Milestones encourage practice; no social comparison, manipulative streak pressure, or claims that activity measures holiness.
- **Source transparency:** Scripture attribution is always visible. Learning content shows its sources, jurisdiction, and review status.
- **Provider independence:** App-owned features depend on internal Scripture abstractions, not a vendor-specific data model.
- **Apple-native quality:** SwiftUI, accessibility, keyboard support, responsive iPhone/Mac layouts, and platform conventions are requirements.
- **Graceful recovery:** Missed plan days and temporary network/provider failures offer a clear path forward without losing user data.

## Scope boundaries

V1 does not include a social network, public profiles, public content publishing, parish administration, clergy advice, sacramental records, donations, or user-generated plan sharing. It does not reproduce copyrighted Scripture or audio outside the permissions of the relevant provider.

YouVersion is a licensed Scripture delivery dependency, not the product database for plans, learning, profile, analytics, Echo integration, or local annotations. Audio is included only after a provider grants the necessary playback and caching rights.

## Success measures

- The owner can complete the daily loop without developer intervention.
- At least one approved edition exposes all 73 Catholic books with correct attribution.
- Plan schedules never omit or duplicate assignments and survive timezone/calendar edge cases.
- Every published learning item has a source, jurisdiction, reviewer, and review date.
- VoiceOver, Dynamic Type, keyboard navigation, and offline/error states work in the primary flows.
- The app collects no unnecessary personal data and never sends journal text without explicit consent.

## Distribution-change review trigger

This brief authorizes development only for owner-only personal use. Before any beta invitation, TestFlight distribution to another person, App Store submission, public repository containing provider material, institutional deployment, commercialization, or transfer to another owner, development pauses for a distribution review.

That review must re-confirm:

- YouVersion Platform eligibility, App Key scope, edition licenses, attribution, rate limits, caching, and branding requirements;
- Scripture and audio redistribution, download, clipping, and sharing rights;
- privacy disclosures, account/data-deletion behavior, analytics consent, and applicable platform rules;
- learning-content copyright and ecclesial review responsibilities; and
- whether product positioning or functionality could reasonably compete with, substitute for, or misrepresent a provider.

Personal use reduces product-market conflict; it does not waive copyright, contract, attribution, privacy, or API-license obligations.

## Approval and change control

The owner approves this brief by merging it to `main`. Any change to audience, distribution, monetization, cloud sharing, public content, Scripture provider, or audio source requires an updated brief and architecture/licensing review before implementation continues.

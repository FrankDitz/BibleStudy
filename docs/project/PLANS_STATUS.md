# Plans Phase Status

**Implementation status:** complete
**Phase-exit status:** passed
**Verified:** 2026-10-12

Phase 3 now delivers the complete accountable reading-plan loop: deterministic scheduling, validated Catholic templates, custom composition, durable activation, assignment-level completion, recovery, progress, and exact reader routing.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0301 | Deterministic plan scheduler covering eligible weekdays, DST, leap years, missed work, pause/resume, recovery, ahead/behind state, and completion reversal | `ReadingPlanScheduler`, `PlanLocalDate`, recovery revisions, completion ledger, focused scheduler tests | Complete |
| BS-0302 | Validate bundled Catholic plan templates and exact canonical coverage | Seven v1 assignment manifests, licensed-edition chapter snapshot, and coverage validator tests | Complete |
| BS-0303 | Build custom plan composer with workload preview | Catholic canon/testament/book/passage scope, finish-date or chapters-per-day pace, dates, weekdays, ordering, recovery, reminder, and truthful workload preview | Complete |
| BS-0304 | Add active-plan day flow and truthful persistence | Cover art, selectable day rail, assignment checklist, completion/reversal, reader routing, pause/resume, recovery, archival, and progress | Complete |

## Scheduler decisions

- Logical day indices are one-based and preserve immutable template intent.
- `PlanLocalDate` stores year/month/day independently of an absolute instant; a supplied calendar is used only for weekday and date arithmetic.
- Eligible weekdays are explicit and nonempty. The scheduler never silently adds a reading day on a disabled weekday.
- Pace compares completed logical days with logical days due by the selected local date. Reading ahead, falling behind, and full completion are distinct states.
- Duplicate completion-event IDs are idempotent; a later `reopened` event reverses completion without deleting history.
- Pausing leaves completed days fixed and reschedules only unfinished affected days from the selected resume date.
- Keep Dates, Shift Forward, Redistribute, and New Finish Date create a before/after `PlanScheduleRevision`; no recovery mode silently mutates past completion.
- Redistribution may assign multiple logical days to one eligible date when the remaining workload exceeds available dates. The future UI must show that workload plainly.

## Template decisions

- Template identity and assignment IDs are revisioned independently from the compatible canon manifest, so future corrections can be migrated instead of silently changing an active plan.
- The v1 canon manifest is the live chapter layout returned for the licensed YouVersion CPDV edition (version 42): 73 books and 1,333 chapters, with Esther 11–15 and Daniel 13–14 integrated.
- New Testament in 90 Days, Catholic Old Testament in 90 Days, Catholic Bible in a Year, The Gospels in 30 Days, and Start with Jesus use deterministic balanced chapter distribution.
- Psalms and Proverbs in 31 Days intentionally pairs five psalms with one proverb for days 1–30, then closes with Proverbs 31.
- Catholic Deuterocanon in 30 Days was added because it serves a distinct Catholic study need: the seven deuterocanonical books plus the additions to Esther and Daniel.
- Template references remain app-owned and provider-neutral. Only editions explicitly compatible with the template's canon manifest may open its assignments.

## Active-plan interaction contract

- Large plan cover art leads the screen, followed immediately by a horizontal day rail and the selected day's readings.
- Tapping a day selects it; it does not mark the day complete. The checkmark is derived from all assignments in that day being complete and reverses if any assignment is reopened.
- Each reading row has a distinct completion control and a navigation action that opens that exact assignment in the approved Bible reader.
- Start/Continue Reading opens the selected day's first incomplete assignment. The selected day and next due day remain easy to bring back into view while past and future days stay inspectable.
- The screen shows truthful Day N of Total and Ahead, On Track, Behind, or Complete state from the scheduling engine rather than a decorative streak.

## Composer decisions

- Scope may cover the full 73-book Catholic canon, either Testament, selected books, or an exact chapter/verse passage. Every selection resolves against the same licensed CPDV chapter manifest as the bundled plans.
- Pace is either a target number of chapters per eligible reading day or a finish date. Finish-date plans balance the workload and spread short plans across the chosen window without inventing empty reading days.
- Eligible weekdays are explicit; unselected weekdays are disclosed as rest days. The preview reports its actual reading-day count, finish date, daily chapter range, estimated minutes, and rest-day count.
- Canonical order is the default. Interleaving preserves the internal order of both Testaments and is accepted only when the chosen scope contains both.
- A demanding-workload warning appears when the busiest day reaches ten or more chapters.
- Recovery and optional reminder preferences are retained in the draft, and activation persists the exact validated preview shown to the user.

## Persistence and active-flow decisions

- Schema v2 adds active-plan snapshots and assignment-completion events through a lightweight migration. A non-destructive automatic migration fallback preserves stores created by early development builds whose schema fingerprint predates the version chain.
- Activating a plan stores its exact title, source revision, canon manifest, compatible edition, assignments, dates, eligible weekdays, recovery preference, reminder, and cover style. Later catalog changes cannot silently rewrite an in-progress plan.
- Completion is an append-only assignment event ledger. A day becomes complete only when every assignment is complete; reopening any assignment immediately reverses day and plan completion.
- Starting a new plan archives the prior active, paused, or completed plan. Archiving removes a plan from the active surface without deleting its history.
- The active screen follows the agreed visual hierarchy: large cover, horizontal selectable day rail, truthful Day N of Total and pace, reading checklist, then Start/Continue Reading.
- Reading rows navigate using the snapshot's approved provider-neutral Scripture reference. The completion control is separate, so opening a reading never marks it complete accidentally.
- Pause/resume and all four recovery modes preserve completed work and use the scheduling engine to revise only unfinished dates.

## Verification evidence

- Focused tests cover both DST transitions, leap day, cross-timezone local-date stability, weekday filtering, missed-day pace, reading ahead, early completion, duplicate events, completion reversal, pause/resume, Keep Dates, Shift Forward, redistribution, and invalid input.
- A live, key-backed CPDV metadata probe confirmed all 73 book resources and their chapter identifiers before the manifest was recorded; no credential or Scripture text was persisted.
- Coverage tests prove all seven templates have valid sequential days and assignments, exact intended coverage, unique stable IDs, no omitted or duplicated chapters, compatible preview routing, and stable duration/workload totals.
- Composer tests cover every scope, both pace models, weekday filtering, fixed-window spreading, canonical and interleaved order, exact verses, reminders, recovery preferences, invalid inputs, and demanding workloads.
- The Plans UI exposes the composer on both Apple platforms and has an accessibility-addressable smoke test for a valid initial preview.
- All macOS unit and contract tests cover activation, snapshot restoration, migration, assignment completion and reversal, completed-plan reopening, archival, pause/resume, recovery schedule persistence, and invalid assignment rejection in addition to the earlier Phase 3 coverage.
- The generic iOS Simulator app and UI-test bundle build successfully.

## Phase exit

Phase 3 is complete. The next roadmap item is BS-0401, which brings the active plan's next due reading into Home's Today orchestration alongside Bible, Learning, virtue, and recent activity entry points.

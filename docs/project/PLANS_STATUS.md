# Plans Phase Status

**Implementation status:** in progress
**Phase-exit status:** persistence and end-to-end active-plan flow remain
**Verified:** 2026-10-12

Phase 3 now has an app-owned deterministic scheduling engine, versioned Catholic reading-plan manifests, and a native custom-plan composer. The scheduler keeps logical plan days separate from calendar dates, while both premade and custom plans validate their assignments against the licensed CPDV chapter layout before a plan can be trusted.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0301 | Deterministic plan scheduler covering eligible weekdays, DST, leap years, missed work, pause/resume, recovery, ahead/behind state, and completion reversal | `ReadingPlanScheduler`, `PlanLocalDate`, recovery revisions, completion ledger, focused scheduler tests | Complete |
| BS-0302 | Validate bundled Catholic plan templates and exact canonical coverage | Seven v1 assignment manifests, licensed-edition chapter snapshot, and coverage validator tests | Complete |
| BS-0303 | Build custom plan composer with workload preview | Catholic canon/testament/book/passage scope, finish-date or chapters-per-day pace, dates, weekdays, ordering, recovery, reminder, and truthful workload preview | Complete |
| BS-0304 | Add active-plan day flow and truthful persistence | Cover art, selectable day rail, assignment checklist, completion/reversal, reader routing, recovery, and progress | Not started |

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
- Recovery and optional reminder preferences are retained in the draft for activation. The composer does not pretend to save or activate a plan before BS-0304 adds durable plan state.

## Verification evidence

- Focused tests cover both DST transitions, leap day, cross-timezone local-date stability, weekday filtering, missed-day pace, reading ahead, early completion, duplicate events, completion reversal, pause/resume, Keep Dates, Shift Forward, redistribution, and invalid input.
- A live, key-backed CPDV metadata probe confirmed all 73 book resources and their chapter identifiers before the manifest was recorded; no credential or Scripture text was persisted.
- Coverage tests prove all seven templates have valid sequential days and assignments, exact intended coverage, unique stable IDs, no omitted or duplicated chapters, compatible preview routing, and stable duration/workload totals.
- Composer tests cover every scope, both pace models, weekday filtering, fixed-window spreading, canonical and interleaved order, exact verses, reminders, recovery preferences, invalid inputs, and demanding workloads.
- The Plans UI exposes the composer on both Apple platforms and has an accessibility-addressable smoke test for a valid initial preview.
- All 102 macOS unit and contract tests pass with the composer included.
- The generic iOS Simulator app and UI-test bundle build successfully.

## Next deliverable

BS-0304 will persist and activate premade or custom plans, then implement the agreed cover-art, selectable-day-rail, assignment-checklist, reader-routing, recovery, and truthful progress experience.

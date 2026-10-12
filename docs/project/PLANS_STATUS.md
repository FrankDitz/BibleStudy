# Plans Phase Status

**Implementation status:** in progress
**Phase-exit status:** composer, persistence, and end-to-end plan flow remain
**Verified:** 2026-10-12

Phase 3 now has an app-owned deterministic scheduling engine and versioned Catholic reading-plan manifests. The scheduler keeps logical plan days separate from calendar dates, while the template layer validates every assignment against the licensed CPDV chapter layout before a plan can be trusted.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0301 | Deterministic plan scheduler covering eligible weekdays, DST, leap years, missed work, pause/resume, recovery, ahead/behind state, and completion reversal | `ReadingPlanScheduler`, `PlanLocalDate`, recovery revisions, completion ledger, focused scheduler tests | Complete |
| BS-0302 | Validate bundled Catholic plan templates and exact canonical coverage | Seven v1 assignment manifests, licensed-edition chapter snapshot, and coverage validator tests | Complete |
| BS-0303 | Build custom plan composer with workload preview | Scope, pace, date, weekday, rest-day, and recovery controls | Not started |
| BS-0304 | Add active-plan day flow and truthful persistence | Day rail, assignments, completion/reversal, reader routing, recovery, and progress | Not started |

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

## Verification evidence

- Focused tests cover both DST transitions, leap day, cross-timezone local-date stability, weekday filtering, missed-day pace, reading ahead, early completion, duplicate events, completion reversal, pause/resume, Keep Dates, Shift Forward, redistribution, and invalid input.
- A live, key-backed CPDV metadata probe confirmed all 73 book resources and their chapter identifiers before the manifest was recorded; no credential or Scripture text was persisted.
- Coverage tests prove all seven templates have valid sequential days and assignments, exact intended coverage, unique stable IDs, no omitted or duplicated chapters, compatible preview routing, and stable duration/workload totals.
- All 91 macOS unit and contract tests pass after adding scheduler and template coverage.
- The generic iOS Simulator app and UI-test bundle build successfully.

## Next deliverable

BS-0303 will build the custom plan composer on the validated scheduler and canon manifest. It will cover scope, pace, start/finish dates, eligible weekdays, rest days, recovery behavior, and a truthful workload preview before a plan is created.

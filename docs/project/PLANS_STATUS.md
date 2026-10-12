# Plans Phase Status

**Implementation status:** in progress
**Phase-exit status:** template, composer, persistence, and end-to-end plan flow remain
**Verified:** 2026-10-12

Phase 3 begins with an app-owned deterministic scheduling engine. It operates on calendar-local date values rather than midnight timestamps, keeps logical plan days separate from calendar dates, and derives completion from append/reopen events so a reversal is explicit and idempotent.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0301 | Deterministic plan scheduler covering eligible weekdays, DST, leap years, missed work, pause/resume, recovery, ahead/behind state, and completion reversal | `ReadingPlanScheduler`, `PlanLocalDate`, recovery revisions, completion ledger, focused scheduler tests | Complete |
| BS-0302 | Validate six bundled Catholic plan templates and exact canonical coverage | Template manifests and coverage tests | Not started |
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

## Verification evidence

- Focused tests cover both DST transitions, leap day, cross-timezone local-date stability, weekday filtering, missed-day pace, reading ahead, early completion, duplicate events, completion reversal, pause/resume, Keep Dates, Shift Forward, redistribution, and invalid input.
- All 82 macOS unit and contract tests pass after adding the scheduler coverage.
- The generic iOS Simulator app and UI-test bundle build successfully.

## Next deliverable

BS-0302 will replace the current preview-only template cards with versioned assignment manifests for the New Testament in 90 days, Catholic Old Testament in 90 days, Catholic Bible in one year, Gospels in 30 days, Psalms and Proverbs rhythm, and Start with Jesus. Coverage tests must prove that every assignment is valid and that whole-canon templates omit or duplicate nothing unintentionally.

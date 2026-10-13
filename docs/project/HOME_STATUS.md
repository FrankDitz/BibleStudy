# Home Phase Status

**Implementation status:** complete  
**Phase-exit status:** passed  
**Verified:** 2026-10-13

Phase 4 turns Home into a truthful “Today” surface. It derives the next useful action from app-owned local state and routes directly into Scripture, the active plan, or Learning without copying private note or reflection text into the dashboard.

## Deliverable

| ID | Deliverable | Evidence | Status |
| --- | --- | --- | --- |
| BS-0401 | Home “Today” orchestration | Saved-reading resume, exact next plan chapter, active-plan routing, learning recommendation, weekly virtue practice and Scripture, deduplicated recent activity, calendar-day plan rhythm, privacy-safe empty/error states | Complete |

## Product decisions

- The active plan is the primary Home action. It shows the earliest unfinished due day, exact per-chapter progress, truthful pace, overall progress, and separate routes to the next chapter or full plan.
- Continue Reading restores the latest approved provider-neutral Scripture reference. Without a saved position, it explicitly offers the approved development starting passage rather than pretending a history exists.
- Learning recommends an unfinished catalog topic deterministically. Once every current topic is complete, the language changes from learning to review.
- The virtue card is a weekly, non-scored practice prompt with a Scripture route. Phase 4 does not pretend this is the reviewed virtue-pathway system; that remains the Phase 4.5 formation track.
- “Plan rhythm” counts consecutive local calendar days represented by assignments whose latest event remains completed. Reopened work is removed from the calculation, and yesterday may preserve a current rhythm without punitive pressure.
- Recent activity collapses repeated events for the same plan assignment to its latest state. It may show safe action metadata, but never annotation text, reflection text, cached Scripture, or journal content.
- Home remains a read-only orchestrator over app-owned stores. It does not duplicate plan, Bible, Learning, annotation, or Echo state.

## Verification evidence

- Repository tests cover saved and empty reading positions, exact next-chapter routing, completion/reopen behavior, local-date streak boundaries, learning recommendations, weekly virtue rotation, and private-note redaction.
- The complete macOS unit and contract target passes.
- The generic iOS Simulator app and UI-test bundle build successfully.
- Native macOS accessibility inspection verifies the Today hierarchy and all primary routes.

## Phase exit

Phase 4 is complete. The next roadmap section is the seven-virtues formation track beginning with BS-0451: a reviewed, provenance-aware model for practices, check-ins, and privacy.

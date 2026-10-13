# Seven Virtues Formation Status

**Phase:** 4A — Seven Virtues formation  
**Current deliverable:** BS-0455 — Weekly review and Then/Now reflection
**Status:** Complete; verification passed
**Started:** 2026-10-13
**Verified:** 2026-10-13

## Product decisions

- Virtues is a first-class product destination, separate from Catholic-life Learning.
- iPhone keeps five permanent tabs—Home, Bible, Plans, Virtues, and Learning—while You opens from the profile control. Mac shows all six destinations in its sidebar.
- Completing the seven Foundations pathways is an introduction, not an endpoint. Continuing formation uses repeatable Focus Cycles and an owner-selected Rule of Life.
- Progress reports factual participation and owner-written observations. The app never computes virtue scores, ranks, mastery, inferred weaknesses, or moral judgments.
- Learning owns Catholic rituals, sacraments and initiation, prayer, liturgical seasons and holy days, devotions, and practical participation in Church life.

## Deliverables

| ID | Deliverable | Status |
| --- | --- | --- |
| BS-0451 | Formation/provenance/privacy model and first-class navigation | Complete |
| BS-0452 | Seven reviewed Foundations pathways | Source-checked implementation complete; qualified Catholic approval pending |
| BS-0453 | Repeatable owner-selected Focus Cycles | Complete |
| BS-0454 | Daily practice and private check-ins | Complete |
| BS-0455 | Weekly review and Then/Now reflection | Complete |
| BS-0456 | Practice library, thematic journeys, and Rule of Life | Not started |
| BS-0457 | Formation Record and app/hub integrations | Not started |
| BS-0458 | Privacy, accessibility, export/delete, and release acceptance | Not started |

## BS-0452 implementation

All seven cards now open complete pathway drafts with teaching, Catholic context, common distortions, three Scripture encounters linked to the Bible reader, three repeatable practice previews, examen prompts, prayer, pastoral boundaries, and exact official sources. The content uses the existing publication gate and a reviewer packet at `docs/content/VIRTUE_FOUNDATIONS_REVIEW_PACKET.md`.

The app labels every pathway **Source-checked draft · Catholic review pending**. It does not claim that generated or source-checked text has received qualified Catholic approval. The gate reports only `notApproved` and `missingReviewDates` for each structurally complete draft.

## BS-0453 implementation

The owner can start an unlimited sequence of Focus Cycles by deliberately choosing one of the seven virtues, a relevant life context, one compatible concrete practice, and a one-, two-, or four-week duration. Only one cycle may be open at once. Pausing freezes elapsed formation time, and returning shifts the target date without penalties, broken-streak language, or lost history. Closing a cycle preserves its factual snapshot and permits the next cycle.

## BS-0454 implementation

The active practice replaces Home's generic weekly rotation and may be checked in directly from Home. The full cycle screen supports all five factual states plus an optional private observation. One entry per local calendar day is updated rather than duplicated. Paused cycles reject check-ins, private text stays out of Home activity and shareable metadata, and the interface contains no score, points, grade, or punitive streak.

## BS-0455 implementation

Each cycle now has a prayerful weekly review built from the owner's factual check-in history. The review shows days engaged and the recorded check-in states without scores or moral conclusions, preserves the owner's optional beginning reflection as “Then,” requires the owner to write “Now,” and offers deliberate continue, change, retain, or close decisions. Submitting the same week's review updates that review instead of duplicating it. Pauses remain neutral and do not turn unrecorded days into failures.

## Verification

- Publication-gate tests cover approved, draft, incomplete, stale, and namespaced-pathway states.
- Privacy tests prove the shareable check-in projection cannot represent a private observation.
- All macOS unit and contract tests pass.
- The generic iOS Simulator app and UI-test bundle build successfully.
- A focused macOS UI test and live accessibility inspection confirm the first-class Virtues destination, formation journey, seven pathways, and privacy statement.
- Strict Swift formatting and whitespace checks pass.
- Seven-pathway library tests verify complete content, unique identifiers, official Vatican sources, Catholic-canon Scripture references, and fail-closed review state.
- Each pathway detail provides an inspectable source trail and preserves the no-score, no-mastery formation boundary.

## Next deliverable

BS-0456 adds a browsable practice library, source-checked thematic journeys, and an owner-curated Rule of Life. Qualified Catholic review is still required to close BS-0452 formally; unapproved content remains visibly gated.

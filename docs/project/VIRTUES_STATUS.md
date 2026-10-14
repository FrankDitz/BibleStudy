# Virtue Study and Formation Status

**Phase:** 4A — Seven Virtues formation  
**Current deliverable:** BS-0461–BS-0462 — extended Catholic virtue curriculum
**Status:** Implemented and technically verified; qualified Catholic review pending
**Started:** 2026-10-13
**Verified:** 2026-10-14

## Product decisions

- Virtues is a first-class product destination, separate from Catholic-life Learning.
- iPhone keeps five permanent tabs—Home, Bible, Plans, Virtues, and Learning—while You opens from the profile control. Mac shows all six destinations in its sidebar.
- Completing the seven Foundations pathways is an introduction, not an endpoint. Continuing formation uses repeatable Focus Cycles and an owner-selected Rule of Life.
- Progress reports factual participation and owner-written observations. The app never computes virtue scores, ranks, mastery, inferred weaknesses, or moral judgments.
- Learning owns Catholic rituals, sacraments and initiation, prayer, liturgical seasons and holy days, devotions, and practical participation in Church life.
- The primary Virtues experience is now learning-first: a ten-lesson orientation, seven ten-lesson counter-virtue courses, and four ten-lesson cardinal-virtue courses. Focus Cycles and the Rule of Life are secondary application tools.
- The counter-virtue track uses the exact formation pairs approved for this app: Humility/Pride, Charity and Generosity/Avarice, Kindness and Goodwill/Envy, Patience and Meekness/Wrath, Chastity/Lust, Temperance/Gluttony, and Diligence and Perseverance/Sloth or Acedia.
- Temperance appears in two courses but is one virtue: the counter-virtue course applies it to gluttony, while the cardinal course teaches its wider moral scope.
- Course completion records lessons studied. It never represents virtue mastery, holiness, culpability, or moral worth.
- Joseph Rickaby’s 1908 *Four-Square* informs the course architecture as a historical secondary source. Current Catechism and universal-Church teaching govern definitions and pastoral framing.

## Deliverables

| ID | Deliverable | Status |
| --- | --- | --- |
| BS-0451 | Formation/provenance/privacy model and first-class navigation | Complete |
| BS-0452 | Seven reviewed Foundations pathways | Source-checked implementation complete; qualified Catholic approval pending |
| BS-0453 | Repeatable owner-selected Focus Cycles | Complete |
| BS-0454 | Daily practice and private check-ins | Complete |
| BS-0455 | Weekly review and Then/Now reflection | Complete |
| BS-0456 | Practice library, thematic journeys, and Rule of Life | Complete |
| BS-0457 | Formation Record and app/hub integrations | Complete |
| BS-0458 | Privacy, accessibility, export/delete, and release acceptance | Not started |
| BS-0459 | Curriculum architecture and source method | Complete |
| BS-0460 | Textbook-like course library, preview, lesson reader, and resume | Complete |
| BS-0461 | Orientation and four extended cardinal-virtue curricula | Complete as 50 source-checked draft lessons; Catholic review pending |
| BS-0462 | Seven extended capital-sin counter-virtue curricula | Complete as 70 source-checked draft lessons; Catholic review pending |
| BS-0463 | Practice bridge, persistence, accessibility, and acceptance | Complete |

## Learning-first curriculum pivot

The Virtues tab now presents twelve courses and 120 lessons: one ten-lesson orientation, seven ten-lesson counter-virtue courses, and four ten-lesson cardinal-virtue courses. Every course exposes its full outline, estimated study time, purpose, source trail, and review status before the owner begins. Every lesson contains core teaching, a doctrinal distinction, a Catholic witness, a realistic case, concrete practice, prayer, a Catholic-canon Scripture route, three retrieval prompts, and exact source identifiers. Progress is local, reversible, backward-compatible with existing course and lesson identifiers, and expressed only as lessons completed.

The earlier Focus Cycle, practice library, thematic journey, Rule of Life, Formation Record, and Echo features remain available under **Live what you learn**. Existing data is preserved; these tools no longer dominate the tab or stand in for teaching.

## BS-0452 implementation

All seven cards now open complete pathway drafts with teaching, Catholic context, common distortions, three Scripture encounters linked to the Bible reader, three repeatable practice previews, examen prompts, prayer, pastoral boundaries, and exact official sources. The content uses the existing publication gate and a reviewer packet at `docs/content/VIRTUE_FOUNDATIONS_REVIEW_PACKET.md`.

The app labels every pathway **Source-checked draft · Catholic review pending**. It does not claim that generated or source-checked text has received qualified Catholic approval. The gate reports only `notApproved` and `missingReviewDates` for each structurally complete draft.

## BS-0453 implementation

The owner can start an unlimited sequence of Focus Cycles by deliberately choosing one of the seven virtues, a relevant life context, one compatible concrete practice, and a one-, two-, or four-week duration. Only one cycle may be open at once. Pausing freezes elapsed formation time, and returning shifts the target date without penalties, broken-streak language, or lost history. Closing a cycle preserves its factual snapshot and permits the next cycle.

## BS-0454 implementation

The active practice replaces Home's generic weekly rotation and may be checked in directly from Home. The full cycle screen supports all five factual states plus an optional private observation. One entry per local calendar day is updated rather than duplicated. Paused cycles reject check-ins, private text stays out of Home activity and shareable metadata, and the interface contains no score, points, grade, or punitive streak.

## BS-0455 implementation

Each cycle now has a prayerful weekly review built from the owner's factual check-in history. The review shows days engaged and the recorded check-in states without scores or moral conclusions, preserves the owner's optional beginning reflection as “Then,” requires the owner to write “Now,” and offers deliberate continue, change, retain, or close decisions. Submitting the same week's review updates that review instead of duplicating it. Pauses remain neutral and do not turn unrecorded days into failures.

## BS-0456 implementation

The full set of Foundation practices is now browsable by life context and commitment size, and any compatible practice can seed a Focus Cycle. Five context-driven thematic journeys connect multiple virtues for faithful work, speech and relationships, digital freedom, service and community, and difficult seasons. Each journey carries exact Vatican sources, remains visibly marked as a source-checked draft pending Catholic review, and supports discernment rather than imposing a rigid program. Choosing “Retain” in a cycle review adds that concrete practice to the owner's Rule of Life; practices can be retired and restored without erasing their revision history.

## BS-0457 implementation

The Formation Record presents only owner-recorded facts: cycles begun and closed, reviews written, contexts practiced, retained practices, check-in-state counts, cycle history, and quiet milestones. It never calculates a percentage, rank, virtue score, inferred weakness, or claim of mastery. The record is reachable from both Virtues and You. Each cycle can prepare an explicit Echo reflection request containing a fresh prompt and the relevant virtue identifier, while excluding private check-in observations and review text. A transport-neutral `virtueCycleCompleted` hub event exposes only the cycle identifier, timestamp, and virtue identifier. Home continues to show the active practice; Scripture links remain inside Foundation pathways. Virtue work does not silently advance Bible reading plans.

## Verification

- Publication-gate tests cover approved, draft, incomplete, stale, and namespaced-pathway states.
- Privacy tests prove the shareable check-in projection cannot represent a private observation.
- All macOS unit and contract tests pass.
- The generic iOS Simulator app and UI-test bundle build successfully.
- A focused macOS UI test and live accessibility inspection confirm the learning-first landing page, honest course preview, complete lesson outline, lesson reader, Scripture route, source trail, and practice bridge.
- Strict Swift formatting and whitespace checks pass.
- Seven-pathway library tests verify complete content, unique identifiers, official Vatican sources, Catholic-canon Scripture references, and fail-closed review state.
- Extended-curriculum tests enforce twelve courses, exactly ten lessons per course, the seven approved vice–virtue pairings, source integrity, Rickaby's secondary-only role, and legacy progress identifiers.
- Each pathway detail provides an inspectable source trail and preserves the no-score, no-mastery formation boundary.

## Next deliverable

Have a qualified Catholic reviewer use `docs/content/VIRTUE_CURRICULUM_REVIEW_PACKET.md` before changing the visible review state. The next engineering deliverable is the deferred BS-0458 export/delete and release-acceptance work.

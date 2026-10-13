# Seven Virtues Formation Status

**Phase:** 4A — Seven Virtues formation  
**Current deliverable:** BS-0451 — Formation model and first-class destination  
**Status:** Complete; phase-exit checks passed  
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
| BS-0452 | Seven reviewed Foundations pathways | Not started; requires approved sources and review route |
| BS-0453 | Repeatable owner-selected Focus Cycles | Not started |
| BS-0454 | Daily practice and private check-ins | Not started |
| BS-0455 | Weekly review and Then/Now reflection | Not started |
| BS-0456 | Practice library, thematic journeys, and Rule of Life | Not started |
| BS-0457 | Formation Record and app/hub integrations | Not started |
| BS-0458 | Privacy, accessibility, export/delete, and release acceptance | Not started |

## BS-0451 boundary

The first deliverable establishes publishability gates for sources, Catholic review, freshness, Scripture references, practices, examen prompts, and pastoral boundaries. It also defines privacy-safe check-in metadata that cannot represent a private observation.

The seven visible pathway cards remain explicitly **in review** until BS-0452 supplies reviewed content. Planning summaries are not presented as approved catechesis.

## Verification

- Publication-gate tests cover approved, draft, incomplete, stale, and namespaced-pathway states.
- Privacy tests prove the shareable check-in projection cannot represent a private observation.
- All macOS unit and contract tests pass.
- The generic iOS Simulator app and UI-test bundle build successfully.
- A focused macOS UI test and live accessibility inspection confirm the first-class Virtues destination, formation journey, seven pathways, and privacy statement.
- Strict Swift formatting and whitespace checks pass.

## Next deliverable

BS-0452 publishes the seven reviewed Foundations pathways. It requires approved Catholic source selections and a recorded Catholic review route; unreviewed generated teaching will continue to fail closed.

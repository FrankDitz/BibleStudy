# Virtue Study and Formation Status

**Phase:** 4A — Seven Virtues formation  
**Current deliverable:** Complete-curriculum owner inspection and qualified Catholic review
**Status:** All twelve courses and 121 lessons technically verified; qualified Catholic review pending
**Started:** 2026-10-13
**Verified:** 2026-10-14

## Product decisions

- Virtues is a first-class product destination, separate from Catholic-life Learning.
- iPhone keeps five permanent tabs—Home, Bible, Plans, Virtues, and Learning—while You opens from the profile control. Mac shows all six destinations in its sidebar.
- Completing the seven Foundations pathways is an introduction, not an endpoint. Continuing formation uses repeatable Focus Cycles and an owner-selected Rule of Life.
- Progress reports factual participation and owner-written observations. The app never computes virtue scores, ranks, mastery, inferred weaknesses, or moral judgments.
- Learning owns Catholic rituals, sacraments and initiation, prayer, liturgical seasons and holy days, devotions, and practical participation in Church life.
- The primary Virtues experience is now learning-first: an eleven-lesson orientation, seven ten-lesson counter-virtue courses, and four ten-lesson cardinal-virtue courses. Focus Cycles and the Rule of Life are secondary application tools.
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
| BS-0461 | Orientation and four extended cardinal-virtue curricula | Complete technically: Orientation, Prudence, Justice, Fortitude, and Temperance are full lecture drafts and pass the enforced learning gates; qualified Catholic review pending |
| BS-0462 | Seven extended capital-sin counter-virtue curricula | Complete technically: all seven courses are full lecture drafts and pass the enforced learning gates; qualified Catholic review pending |
| BS-0463 | Practice bridge, persistence, accessibility, and acceptance | Complete |

## Learning-first curriculum pivot

The curriculum has a twelve-course, 121-lesson architecture, but the earlier implementation did not meet its own educational promise. Short paragraphs and one brief Scripture route were incorrectly presented with roughly twenty-minute estimates. Those drafts are now treated as prototypes rather than publishable courses.

The eleven-lesson foundation course, all four ten-lesson cardinal courses, and all seven ten-lesson counter-virtue courses are currently available. Every available lesson contains at least 800 words of actual instruction and 1,000 words overall, at least three contextual Scripture readings totaling 24 or more verses, a misconception check, a reasoned case, guided self-examination, concrete practice, prayer, and five review prompts. Study time is calculated from the authored material, assigned Scripture, formation support, and review work rather than hard-coded.

Prudence preserves its ten existing lesson identifiers and now teaches a complete sequence: the true good; attention to reality; memory, docility, and counsel; formation of conscience; proportionate deliberation; command and action; foresight and timing; prayerful discernment; counterfeit forms of prudence; and a capstone discernment. Three ungraded checkpoints provide cumulative recall, and the final lesson rehearses the whole process without assigning a virtue score or judging culpability.

Justice preserves its ten existing lesson identifiers and now teaches a connected sequence: what is due; justice toward God and neighbor; equal dignity and impartiality; truth, promises, and reputation; property, stewardship, and restitution; work, wages, and economic power; authority, participation, and the common good; the relation of justice and charity; the poor and works of mercy; and a capstone justice examination. Three ungraded checkpoints provide cumulative recall. The guided examinations distinguish duties from gifts, attend to power and effects, and direct serious safety, legal, employment, or financial questions toward qualified help rather than private moral verdicts.

Fortitude preserves its ten existing lesson identifiers and now teaches a connected sequence: fear and the difficult good; cowardice, rashness, and stubbornness; motive and charity; ordinary moral courage; patient endurance; Christ's Passion; resistance to evil and injustice; help and human limits; grace and hope; and a capstone graduated courage plan. Three ungraded checkpoints provide cumulative recall. The course explicitly rejects aggression, spectacle, isolated self-sufficiency, and spiritualized danger, directing abuse, self-harm, medical, psychological, legal, recovery, and safeguarding concerns toward qualified real-world help.

Cardinal Temperance preserves its ten existing lesson identifiers and now teaches a connected sequence: fitting measure; integration of desire; creation's goodness; food, drink, and bodily domains; digital attention; possessions and enough; speech and anger; fasting and feasting; compulsion, recovery, and grace; and a capstone four-week rule. Three ungraded checkpoints provide cumulative recall. The course rejects body contempt, arbitrary severity, universal quantities, consumerism, shame-based recovery, and spiritualized medical risk. It distinguishes this broad cardinal treatment from the Temperance-against-Gluttony course, which applies the same virtue specifically to appetite and consumption.

The seven counter-virtue courses preserve every existing course and lesson identifier and now provide seventy complete lessons: Humility against Pride; Charity and Generosity against Avarice; Kindness and Goodwill against Envy; Patience and Meekness against Wrath; Chastity against Lust; Temperance against Gluttony; and Diligence and Perseverance against Sloth or Acedia. Each course moves from the virtue's proper good and the capital vice's root pattern through concrete moral action, grace, community, and sustained practice. Every lesson includes a contextual case, a worked reasoning model, Scripture synthesis, a witness, a guided nine-step examination, concrete practice, prayer, five review prompts, traceable Catholic sources, and appropriate pastoral safeguards. Three ungraded checkpoints in each course reinforce cumulative learning without scoring virtue, culpability, or holiness.

Progress remains local, reversible, backward-compatible with existing course and lesson identifiers, and expressed only as lessons completed.

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
- All macOS unit and contract tests pass, including full-lecture gates for all 121 lessons.
- The generic iOS Simulator app and UI-test bundle build successfully.
- A focused macOS UI test and live accessibility inspection confirm the learning-first landing page, honest course preview, complete lesson outline, lesson reader, Scripture route, source trail, and practice bridge.
- Strict Swift formatting and whitespace checks pass.
- Seven-pathway library tests verify complete content, unique identifiers, official Vatican sources, Catholic-canon Scripture references, and fail-closed review state.
- Extended-curriculum tests enforce twelve course definitions, exactly ten lessons per course, the seven approved vice–virtue pairings, source integrity, Rickaby's secondary-only role, and legacy progress identifiers.
- A separate lecture-quality gate rejects any course lesson below 800 instructional words, 1,000 total authored words, three Scripture passages, 24 assigned verses, eight sections, or five review prompts. It also rejects inaccurate time estimates. Only courses whose every lesson passes are available in the interface.
- Each pathway detail provides an inspectable source trail and preserves the no-score, no-mastery formation boundary.

## Next deliverable

Have the owner inspect the complete sequence for educational depth, tone, pacing, Scripture integration, navigation, and usability. Then complete BS-0458 release acceptance and have a qualified Catholic reviewer use `docs/content/VIRTUE_CURRICULUM_REVIEW_PACKET.md` before any course changes from **Catholic review pending**.

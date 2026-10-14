# Bible Study — Product Plan and Delivery Roadmap

Status: active delivery roadmap; Phase 2 closed with owner-approved hardening deferrals

Platforms: iPhone and Mac, inside the local self-improvement hub
Planning date: October 12, 2026

## The gist

Build the product around one daily loop:

1. **See today's purpose** on Home: continue Scripture, complete a plan, learn one thing, or reflect.
2. **Read or listen without friction** in Bible: Catholic canon, version selection, readable typography, notes, bookmarks, and optional synchronized narration.
3. **Finish a concrete commitment** in Plans: a day-based checklist with flexible catch-up rules and honest progress.
4. **Learn the faith in context** in Learning: concise, reviewed guides to Mass, sacraments, prayer, the liturgical year, holy days, and Catholic practice.
5. **Practice one virtue deliberately** through reviewed teaching, Scripture, a concrete action, and optional Echo reflection.
6. **See growth without turning faith into a game** in You: private analytics, restrained milestones, preferences, data controls, and hub integration.

The personal-use release is a local-first formation app that uses the YouVersion Platform Swift SDK as its Scripture-text foundation, subject to the desired Catholic editions being licensed to our App Key. Bible Study owns plans, notes, bookmarks, learning, analytics, and iCloud state. Licensed human narration and verse-synchronized follow-along remain a gated second release because the reviewed YouVersion developer surface does not currently document audio APIs. Any future distribution beyond the owner's devices triggers a fresh Platform-terms, translation-rights, privacy, and App Store review.

## Roadmap at a glance

| Phase | Outcome | Primary deliverables | Exit gate |
|---|---|---|---|
| 0. Decisions and rights | The team can build without rework or licensing surprises | Personal-use scope record, hub contract, YouVersion App Key/licenses, canon/version matrix, learning editorial policy | App Key, Catholic edition access, and integration assumptions are verified |
| 1. Foundation | A real iPhone/Mac shell with production architecture | Five-tab navigation, design system, storage/sync skeleton, feature flags, telemetry policy, CI | Shell runs on both platforms and saves sample data |
| 2. Bible vertical slice | Scripture is pleasant and dependable to read | Canon browser, chapter reader, version picker, navigation, search, highlights, notes, bookmarks, offline behavior | A user can read front-to-back and resume reliably |
| 3. Plans | Reading goals become actionable and accountable | Premade plans, custom plan builder, schedule engine, day checklist, reminders, catch-up choices, progress | Plan math passes edge cases and a plan works end-to-end |
| 4. Daily formation | The app feels like a coherent Catholic companion | Home dashboard, Learning MVP, Echo reflection handoff, source/reviewer metadata | A complete daily loop works without dead ends |
| 4A. Virtue study and formation | Catholic teaching and Scripture become an intelligible path toward virtuous life | First-class Virtues destination, orientation course, seven capital-sin counter-virtue courses, four cardinal-virtue courses, optional practice tools, private study record | Every virtue has a coherent source-backed course and Scripture path; study progress never claims moral mastery |
| 5. Personalization and hub | The experience persists across devices and belongs in the hub | You, private analytics, milestones, iCloud sync, deep links, import/export, hub events | iPhone/Mac state converges and hub journeys work |
| 6. Narrated Bible | Listening is first-class where rights allow it | Licensed audio provider, background player, lock-screen controls, chapter queue, optional verse timecodes | Playback survives interruptions and text/audio stay aligned |
| 7. Hardening and personal release | A trustworthy owner-only v1.0 is ready | Accessibility, performance, content/legal QA, direct-device testing, migration and recovery tests, release checklist | No personal-release blocker remains |
| 8. Expansion | The product grows without destabilizing the core | Widgets, daily Mass readings if licensed, richer study, shared plans, more languages/content | Each addition has rights, review, and privacy approval |

These are dependency phases, not promises of calendar duration. YouVersion is the committed text/reader foundation for the personal build; Phase 0 verifies the App Key and exact Catholic editions and selects an independent audio provider. The provider abstraction and public-domain development fallback remain because access is revocable, per-version licensing still applies, and future public distribution would materially change the Platform-terms analysis.

### What changed after the YouVersion review

- **YouVersion is now the committed personal-build text/reader provider**, not merely one provider to compare equally with API.Bible.
- **The personal-use boundary is recorded as an architecture constraint.** TestFlight, App Store, organizational, or multi-user distribution requires a new terms and licensing review before release.
- **Phase 2 starts with `BibleReaderView`**, a Catholic-edition allowlist, `BibleReaderNavigation`, Platform search, and provider-managed attribution/cache behavior.
- **Personal data stays ours.** The current documented YouVersion user-data permission covers highlights, not notes or bookmarks; sign-in is disabled for the first beta.
- **Plans remain entirely app-owned.** No public YouVersion reading-plan API was found in the reviewed developer surface.
- **Audio remains separate.** No public YouVersion audio API or Swift audio component was found, so API.Bible and a direct STREETLIGHTS partnership remain the audio paths.
- **Full offline Scripture is no longer assumed.** The spike must verify the selected edition's license and supported SDK behavior before it becomes a promise.
- **Privacy copy must disclose provider processing.** YouVersion requires built-in usage reporting and receives Aggregate Data from use of its tools.

---

## 1. Product definition

### Vision

A calm, private, Catholic-centered Bible and formation companion that helps one person consistently encounter Scripture, understand Catholic practice, and reflect on how faith is shaping his life.

### Primary user

The initial product is designed for the owner of the local hub, not for growth, social engagement, or public community. Architecture can leave room for broader distribution, but v1 decisions should optimize for privacy, speed, correctness, and durable personal data.

### Core jobs

- Let me open Scripture at any book, chapter, or verse and keep my place.
- Let me choose a translation whose canon and usage rights are clear.
- Let me listen to a human narration and follow the text when licensed timing data exists.
- Turn a large reading goal into today's small, unambiguous assignment.
- Let me miss a day without corrupting the schedule or shaming me.
- Teach me what Catholics do, why they do it, and how to participate respectfully.
- Help me notice patterns in my practice and carry meaningful reflections into Echo.
- Work on iPhone and Mac with my progress available on both.

### Product principles

1. **Formation before engagement.** Optimize for faithful practice, not time-in-app.
2. **Completion must be truthful.** A plan item is complete only through an explicit action or a clearly disclosed auto-completion rule.
3. **Graceful accountability.** Show missed work and choices plainly, without punitive streak language.
4. **Catholic specificity.** Support the 73-book Catholic canon and clearly label content, calendar, and translation differences.
5. **Sources over unsupported claims.** Learning content carries sources, review status, jurisdiction, and last-reviewed date.
6. **Private by default.** No public profile, social graph, ad tracking, or general third-party analytics in v1. Essential Scripture-provider requests and mandatory Platform usage reporting are disclosed separately.
7. **Local first, sync second.** Reading and plan state work offline; sync reconciles later.
8. **One hub, distinct tools.** Scripture and formation live here; extended journaling opens Echo; broader goals return to the hub.

### v1 success measures

These are private product-health measures, calculated locally unless the owner opts into diagnostics:

- A first-time user can start reading in three taps or fewer after setup.
- App restores the exact last translation, chapter, scroll anchor, and audio position.
- At least 95% of plan sessions can be completed without editing the schedule.
- Plan progress never changes because of a timezone or daylight-saving transition.
- Bible reader is usable offline for every translation whose license permits local storage.
- All essential paths pass VoiceOver and largest Dynamic Type checks.
- Every published Learning article has an owner, source list, jurisdiction, review status, and review date.
- No private note, reflection, plan history, or reading history is sent to a nonessential service. Scripture requests and any provider-required aggregate reporting are documented plainly.

### Explicit non-goals for v1

- A social network, public leaderboards, comments, or competitive streaks.
- AI-generated theological answers presented as authoritative.
- Replacing a priest, confessor, catechist, spiritual director, or official liturgical books.
- Hosting unlicensed Bible translations, liturgical texts, artwork, or recordings.
- A full scholarly study Bible with interlinear texts, lexicons, maps, and commentaries.
- Rebuilding long-form journaling already provided by Echo.

---

## 2. Information architecture and navigation

### Module placement inside the hub

Treat Bible Study as a full module with its own root navigation, not as one tab nested inside the hub's tab bar. The hub should open it from an app tile, command, or deep link and provide one clear way back. This avoids nested tab bars and gives the five requested destinations enough space.

Use a shared Swift package for the domain, persistence, and feature code, plus:

- a hub-integrated target for production;
- a thin standalone development target for previews, tests, and isolated iteration.

Proposed deep-link namespace:

```text
hub://bible/home
hub://bible/read/{translation}/{book}/{chapter}?verse={verse}
hub://bible/plan/{enrollmentID}/day/{dayNumber}
hub://bible/virtues
hub://bible/virtues/{virtueID}
hub://bible/learn/{articleSlug}
hub://bible/you
```

### Top-level destinations

| Destination | Purpose | Default state |
|---|---|---|
| Home | Orient the current day and present the next best action | Continue Reading + active-plan task |
| Bible | Read, search, annotate, or listen to Scripture | Last location, or Genesis 1 on first launch |
| Plans | Browse, create, run, and review reading plans | Active plans, then recommended templates |
| Virtues | Turn Scripture and reflection into deliberate, continuing character practice | Current focus + today's practice |
| Learning | Learn Catholic worship, sacraments, prayer, seasons, rituals, and practical Church life | Continue learning + Catholic-life collections |
| You | Preferences, progress, milestones, data, and sources | This week + settings entry |

On iPhone, use five stable, labeled tabs: Home, Bible, Plans, Virtues, and Learning. You remains a complete destination opened from a persistent profile control rather than being hidden behind a More tab. On Mac, show all six destinations in the sidebar while preserving selection and navigation history. Apple's current guidance supports tab navigation for top-level sections and an adaptive sidebar where complexity warrants it ([Apple: Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars), [Apple: SwiftUI tab navigation](https://developer.apple.com/documentation/swiftui/enhancing-your-app-content-with-tab-navigation)).

### Visual direction from the references

Retain:

- high-contrast, distraction-free reading;
- prominent book/chapter and version controls;
- large, comfortable text with restrained chrome;
- a persistent mini-player that never obscures text;
- day cards, explicit checkmarks, an outlined current day, and an ahead/behind indicator;
- one clear primary action such as **Start Reading** or **Continue**.

Adapt:

- red-letter text is an optional display preference and must be supplied or derived under the translation's rules;
- plan progress needs accessible labels in addition to checkmarks and color;
- the Mac layout should use available width for a book/plan sidebar, not simply stretch the iPhone view;
- light, dark, sepia, and system themes should all meet contrast requirements;
- the audio button appears only for a translation/chapter with licensed audio.

---

## 3. Feature specification

## 3.1 Home

### Purpose

Answer, “What is the most meaningful next step today?” without becoming a noisy feed.

### Sections, in priority order

1. **Continue Scripture** — last book/chapter, percentage or verse anchor, version, and listening state.
2. **Today's plan** — next incomplete assignment, remaining item count, and estimated reading time.
3. **Virtue practice** — continue the owner-selected Focus Cycle or enter Virtues; never infer a weakness.
4. **Catholic-life learning** — continue a reviewed ritual, sacrament, prayer, season, or practical Church-life guide.
5. **Reflect in Echo** — a small prompt tied to the completed reading, plan, or current virtue focus.
6. **Weekly rhythm** — reading days, plan completion, minutes, and a gentle recovery action if behind.
7. **Optional Scripture of the Day** — use YouVersion's Verse of the Day reference rendered in the user's approved translation; never present it as the Catholic daily Mass reading.

### Rules

- Never show more than one primary action above the fold.
- Hide empty modules with an explanation or setup action; do not create blank cards.
- Seasonal cards must be jurisdiction-aware and cite their source.
- A reflection handoff sends a prompt and Scripture reference to Echo through a versioned local contract; Bible Study stores only the link/identifier, not a duplicate private entry.
- Home remains useful with no active plan: default to Continue Reading and Browse Plans.

## 3.2 Bible

### Reader capabilities

- Catholic book order and all 73 books when the selected translation contains them.
- Book and chapter picker with Old Testament, Deuterocanonical, and New Testament grouping.
- Translation picker showing language, canon coverage, offline availability, audio availability, publisher, and copyright/attribution.
- Continuous chapter reading with previous/next chapter controls.
- Resume at a stable verse anchor; do not rely solely on pixel scroll offset.
- Adjustable font family, text size, line spacing, margins, theme, verse numbers, headings, footnotes, and red letters where supported.
- Long-press or keyboard selection for verse actions: highlight, bookmark, note, copy, share, open in plan, and reflect in Echo.
- Full-text search by word/phrase plus direct reference parsing such as `John 3:16`, `Jn 3`, or `Psalm 23`.
- Search results show enough context, translation, and reference, with a direct jump.
- Reading history and recents are private and clearable.
- Footnotes and cross-references are optional provider content; never fabricate them.

For the first vertical slice, prefer YouVersion's `BibleReaderView` behind our `ScriptureReading` abstraction. Configure `permittedVersionIds` so the picker contains only reviewed Catholic-capable editions, disable YouVersion sign-in by default, and intercept verse taps for our local highlight/bookmark/note sheet. `BibleReaderNavigation` can take a plan assignment or Home card directly to its chapter and focus a verse on supported OS versions. If the embedded reader cannot meet the visual, Mac, accessibility, or plan-completion requirements, retain the same provider and switch to `BibleTextView` or REST-backed custom presentation rather than rewriting the domain layer.

### Canon/version behavior

- Model Scripture references using a canonical USFM-style identifier independent of any one translation.
- Store a per-translation book manifest. Never assume every version includes the same canon or verse numbering.
- If a plan requests a book absent from the current translation, explain the conflict and offer a compatible Catholic translation; do not silently substitute.
- Keep highlights and notes attached to a canonical reference plus the originating translation. Display them in another translation only as a clearly labeled mapped annotation.

### Offline model

- Bundle only content whose license explicitly allows bundling.
- Allow on-demand chapter/book/version downloads only when the provider license permits storage.
- When using YouVersion, allow its SDK to manage HTTP caching and obey server `Cache-Control`; do not copy cached Scripture into our own database.
- Treat full-version offline access through YouVersion as unconfirmed until the selected license and supported public SDK behavior are validated in the Phase 0 spike.
- Cache short-lived content from other providers only within their stated rules.
- Always keep user annotations and plan state offline.
- Show a simple availability badge: Downloaded, Online, or Unavailable Offline.

### Search implementation

Use YouVersion's online search first for YouVersion-hosted text. It supplies text, reference, and topical search, suggestions, pagination, intent detection, and spelling corrections; search results return references that are then rendered with attribution. Use a local SQLite FTS index only for independently licensed, downloaded, or bundled translations. Normalize punctuation and diacritics but preserve the original text for display. Indexing, caching, copying, sharing, and text-to-speech must each respect translation-specific capabilities.

## 3.3 Plans

### Premade v1 templates

- New Testament in 90 days.
- Old Testament in 90 days, explicitly including the Catholic deuterocanonical books.
- Bible in one year, Catholic canon.
- Gospels in 30 days.
- Psalms and Proverbs rhythm.
- A gentle “Start with Jesus” plan for a new reader.
- Catholic deuterocanonical books and the additions to Esther and Daniel in 30 days.

Each template includes a title, purpose, estimated daily time, duration, canon requirement, ordered assignments, optional rest/catch-up days, author/reviewer, version, and revision date.

### Custom plan builder

The user can:

- choose whole Bible, testament, one or more books, or a verse range;
- choose start date and either end date or pace;
- select reading days of the week and optional rest days;
- order readings canonically or use a supported interleaving strategy;
- preview workload distribution before saving;
- name, duplicate, pause, archive, restart, or delete a plan;
- choose a recovery policy and reminder time.

### Schedule engine

Assignments are immutable template intent; scheduled days and completion records are user state. The engine must support:

- local-calendar days and timezone changes;
- daylight-saving transitions;
- multiple readings per day;
- partial completion;
- starting late or reading ahead;
- pausing and resuming;
- changing eligible weekdays;
- finishing early;
- an item being included in more than one plan without cross-completing them.

When behind, offer an explicit choice:

1. **Keep dates** — leave missed work visible.
2. **Shift forward** — move unread days without changing their workload.
3. **Redistribute** — spread remaining work across the remaining target dates.
4. **Choose a new finish date** — recalculate from today.

Never silently rewrite history. Store schedule revisions so the user can understand what changed.

### Active-plan screen

Based on the attached reference:

- title followed by large, app-owned plan cover art; use a restrained generated typographic cover only as an accessibility-safe fallback when a plan has no illustration;
- horizontally scrollable day rail directly below the cover, with date, day number, completion state, and a strong selected outline;
- tapping a day selects it and loads its assignments but never toggles completion by itself; a day receives its completion mark only when every assignment in that logical day is complete and loses it if an assignment is reopened;
- selecting today, the next due day, or **Start Reading** scrolls that day into view without preventing the user from inspecting past or future days;
- “Day 32 of 365” style position plus Ahead, On Track, or Behind status;
- checklist of readings for the selected day, with a separate leading completion control and a tappable row/chevron that opens the precise assignment in the approved Bible edition;
- primary Start/Continue Reading action pinned near the bottom that opens the selected day's first incomplete assignment and then advances through the remaining assignments;
- completion summary and optional short reflection handoff to Echo;
- plan settings for reminders, recovery, pause, archive, and restart.

### Completion policy

Default: opening a passage does not complete it. Mark completion when the user reaches the end and taps **Complete**, or manually checks the assignment. If auto-completion is enabled later, disclose it and require a meaningful reading/listening threshold. Completion is idempotent and reversible.

## 3.4 Learning

### Editorial model

Learning is a curated library, not an open-ended answer bot. Every item has:

- title, summary, intended audience, and estimated time;
- source list and outbound references;
- universal, national, diocesan, parish-specific, or devotional scope;
- doctrinal/content owner and reviewer;
- draft, reviewed, published, or retired status;
- published and last-reviewed dates;
- related Scripture and related articles;
- a note where legitimate local practice varies.

### Starter curriculum

1. **Start Here** — what happens at Mass, how to enter and participate, postures, responses, receiving a blessing versus Communion, and church etiquette.
2. **The Mass** — Introductory Rites, Liturgy of the Word, Liturgy of the Eucharist, and Concluding Rites.
3. **The Seven Sacraments** — purpose, signs, ordinary preparation, and when to speak with a parish.
4. **Confession** — examination of conscience, how the rite proceeds, Act of Contrition options, and pastoral sensitivity.
5. **Prayer** — sign of the cross, Our Father, Hail Mary, Glory Be, spontaneous prayer, Lectio Divina, and a daily prayer rhythm.
6. **Rosary** — beads, mysteries, step-by-step mode, optional spoken prompts, and Scripture links.
7. **Liturgical year** — Advent, Christmas, Lent, Triduum, Easter, Ordinary Time, solemnities, feasts, and memorials.
8. **Holy days and disciplines** — holy days of obligation, fasting, abstinence, and why jurisdiction and dispensation matter.
9. **Devotions and sacramentals** — Stations of the Cross, Divine Mercy Chaplet, Eucharistic adoration, holy water, medals, scapulars, and blessings.
10. **Catholic life** — works of mercy, vocation, parish life, stewardship, spiritual reading, and seeking pastoral guidance.

### Learning experience

- Topic collections plus search.
- Short, structured articles with “What,” “Why,” “How,” and “What varies” sections.
- Step-by-step prayer/ritual modes with screen-awake option and large controls.
- Glossary links for unfamiliar terms.
- Save, resume, and mark complete.
- Related Scripture opens in Bible; reflection opens Echo.
- Learning completion may contribute to a restrained milestone but should not imply mastery or holiness.

### Content guardrails

- Obtain permission before reproducing copyrighted Scripture, liturgical translations, prayers, artwork, or long quotations.
- Separate official teaching, common discipline, local policy, and private devotion in the UI.
- Do not publish rules for holy days, fasting, sacraments, or Communion without jurisdiction and review metadata.
- Include “Ask your parish/priest” where individual circumstances matter.
- Commission a qualified Catholic reviewer before public release.

## 3.5 You

### Profile and progress

- Display name/avatar stored locally or in the hub profile.
- Current plan summary and recent activity.
- Reading days, chapters/passages completed, reading/listening minutes, plan adherence, and completed plans.
- Date range filters: week, month, year, all time.
- Book-level activity is optional and private; avoid scoring spiritual worth.

### Milestones

Examples: first plan started, first Gospel completed, seven reading days, first book completed, first plan completed, whole New Testament completed. Milestones are quiet, dismissible, and can be disabled. Do not use scarcity, public comparison, or loss aversion.

### Settings

- Default translation and fallback translation.
- Reader appearance and red-letter preference.
- Audio voice/provider, playback speed, sleep timer, auto-advance, and download policy.
- Reminder schedule and quiet hours.
- iCloud sync status and last successful sync.
- Data export, import, and delete.
- Clear history/cache without deleting notes or plan progress.
- Sources, translation rights, audio credits, learning reviewers, privacy, and app version.
- Diagnostic sharing is off by default.

## 3.6 Virtue study and formation

### Purpose

Teach the owner the four cardinal virtues—prudence, justice, fortitude, and temperance—and seven virtues as remedies to the capital sins—humility against pride, charity and generosity against avarice, kindness and goodwill against envy, patience and meekness against wrath, chastity against lust, temperance against gluttony, and diligence and perseverance against sloth or acedia. The primary experience is a calm, textbook-like course library. Practice and reflection remain important, but follow understanding rather than replacing it. The feature records study and voluntary participation, never a person’s holiness, moral worth, or standing before God.

### Learning model

The tab is organized as a small virtue academy with the least possible navigation depth:

1. **Start Here: Becoming the Person God Calls You to Be** — ten lessons on beatitude, stable dispositions, freedom, passions, habit, the cardinal and theological virtues, grace, the Church, and imitation of Christ.
2. **Seven Virtues against the Capital Sins** — seven ten-lesson courses that teach both the vice and the healing virtue through doctrine, Scripture, case studies, practice, prayer, and pastoral boundaries.
3. **The Four Cardinal Virtues** — four ten-lesson courses grounded in CCC 1803–1811, Joseph Rickaby’s *Four-Square* as a historical secondary guide, and contemporary universal-Church catechesis.
4. **Course preview** — every course shows its purpose, honest overview, complete lesson breakdown, estimated time, source trail, and review status before the owner begins.
5. **Lesson reader** — each lesson teaches one coherent idea, opens relevant passages in the licensed Bible reader, offers questions for consideration, and identifies its exact sources.
6. **Factual study progress** — the app records lessons opened and completed, supports completion reversal, and resumes the most recent course. “Complete” means studied, never virtuous or mastered.

### From study to practice

Completing a course is intellectual progress, not the endpoint of formation. A secondary **Live what you learn** area preserves the existing practice system:

1. **Focus Cycles** — repeatable owner-selected one-, two-, or four-week cycles tied to one concrete practice.
2. **Private check-ins and review** — factual participation plus owner-written reflection without points, grades, punitive streaks, or automated judgment.
3. **Rule of Life** — a revisable set of practices the owner deliberately retains. It is a personal aid, not a generated moral rule or substitute for pastoral guidance.

### The seven counter-virtue pathways

| Capital sin | Virtue taught against it | Formation emphasis |
| --- | --- | --- |
| Pride | Humility | Truth before God, gratitude, teachability, service, and freedom from self-exaltation or self-contempt |
| Avarice | Charity and generosity | Love of God and neighbor through stewardship, justice, mercy, and concrete gift |
| Envy | Kindness and goodwill | Rejoicing in another’s good, gratitude, protected speech, encouragement, and repair |
| Wrath | Patience and meekness | Governing anger, setting truthful boundaries, enduring difficulty, and seeking justice without hatred |
| Lust | Chastity | Integrated sexuality, purity of heart, fidelity, reverence for persons, and appropriate support |
| Gluttony | Temperance | Grateful freedom in appetite, fasting and feasting, hospitality, health, and responsible help |
| Sloth or acedia | Diligence and perseverance | Faithful attention to prayer, work, duty, legitimate rest, and returning after neglect |

These descriptions are product-planning summaries, not independently authoritative catechesis. Course language, Scripture choices, practices, and reflection prompts require the same source, copyright, freshness, and Catholic-review controls as Learning content. The UI distinguishes `christian.temperance` from `cardinal.temperance` while explicitly teaching their relationship.

### Source method

- Joseph Rickaby’s 1908 *Four-Square, or The Cardinal Virtues* is a historical secondary source for the intellectual architecture: virtue as stable habit, the four virtues as hinges, human acts and freedom, endurance under fortitude, justice and charity, religion under justice, humility joined to magnanimity, and acquired virtue elevated by grace.
- Current Catechism teaching and contemporary universal-Church catechesis govern definitions and present pastoral framing.
- Dated rhetoric, obsolete examples, unqualified clinical claims, and historically situated political or social assertions are not carried into the app as Catholic doctrine.
- Scripture appears through canonical references opened in the licensed Bible reader, preserving translation rights and passage context instead of embedding unlicensed quotation text.

### Experience and safeguards

- The owner chooses the current virtue focus manually; the app never infers a moral weakness from reading, journal, browsing, or behavioral data.
- Virtues is a first-class destination. Learning remains the separate Catholic-life library for worship, sacraments, prayer, rituals, seasons, and practical participation in the Church.
- Home may show one current practice and one optional reflection prompt, never a virtue leaderboard or comparative score.
- Plans may include virtue practices, but completing Scripture never automatically claims progress in a virtue.
- Check-ins, notes, and reflections remain local/private; hub events contain only allowlisted identifiers and completion metadata.
- Analytics describe actions taken over a selected period and can be disabled or deleted.
- Formation history reports facts—pathways encountered, cycles completed, practices attempted, contexts practiced, reviews completed, retained practices, and owner-written then/now observations. It never calculates a virtue percentage or attainment level.
- Returning after a break is welcomed without lost progress, broken-streak language, or a penalty.
- Difficult or sensitive topics—especially chastity—use pastoral language, avoid diagnosing culpability, and direct personal questions to an appropriate priest or qualified guide.
- Every path supports VoiceOver, Dynamic Type, keyboard navigation, Reduce Motion, and non-color status cues.

### Deliverables

1. **Curriculum foundation and source synthesis** — stable course/lesson/source/review models; complete reading of Rickaby; current Catechism and Church-source reconciliation; explicit historical-source guardrails.
2. **Course library experience** — Start Here hero, seven counter-virtue cards, four cardinal cards, honest previews, complete outlines, estimated time, sources, and recent-course resume.
3. **Orientation and cardinal curriculum** — ten orientation lessons plus ten lessons each for prudence, justice, fortitude, and cardinal temperance.
4. **Seven counter-virtue curricula** — ten lessons per course covering Catholic meaning, the capital vice, counterfeits and pastoral boundaries, Scripture in context, interior and relational formation, habits, failure, grace, and a continuing rule of life.
5. **Study progress and Scripture integration** — local lesson completion, reversible state, recent-course restoration, Bible-reader routes, backward-compatible decoding, and no virtue score.
6. **Practice companion** — preserve Focus Cycles, daily check-ins, weekly review, practice library, thematic journeys, Rule of Life, Formation Record, and Echo handoff as optional application tools.
7. **Content review and release acceptance** — qualified Catholic review, source fixtures, copyright checks, accessibility, privacy/redaction, migration, iPhone, and Mac tests.

### Exit criteria

- The owner can preview and begin the orientation, any counter-virtue course, or any cardinal virtue without navigating through a tracker first.
- Every course presents a coherent lesson sequence, exact sources, contextual Scripture routes, and factual reversible completion.
- After study, the owner can begin unlimited Focus Cycles, retain practices in a Rule of Life, and review factual formation history without an artificial endpoint.
- All courses have approved Catholic review, visible freshness metadata, and tested Scripture links before public distribution.
- No score, rank, streak loss, automated moral judgment, or private reflection text crosses the module boundary.
- Accessibility, persistence, export/delete, and hub-contract tests pass on iPhone and Mac.

---

## 4. Core user journeys

### First launch

1. Explain that data is local-first and iCloud sync is optional.
2. Select a default Catholic-capable translation from the currently licensed catalog.
3. Choose text size/theme and whether reminders are desired.
4. Offer: Start reading, choose a plan, or learn how Mass works.
5. Do not require an account beyond the device/iCloud identity already used by the hub.

### Read from front to back

Bible → book picker → Genesis → chapter 1 → read → next chapter. The reader retains position, shows chapter progress without pressure, and returns to the same place across launches.

### Complete today's plan

Home → Today's Plan → Start Reading → assignment 1 → Complete & Next → assignment 2 → Finish Day → optional Echo reflection. The plan and Home update immediately and later sync idempotently.

### Recover after missed days

Home shows **3 reading days to resolve** → Plan → choose Keep, Shift, Redistribute, or New Finish Date → preview result → confirm → store revision and update reminders.

### Listen and follow along

Bible → choose audio-enabled translation/chapter → Play → mini-player appears → active verse highlights only when licensed timecodes are available → lock screen controls continue playback → interruption pauses/resumes appropriately → position syncs locally.

### Learn the Rosary

Learning → Prayer → Rosary → choose mystery set or today's traditional set → step-by-step mode → optional spoken prompts → completion → optional Echo reflection. The guide clearly distinguishes tradition from obligation.

---

## 5. Technical architecture

### Recommended stack

- SwiftUI multi-platform app/module with native iOS and macOS adaptations; target iOS 17+ and macOS 15+ for compatibility with the current YouVersion Swift package, subject to the hub's support policy.
- YouVersion Platform Swift SDK behind an app-owned adapter for licensed Scripture text, reader UI, online search, version metadata, attribution, and optional Verse of the Day.
- Swift concurrency for provider, sync, search, and audio work.
- SwiftData for user-authored/stateful records; CloudKit private database for optional cross-device sync.
- SQLite FTS only for independently licensed offline Scripture; never duplicate YouVersion-managed cached content into it.
- AVFoundation/AVKit plus MediaPlayer/Now Playing integration for narrated audio.
- UserNotifications for plan reminders.
- OSLog with privacy redaction; no note text, reading text, or full references in production logs.
- XCTest/Swift Testing and XCUITest for unit, integration, and end-to-end coverage.

SwiftData supports local persistence and optional CloudKit sync; Apple's setup requires the iCloud and remote-notification capabilities and a CloudKit-compatible schema ([Apple: SwiftData sync](https://developer.apple.com/documentation/swiftdata/syncing-model-data-across-a-persons-devices)).

### Module boundaries

```text
BibleStudyApp / Hub Adapter
├── AppShell             navigation, routing, dependencies
├── HomeFeature
├── BibleFeature
├── PlansFeature
├── LearningFeature
├── ProfileFeature
├── ScriptureDomain      canonical references, canon, manifests
├── ScriptureProvider    API/SDK adapters and license capabilities
├── ReadingPlanEngine    scheduling and completion logic
├── AudioPlayer          queue, position, timecodes, Now Playing
├── Persistence          user store, content cache, migrations
├── Sync                 CloudKit reconciliation and status
├── HubIntegration       profile, Echo handoff, virtue tags, events
└── DesignSystem         typography, colors, components, accessibility
```

Features depend on protocols, not a specific content vendor. `YouVersionScriptureAdapter` is the preferred first implementation, but Home, Plans, annotations, Learning, and analytics must never import the YouVersion package directly. This preserves a public-domain development fallback and keeps an audio provider independent.

### YouVersion integration boundary

```text
Home / Plans / Learning
        │ canonical ScriptureReference
        ▼
ScriptureReading protocol
        │
        ├── YouVersionScriptureAdapter
        │   ├── BibleReaderView or BibleTextView
        │   ├── BibleReaderNavigation
        │   ├── Search and Verse of the Day APIs
        │   └── version/license/attribution metadata
        │
        └── DevelopmentFallbackAdapter

App-owned SwiftData/CloudKit
    ├── notes and bookmarks
    ├── local highlights by default
    ├── plans and completions
    ├── reading/learning progress
    └── private analytics
```

Do not make YouVersion identity the hub identity. YouVersion sign-in is an optional connection whose documented data permission currently covers highlights; the current sign-in documentation explicitly says notes and bookmarks are not supported. Keep those records app-owned so export, iCloud sync, and deletion remain coherent.

### Provider capability contract

Each translation/audio catalog entry advertises capabilities rather than relying on global assumptions:

```text
canReadOnline
canCacheTemporarily
canDownloadOffline
canSearchLocally
canCopy / copyLimit
canShare / shareLimit
hasFootnotes
hasHeadings
hasRedLetters
hasHumanAudio
hasVerseTimecodes
canDownloadAudio
requiredAttribution
licenseRevision
providerLicenseId
providerDeepLink
```

### Core data model

| Entity | Essential fields |
|---|---|
| CanonicalReference | canon ID, book USFM ID, chapter, verse/range |
| Translation | provider ID, language, title, abbreviation, canon manifest, rights/capabilities |
| ReadingPosition | translation, reference, verse anchor, scroll fraction fallback, updated time |
| Bookmark | reference, translation, label, created time |
| Highlight | reference/range, translation, color/style, created/updated time |
| ScriptureNote | reference/range, translation, body, created/updated time |
| ReadingSession | references, start/end, active reading seconds, audio seconds, source |
| PlanTemplate | metadata, ordered template days, canon requirement, revision |
| PlanEnrollment | template/custom source, start date, timezone policy, state, recovery policy |
| PlanDay | enrollment, logical day number, scheduled local date, revision |
| ReadingAssignment | plan day, order, canonical range, estimated effort |
| AssignmentCompletion | assignment ID, completed time, method, reversal state |
| PlanRevision | reason, before/after schedule metadata, created time |
| LearningArticle | slug, version, scope, sources, reviewer, status, review date |
| LearningProgress | article/step, state, position, completed time |
| AudioPosition | audio edition, chapter, seconds, playback rate, updated time |
| MilestoneAward | milestone version, earned time, dismissed time |

Use stable UUIDs and tombstones for syncable deletions. Keep provider content out of the private user database except where the license permits caching.

### Sync and conflict rules

- Latest reading position wins per translation, but never deletes a newer explicit bookmark/note.
- Highlights and notes merge by stable object ID; concurrent note edits preserve both versions for user resolution.
- Assignment completion is an append/reverse event, so retries cannot double-count.
- Plan schedule revisions use a monotonically increasing enrollment revision.
- Learning progress takes the furthest completed step unless the user explicitly resets it.
- All progress works before iCloud is enabled and migrates safely when sync is turned on.

### Hub contracts

Define versioned, local interfaces rather than reaching into another module's database:

- `HubProfileProviding`: display name, avatar, locale, timezone.
- `VirtueCatalogProviding`: the hub's exact virtue taxonomy and identifiers, including the approved seven capital-sin counter-virtue pairings and the four cardinal virtues.
- `EchoReflectionOpening`: prompt, Scripture references, plan/learning context, callback identifier.
- `FormationEventPublishing`: plan completed, reading completed, lesson completed, milestone earned.
- `HubRouting`: open module, return to hub, and handle deep links.

### Privacy and security

- Keep user notes, history, and analytics on-device and in the user's private iCloud database only.
- Use Apple data protection for local stores and Keychain for credentials/tokens.
- Use the YouVersion App Key only through its documented native SDK configuration and follow its rotation/incident requirements. Never embed any other provider secret not designed for native-client distribution.
- Disable YouVersion sign-in in the first beta unless cross-app YouVersion highlights are deliberately enabled. If enabled, explain that highlight data is stored in the user's YouVersion account and make disconnect behavior explicit.
- Disclose that the YouVersion Platform terms require built-in usage reporting and allow Aggregate Data derived from the Platform integration. Do not send app-owned notes, plan state, Echo reflections, or private analytics through that channel.
- Redact content and identifiers from logs and crash breadcrumbs.
- Provide complete export and deletion, including pending sync tombstones.
- Document exactly which content requests reach a Bible provider and when.

---

## 6. Scripture and audio sourcing strategy

### Required gate before implementation

Create a rights matrix for every translation and audio edition. “Available on a website” or “free in another app” does not mean it can be embedded, cached, narrated, or redistributed.

The NABRE is particularly important for a US Catholic app, but the USCCB states that digital apps, including free ones, require a license and fee/royalty arrangement ([USCCB Bible permissions](https://www.usccb.org/offices/new-american-bible/permissions)). Do not bundle it until an agreement is executed.

### YouVersion Platform review and decision

The Platform is useful enough to change the implementation plan. It is the **committed Scripture-text and first-reader foundation for the personal build**, subject to edition-level licenses on our App Key. It does not replace the app's plan engine, Learning library, personal data store, or audio provider.

The current official Swift package supplies native SwiftUI components and API helpers and declares iOS 17 and macOS 15 support. `BibleReaderView` provides chapter/version navigation, last-passage restoration, selection actions, built-in attribution, and optional YouVersion highlight sync. `BibleReaderNavigation` can open and focus plan references. `BibleTextView` supports a custom surrounding design, while `BibleCardView` and `VotdView` cover smaller Home/Learning placements ([YouVersion Swift components](https://developers.youversion.com/sdks/swift/components), [official Swift package](https://github.com/youversion/platform-sdk-swift)).

| Capability | Finding | Roadmap decision |
|---|---|---|
| Bible catalog and text | More than a thousand licensed versions are advertised; access is limited to licenses accepted for the App Key | Use as preferred catalog after verifying the exact Catholic editions |
| Catholic canon structure | Book metadata explicitly distinguishes `old_testament`, `new_testament`, and `deuterocanon` and uses USFM identifiers | Build compatibility checks from the returned per-version book manifest |
| Native reader | `BibleReaderView`, version picker, chapter navigation, restoration, verse focus, copy/share, themes, footnotes, and attribution are provided | Use for the first vertical slice behind our adapter; replace only if product requirements exceed its public customization points |
| Version control | SDK can permit/exclude version IDs and languages | Curate a Catholic-capable allowlist rather than expose the entire catalog |
| Search | Reference, text, topical, suggested, and trending search are available, with pagination and spelling correction | Replace our online search implementation with the Platform search API; keep local FTS only for independently stored texts |
| Verse of the Day | Calendar reference plus ready-made SwiftUI view | Optional Home card; label it as Scripture of the Day, not a liturgical reading |
| Attribution | Reader/Card handle it; custom `BibleTextView` does not | Fail closed in custom layouts until version attribution metadata loads |
| YouVersion sign-in | Native OAuth support and persisted access token | Optional connection, not the hub account |
| Synced user data | Current developer docs support YouVersion highlights; they explicitly say notes and bookmarks are not supported permissions | Keep notes/bookmarks local+iCloud; keep highlights local by default and offer YouVersion sync only as an opt-in later |
| Reading plans | No public reading-plan endpoints or Swift plan components are documented in the reviewed Platform surface | Retain the complete app-owned plan engine and templates |
| Audio | No public audio endpoint or Swift audio component is documented in the reviewed Platform surface | Retain API.Bible/STREETLIGHTS/other licensed audio evaluation in Phase 6 |
| Offline | SDK caches responses and its changelog states that it obeys `Cache-Control`; complete offline-version behavior is not clearly documented for our selected licenses | Do not promise full offline YouVersion Bibles until the spike verifies supported behavior and rights |
| Rate limits/errors | App Keys are rate-limited; `429` includes `Retry-After`; `403` can mean unlicensed content | Use SDK caching, exponential backoff, defensive error parsing, and clear license/unavailable states |
| Privacy/telemetry | Platform terms require built-in usage reporting and assign YouVersion rights in resulting Aggregate Data | Disclose this essential provider processing and keep all app-owned personal content outside it |
| Product/legal fit | Platform terms restrict using its IP to replicate or compete with the YouVersion Bible App | Keep this build personal and undistributed; require a new legal/platform review before any TestFlight, App Store, multi-user, or commercial release |

The public YouVersion Bible catalog currently contains promising Catholic candidates, including Douay-Rheims Challoner (`55`), NABRE (`463`), and NRSV Catholic Interconfessional (`2015`) ([DRC1752](https://www.bible.com/versions/55), [NABRE](https://www.bible.com/versions/463), [NRSV-CI](https://www.bible.com/versions/2015)). Their presence in the Bible App does **not** prove that our Platform App Key can use them; Phase 0 must verify the licensed API catalog and returned 73-book manifests. Similarly, audio shown in the consumer Bible App does not create a developer audio entitlement.

Relevant official references: [Platform overview](https://developers.youversion.com/), [Swift quick start](https://developers.youversion.com/sdks/swift/quick-start), [Swift search](https://developers.youversion.com/sdks/swift/guides/search), [copyright and attribution](https://developers.youversion.com/sdks/swift/guides/copyright-and-attribution), [sign-in permissions](https://developers.youversion.com/sign-in-apis), [API errors](https://developers.youversion.com/error-codes), and [Platform terms](https://platform.youversion.com/?tos=1).

### Recommended integration sequence

1. Register a personal-use app in the YouVersion Platform portal and obtain its App Key.
2. In the developer portal, identify and accept licenses for at least one complete Catholic edition; record the exact Bible IDs, rights, attribution, geography, and caching terms.
3. Record the distribution boundary in the repository: owner-only installation is allowed for this plan; any TestFlight, App Store, multi-user, organizational, or commercial use blocks release until terms and content rights are reviewed again.
4. Build a technical spike using the current Swift package:
   - filter to the approved Catholic Bible IDs;
   - open all 73 books and verify deuterocanonical ordering;
   - navigate from a sample Plan assignment with `BibleReaderNavigation`;
   - intercept verse taps for local notes/bookmarks/highlights;
   - test attribution, search, VoiceOver, Dynamic Type, dark mode, Mac layout, no-network behavior, cache expiry, `403`, and `429`;
   - verify what “downloaded version” means in the supported public API and selected license.
5. If it passes, adopt `YouVersionScriptureAdapter` for text/search and keep sign-in disabled for the first personal beta.
6. If the App Key lacks a complete Catholic edition or the SDK fails product, canon, Mac, accessibility, or offline requirements, switch the adapter to API.Bible or a verified public-domain Catholic source without changing plans or user data.

API.Bible remains the leading documented audio candidate because it exposes chapter audio and optional verse timecodes, with special licensing required ([API.Bible overview](https://docs.api.bible/), [API.Bible audio](https://docs.api.bible/guides/audio-bibles/)). It may also serve as the text fallback if YouVersion is not approved for this product.

### Safe MVP fallback

If licensed Catholic translations are delayed, ship development and private beta with a verified public-domain Catholic-capable source whose provenance, canon, text integrity, and app redistribution rights have been reviewed. Label it accurately. Do not present a Protestant 66-book edition as a complete Catholic Bible.

### STREETLIGHTS

Treat STREETLIGHTS as a prospective content partnership, not an API assumption. Their public materials describe human narration of the NLT/NVI, but that does not grant this app redistribution or synchronization rights. Phase 0 should request written terms covering:

- mobile and Mac playback;
- streaming versus download;
- geographic and distribution limits;
- translation rights bundled with the recording;
- chapter files and verse-level timing data;
- artwork/name attribution;
- offline playback, caching, analytics, and termination handling.

If rights are unavailable, provide a clearly labeled external open-in-STREETLIGHTS action only if their link/deep-link terms permit it. Do not scrape or relay their streams.

### Audio implementation tiers

1. **Tier A — chapter audio:** play, pause, seek, speed, skip chapter, queue, sleep timer, background playback, and saved position.
2. **Tier B — verse follow-along:** use provider-supplied verse timecodes to highlight and auto-scroll; user can disable motion.
3. **Tier C — offline audio:** only for editions whose license expressly permits downloads; include storage management and expiry/revocation behavior.

Do not generate text-to-speech from a copyrighted translation unless its license expressly allows audio derivatives. On iPhone, background playback requires the playback audio session and Audio background mode ([Apple: media playback](https://developer.apple.com/documentation/avfoundation/configuring-your-app-for-media-playback)).

---

## 7. Quality bar

### Accessibility

- Full VoiceOver navigation and meaningful labels for verse numbers, checkmarks, progress, and audio controls.
- Dynamic Type through the largest accessibility sizes without clipped Scripture or covered controls.
- Keyboard navigation and shortcuts on Mac; pointer and focus states.
- Sufficient contrast in all themes; color never carries state alone.
- Reduce Motion disables auto-scrolling animation and nonessential transitions.
- Reader supports font, size, spacing, margins, and theme changes without losing position.
- Audio provides transcripts through the Scripture text and accessible elapsed/remaining time.

### Test strategy

- **Unit:** canon manifests, reference parsing, progress math, plan distribution, recovery, timezones, DST, leap years, pause/resume, completion reversal, sync merging.
- **Contract:** provider responses, rights capability mapping, attribution rendering, quota and error behavior.
- **Integration:** local storage migrations, CloudKit sync, offline/online transitions, notification rescheduling, audio interruptions.
- **UI:** first launch, front-to-back navigation, version switch, search, plan start/complete/recover, Learning steps, export/delete.
- **Visual:** iPhone sizes, Mac window sizes, light/dark/sepia, largest text, localization expansion.
- **Content:** 73-book manifest where promised; chapter/verse spot checks; no missing plan assignments; every article passes source/reviewer checks.
- **Resilience:** corrupt cache rebuild, expired audio URL, provider outage, iCloud signed out/full, device timezone change, and app upgrade with pending progress.

### Performance budgets

- Warm launch to usable Home: target under 1 second on supported hardware.
- Cached chapter open: target under 200 ms.
- Reader scrolling remains smooth at largest chapter size.
- Search returns initial local results in under 300 ms for a downloaded English translation.
- User action state saves immediately; network sync never blocks reading.
- Audio resumes within 2 seconds when the network and provider are healthy.

---

## 8. Detailed phased delivery

## Phase 0 — Product decisions, content rights, and proof of concept

### Deliverables

- One-page product brief recording owner-only personal use and the distribution-change review trigger.
- Decision record for module-in-hub navigation and standalone development target.
- Hub integration contract for Echo, profile, virtue taxonomy, and events.
- Catholic canon manifest and naming/order policy.
- Registered YouVersion personal-use application, App Key setup, and accepted licenses for the chosen Catholic editions.
- Translation/audio rights matrix, exact provider Bible IDs, attribution templates, and provider contacts.
- YouVersion Swift spike: filter to approved Catholic editions, map all 73 conceptual books across provider resources (including `ESG`), render/navigate chapters, open a plan reference, test local verse actions, search, attribution, Mac, accessibility, caching, offline behavior, and provider error states.
- API.Bible audio/fallback spike: inspect licensed Catholic text availability, chapter audio, timecodes, and caching/download rules.
- STREETLIGHTS partnership inquiry; no dependency on a positive answer.
- Learning editorial guide, source hierarchy, jurisdiction model, and reviewer role.
- Target OS/support policy and data migration policy.
- Initial backlog, risk register, and Definition of Done.

### Exit criteria

- At least one legally usable complete Catholic text path is identified for beta.
- The YouVersion App Key can retrieve at least one complete Catholic edition—including `ESG` and Daniel additions—and its required attribution; provider resource count is not assumed to equal 73.
- The primary Scripture provider, exact edition allowlist, audio candidate, and fallback are chosen.
- Hub/Echo boundaries are accepted.
- No unresolved assumption can force a reader or data-model rewrite.

## Phase 1 — Foundation and design system

### Deliverables

- SwiftUI iPhone/Mac project, shared package boundaries, dependency container, and build configurations.
- Current YouVersion Swift package pinned to a reviewed compatible major version; license notices and upgrade review policy recorded.
- Five-destination shell; iPhone tab bar and Mac sidebar.
- Design tokens, typography, reader themes, reusable cards, empty/error/loading states.
- SwiftData user store with schema v1, migrations, in-memory test store, and sync-ready model.
- Scripture provider protocol, fixture provider, `YouVersionScriptureAdapter`, rights capability model, and App Key configuration.
- Routing/deep links and standalone/hub adapters.
- OSLog privacy categories, feature flags, unit/UI test targets, CI, lint/format policy.
- Accessibility baseline and preview matrix.

### Exit criteria

- Both targets launch, navigate, persist sample state, and pass CI.
- No feature imports a concrete content vendor directly.
- A dependency test prevents Home, Plans, Learning, Profile, and Persistence from importing the YouVersion package outside the adapter/reader boundary.
- Largest text and VoiceOver work on the navigation shell.

## Phase 2 — Bible reader vertical slice

**Status:** Closed October 12, 2026. The owner accepted deferral of physical-device accessibility and live offline/error-recovery acceptance to Phase 7 hardening; this does not assert those checks passed.

### Deliverables

- YouVersion-approved translation allowlist and catalog metadata with rights/capability details.
- `BibleReaderView`-based Catholic-aware book/chapter flow and front-to-back navigation, or a documented decision to use custom `BibleTextView`/REST presentation after the spike.
- Production chapter rendering with headings, poetry, footnotes where supplied, stable verse anchors, and always-correct attribution.
- Resume position, history, bookmarks, highlights, and notes.
- `BibleReaderNavigation` bridge from Home/Plans/Learning; verse focus where supported.
- YouVersion reference/text/topic search with suggestions/corrections; local FTS only for independently licensed eligible downloads.
- Reader settings, themes, Dynamic Type, VoiceOver, keyboard shortcuts, and share/copy limits.
- SDK cache behavior governed by HTTP/license rules; separate download manager only for independently licensed content.
- Provider outage, rate-limit, no-network, unlicensed `403`, unavailable-book, and expired-content states.

### Exit criteria

- A user can read every available book in order, switch versions safely, search, annotate, close the app, and resume.
- Offline and rights behavior match the selected provider agreement.
- YouVersion attribution is visible for every rendered passage, or the passage fails closed.
- Reference and canon test suites pass.

## Phase 3 — Plans and accountability

### Deliverables

- Versioned plan-template format and six reviewed starter plans.
- Custom plan builder with workload preview.
- Scheduling engine, plan enrollment, completion events, pause/archive/restart, and four recovery modes.
- Active-plan day rail, assignment checklist, progress states, plan library, and plan history.
- Start/Continue flow that sequences assignments in the Bible reader.
- Local notifications with quiet hours and rescheduling.
- Plan analytics and sync-safe event model.
- Edge-case/property tests across calendars, timezones, DST, leap years, and multiple plans.

### Exit criteria

- Every starter plan produces the expected coverage with no duplicate or missing passages.
- Completion and recovery are correct after reinstall/sync simulations and timezone changes.
- A user can create and finish a custom plan without developer intervention.

## Phase 4 — Home, Learning MVP, and Echo loop

### Deliverables

- Ranked Home cards and next-action rules.
- Learning library, search, article renderer, step mode, glossary, saves, and progress.
- Reviewed starter articles for Mass, sacraments, Confession, prayer, Rosary, liturgical year, holy days/discipline, devotions, and Catholic life.
- Source/reviewer/jurisdiction UI and content publication checks.
- Seasonal content rules with a manual override and no unreviewed live text.
- Echo handoff with prompt, canonical references, source context, and callback.
- Home refresh after plan, reading, learning, or Echo completion.

### Exit criteria

- The daily loop from Home through reading/learning to optional reflection is complete.
- Every published article passes doctrinal/editorial and copyright review.
- Bible Study does not duplicate Echo entries.

## Phase 4A — Virtue study and formation

### Deliverables

1. **BS-0451 — Formation model and first-class destination:** provenance-aware content and privacy contracts; Mac sidebar entry; iPhone Virtues tab; profile access outside the five-tab limit.
2. **BS-0452 — Seven reviewed Foundations pathways:** chastity, temperance, charity, diligence, patience, kindness, and humility each include teaching, contextual Scripture, practices, examen prompts, pastoral boundaries, and visible review metadata.
3. **BS-0453 — Repeatable Focus Cycles:** owner-selected virtue, context, duration, practice, pause/return, and close/continue/change behavior after Foundations.
4. **BS-0454 — Daily practice and private check-ins:** Home practice card, factual check-in history, optional local observation, and no punitive streaks.
5. **BS-0455 — Weekly review and Then/Now:** factual weekly summaries, owner-written beginning/ending reflections, retained-practice selection, and cycle review.
6. **BS-0456 — Practice library, thematic journeys, and Rule of Life:** reviewed practices by context, cross-virtue application journeys, and a revisable owner-selected rule.
7. **BS-0457 — Formation record and integrations:** private history and participation milestones plus Scripture, Plans, Echo, You, Hub, and future Ambition boundaries.
8. **BS-0458 — Trust and release acceptance:** independent export/delete, migration, accessibility, content-review fixtures, privacy/redaction, iPhone, and Mac tests.
9. **BS-0459 — Curriculum architecture and source method:** course/lesson/progress contracts, complete Rickaby synthesis, current Catholic source reconciliation, and historical-source guardrails.
10. **BS-0460 — Textbook-like course experience:** Start Here, grouped virtue cards, honest course previews, lesson reader, course outline, sources, and recent-course resume.
11. **BS-0461 — Orientation and four cardinal courses:** ten orientation lessons plus ten lessons each for prudence, justice, fortitude, and temperance with contextual Scripture routes.
12. **BS-0462 — Seven counter-virtue courses:** ten lessons each for humility against pride, charity and generosity against avarice, kindness and goodwill against envy, patience and meekness against wrath, chastity against lust, temperance against gluttony, and diligence and perseverance against sloth or acedia.
13. **BS-0463 — Practice bridge and acceptance:** keep existing formation tools secondary to study; verify backward-compatible progress, accessibility, iPhone/Mac presentation, privacy, and content review state.

### Exit criteria

- Every virtue card opens an honest preview and a complete teach → Scripture → consider → apply lesson sequence.
- Study leads into optional Focus Cycles, an owner-selected Rule of Life, and a factual long-term Formation Record.
- A qualified Catholic review route approves all published formation content and sensitive pastoral language.
- The owner can remove the complete virtue history without deleting Scripture annotations or Echo entries.
- No private check-in or reflection text enters provider requests, logs, analytics, or hub events.

## Phase 5 — You, iCloud, and hub integration

### Deliverables

- You dashboard, local analytics, date filters, milestone system, and opt-outs.
- Complete settings, attribution, privacy, and source screens.
- CloudKit private sync, status UI, retry/recovery, merge rules, and multi-device tests.
- Export/import for notes, highlights, bookmarks, plans, progress, and settings in a documented portable format.
- Granular delete/clear flows and full-module data deletion.
- Hub profile, routing, virtue tags, events, and shared design-token integration.
- Deep-link validation and backward-compatible contract tests.

### Exit criteria

- iPhone and Mac converge after concurrent offline changes without losing user content.
- Export → delete → import round-trip preserves documented data.
- Hub, Bible Study, and Echo flows work across upgrades.

## Phase 6 — Licensed narration and follow-along

### Deliverables

- Executed audio/content rights and in-app attribution.
- Audio catalog mapped to compatible text editions.
- Chapter queue, mini-player, full player, speed, seek, skip, sleep timer, and saved position.
- Background audio, lock-screen/Control Center commands, Now Playing metadata, and interruption/route handling.
- Verse highlighting and optional auto-scroll where provider timecodes exist.
- Download manager, storage controls, expiry/revocation, and offline playback only where licensed.
- Audio accessibility, network recovery, analytics privacy, and end-to-end tests.

### Exit criteria

- Playback survives lock, calls/interruptions, Bluetooth route changes, app termination, and chapter boundaries.
- Verse highlighting never claims precision without provider timing data.
- All streaming/download behavior has written rights coverage.

## Phase 7 — Personal beta, hardening, and owner-only v1.0

### Deliverables

- Full accessibility audit and fixes.
- Performance, memory, battery, network, and storage profiling.
- Data migration, backup/recovery, provider outage, rate-limit, and iCloud failure drills.
- Canon, plan, translation, attribution, and Learning content audit.
- Privacy manifest, permissions copy, support/privacy pages, and release notes.
- Structured owner testing on the primary iPhone and Mac, crash triage, a usage diary, and a release-candidate checklist.
- A separate future-distribution gate; do not create a TestFlight or App Store build without reopening Platform terms, translation/audio rights, privacy disclosures, and content review.
- Operational playbook for provider key rotation, revoked content, bad article correction, and schema rollback/forward recovery.

### Exit criteria

- No critical/high defect; no known data-loss, rights, doctrinal, accessibility, or privacy blocker.
- Critical journeys pass on the oldest supported iPhone and Mac plus current OS versions.
- Support and recovery procedures have been rehearsed.

## Phase 8 — Post-v1 candidates

Prioritize only after observing real use:

- Home/lock-screen widgets and Shortcuts/App Intents.
- Daily Mass readings and liturgical calendar, only after text/calendar rights and jurisdiction rules are solved.
- Richer cross-references, maps, timelines, introductions, and licensed commentaries.
- Spaced-repetition Scripture memory.
- Parish or mentor-shared plans with explicit privacy boundaries.
- Family sharing or accountability partner, opt-in and never public by default.
- Additional languages, translations, and narrated editions.
- iPad layouts if not included in the first universal target.
- Carefully bounded on-device semantic search over licensed/indexable material; no authoritative “AI theology” mode.

---

## 9. Backlog priority

### Must ship in v1.0

- Five destinations on iPhone and Mac.
- A legally usable Catholic-capable Scripture source and complete canon-aware navigation.
- Read, resume, search, bookmark, highlight, and note.
- Starter and custom plans with reliable scheduling/recovery.
- Home daily loop.
- Reviewed Learning starter curriculum.
- You settings, private analytics, export/delete, and optional iCloud sync.
- Echo/hub integration.
- Accessibility, offline handling, attribution, migrations, and recovery.

### Should ship if it does not threaten quality

- Additional licensed translations.
- Local download of eligible text.
- Milestones.
- Rich seasonal Home cards.
- Basic human narration if rights are ready before feature freeze.

### Later

- STREETLIGHTS integration or any premium/licensed audio partnership.
- Verse-synchronized follow-along across multiple editions.
- Daily liturgical readings.
- Social/shared plans.
- Advanced study tools and semantic features.

---

## 10. Key risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Translation or audio rights arrive late | Reader/audio release blocked | Provider abstraction; verified public-domain beta fallback; audio is independently gated |
| The personal app is later distributed and changes the Platform-terms analysis | Release can violate provider terms or lose access | Treat distribution as a release blocker requiring fresh YouVersion/content-rights review; preserve API.Bible/public-domain adapter fallback |
| A desired Catholic edition is absent from the App Key's licenses | Incomplete canon or wrong default translation | Verify exact Bible IDs and 73-book manifest in Phase 0; curate an approved allowlist |
| YouVersion SDK changes, rate limits, or outages | Reader/search degradation | Pin a reviewed major version; contract tests; cache-control compliance; backoff; provider abstraction |
| Provider telemetry conflicts with privacy expectations | Loss of trust | Disclose essential requests/aggregate reporting; keep notes, plans, history, analytics, and Echo data app-owned |
| Catholic canon differs by translation | Missing books or broken plans | Per-version manifest; canonical references; plan compatibility checks |
| Liturgical/Catholic content is inaccurate or overgeneralized | Loss of trust and pastoral harm | Qualified reviewer; jurisdiction metadata; sources; review dates; correction workflow |
| Nested hub/module navigation becomes confusing | Poor usability | Full module root with one back-to-hub action and versioned deep links |
| Plan rescheduling corrupts progress | Core value failure | Event-based completion; immutable assignments; revision history; property tests |
| Cloud sync loses personal notes | Irreplaceable data loss | Local-first writes; stable IDs/tombstones; conflict copies; export and recovery tests |
| Gamification distorts the purpose | Shame or shallow engagement | Quiet milestones, no public scores, opt-outs, recovery-oriented language |
| Provider outage or quota makes Scripture unavailable | Broken daily use | Eligible offline content, cache policy, clear status, retry, multiple adapters |
| Audio player consumes battery or loses position | Unreliable listening | Native media frameworks, background-mode discipline, position checkpoints, interruption tests |
| Hub and Echo schemas drift | Broken cross-app flows | Versioned protocol contracts and compatibility tests |

---

## 11. Foundation decisions

The following decisions are now locked for the initial build:

1. Distribution is owner-only personal use. Any TestFlight, App Store, multi-user, organizational, or commercial release requires a new terms, rights, privacy, and content review.
2. YouVersion is the primary Scripture text, reader, catalog, search, and attribution provider.
3. CPDV (`42`) is the active approved Catholic edition. NRSV-CI (`2015`) is the desired edition pending provider access; NABRE (`463`) and DRC1752 (`55`) remain disabled unless the App Key later exposes them and the same live canon/attribution audit passes.
4. YouVersion sign-in is disabled. Highlights, notes, bookmarks, history, plans, and analytics remain local and later sync through the owner's private iCloud database.
5. The app owns Catholic canonical navigation and restoration while the supported YouVersion `BibleTextView` renders licensed Scripture. Provider adapters and canonical references preserve the option to move to another approved presentation/source without changing plans or user data.
6. Reading plans are app-owned, complete manually, and never depend on YouVersion user data.
7. YouVersion search supplies online reference, text, topic, suggestion, and correction results. Local FTS exists only for independently licensed offline text.
8. Verse of the Day may appear on Home as **Scripture of the Day**, never as the Catholic daily Mass reading.
9. Bible audio is outside the YouVersion integration and remains gated on API.Bible or a direct licensed partnership.
10. The codebase provides a hub-integrated route and a standalone development app. Versioned adapters define Echo, profile, virtue-catalog, and hub-routing boundaries.
11. iCloud follows the reader/plans vertical slice. Milestones are private, optional, and noncompetitive.
12. US Catholic practice is the default Learning jurisdiction; variation is always labeled. Qualified external review becomes mandatory before any distribution beyond the owner.

Phase 2 closed on October 12, 2026 with CPDV (`42`) as the approved text edition. The owner explicitly deferred physical-device accessibility and live offline/error-recovery acceptance to Phase 7 hardening. NRSV-CI (`2015`) remains a desired edition pending provider access and must pass the same fail-closed audit before use.

Inputs still required before the seven-virtues track exits:

- approved Catholic sources and a qualified review route for each formation pathway;
- owner acceptance of the proposed practice/check-in model and pastoral language;
- the existing Ambition and Echo runtime contracts when those sibling apps are ready for integration.

## 12. Definition of Done for every feature

A feature is done only when:

- its happy path, empty state, offline state, error state, and recovery state exist;
- iPhone, Mac, light/dark appearance, Dynamic Type, VoiceOver, and keyboard behavior are addressed;
- private data handling and log redaction are reviewed;
- provider/content rights and required attribution are encoded, not kept as tribal knowledge;
- YouVersion-backed work passes adapter contract tests, displays current attribution, respects version filters and `Cache-Control`, and handles `403`/`429` without leaking provider details into other features;
- unit/integration/UI tests appropriate to the risk pass;
- user-visible copy is final and Catholic claims have the required review;
- data migration and sync implications are documented;
- deep links and hub/Echo contracts are versioned;
- acceptance criteria are demonstrated on real supported devices.

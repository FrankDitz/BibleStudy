# Editorial Depth Implementation Plan

Status: implementation contract
Target branch: `feature/editorial-depth`
Visual references: the approved Emerald Light, Emerald After Dark, and Editorial Depth boards

## Success condition

This work is accepted only when the running iPhone and macOS app has the same hierarchy, contrast, visual rhythm, and editorial character as the approved boards. The boards are not mood references. They are the composition target.

Emerald Light uses optic white as the dominant canvas. Emerald After Dark uses black as the dominant canvas; graphite separates adjacent regions and emerald is reserved for active state, progress, rules, and decisive calls to action. The dark appearance must never read as a green page with black decoration.

## Existing structure audit

The app already has the correct functional navigation and a useful first-generation visual foundation:

- five attached iPhone tabs and a fixed macOS sidebar;
- semantic light/dark colors and an appearance selector;
- 16:9 feature, 3:2 plan-cover, and 1:1 thumbnail artwork slots;
- bounded 1180-point macOS content regions;
- editorial serif headings, tracked metadata, hairlines, and near-square controls;
- complete Home, Bible, Plans, Virtues, Learning, and You journeys.

The missing layer is the below-hero composition. Most content still enters a generic `FeatureCard`, which makes plans, courses, learning topics, progress, and profile information look structurally identical. The approved boards require purpose-built containers.

## Responsive canvas contract

| Region | iPhone | macOS |
| --- | --- | --- |
| Reference viewport | 390 pt wide | 1180 pt maximum content width |
| Screen side inset | 20 pt | 24 pt inside the bounded canvas |
| Primary vertical gap | 24 pt | 24–32 pt |
| Feature artwork | available width at 16:9; 197 pt at 350 pt content width | one column of a 2-column split, minimum 420 pt wide |
| Editorial media | available width at 3:2; 233 pt at 350 pt content width | adaptive 3:2 tile, minimum 320 pt wide |
| Progress thumbnail | 92 × 92 pt | 132 × 132 pt |
| Attached tab bar | 58 pt plus bottom safe area | not applicable; fixed 190–230 pt sidebar |
| Long-page clearance | 32 pt plus tab-bar content margin | 32 pt |

At accessibility text sizes, fixed-height text containers become minimum heights. Photography and decorative numerals may crop, but instructional text must expand.

## New container contracts

### 1. `EditorialPanel`

The base architectural surface replacing generic rounded cards where the design calls for a composed module.

- Geometry: square 0–4 pt radius, 1 pt hairline, optional 4 pt emerald leading rule.
- Padding: 16 pt iPhone, 20–24 pt macOS.
- Light: white or warm elevated white.
- Dark: black (`#020302`) or graphite (`#0C100D`), never a translucent green wash.
- Minimum interactive target: 44 pt.

### 2. `EditorialInterlude`

A visual pause between utilitarian groups. It carries one formation statement, Scripture reference, or contextual explanation.

- iPhone: full content width, minimum 168 pt; 20 pt padding.
- macOS: minimum 196 pt; may pair with a 3:2 media tile in a two-column row.
- Structure: tracked eyebrow, 36–58 pt background numeral or wordmark, serif statement, 32 × 3 pt emerald rule, optional citation.
- Background: black in dark appearance; emerald or black in light appearance depending on hierarchy.

### 3. `EditorialRouteMap`

The Plans progress container visible in browse and active-plan contexts.

- iPhone: minimum 122 pt; three equal checkpoints connected by 1 pt rules.
- macOS: minimum 144 pt; horizontal layout with expanded descriptions.
- Checkpoint: 40 × 40 pt; selected checkpoint emerald, completed checkpoint emerald outline/check, future checkpoint elevated surface.
- Always includes textual progress and cannot communicate state by color alone.

### 4. `EditorialIdentityRail`

The Virtues course-identity container.

- iPhone: horizontally scrollable 112 × 128 pt tiles.
- macOS: four equal tiles in a row, minimum 150 pt high.
- Tile content: 28–34 pt emblem, title, one-line formation verb, active/completed state.
- Cardinal emblems: lamp/path for Prudence, scales for Justice, shield for Fortitude, vessel/flame for Temperance.
- Counter-virtue courses retain their existing doctrinal names and receive distinct symbols and course numbers.

### 5. `EditorialProgressSegments`

Discrete lesson/course progress used where a continuous bar loses meaning.

- Segment height: 8 pt iPhone, 10 pt macOS.
- Segment gap: 5–7 pt.
- Completed: emerald; current: emerald outline; future: graphite/elevated surface.
- Text summary appears beside or below the segments.

### 6. `EditorialMediaStory`

A 3:2 image paired with a compact story, witness, or formation prompt.

- iPhone: image 3:2 above a minimum 116 pt text panel.
- macOS: two-column split, 3:2 image width 45–55%, minimum total height 250 pt.
- Image owns no baked-in app heading. Garment text may be part of the photographed subject.
- Overlay gradients may protect app-owned text but cannot conceal faces or garment messages.

### 7. `EditorialMetricMatrix`

The You screen’s progress visualization.

- iPhone: two columns; each cell minimum 108 pt.
- macOS: four columns; each cell minimum 124 pt.
- Large serif value, tracked label, short interpretation, and optional segmented rhythm marks.
- No holiness score, social ranking, or inferred moral judgment.

### 8. `ReaderPullQuote`

A restrained Bible-reader accent used only when the provider supplies a supported section or selected passage context.

- Maximum reader width remains 760 pt.
- 4 pt emerald rule, 16 pt inset, serif italic quotation, reference line.
- No photography inside Scripture text and no interruption of provider-owned verse ordering.
- Until structured section data is available, the masthead provides the approved editorial depth and no synthetic quotation is injected.

## Screen composition contracts

### Home

1. Existing photo-led hero, 690 pt on iPhone and 570 pt in the Mac split.
2. `EditorialInterlude`: weekly formation prompt with a large Scripture reference.
3. Today actions use purpose-built rows rather than identical cards.
4. Recent activity closes with a rhythm/progress treatment.

### Plans

1. Existing 16:9 orientation feature.
2. Active plan uses image + progress summary.
3. `EditorialRouteMap` shows Foundations / Discipleship / Mission or equivalent thirds derived from actual plan duration.
4. A Scripture interlude separates the active journey from the browse library.
5. Plan library remains grouped by intention with full-width 3:2 covers on iPhone and an adaptive grid on Mac.
6. Active plan detail uses its source plan’s 3:2 artwork instead of a generic gradient.

### Virtues

1. Existing current-course photographic feature.
2. `EditorialIdentityRail` establishes a distinct visual identity for the four cardinal virtues.
3. Current course progress and lesson action remain attached to the hero.
4. Course libraries retain doctrinal grouping but use emblem-led identities instead of repeated generic cards.
5. A witness/formation interlude appears after the course library and before optional practice tools.

### Learning

1. Existing Catholic-formation feature.
2. Worship / Belong / Pray becomes a connected route rather than three interchangeable cards.
3. Each topic gains a strong numbered identity band and predictable lesson outline.
4. At least one 3:2 `EditorialMediaStory` breaks the long catalog and explains how knowledge becomes participation.

### Bible

1. Reader remains the quietest surface.
2. Existing book/chapter masthead is strengthened with subtle texture, oversized numeral, and clearer editorial partitioning.
3. Scripture width remains 760 pt; no photo or fabricated devotional content is inserted between verses.
4. Dark reader remains independently controlled by Reader settings.

### You

1. Editorial black/emerald identity header.
2. `EditorialMetricMatrix` for reading rhythm, current plan, completed courses, and private milestones.
3. Appearance, integrations, and privacy use bordered editorial panels with clearer section transitions.

## Deliverables

### ED-1 — Specification and shared containers

- Record this responsive contract.
- Add layout tokens and all reusable containers listed above.
- Make dark semantic colors genuinely black-led.
- Add design-system tests for ratios, minimum dimensions, and theme roles.

### ED-2 — Home and You depth

- Add the Home formation interlude and structured Today/action rhythm.
- Add the You identity header and metric matrix.
- Preserve all existing actions, privacy guarantees, and appearance selection.

### ED-3 — Plans depth

- Add active-plan route map and Scripture interlude.
- Bind active-plan cover art to its source template.
- Preserve plan preview, activation, completion, recovery, and scheduling behavior.

### ED-4 — Virtues depth

- Add cardinal identity rail and emblem system.
- Strengthen current-course segmented progress and course-library identities.
- Add a formation witness/interlude without changing doctrine or progress semantics.

### ED-5 — Learning and Bible depth

- Convert the Learning map to a connected route and add a media-story break.
- Refine topic identity bands.
- Refine the Bible masthead and reader surface without injecting unsupported Scripture text.

### ED-6 — Production artwork and responsive verification

- Generate or select artwork only after its final slot dimensions are fixed.
- Verify focal points at 390 pt iPhone width and in 1180 pt Mac compositions.
- Build iOS and macOS, run unit/UI checks, inspect light and dark appearances, and correct any Dynamic Type or bottom-clearance regression.

## Acceptance checklist

- Emerald After Dark is visually dominated by black and graphite.
- Every main tab has at least two kinds of visual structure below the hero.
- Plans communicates route and progress before library browsing.
- Virtues communicates distinct course identities before long descriptions.
- Learning reads as an ordered Catholic curriculum.
- Bible remains calm and legible.
- You presents private progress visually without scoring holiness.
- No floating tab bar, generic capsule stack, botanical decoration, or stretched Mac phone layout appears.
- The running app, not only a static mockup, visibly matches the approved boards.

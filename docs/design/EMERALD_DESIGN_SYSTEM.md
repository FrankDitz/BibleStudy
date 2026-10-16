# Emerald Light + Emerald After Dark

Status: approved visual direction  
Approved: October 15, 2026

The app uses one adaptive visual system with two appearances:

- **Emerald Light** is the default daytime appearance: optic white, ink black, saturated emerald blocks, sharp architectural photography, and generous negative space.
- **Emerald After Dark** is the nighttime appearance: near-black and graphite surfaces, crisp white type, saturated emerald accents, and cinematic photography.

The source boards are preserved at:

- `docs/design/references/emerald-light.png`
- `docs/design/references/emerald-after-dark.png`

The in-app hero artwork is original project artwork and lives in `BibleStudy/Resources/Assets.xcassets`.

## Non-negotiable visual rules

1. Scripture remains the quietest, most readable surface in the product.
2. Saturated emerald is architectural: full-width reading blocks, progress segments, large numerals, active navigation, and decisive rules. It is not a soft wellness tint.
3. Fashion photography communicates confident, positive Christian culture. It never becomes a storefront or overwhelms the content.
4. Display typography uses an editorial serif; controls and metadata use a restrained system sans serif with tracked uppercase labels.
5. Cards use controlled radii, hairline borders, and little or no material blur. Avoid floating translucent-card clutter.
6. No botanical, pastoral, Mediterranean, rustic, or luxury-resort imagery.
7. Dark appearance is not neon or cyberpunk. Emerald remains a flat, legible accent.
8. Progress is always communicated with text or symbols as well as color.

## Binding layout rules

- On iPhone, Home opens as an image-led canvas. The fashion photograph occupies most of the first viewport; the brand, display line, Continue Reading block, and three primary formation choices are layered into that canvas rather than presented as detached cards.
- The iPhone primary navigation is a full-width bar attached to the bottom safe area. It never floats inside a capsule or rounded container.
- Bible chapters open with an editorial masthead that names the current book and makes the current chapter number unmistakable before the passage text begins.
- Virtues opens with the current course as a photographic hero. Course progress and the next lesson sit directly beneath it as one connected learning module.
- Plans uses the same display type, emerald architecture, straight-edged controls, segmented progress, and responsive content grid even though it has no photographic concept board.
- On Mac, navigation uses a fixed editorial sidebar. Core screens use bounded wide layouts, multi-column composition where useful, and purpose-sized heroes; phone-width stacks must not be stretched across the desktop window.
- Cards, fields, day selectors, badges, and secondary actions use near-square geometry with hairline borders. Rounded bubbles, floating pills, and soft wellness-card shadows are not part of this system.

## Content hierarchy and artwork contracts

Layout is approved before final photography is generated. The interface defines the crop; photography must be composed for the interface rather than forcing an unrelated portrait into a card.

### Fixed artwork slots

| Slot | Ratio | Used for | Composition requirement |
| --- | --- | --- | --- |
| Feature | 16:9 | Plans, Virtues, and Learning introductions | Keep the subject and any garment message within the central 60% of the frame. Leave deliberate negative space for an optional app-owned overlay. Do not bake headings into the image. |
| Plan cover | 3:2 | Every premade-plan cover | One clear subject or symbolic scene. The focal point and Christian apparel must remain readable at compact iPhone width and in a multi-column Mac grid. |
| Progress thumbnail | 1:1 | Active-plan and other compact continuation rows | A simple crop with one unmistakable focal point. It must remain legible at 92 points on iPhone. |

`EditorialMediaSlot` owns these ratios on both platforms. Existing photography is temporary until the content layout is signed off; visible cropping in the temporary assets is not a reason to change the slot.

### Plans hierarchy

1. Orient the reader with a 16:9 Scripture-formation feature and a short three-step Choose / Preview / Begin guide.
2. Put the active plan—or the create/choose next step—immediately after the orientation.
3. Organize the library by intention: begin with Jesus, build a monthly rhythm, then take a complete journey.
4. On iPhone, plans are compact 3:2-thumbnail rows with the commitment and both Preview and Start actions visible. On Mac, the same plans become full 3:2 cover cards in a bounded adaptive grid.

### Virtues hierarchy

1. Open with one connected current-course module: 16:9 feature, segmented progress, current lesson, and one clear Open Course action.
2. Explain the formation sequence—learn, practice, live—before presenting the library.
3. Present the foundation course before two numbered libraries: the seven virtues opposed to the capital sins, then the four cardinal virtues.
4. Keep optional practice cycles, journeys, rule of life, and formation record after study. Progress is private and never presented as a holiness score.
5. On iPhone, course libraries are numbered scan-friendly rows. On Mac, they expand into bounded multi-column course cards.

### Learning hierarchy

1. Open with a 16:9 Catholic-formation feature and the promise to help the reader participate with confidence.
2. Show the learning map before the catalog: Worship, Belong, Pray.
3. Group lessons into numbered tracks: worship and sacred time, sacraments and belonging, then prayer and devotion.
4. Every planned topic exposes a concrete three-part curriculum outline so the reader understands its purpose before content is published.
5. On iPhone, tracks form one readable vertical path. On Mac, topic cards use a bounded adaptive grid without stretching phone layouts.

## UI redesign deliverables

### UI-1 — Visual specification and source assets

- Preserve both approved concept boards.
- Record palette, typography, imagery, component, accessibility, and responsive-layout rules.
- Produce original light and dark hero artwork with documented project ownership.

### UI-2 — Adaptive design-system foundation

- Add semantic colors for background, surface, elevated surface, ink, muted ink, emerald, and hairlines.
- Add System, Emerald Light, and Emerald After Dark preferences.
- Build shared editorial headings, section labels, cards, action treatments, progress blocks, and hero imagery.
- Keep semantic colors accessible across iPhone and Mac.

### UI-3 — Navigation and app chrome

- Apply the emerald selection state to iPhone tabs and the Mac sidebar.
- Preserve five stable iPhone tabs and the profile destination.
- Standardize screen backgrounds, toolbars, dividers, and selected states.

### UI-4 — Home

- Add the fashion-led hero and editorial `LIVE THE WORD` composition.
- Make Continue Reading the single dominant action.
- Recompose plan, virtue, learning, and recent-activity content into the new hierarchy.

### UI-5 — Bible reader

- Give the provider-backed reader quiet white/black Scripture surfaces.
- Apply emerald chapter/navigation accents and editorial controls without changing provider or rights behavior.
- Preserve reader-specific light, sepia, and dark preferences.

### UI-6 — Plans

- Restyle browse, preview, activation, and active-plan screens.
- Use cover blocks, segmented progress, and clear day/readings hierarchy.
- Preserve truthful completion and all scheduling behavior.

### UI-7 — Virtues and Learning

- Give Virtues a strong emerald editorial introduction, course progress, and consistent lesson cards.
- Give Learning a Catholic-life collection layout using the same visual language.
- Remove decorative botanical symbolism from primary navigation and prominent cards.

### UI-8 — You, accessibility, and verification

- Add the appearance selector to You.
- Verify Dynamic Type, VoiceOver labels/order, contrast, Reduce Motion, keyboard focus, iPhone layouts, and Mac resizing.
- Build both platforms and run the existing unit/UI checks before merge.

## Acceptance gate

The redesign is complete when the app is recognizably the same product as both approved boards in either appearance, Scripture remains comfortable for long reading, all existing journeys still work, and the verification suite passes without introducing provider, persistence, or content changes.

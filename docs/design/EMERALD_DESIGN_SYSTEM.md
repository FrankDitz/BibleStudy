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

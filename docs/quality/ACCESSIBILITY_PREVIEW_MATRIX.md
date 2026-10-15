# Accessibility and Preview Matrix

**Baseline:** Phase 1 navigation shell and design states  
**Platforms:** iOS 17+ and macOS 15+  
**Last updated:** 2026-10-15

## Required preview matrix

| Surface | Compact iPhone | Large iPhone | Mac compact window | Mac wide window |
| --- | --- | --- | --- | --- |
| Home | Default, AX5 text, dark | Default, largest accessibility text | 640×520, keyboard | 1080×760, dark |
| Bible/setup | Missing key, loading, rights locked, offline | Reader handoff | Sidebar focus | Reader resizing |
| Plans | Empty plan, template cards | Largest text | Keyboard toolbar | Wide cards |
| Learning | Topic list, long localization | Largest text | Sidebar/list focus | Wide list |
| You | Integration off/on | Largest text | Keyboard links | Diagnostics results |
| Shared states | loading, empty, error, offline, rights locked, stale | Every state | Every state | Every state |

## Acceptance checks

- VoiceOver reads destination, title, supporting text, current state, and action in a useful order.
- SF Symbols are decorative when adjacent text already names the concept; icon-only controls have explicit labels.
- Dynamic Type through the largest accessibility size does not clip, overlap, or hide actions. Horizontal card groups fall back to vertical layout.
- Color is not the only state signal; every status includes text and an icon.
- Text/background combinations meet WCAG AA contrast for normal text and remain legible in light, dark, and sepia reader themes.
- Mac navigation is reachable by keyboard with visible focus and logical sidebar/detail movement.
- Reduce Motion disables future reader auto-scroll animation and nonessential transitions; no current shell behavior requires motion.
- Loading announcements are meaningful and do not loop; retry actions name the operation.
- Offline, stale, provider-denied, and generic failure are distinct messages.
- Content remains usable at the minimum supported window size without covered controls.

## Change evidence

For UI changes, record the tested platform/window, text size, color scheme, VoiceOver/keyboard result, and any unverified case in the change description. Phase exit requires a manual pass on physical iPhone and Mac in addition to previews and automated builds.

### 2026-10-11 foundation verification

- iPhone 16e simulator, iOS 18.5: four shell UI tests passed, including largest accessibility text and labels/hit targets.
- XCTest's audit exposed insufficient supporting-text contrast on the warm material card; the shell now uses `AppTheme.supportingText`.
- Native Mac app: Home, Bible, Plans, Learning, and You launched and navigated successfully through the accessibility tree.
- Mac XCTest UI automation: not executed because the host timed out while enabling automation mode; normal app behavior was verified separately.
- Still required: physical iPhone/Mac VoiceOver, minimum-window/keyboard, light/dark, and Reduce Motion sign-off.

### 2026-10-12 Phase 2 disposition

The owner approved closing the reader phase and deferring the physical iPhone/Mac accessibility pass plus live provider-managed offline/error-recovery checks to Phase 7 hardening. Automated reader semantics, largest-text UI coverage, simulator compilation, keyboard shortcuts, themes, Reduce Motion-aware transitions, and live Mac reader behavior are complete. The deferred checks remain release requirements and must not be described as passing until performed.

### 2026-10-15 Emerald redesign verification

- Native Mac, wide window: Emerald Light and Emerald After Dark were both selected in-app and visually inspected on Home and You. Editorial type, fashion artwork, surface contrast, progress modules, and appearance persistence rendered correctly.
- Native Mac reader: Scripture content, chapter controls, edition notice, and typography rendered correctly. The default reader theme now follows the app appearance; Light, Sepia, and Dark remain explicit reader overrides.
- macOS build and the complete `BibleStudyTests` unit-test bundle passed.
- Generic iOS Simulator compilation passed after the automatic reader-theme refinement.
- The combined macOS scheme test reached and passed the unit suites, but the UI-test runner exited before establishing its automation connection. This is a host-runner failure, not a passing UI-test result.
- Still required before release: hands-on compact/large iPhone review, largest Dynamic Type, VoiceOver, keyboard-only Mac navigation, Reduce Motion, and the physical-device checks already deferred to Phase 7.

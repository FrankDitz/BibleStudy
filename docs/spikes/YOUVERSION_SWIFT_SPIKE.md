# YouVersion Swift Spike

**SDK tested:** 5.5.0  
**Platforms compiled:** macOS 15 target; iOS 17 target remains in CI  
**Live account status:** Blocked until the owner registers an App Key and accepts edition licenses  
**Last reviewed:** 2026-10-11

## Outcome

Keep YouVersion as the primary Scripture integration, but keep app-owned references, plans, annotations, and provider adapters. The stable SDK materially accelerates the reader. It does not complete plans, audio, learning, or every Catholic validation requirement.

The project now includes an on-device audit under **You → Integrations → Audit licensed editions**. It fetches only metadata/indexes for IDs `463`, `2015`, and `55`, verifies Catholic structure and attribution, and stores neither Scripture text nor the App Key.

## Verified from SDK 5.5.0 source and compilation

| Capability | Result | Decision |
| --- | --- | --- |
| SwiftUI full reader | Available through `BibleReaderView` | Use as Phase 2 baseline |
| iPhone/iPad/Mac | Package minimums are iOS 17 and macOS 15; app compiles for Mac | Supported |
| Book/chapter/version navigation | Built into reader; version allowlist supported | Use with Catholic audit gate |
| External plan/home navigation | `BibleReaderNavigation.request` works with app-owned references | Keep current bridge |
| Verse actions | Host `onVerseTap` intercepts selection | Keep notes/bookmarks/highlights local |
| YouVersion sign-in | Optional; disabled in this app | Do not depend on it |
| Attribution | Reader renders `copyright`, then `promotionalContent`, plus publisher footer | Use reader; custom views fail closed |
| Caching | 5.5.0 honors response cache-control headers and has memory/disk caches | Do not add unrestricted bulk caching |
| Offline | Previously cached eligible chapters can be returned by the repository | Live device test still required per edition |
| Accessibility | SDK contains labels, Dynamic Type-oriented SwiftUI, Reduce Motion handling, and keyboard-compatible native controls | Manual VoiceOver/largest-text pass remains required |
| Search | Documented for newer Swift SDK source, but absent from the stable 5.5.0 tag | Do not pin unreleased `main`; use REST adapter or next stable tag |
| Reading plans | No documented Platform plan API in the SDK/API surface | Plans remain app-owned |
| Audio | No documented YouVersion Platform audio API in the developer surface | Use a separate licensed provider |

## Catholic coverage rule

Do not require exactly 73 provider book records. The conceptual Catholic canon contains 73 books, but YouVersion exposes the additions to Esther as a separate `ESG` resource alongside `EST`. A structurally complete edition therefore currently maps 73 canonical books across 74 expected provider IDs.

The audit also requires Daniel chapters 13 and 14 and nonempty live attribution. This is still a structural test. Final approval additionally opens and visually checks `ESG`, Daniel 3, Daniel 13, and Daniel 14 because chapter identifiers and versification differ by edition.

## Known SDK risk: nonstandard chapter identifiers

SDK 5.5.0's picker displays provider chapter labels but sends the selected list index plus one as the chapter number. Catholic Esther resources can use provider identifiers such as `1_1`, or labels/numbering such as A–F and 11–16. The public `BibleReference` type accepts an integer chapter.

This may make some `ESG` navigation incorrect even when its text exists. The live test must exercise every `ESG` chapter in all approved editions. If any fail, Phase 2 uses one of these routes before broader reader work:

1. adopt a tagged SDK release that preserves provider passage IDs;
2. submit/consume an upstream fix after review; or
3. use app-owned Catholic navigation and the REST passage endpoint while retaining SDK rendering where safe.

The app must not hide `ESG` or declare the edition complete merely because the other books render.

## Live App Key test script

After the owner creates `Config/Secrets.xcconfig` and accepts the desired licenses:

1. Launch on iPhone and Mac; open the Bible tab.
2. Run **You → Audit licensed editions** and save the three results in the rights matrix.
3. For every approved edition, open Genesis 1, Psalm 23, Matthew 1, Revelation 22, Tobit 1, Baruch 1, `ESG` beginning/end, Daniel 3, Daniel 13, and Daniel 14.
4. Navigate previous/next across Tobit, Judith, Esther/`ESG`, 1–2 Maccabees, Wisdom, Sirach, Baruch, and the Old/New Testament boundary.
5. Launch a plan reference and confirm the reader changes in place.
6. Tap a verse and verify only Bible Study's local action sheet appears.
7. Confirm the live copyright/footer is present in light/dark mode, largest text, VoiceOver, and Mac keyboard navigation.
8. Warm a chapter, disable networking, relaunch, and document cached/uncached behavior.
9. Exercise missing key, invalid key, unlicensed `403`, offline, empty, decoding, and rate-limit states.
10. Test search through the next tagged SDK or a small REST adapter; confirm reference, text, topic, suggestions, corrections, and pagination behavior without treating search results as passage text.

## Merge gate

The harness and static spike may merge without a credential. The Phase 0 YouVersion provider gate remains open until a real App Key produces at least one passing edition audit and the manual `ESG`/Daniel checks succeed. The App Key and accepted-license HTML must never be committed.

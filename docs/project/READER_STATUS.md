# Reader Phase Status

**Implementation status:** complete
**Phase-exit status:** owner physical-device accessibility sign-off remains
**Verified:** 2026-10-12

The owner’s YouVersion App Key exposes CPDV (`42`), which passes the automated 73-book Catholic structure and attribution gate. NRSV-CI (`2015`) is not currently exposed to this developer App Key; the owner’s support request is pending but does not block continued work with CPDV. Bible Study remains fail-closed: the runtime audit must pass before the reader or search is enabled.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0201 | Restrict the SDK to candidate Catholic edition IDs, audit canon structure and attribution at runtime, then reconfigure the picker with only passing IDs | `YouVersionCatalogPolicy`, `YouVersionCatalogApproval`, `YouVersionCatalogGateDecision`; live CPDV `42` approval | Complete |
| BS-0202 | Map the 73-book Catholic canon to YouVersion resources and detect split or integrated Esther additions plus Daniel 13–14 | `YouVersionCatholicBookMapping`, `YouVersionEditionAuditor`; live CPDV Esther 11–15 and Daniel 13–14 traversal | Complete |
| BS-0203 | Ship app-owned front-to-back navigation and restoration while retaining YouVersion rendering | `YouVersionBibleReaderView`, `YouVersionReaderNavigator`, `ReadingPositionRepository`, `ScriptureNavigationController` | Complete; live macOS relaunch restoration and Catholic boundary traversal pass |
| BS-0204 | Store translation-scoped bookmarks, highlight choices, and private notes locally | `ScriptureAnnotationRepository`, `YouVersionLocalHighlightBridge`, reader verse actions, disk-reopen and render-cache tests | Complete; data remains app-local and YouVersion sign-in is disabled |
| BS-0205 | Search licensed Scripture with version, attribution, paging, correction, and provider-error behavior | `YouVersionScriptureSearchAdapter`, `YouVersionBibleSearchView`, adapter contract tests, live CPDV probe | Complete |
| BS-0206 | Validate reader text controls, VoiceOver, keyboard, contrast, and Reduce Motion on iPhone and Mac | App reader controls, semantic labels, keyboard shortcuts, Reduce Motion-aware transitions, app accessibility matrix | Implementation complete; owner physical-device sign-off remains |

## Verification evidence

- All 69 macOS unit and contract tests pass, including search, reader navigation, approved-edition restoration, persistence, and highlight-rendering coverage.
- Annotation tests cover translation/passage isolation, bookmark toggling without duplicate rows, highlight changes, note trimming and soft deletion, and a real store close/reopen round trip.
- The generic iOS Simulator app and UI-test bundle build successfully.
- Four iPhone UI tests pass for navigation, the missing-provider state, semantic accessibility, and largest accessibility text.
- CPDV search returned licensed reference results for reference/text/topic intent. Five sequential 10-result text searches measured 0.445–0.825 seconds, with a 0.559-second median, on 2026-10-12; passage cards fetch and attribute the licensed text through the SDK.
- The reader cannot render an unaudited edition: missing configuration, rejected Catholic structure/attribution, and audit unavailability each have distinct fail-closed states.
- The app-owned reader presents all 73 CPDV books in Catholic canonical order, exposes every available chapter, uses supported `BibleTextView` rendering, and persists only an approved canonical reading position in SwiftData.
- A live macOS run advanced John 1 to John 2, terminated the process, and restored John 2 after relaunch without reading or writing YouVersion’s private storage keys.
- Live boundary checks opened Esther 15 and Daniel 14; next-chapter navigation reached 1 Maccabees 1 and Hosea 1 respectively.
- Light, sepia, and dark reader themes, scalable text, semantic passage controls, `Command-[`/`Command-]` navigation, and Reduce Motion-aware transitions are implemented.

## Remaining acceptance

The repository does not contain a YouVersion credential. The owner’s key remains only in ignored `Config/Secrets.xcconfig`; never commit or paste it into an issue, log, test fixture, or chat message.

The remaining owner acceptance is the physical-device portion of the accessibility matrix: VoiceOver reading order, maximum Dynamic Type, keyboard focus, contrast, Reduce Motion, and provider-managed offline/error recovery on the owner’s iPhone and Mac. Automated tests, simulator compilation, semantic accessibility inspection, and live Mac behavior are merge gates; physical sign-off remains an owner acceptance gate rather than unfinished implementation.

The NRSV-CI support request can later add `2015` to the same fail-closed catalog and search paths after its exact book/chapter layout passes the navigation and restoration acceptance matrix. Audio remains outside this phase until a separately licensed Catholic audio source is approved.

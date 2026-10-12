# Reader Phase Status

**Implementation status:** in progress
**Phase-exit status:** reader restoration and cross-platform accessibility acceptance remain
**Verified:** 2026-10-12

The owner’s YouVersion App Key exposes CPDV (`42`), which passes the automated 73-book Catholic structure and attribution gate. NRSV-CI (`2015`) is not currently exposed to this developer App Key; the owner’s support request is pending but does not block continued work with CPDV. Bible Study remains fail-closed: the runtime audit must pass before the reader or search is enabled.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0201 | Restrict the SDK to candidate Catholic edition IDs, audit canon structure and attribution at runtime, then reconfigure the picker with only passing IDs | `YouVersionCatalogPolicy`, `YouVersionCatalogApproval`, `YouVersionCatalogGateDecision`; live CPDV `42` approval | Complete |
| BS-0202 | Map the 73-book Catholic canon to YouVersion resources and detect split or integrated Esther additions plus Daniel 13–14 | `YouVersionCatholicBookMapping`, `YouVersionEditionAuditor`; CPDV integrated Esther 11–15 and Daniel 13–14 audit | Automated structure complete; full manual boundary traversal remains with BS-0203 acceptance |
| BS-0203 | Use the native reader and accept Home, Plan, Learning, and deep-link passage requests | `YouVersionBibleReaderView`, `BibleReaderNavigation`, `ScriptureNavigationController` | Partial; live front-to-back and restoration acceptance pending |
| BS-0204 | Store translation-scoped bookmarks, highlight choices, and private notes locally | `ScriptureAnnotationRepository`, `YouVersionLocalHighlightBridge`, reader verse actions, disk-reopen and render-cache tests | Complete; data remains app-local and YouVersion sign-in is disabled |
| BS-0205 | Search licensed Scripture with version, attribution, paging, correction, and provider-error behavior | `YouVersionScriptureSearchAdapter`, `YouVersionBibleSearchView`, adapter contract tests, live CPDV probe | Complete |
| BS-0206 | Validate reader text controls, VoiceOver, keyboard, contrast, and Reduce Motion on iPhone and Mac | SDK reader controls, app accessibility matrix | Shell verified; live reader matrix pending |

## Verification evidence

- The complete macOS unit and contract suite passes, including search request, paging, correction, entitlement, rate-limit, persistence, and highlight-rendering coverage.
- Annotation tests cover translation/passage isolation, bookmark toggling without duplicate rows, highlight changes, note trimming and soft deletion, and a real store close/reopen round trip.
- The generic iOS Simulator app and UI-test bundle build successfully.
- Four iPhone UI tests pass for navigation, the missing-provider state, semantic accessibility, and largest accessibility text.
- CPDV search returned licensed reference results for reference/text/topic intent. Five sequential 10-result text searches measured 0.445–0.825 seconds, with a 0.559-second median, on 2026-10-12; passage cards fetch and attribute the licensed text through the SDK.
- The reader cannot render an unaudited edition: missing configuration, rejected Catholic structure/attribution, and audit unavailability each have distinct fail-closed states.

## Remaining acceptance

The repository does not contain a YouVersion credential. The owner’s key remains only in ignored `Config/Secrets.xcconfig`; never commit or paste it into an issue, log, test fixture, or chat message.

The remaining reader acceptance run is:

1. manually traverse all CPDV book boundaries, including integrated Esther 10–15 and Daniel 12–14;
2. terminate and relaunch on iPhone and Mac to verify the SDK restores the last passage without using its private storage keys;
3. validate provider-managed offline/error recovery behavior; and
4. complete the VoiceOver, largest-text, keyboard, contrast, and Reduce Motion matrix on both platforms.

The NRSV-CI support request can later add `2015` to the same fail-closed catalog and search paths without changing the reader architecture. Audio remains outside this phase until a separately licensed Catholic audio source is approved.

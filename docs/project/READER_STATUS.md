# Reader Phase Status

**Implementation status:** in progress  
**Phase-exit status:** blocked on live licensed-catalog validation  
**Verified:** 2026-10-11

The first provider-neutral reader slices are implemented and merged. Bible Study remains fail-closed: a configured YouVersion App Key must complete a runtime Catholic-edition audit before the licensed reader can appear.

## Deliverables

| Backlog | Outcome | Evidence | Status |
| --- | --- | --- | --- |
| BS-0201 | Restrict the SDK to candidate Catholic edition IDs, audit canon structure and attribution at runtime, then reconfigure the picker with only passing IDs | `YouVersionCatalogPolicy`, `YouVersionCatalogApproval`, `YouVersionCatalogGateDecision` | Implementation complete; live App Key result pending |
| BS-0202 | Map 73 Catholic books to 74 YouVersion resources and detect Esther additions plus Daniel 13–14 | `YouVersionCatholicBookMapping`, `YouVersionEditionAuditor` | Mapping complete; live navigation audit pending |
| BS-0203 | Use the native reader and accept Home, Plan, Learning, and deep-link passage requests | `YouVersionBibleReaderView`, `BibleReaderNavigation`, `ScriptureNavigationController` | Partial; live front-to-back and restoration acceptance pending |
| BS-0204 | Store translation-scoped bookmarks, highlight choices, and private notes locally | `ScriptureAnnotationRepository`, reader verse actions, disk-reopen tests | Persistence complete; in-text highlight rendering pending |
| BS-0205 | Search licensed Scripture with version, attribution, paging, correction, and provider-error behavior | Provider capability boundary | Not started; live provider access required |
| BS-0206 | Validate reader text controls, VoiceOver, keyboard, contrast, and Reduce Motion on iPhone and Mac | SDK reader controls, app accessibility matrix | Shell verified; live reader matrix pending |

## Verification evidence

- 50 macOS unit and contract tests pass.
- Annotation tests cover translation/passage isolation, bookmark toggling without duplicate rows, highlight changes, note trimming and soft deletion, and a real store close/reopen round trip.
- The generic iOS Simulator app and UI-test bundle build successfully.
- Four iPhone UI tests pass for navigation, the missing-provider state, semantic accessibility, and largest accessibility text.
- GitHub Actions run `38179592944` passed formatting, provider-boundary, tracked-secret, macOS-test, and iOS-build jobs for commit `4d8d1fc`.
- The reader cannot render an unaudited edition: missing configuration, rejected Catholic structure/attribution, and audit unavailability each have distinct fail-closed states.

## Live provider gate

The repository does not contain a YouVersion credential. To continue the licensed reader work, create the ignored local file `Config/Secrets.xcconfig` from `Config/Secrets.example.xcconfig` and replace the placeholder with the owner’s YouVersion Platform App Key. Never commit or paste the key into an issue, log, test fixture, or chat message.

With the key installed locally, the next acceptance run is:

1. record which of NABRE (`463`), NRSV-CI (`2015`), and Douay-Rheims (`55`) the App Key can access;
2. save the structural audit results without Scripture text or credentials;
3. manually open every approved book resource, including `ESG` and Daniel 13–14;
4. confirm attribution, version switching, SDK restoration, provider-managed offline behavior, and error recovery on iPhone and Mac; and
5. decide how to close the SDK gaps for app-owned current-passage history and rendering local highlight colors in the Scripture body.

Search is implemented only after the licensed catalog proves the provider search capability for the approved edition. Audio remains outside this phase until a separately licensed Catholic audio source is approved.

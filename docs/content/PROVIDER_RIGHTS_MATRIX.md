# Scripture and Audio Provider Rights Matrix

**Status:** Research complete; account-specific approvals pending  
**Use case:** Owner-only, non-commercial personal app  
**Last verified:** 2026-10-11

This matrix is an engineering control, not legal advice. “Available in a public catalog” does not mean an App Key is licensed to render that content. No provider content is production-approved until the account-specific checks below are recorded.

## Decisions

- **Primary Scripture provider:** YouVersion Platform through the official Swift SDK.
- **Preferred edition:** NABRE, subject to App Key licensing and a live Catholic-content audit.
- **Secondary editions:** NRSV-CI, then DRC1752, subject to the same App Key audit.
- **Independent text fallback:** not selected. API.Bible remains a candidate only if an account exposes a complete Catholic edition on acceptable terms.
- **Audio:** deferred behind a provider-neutral interface. API.Bible is the technical first candidate; STREETLIGHTS is a partnership candidate. Neither is approved for integration yet.
- **YouVersion Bible App audio:** not reusable. The public Bible App's listening catalog is not a documented YouVersion Platform audio API or grant.

## Exact edition matrix

| Provider | Edition/content | Provider ID | Public evidence | Account license | Catholic coverage | Attribution source | Decision |
| --- | --- | ---: | --- | --- | --- | --- | --- |
| YouVersion | New American Bible, revised edition (NABRE) | `463` | [Public version page](https://www.bible.com/versions/463) | **Pending App Key** | Public pages show deuterocanon, `ESG`, and Daniel 13; live index/content audit still required | Live `copyright`, falling back to `promotional_content`; publisher footer where supplied | Preferred, not yet approved |
| YouVersion | New Revised Standard Version Catholic Interconfessional (NRSV-CI) | `2015` | [Public version page](https://www.bible.com/versions/2015) | **Pending App Key** | Public pages show 1–2 Maccabees and `ESG`; live audit still required | Live metadata; do not hard-code as the authoritative notice | Secondary, not yet approved |
| YouVersion | Douay-Rheims Challoner Revision 1752 (DRC1752) | `55` | [Public version page](https://www.bible.com/versions/55) | **Pending App Key** | Public page states 46-book OT plus longer Esther/Daniel; live audit still required | Live metadata; public page says out of copyright but maintained by BFBS | Development default, not yet approved |
| API.Bible | Holy Bible, New Living Translation, Catholic Edition | **Portal lookup required** | Named in current [API.Bible terms](https://api.bible/terms-and-conditions) | **Pending API.Bible account/plan** | Exact digital edition and book index unknown | API response `copyright` plus edition-specific license | Text/audio candidate only |
| API.Bible | Any English Catholic audio Bible | **`GET /v1/audio-bibles` required** | [Audio API documentation](https://docs.api.bible/guides/audio-bibles/) | **Special audio license required** | Unknown until account response | Audio-Bible metadata and license | Audio spike candidate only |
| STREETLIGHTS | English word-for-word NLT audio and soundtrack | No developer API or licensed content ID published | [English Audio Bible](https://www.streetlightsbible.com/english) | **Written permission required** | Site describes OT/NT NLT, not a complete Catholic edition | Permission agreement must specify credit | Optional partnership only |

An exact API.Bible Bible ID cannot responsibly be recorded before logging into the owner’s API.Bible dashboard: IDs identify particular digital editions/formats, and availability depends on plan and selected licenses. The live account result, not a search-engine result, becomes authoritative.

## YouVersion requirements

Official documentation establishes these controls:

- Every request requires the private `X-YVP-App-Key` associated with the registered application.
- The default Bible collection returns editions licensed to that key. `all_available=true` is discovery, not permission.
- Content calls can return `403` even when public metadata for the edition exists.
- The applicable publisher license must be accepted in the Platform Portal.
- Scripture must be shown with the version's current attribution. The app fails closed when required attribution cannot be loaded.
- SDK caching follows provider response headers. Bible Study will not add a separate bulk download/export layer for YouVersion content.
- A `429` honors `Retry-After`; authentication, unlicensed, offline, empty, and provider failures are distinct states.

The official Swift `BibleReaderView` already renders `copyright` or `promotionalContent` and publisher footer data. Any custom Bible text screen must reproduce that behavior before it may ship.

## API.Bible audio/fallback findings

API.Bible has the mechanics needed for a later audio prototype:

- list licensed audio Bibles, books, and chapters;
- obtain one expiring `resourceUrl` per chapter; and
- use optional verse-level timecodes when a recording supplies them.

This is technically suitable for chapter playback and follow-along highlighting. It is not yet a usable content path because audio requires special licensing and the owner's account has not returned a qualifying Catholic audio edition.

Current API.Bible terms and help material require edition-by-edition license review, preservation of content integrity, and cache refresh at least every 30 days. Documentation recommends fewer than 500 consecutive cached verses and a refresh within 14 days. Text and audio rights are format-specific; copyrighted text cannot be converted to audio, and publisher audio cannot be transcribed into reusable text without permission.

For a native-only personal app, the current FUMS guide says the web-app section may be skipped. This must be reconfirmed against the owner's selected plan and edition before implementation.

## STREETLIGHTS finding

STREETLIGHTS says its resources are freely given and allows listening/download through its own channels, while its site also states “all rights reserved.” That is not permission to embed, stream, cache, synchronize, or redistribute its recordings in Bible Study.

The app therefore treats STREETLIGHTS as an optional partnership. No implementation, schedule, or Phase 1–3 acceptance criterion depends on a positive response. A ready-to-send request covering private in-app playback, source URLs/API, offline storage, verse/chapter timecodes, NLT publisher rights, Catholic-canon coverage, attribution, analytics, and revocation is maintained in [`STREETLIGHTS_PARTNERSHIP_INQUIRY.md`](STREETLIGHTS_PARTNERSHIP_INQUIRY.md). It remains pending until the owner supplies the sending identity and submits it.

## Attribution templates

These are layout templates. Bracketed values are always populated from live provider metadata or the signed permission; they are not license text.

### Passage-adjacent text

```text
[Localized edition abbreviation] · [current provider copyright/required brief notice]
```

If a provider requires a specific line, that exact line replaces this template. The passage is withheld when a required notice is missing because of a metadata failure.

### Edition details

```text
[Localized edition title]
[full promotional/copyright notice]
[publisher information or link]
Scripture supplied through [provider].
```

### Audio player

```text
Audio: [recording/edition title] · [reader/producer if required]
[required rights notice] · Provided by [provider]
```

Audio and displayed text may name different editions. When they do, both edition labels remain visible and the UI must not imply word-level synchronization unless verified timecodes and versification mapping exist.

## Provider contacts

| Provider | Contact route | Use |
| --- | --- | --- |
| YouVersion Platform | [Platform support](https://platform.youversion.com/) | App Key, edition license, API/SDK entitlement, cache, and attribution questions |
| API.Bible | `support@api.bible` and [API.Bible support](https://api.bible/) | Exact Catholic text/audio IDs, special audio license, caching, and native-app reporting |
| STREETLIGHTS | `info@streetlightsbible.com` and [contact page](https://www.streetlightsbible.com/contact) | Partnership and embedded-playback permission |

## Approval checklist

For each selected source, record all of the following before enabling it:

- provider and exact content ID;
- account/app owning the credential;
- agreement/license name and acceptance date;
- allowed personal/native-app use;
- permitted display, streaming, caching, offline download, clipping, and sharing;
- required attribution captured from live metadata;
- canonical book coverage plus Esther/Daniel content audit;
- rate limits, expiration/cache rules, and revocation behavior;
- support contact and escalation date; and
- re-review trigger for any distribution or monetization change.

Credentials, license HTML, and personal account identifiers remain outside Git. The repository stores only non-secret IDs, decisions, and confirmation dates.

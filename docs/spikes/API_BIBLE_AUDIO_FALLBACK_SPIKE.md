# API.Bible Audio and Fallback Spike

**Technical status:** API contract and policy harness verified with fixtures  
**Live account status:** Blocked until the owner creates an API.Bible account, obtains a key, and receives the relevant edition/audio licenses  
**Last reviewed:** 2026-10-11

## Outcome

API.Bible is technically suitable as a provider-neutral audio candidate and a possible independent Scripture fallback. It is not yet selected as either because catalog access is account- and license-specific. No exact Bible ID will be guessed from public search results.

The repository now models the documented audio chapter response, validates expiring HTTPS resource URLs, parses numeric and clock-form timecodes, requires attribution, and encodes the 14-day recommended/30-day mandatory cache refresh windows. The harness contains no credential and downloads no copyrighted content.

## Verified capabilities

| Capability | Finding | Product decision |
| --- | --- | --- |
| Text catalog | Licensed Bibles are listed per account; books/chapters expose USFM-style IDs | Inspect the owner's live catalog before naming a fallback |
| Audio catalog | `GET /v1/audio-bibles` lists only audio Bibles licensed to the key | Special audio license is a hard gate |
| Chapter playback | One expiring `resourceUrl` is returned per audio chapter | Download promptly to a temporary playback location; do not treat the URL as durable |
| Follow-along | Some chapters include verse `start`, `end`, and `verseId` timecodes | Tier B only when the selected recording supplies complete, valid timecodes |
| Verse alignment | API.Bible distinguishes edition `id` from normalized `orgId` | Use `orgId` for cross-edition annotations; audit Catholic versification separately |
| Attribution | Chapter responses include `copyright`; account terms may add requirements | Fail closed if the required notice is absent |
| Caching | Refresh is required within 30 days; 14 days or less is recommended | Default to 14 days and make 30 days an enforced ceiling |
| Offline audio | A presigned URL is not itself permission for permanent download | Enable offline storage only with explicit edition/audio terms |

## Live account test script

1. Create the owner account and a personal, non-commercial application; keep the API key outside Git.
2. Record every English Catholic text edition returned by `GET /v1/bibles?language=eng&include-full-details=true`.
3. For each candidate, fetch `/bibles/{id}/books?include-chapters=true`; verify all 73 conceptual books, Catholic Esther, Daniel additions, and the returned copyright.
4. Record the exact text Bible ID and license in `PROVIDER_RIGHTS_MATRIX.md`; reject partial editions as a complete fallback.
5. Ask `support@api.bible` to enable eligible audio, then record every result from `GET /v1/audio-bibles?language=eng&include-full-details=true`.
6. Fetch the audio book index and spot-check Genesis 1, Psalm 23, Matthew 1, John 3, Revelation 22, and any deuterocanonical books advertised by the recording.
7. Fetch sample chapters, validate `resourceUrl`, `expiresAt`, attribution, and timecode coverage with the app audit model.
8. Confirm in writing whether transient download, persistent offline storage, analytics/FUMS handling, and the intended native personal use are allowed.
9. Exercise `401`/`403`, `404`, `429`, expired URL, offline, empty catalog, missing timecodes, and malformed response states.

## Selection gate

API.Bible becomes the text fallback only after one live, legally usable complete Catholic edition passes the book/content audit. It becomes the audio provider only after a licensed recording passes the playback audit and its agreement covers the intended storage behavior.

Until then:

- YouVersion remains the primary Scripture candidate;
- audio stays disabled in production;
- plan data and user progress remain app-owned; and
- no API.Bible text, audio, IDs, or attribution are represented as approved.

## Sources

- [API.Bible audio guide](https://docs.api.bible/guides/audio-bibles/)
- [API.Bible chapter guide](https://docs.api.bible/guides/chapters/)
- [API.Bible verse-reference guidance](https://docs.api.bible/resources/referencing-verses/)
- [API.Bible cache policy](https://care.api.bible/article/401-caching-content)
- [API.Bible terms](https://api.bible/terms-and-conditions)

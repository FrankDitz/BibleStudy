# Risk Register

**Owner context:** single-user personal application  
**Last reviewed:** 2026-10-12

Scale: likelihood and impact are `Low`, `Medium`, or `High`. “Owner” identifies the accountable role, not necessarily a separate person.

| ID | Risk | Likelihood | Impact | Early warning / trigger | Mitigation and contingency | Owner | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R-01 | No App Key edition provides a legally usable complete Catholic Bible | Low | High | Live catalog omits deuterocanon, denies content, or lacks acceptable terms | CPDV `42` passed the live account/canon/attribution gate; retain fail-closed runtime audit and re-review any replacement edition | Product/rights | Mitigated/monitor |
| R-02 | YouVersion `ESG` or Daniel additions do not navigate correctly through the stable SDK | Low | High | Picker opens the wrong chapter or cannot represent provider chapter IDs | App-owned Catholic navigator uses SDK metadata/rendering; live Esther 11–15 and Daniel 13–14 boundaries pass for CPDV | Scripture engineering | Mitigated/monitor |
| R-03 | Provider or publisher terms prohibit required cache/offline/share behavior | Medium | High | License differs from assumptions or content returns `403` | Rights capability flags; fail closed; separate provider caches; disable unsupported features | Rights/engineering | Open gate |
| R-04 | Audio rights or complete Catholic audio are unavailable | High | Medium | Empty audio catalog, special license denied, or response excludes deuterocanon | Make audio optional; ship text-first; keep API.Bible/STREETLIGHTS behind adapters | Product/rights | Accepted contingency |
| R-05 | A native-app API credential can be extracted or abused | Medium | High | Unexpected quota/auth events or key disclosure | Keep keys out of Git/logs; scope/rotate; use provider restrictions; consider a personal backend if provider requires secrecy | Security | Open |
| R-06 | Provider outage, rate limit, schema change, or SDK regression blocks reading | Medium | High | `429`/5xx spikes, decoding errors, package change, unavailable cache | Pin/review SDK; contract tests; typed states; retry rules; permitted cache; adapter boundary | Scripture engineering | Mitigated/monitor |
| R-07 | Canon or versification mismatch corrupts plan links, annotations, or audio highlighting | Medium | High | Provider IDs differ, Psalm numbering shifts, partial verses, wrong highlights | Store canonical app references plus provider mapping; use organizational IDs where available; content-level fixtures | Domain engineering | Open |
| R-08 | Plan dates/progress become inaccurate across DST, timezone, leap year, or edits | Medium | High | Duplicate/missing day, streak reversal, incorrect ahead/behind count | Calendar-based model, immutable completion events, deterministic scheduler, exhaustive date tests | Plans engineering | Planned |
| R-09 | Sync conflict or migration loses private progress/notes | Medium | High | Duplicate records, failed migration, iCloud partial state | Versioned schemas, migration fixtures, merge semantics, backup/export, never delete on sync ambiguity | Data engineering | Planned |
| R-10 | Private notes/reflections leak through logs, Hub events, analytics, or provider calls | Low | High | Payload contains note/journal text or sensitive reference context | Allowlisted event schemas, privacy tests, private OSLog fields, no third-party analytics by default | Privacy | Mitigated/monitor |
| R-11 | Learning content states doctrine or practice inaccurately or without jurisdiction | Medium | High | Conflicting sources/reviewer correction/local exception | Editorial hierarchy, visible scope, Catholic reviewer gate, expiry/re-review, correction history | Content reviewer | Policy complete |
| R-12 | Accessibility fails in long Scripture, plans, learning, or audio | Medium | High | Clipping, lost focus, unlabeled state, forced motion | Semantic reader controls, scalable text, keyboard navigation, Reduce Motion handling, automated matrix, and owner physical-device sign-off | Design/QA | Mitigated; physical sign-off pending |
| R-13 | Personal-use project quietly expands to public distribution without rights/privacy re-review | Low | High | TestFlight/App Store/multi-user/monetization request | Distribution kill switch and explicit review trigger in product brief, rights matrix, and DoD | Owner | Mitigated |
| R-14 | Scope breadth delays a usable reader/plans core | High | Medium | Work starts on badges/audio/content breadth before reader gate | Phase exit criteria, P0 backlog, vertical slices, audio optional, WIP discipline | Product | Active |
| R-15 | External links, calendars, local guidance, or attribution become stale | High | Medium | Broken link, new liturgical year, provider metadata change | Freshness metadata, scheduled reviews, live attribution, stale-content state | Content/rights | Planned |
| R-16 | Hub integration couples Bible Study to sibling app internals | Medium | Medium | Direct database/model imports or breaking cross-module change | Versioned Codable contract, adapter boundary, unknown-event tolerance, contract tests | Architecture | Mitigated |

## Review rule

Review the register at every phase boundary and whenever a provider, license, target OS, schema, distribution plan, or Church source changes. A `High`-impact risk must have a tested mitigation or an explicit feature deferral before the dependent work is considered done.

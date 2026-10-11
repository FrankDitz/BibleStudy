# ADR-006: Compose one app for standalone and Hub launch modes

- Status: accepted
- Date: 2026-10-11

## Decision

`AppDependencies` is the composition root for configuration, provider capability, feature flags, and launch context. Production construction occurs once in `BibleStudyApp`; tests and future Hub hosts can inject fixtures without global vendor state in feature views.

The root shell owns one destination selection and one Scripture navigation controller. Internal actions, Hub launches, and `biblestudy://` deep links all become a typed `BibleStudyRoute`, preventing separate navigation implementations from drifting.

Supported deep-link forms are:

- `biblestudy://destination/<home|bible|plans|learning|you>`
- `biblestudy://scripture/<book>/<chapter>?version=<id>&verse=<start>&end=<end>`

The Hub launch adapter accepts the small profile projection already defined in the integration contract. It does not import Hub storage or mutate another module.

Feature flags default unfinished cloud sync and audio off. Provider diagnostics are enabled only when the local YouVersion key is configured.

## Logging policy

OSLog categories exist for app, Scripture, persistence, plans, Learning, and integration. Logs may contain error classes, counts, durations, and non-personal build state. Credentials, signed URLs, Scripture response bodies, profile details, reading history, annotations, notes, and Echo content are prohibited.

## Consequences

- Standalone and Hub modes reuse the same stateful feature shell.
- Deep links are parsed and validated in one place.
- Future UI tests can launch deterministic dependency combinations.
- Provider and private-data boundaries remain visible at the composition root.

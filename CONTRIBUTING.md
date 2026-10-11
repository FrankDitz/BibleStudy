# Git workflow

## Branches

Use the automation-friendly branch pattern `<type>/<work-item>-<short-description>` when an issue or ticket exists, and `<type>/<short-description>` when this repository has no work-item tracker.

Examples:

- `feature/BS-123-plan-scheduler`
- `feature/audio-player`
- `fix/BS-456-reader-restoration`
- `chore/sdk-upgrade`
- `docs/learning-sources`

Allowed types are `feature`, `fix`, `hotfix`, `chore`, `docs`, `refactor`, `test`, and `release`.

Rules:

- Use a lowercase type prefix, a forward slash, and a concise lowercase hyphenated description; preserve the tracker’s canonical work-item casing when present.
- Include a real work-item identifier when one exists; never invent one.
- Name the capability or correction being delivered, not its roadmap phase, sprint, date, author, or implementation agent.
- Keep the full name under 80 characters and use only ASCII letters, digits, `/`, and `-`.
- Reserve `main` for integrated, verified work and `release/<version>` for actual release stabilization.

Valid names include `feature/scripture-provider-adapter`, `fix/plan-timezone-rollover`, and `docs/provider-rights`. Names such as `feature.phase-zero-reader`, `feature/phase-one-reader`, `frank/reader`, and `feature/october-work` are invalid because they encode workflow context or ownership rather than a durable change purpose.

## Commits

Use Conventional Commits with an optional scope:

```text
feat(reader): add YouVersion-backed Bible shell
fix(plans): preserve completion across timezone changes
docs(roadmap): lock personal-use provider strategy
```

Keep each commit focused, buildable, and free of credentials. Never commit `Config/Secrets.xcconfig` or provider tokens.

## Pull requests

- Use a concise outcome-based title.
- Include verification performed and any unverified behavior.
- Call out schema, provider-license, privacy, or Catholic-content implications.
- Do not merge a change that weakens attribution, provider boundaries, or private-data handling.

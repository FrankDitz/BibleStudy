# Git workflow

## Branches

Use the enterprise branch pattern `<type>.<short-kebab-description>`.

Examples:

- `feature.plan-scheduler`
- `feature.audio-player`
- `fix.reader-restoration`
- `chore.sdk-upgrade`
- `docs.learning-sources`

Allowed types are `feature`, `fix`, `hotfix`, `chore`, `docs`, `refactor`, `test`, and `release`.

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

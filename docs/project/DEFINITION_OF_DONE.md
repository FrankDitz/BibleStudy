# Definition of Done

A change is done only when every applicable item below is satisfied. “Not applicable” must be stated with a reason in the change review; silence is not a waiver.

## Product and behavior

- Acceptance criteria are met on the supported iPhone and Mac targets.
- Loading, empty, offline, provider-denied, stale, and error behavior is intentional where applicable.
- The change does not quietly expand owner-only distribution scope.
- Any deferred behavior is recorded in the backlog rather than hidden in comments or optimistic UI.

## Architecture and data

- Feature code respects module/provider boundaries and uses app-owned canonical IDs and models.
- Persistent changes include schema versioning, migration/rollback reasoning, and fixtures for old data.
- Sync and date-sensitive behavior defines conflict, timezone, DST, leap-year, and retry semantics as applicable.
- Hub/Echo events use the versioned allowlisted contract and contain no private note, journal, or Scripture cache content.

## Verification

- New logic has focused unit/contract tests, including failure and boundary cases.
- Existing macOS tests pass; the iOS Simulator target builds.
- Relevant integration/UI/manual checks are recorded with device/OS and any unverified behavior.
- No compiler warning, failing check, known crash, or flaky test is introduced.
- Performance budgets in the roadmap are measured for performance-sensitive work.

## Accessibility and design

- VoiceOver order/labels/state, Dynamic Type through accessibility sizes, contrast, and non-color state cues pass.
- Mac keyboard/focus and pointer behavior pass where relevant.
- Reduce Motion and audio accessibility behavior are respected.
- Light/dark/reader themes and representative iPhone/Mac sizes are checked.

## Privacy and security

- Credentials, signed URLs, personal account identifiers, private correspondence, and license files are absent from Git.
- Logs and diagnostics avoid Scripture payloads, notes, reflections, profile secrets, and credentials.
- Network data is minimized and sent only to the selected provider for the requested operation.
- Export, deletion, retention, and revocation effects are defined for new user data.
- A secret scan and diff review show no accidental sensitive material.

## Scripture, provider, and rights changes

- Exact provider/edition IDs and account entitlements are verified rather than inferred from a public catalog.
- Catholic coverage includes Esther additions, Daniel additions, and deuterocanonical books where completeness is claimed.
- Required attribution is visible and the feature fails closed if it cannot be produced.
- Cache, download, share, derivative, audio, expiry, rate-limit, and revocation behavior matches the exact license/capability record.
- Provider response fixtures and typed authentication, authorization, offline, expiry, empty, malformed, and rate-limit states are covered.
- Any terms/license or distribution-impacting change updates the rights matrix and receives owner review.

## Catholic Learning changes

- Every material claim has a current primary-source pinpoint citation and visible jurisdiction/tradition scope.
- A qualified Catholic reviewer has approved theology, liturgy, terminology, and pastoral framing.
- Rights for quotations, prayers, Scripture, images, and calendars are recorded.
- Freshness/review dates and correction history are present.
- The content does not impersonate clergy, judge culpability, certify sacramental readiness, or replace parish guidance.

## Documentation and delivery

- User/developer documentation and the backlog/risk register are updated when behavior or assumptions change.
- Branch name follows `<type>.<short-kebab-description>` and commits use Conventional Commits.
- The diff is focused, reviewed, buildable, and merged only after checks pass.
- `main` is pushed and clean; the merged commit is traceable to its verification evidence.

## Phase exit rule

A phase is complete only when all of its roadmap exit criteria are evidenced in the repository or a non-secret owner/provider confirmation is recorded. A compiled harness is not evidence that an external license, live catalog, Catholic review, device behavior, or permission exists.

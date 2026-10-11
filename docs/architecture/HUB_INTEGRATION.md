# Hub Integration Contract

**Contract version:** 1  
**Status:** Implemented boundary; transport deferred  
**Last reviewed:** 2026-10-11

Bible Study will participate in Frank's private self-improvement hub without sharing persistence stores or importing another app. The executable contract is defined in `BibleStudy/Integration/BibleStudyHubContract.swift`.

## Contract rules

- Bible Study owns its reading, plan, learning, milestone, and preference data.
- Echo owns all journal entries and private journal text.
- The Hub may aggregate metadata but never edits a module's database directly.
- Contracts are `Codable`, transport-neutral, versioned, and additive where possible.
- Stable entities use UUIDs; timestamps encode as ISO 8601; JSON keys are sorted.
- Scripture locations use OSIS book identifiers and contain no provider Bible ID.
- Creating an event or reflection request does not publish, send, or persist it.
- A transport is chosen only when the real Hub exists and can define delivery semantics.

## Profile projection

`BibleStudyProfileContext` is the maximum profile surface accepted from the Hub:

- stable profile UUID;
- optional preferred name for local greetings;
- locale and time-zone identifiers; and
- Catholic jurisdiction: country, optional civil subdivision, and optional diocese name.

It deliberately excludes email, contacts, birthday, credentials, health data, and journal content. Bible Study preferences remain owned by Bible Study.

## Virtue taxonomy

Identifiers are namespaced so similarly named virtues remain unambiguous.

The seven Christian/heavenly virtues are chastity, temperance, charity, diligence, patience, kindness, and humility. The four cardinal virtues are prudence, justice, fortitude, and temperance. Therefore `christian.temperance` and `cardinal.temperance` are distinct identifiers even when the UI later explains their relationship.

Unknown identifiers must be retained or ignored safely by consumers rather than causing an event-decoding failure.

## Events emitted to the Hub

Initial event types are:

- `bible-study.reading.progress-updated`
- `bible-study.plan.assignment-completed`
- `bible-study.learning.item-completed`
- `bible-study.milestone.earned`

The envelope follows Echo's conventions: event UUID, schema version, source app, extensible string event type, timestamp, entity UUID, and typed payload. Payloads may contain a canonical Scripture reference, plan UUID, learning item ID, milestone ID, and virtue identifiers.

Events never contain notes, highlights, annotation text, complete reading history, learning article bodies, or journal text. They describe a change; they do not grant a consumer permission to copy private content.

## Echo reflection handoff

`BibleStudyEchoReflectionRequest` is created only after the owner invokes **Reflect in Echo**. It may contain:

- the prompt visible to the owner;
- a canonical Scripture reference;
- a related plan or learning identifier; and
- selected virtue identifiers.

It never contains a pre-existing journal entry, private Scripture note, annotation, or full provider passage. Echo creates and owns the resulting entry. Any future return path sends only an entry identifier and completion metadata unless Echo's own purpose-specific permission model explicitly allows more.

## Compatibility and failure behavior

- Version 1 consumers ignore unknown JSON keys and unknown event-type strings.
- New optional fields and event types are additive. Renames, removals, or semantic changes require a new schema version.
- Unsupported major versions fail closed and leave local module data untouched.
- Duplicate event UUIDs are idempotent at the future consumer.
- Delivery failure never rolls back a completed local reading or plan action.

## Deferred choices

No event bus, URL scheme registration, app group, CloudKit container, network service, or cross-process transport is selected in Phase 0. Those choices require the actual Hub repository and threat model. The contract stays usable for in-process injection, local fixtures, or a later durable transport.

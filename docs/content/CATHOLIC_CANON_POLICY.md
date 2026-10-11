# Catholic Canon and Naming Policy

**Status:** Accepted  
**Manifest version:** 1  
**Last reviewed:** 2026-10-11

## Authority and scope

The app's canonical order follows the United States Conference of Catholic Bishops [Books of the Bible](https://bible.usccb.org/bible?orderby=0): 46 Old Testament books followed by 27 New Testament books. The executable manifest is `BibleStudy/Domain/Scripture/CatholicCanon.swift`.

This manifest defines application identity and ordering. It does not grant permission to display any translation and does not replace provider-specific content verification.

## Identity rules

- Each book has a stable, provider-neutral, uppercase OSIS-style identifier.
- IDs and order values are unique; order is contiguous from 1 through 73.
- Display names use contemporary USCCB English naming: for example, **Song of Songs**, **Acts of the Apostles**, and **Revelation**.
- UI localization changes display strings, never persistent identifiers.
- Provider identifiers are mapped at the adapter boundary and are never stored as canonical book identity.
- Search aliases and abbreviations may be additive, but they resolve to a canonical identifier before persistence or routing.

## Canonical order

The Old Testament sections are Pentateuch; Historical Books; Biblical Novellas; Wisdom Books; and Prophetic Books. The New Testament sections are Gospels; Acts; Pauline Letters (including Hebrews for navigation); Catholic Letters; and Revelation.

The seven separately named deuterocanonical books are Tobit, Judith, 1 Maccabees, 2 Maccabees, Wisdom, Sirach, and Baruch. They are flagged in the manifest so a 66-book edition can never silently pass Catholic coverage checks.

## Esther and Daniel rule

A 73-book count is necessary but not sufficient. A Catholic edition must also include the deuterocanonical portions incorporated into Esther and Daniel. Providers can number and arrange those passages differently, so the app will not hard-code a universal chapter-count test for them.

Before an edition is approved, the live provider audit must verify:

- Catholic Esther content is present, including the Greek additions represented by that edition;
- Daniel includes the Prayer of Azariah/Song of the Three, Susanna, and Bel and the Dragon; and
- the provider's reference mapping can open these portions without silently redirecting to a shorter canon.

The audit result is recorded per exact provider edition and provider Bible ID in the rights matrix.

## Psalms and numbering

Canonical identity is **Psalms** (`PS`). Verse and psalm numbering follow the selected edition's supplied text and attribution. The UI must not silently renumber between Hebrew/Masoretic and Greek/Vulgate traditions. If alternate numbering is presented, it must be labeled and mapped explicitly.

## Validation gates

An edition may be shown as a complete Catholic Bible only when all of these pass:

1. The provider license is accepted for the exact edition.
2. All 73 manifest books map to provider resources without assuming a one-to-one count; for example, YouVersion currently represents Catholic Esther with both `EST` and `ESG`.
3. Catholic Esther and Daniel content passes the content-level audit.
4. Chapter navigation, canonical references, attribution, and plan links are spot-checked.
5. Any provider-specific naming differences are mapped without changing stored canonical IDs.

An edition that fails a gate may be hidden or accurately labeled as partial; it must never be presented as a complete Catholic Bible.

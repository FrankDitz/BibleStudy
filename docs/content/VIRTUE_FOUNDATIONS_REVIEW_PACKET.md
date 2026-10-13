# Virtue Foundations Catholic Review Packet

**Deliverable:** BS-0452  
**Content version:** 1  
**Prepared:** 2026-10-13  
**Current state:** Source-checked draft; qualified Catholic review pending

## Review decision required

The app deliberately fails closed: these pathways may be inspected, but they are not marked
`approved` until a qualified Catholic reviewer records a role, review date, and future review-by
date. Code generation, source checking, and automated tests are not substitutes for that review.

A reviewer should assess each pathway for:

1. Fidelity to the cited Catechism paragraphs and the broader Catholic moral tradition.
2. Responsible use of Scripture in context rather than as isolated proof texts.
3. Clear distinctions between a virtue and common distortions of it.
4. Practices that are concrete, proportionate, and suitable for continuing formation.
5. Pastoral boundaries around abuse, trauma, illness, disability, addiction, eating disorders,
   compulsive behavior, overwork, and scrupulosity.
6. Language that invites grace, freedom, repentance, and growth without shame, scoring, ranking,
   diagnosis, or claims of spiritual mastery.

## Pathway inventory

Each pathway contains a definition and Catholic relationship, two “what it is not” boundaries,
three Scripture encounters, three practices, three examen prompts, a short prayer, pastoral
guardrails, and direct links to the sources below.

| Pathway | Primary Catechism anchors | Scripture encounters |
| --- | --- | --- |
| Chastity | CCC 2337–2350; 1803–1811 | Matthew 5:8; 1 Corinthians 6:18–20; 1 Thessalonians 4:3–8 |
| Temperance | CCC 1803–1811; 1830–1832 | Galatians 5:22–25; 1 Corinthians 9:24–27; Sirach 18:30–33 |
| Charity | CCC 1812–1829; 1803–1811 | Matthew 22:37–40; 1 Corinthians 13; John 13:34–35 |
| Diligence | CCC 1803–1811; 2427–2428 | Colossians 3:23–24; Proverbs 6:6–11; Matthew 25:14–30 |
| Patience | CCC 1830–1832; 1812–1829 | James 5:7–11; Romans 12:12; Ephesians 4:1–3 |
| Kindness | CCC 1830–1832; 1812–1829 | Ephesians 4:29–32; Luke 6:27–36; Colossians 3:12–14 |
| Humility | CCC 1803–1811; 2559–2561 | Philippians 2:3–11; Luke 14:7–11; 1 Peter 5:5–7 |

## Official sources checked

- [Catechism — The Human Virtues](https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/i_the_human_virtues.html), CCC 1803–1811
- [Catechism — The Theological Virtues](https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/ii_the_theological_virtues.html), CCC 1812–1829
- [Catechism — Gifts and Fruits of the Holy Spirit](https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/iii_the_gifts_and_fruits_of_the_holy_spirit.html), CCC 1830–1832
- [Catechism — The Vocation to Chastity](https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_6/ii_the_vocation_to_chastity.html), CCC 2337–2350
- [Catechism — Economic Activity and Social Justice](https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_7/iv_economic_activity_and_social_justice.index.html), CCC 2427–2428
- [Catechism — Prayer as God's Gift](https://www.vatican.va/content/catechism/en/part_four/section_one/chapter_one/article_1/i_prayer_as_gods_gift.html), CCC 2559–2561

## Recording approval

Approval requires all of the following in the pathway's `VirtueContentReview`:

- `state: .approved`
- a nonempty reviewer role
- the actual review date
- a future review-by date

Any missing, expired, or superseded record keeps the pathway out of approved state. Requested
changes should increment `contentVersion`, return the record to `inReview`, and receive a new
review rather than reusing a previous approval.

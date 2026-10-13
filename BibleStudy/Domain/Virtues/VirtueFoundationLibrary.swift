import Foundation

enum VirtueFoundationLibrary {
    static let pathways: [VirtueFormationPathway] = [
        chastity,
        temperance,
        charity,
        diligence,
        patience,
        kindness,
        humility,
    ]

    static func pathway(for id: VirtueIdentifier) -> VirtueFormationPathway? {
        pathways.first { $0.id == id }
    }

    private static let checkedAt = Date(
        timeIntervalSince1970: 1_760_335_200
    )  // 2025-10-13T12:00:00Z

    private static let humanVirtues = source(
        id: "ccc-human-virtues",
        title: "Catechism of the Catholic Church — The Human Virtues",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/i_the_human_virtues.html",
        locator: "CCC 1803–1811"
    )

    private static let theologicalVirtues = source(
        id: "ccc-theological-virtues",
        title: "Catechism of the Catholic Church — The Theological Virtues",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/ii_the_theological_virtues.html",
        locator: "CCC 1812–1829"
    )

    private static let fruitsOfTheSpirit = source(
        id: "ccc-fruits-spirit",
        title: "Catechism of the Catholic Church — Gifts and Fruits of the Holy Spirit",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/iii_the_gifts_and_fruits_of_the_holy_spirit.html",
        locator: "CCC 1830–1832"
    )

    static let chastity = pathway(
        id: .chastity,
        title: "Chastity",
        summary: "Receive sexuality as a gift and grow in integrity, freedom, and reverence for every person.",
        catholicRelationship:
            "Catholic teaching places chastity under temperance and calls every baptized person to live it according to his or her state of life. It concerns the unity of the whole person, not merely a list of prohibitions.",
        teaching:
            "Chastity integrates body, affection, desire, and vocation so love can become truthful self-gift. It grows through prayer, honest self-knowledge, wise boundaries, friendship, the sacraments, and renewed choices over a lifetime.",
        whatItIsNot: [
            "It is not disgust toward the body, sexuality, marriage, or affection.",
            "It is not instant perfection, secrecy, or a reason to treat another person as a problem.",
        ],
        sources: [
            source(
                id: "ccc-vocation-chastity",
                title: "Catechism of the Catholic Church — The Vocation to Chastity",
                url:
                    "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_6/ii_the_vocation_to_chastity.html",
                locator: "CCC 2337–2350"
            ),
            humanVirtues,
        ],
        scripture: [
            encounter(
                "chastity-pure-heart", "Purity of heart", "Jesus joins purity of heart to seeing God.", "MATT", 5, 8, 8),
            encounter(
                "chastity-honor-body", "Honor God in the body", "Paul grounds bodily integrity in belonging to Christ.",
                "1COR", 6, 18, 20),
            encounter(
                "chastity-holiness", "A call to holiness",
                "Receive self-control as part of learning to love in holiness and honor.", "1THESS", 4, 3, 8),
        ],
        practices: [
            practice(
                "chastity-person-not-object", "See the whole person",
                "When attraction arises, name one God-given dignity, responsibility, or good in that person beyond appearance.",
                [.relationships, .digitalLife], .small, 2),
            practice(
                "chastity-digital-boundary", "Choose one digital boundary",
                "Remove or limit one source that trains you to consume people rather than love them.", [.digitalLife],
                .ordinary, 10),
            practice(
                "chastity-pray-honestly", "Bring desire to prayer",
                "Speak honestly to God about one desire and ask for freedom to love truthfully.",
                [.prayer, .difficultSeason], .small, 5),
        ],
        examen: [
            "Where did I recognize another person's full dignity today?",
            "When did desire become possessive, avoidant, or dishonest?",
            "What boundary or friendship would help me love with greater freedom?",
        ],
        prayer:
            "Jesus, make my heart undivided. Teach me to receive my body and every person as your gift, and give me freedom to love truthfully.",
        boundaries: [
            "This pathway is formation, not treatment for trauma, compulsive behavior, or abuse; seek qualified pastoral and clinical care when needed.",
            "A setback is an invitation to truth, mercy, reconciliation, and renewed practice—not shame or self-hatred.",
        ]
    )

    static let temperance = pathway(
        id: .temperance,
        title: "Temperance",
        summary:
            "Enjoy created goods with gratitude while keeping desire free, balanced, and ordered toward what is truly good.",
        catholicRelationship:
            "Temperance is one of the four cardinal virtues. It moderates attraction to pleasure and brings balance to the use of created goods so desire can serve reason, faith, and love.",
        teaching:
            "Temperance does not erase appetite. It trains freedom: receiving enough with gratitude, declining excess, and choosing the right measure for food, drink, entertainment, spending, technology, rest, and other goods.",
        whatItIsNot: [
            "It is not contempt for pleasure, celebration, food, rest, or material creation.",
            "It is not rigid control, comparison, or earning worth through deprivation.",
        ],
        sources: [humanVirtues, fruitsOfTheSpirit],
        scripture: [
            encounter(
                "temperance-spirit", "Walk by the Spirit",
                "Paul contrasts slavery to impulse with the Spirit's fruit, including self-control.", "GAL", 5, 22, 25),
            encounter(
                "temperance-training", "Train for what lasts",
                "Paul uses disciplined training to point desire toward an enduring good.", "1COR", 9, 24, 27),
            encounter(
                "temperance-desire", "Do not follow every desire",
                "Sirach offers practical wisdom about appetite and self-command.", "SIR", 18, 30, 33),
        ],
        practices: [
            practice(
                "temperance-pause", "Practice the free pause",
                "Before one habitual pleasure, pause, give thanks, and decide freely whether and how much to receive.",
                [.healthAndAppetite, .digitalLife], .small, 2),
            practice(
                "temperance-enough", "Choose enough",
                "Set a reasonable limit for one good today and stop when you reach it without condemning the good itself.",
                [.healthAndAppetite, .digitalLife], .ordinary, 10),
            practice(
                "temperance-reorder", "Make room for a greater good",
                "Trade fifteen minutes of passive consumption for prayer, relationship, useful work, or restorative rest.",
                [.digitalLife, .prayer, .relationships], .ordinary, 15),
        ],
        examen: [
            "Where did I enjoy a good gift with gratitude and freedom?",
            "What appetite made it harder to choose the greater good?",
            "What humane limit would help tomorrow without becoming rigid?",
        ],
        prayer:
            "Holy Spirit, order my desires without hardening my heart. Teach me gratitude, wise measure, and freedom for the greater good.",
        boundaries: [
            "Food, substance, or behavioral concerns may require professional care; this pathway is not a diagnosis or treatment plan.",
            "Temperance protects human flourishing and must never become punishment, dangerous restriction, or contempt for the body.",
        ]
    )

    static let charity = pathway(
        id: .charity,
        title: "Charity",
        summary: "Receive God's love and make it concrete in love of neighbor, especially when love is costly.",
        catholicRelationship:
            "Charity is the theological virtue by which Christians love God above all and their neighbor for God's sake. It animates and orders the practice of every other virtue.",
        teaching:
            "Christian charity begins in God's initiative, not personal niceness. It seeks the true good of the beloved through worship, mercy, truth, forgiveness, justice, service, and love of those who cannot repay us.",
        whatItIsNot: [
            "It is not mere sentiment, people-pleasing, or avoiding truthful boundaries.",
            "It is not rescuing others to feel superior or ignoring justice in the name of being nice.",
        ],
        sources: [theologicalVirtues, humanVirtues],
        scripture: [
            encounter(
                "charity-great-commandment", "The greatest commandments",
                "Jesus binds love of God and love of neighbor together.", "MATT", 22, 37, 40),
            encounter(
                "charity-way", "The way of love", "Paul describes love through patient, truthful, enduring action.",
                "1COR", 13, 1, 13),
            encounter(
                "charity-new-commandment", "Love as Jesus loves",
                "Jesus makes self-giving love the mark of discipleship.", "JOHN", 13, 34, 35),
        ],
        practices: [
            practice(
                "charity-hidden-service", "Offer hidden service",
                "Do one useful act for another person without seeking notice or repayment.",
                [.family, .work, .serviceAndCommunity], .ordinary, 15),
            practice(
                "charity-neighbor-prayer", "Pray for a difficult neighbor",
                "Name a person you struggle to love and ask sincerely for that person's true good.",
                [.prayer, .relationships], .small, 5),
            practice(
                "charity-attentive-presence", "Give undivided attention",
                "Listen to one person without planning your response or reaching for a device.",
                [.relationships, .family], .ordinary, 10),
        ],
        examen: [
            "Where did I receive or give love as a gift today?",
            "Whose true good was difficult for me to seek?",
            "Did my love include both mercy and truth?",
        ],
        prayer:
            "God of love, let the charity you pour into my heart become patient, truthful, and concrete for the neighbor before me.",
        boundaries: [
            "Charity does not require remaining in danger, enabling harm, or abandoning appropriate boundaries and justice.",
            "Service is not a measure of personal worth; receive rest, help, and the love of others as gifts too.",
        ]
    )

    static let diligence = pathway(
        id: .diligence,
        title: "Diligence",
        summary: "Give faithful, attentive effort to the duties and worthy commitments entrusted to you.",
        catholicRelationship:
            "Diligence gathers perseverance, responsibility, and care around the good of one's vocation. Catholic teaching honors work while insisting that work serves the person and the human community.",
        teaching:
            "Diligence is faithful attention, not frantic output. It helps us begin necessary work, sustain reasonable effort, repair neglect, and finish what love and duty require while respecting worship, rest, health, and relationships.",
        whatItIsNot: [
            "It is not productivity as identity, constant availability, or contempt for limits.",
            "It is not perfectionism or doing every possible task instead of the duties actually entrusted to you.",
        ],
        sources: [
            humanVirtues,
            source(
                id: "ccc-work",
                title: "Catechism of the Catholic Church — Economic Activity and Social Justice",
                url:
                    "https://www.vatican.va/content/catechism/en/part_three/section_two/chapter_two/article_7/iv_economic_activity_and_social_justice.index.html",
                locator: "CCC 2427–2428"
            ),
        ],
        scripture: [
            encounter(
                "diligence-wholehearted", "Work wholeheartedly",
                "Paul places ordinary work within service to the Lord.", "COL", 3, 23, 24),
            encounter(
                "diligence-ant", "Learn faithful preparation",
                "Proverbs uses the ant to expose avoidable neglect and encourage timely action.", "PROV", 6, 6, 11),
            encounter(
                "diligence-talents", "Be faithful with what is entrusted",
                "Jesus' parable asks disciples to steward gifts rather than bury them in fear.", "MATT", 25, 14, 30),
        ],
        practices: [
            practice(
                "diligence-next-duty", "Do the next faithful duty",
                "Name the most necessary unfinished duty and give it one uninterrupted work period.", [.work, .family],
                .ordinary, 25),
            practice(
                "diligence-small-start", "Begin for five minutes",
                "When resistance is high, start the worthy task for five honest minutes before deciding what follows.",
                [.work, .difficultSeason], .small, 5),
            practice(
                "diligence-close-loop", "Close one loop",
                "Finish, schedule, delegate, or consciously decline one open commitment.", [.work, .family], .ordinary,
                15),
        ],
        examen: [
            "What entrusted duty received faithful attention today?",
            "Where did fear, distraction, or perfectionism delay the good?",
            "Did I protect the rest and relationships that make work humane?",
        ],
        prayer:
            "Lord Jesus, bless the work entrusted to me. Give me a willing beginning, faithful attention, and the humility to honor human limits.",
        boundaries: [
            "Diligence must not validate overwork, unsafe conditions, exploitation, or neglect of worship, health, family, and rest.",
            "Reduced capacity during illness, grief, disability, or crisis is not a moral failure; choose a faithful practice suited to reality.",
        ]
    )

    static let patience = pathway(
        id: .patience,
        title: "Patience",
        summary: "Remain faithful and peaceable through delay, difficulty, weakness, and the slow work of growth.",
        catholicRelationship:
            "Patience is named among the fruits of the Holy Spirit and gives endurance to charity. It helps a person bear trials and another person's limitations without surrendering truth or hope.",
        teaching:
            "Patience creates room between difficulty and reaction. It waits without abandoning the good, endures without becoming passive, and trusts that people and holy work often grow slowly through grace and repeated choices.",
        whatItIsNot: [
            "It is not passivity toward injustice, danger, abuse, or responsibilities that require action.",
            "It is not suppressing anger until it becomes resentment or pretending pain does not matter.",
        ],
        sources: [fruitsOfTheSpirit, theologicalVirtues],
        scripture: [
            encounter(
                "patience-farmer", "Wait with steady hope", "James points to the farmer's active, expectant waiting.",
                "JAS", 5, 7, 11),
            encounter(
                "patience-tribulation", "Persevere in prayer",
                "Paul joins hope, endurance in affliction, and faithfulness in prayer.", "ROM", 12, 12, 12),
            encounter(
                "patience-bearing", "Bear with one another in love",
                "Patience protects unity through humility, gentleness, and love.", "EPH", 4, 1, 3),
        ],
        practices: [
            practice(
                "patience-one-breath", "Take one prayerful breath",
                "Before responding to a delay or irritation, breathe once and ask, ‘What does love require now?’",
                [.speechAndConflict, .difficultSeason], .small, 1),
            practice(
                "patience-slower-person", "Honor another person's pace",
                "Give one person time to finish speaking, learning, or deciding without taking over.",
                [.relationships, .family, .work], .ordinary, 10),
            practice(
                "patience-faithful-wait", "Choose faithful waiting",
                "For one unresolved concern, name the action that is yours today and release what is not yours.",
                [.prayer, .difficultSeason], .ordinary, 10),
        ],
        examen: [
            "Where did I make room for another person or for slow growth?",
            "When did delay turn into anger, control, or discouragement?",
            "What action is mine now, and what must I entrust to God?",
        ],
        prayer:
            "Patient God, steady me in delay and difficulty. Show me when to wait, when to act, and how to remain loving in both.",
        boundaries: [
            "Patience never requires tolerating abuse, concealing harm, or delaying urgent help.",
            "Strong anger can reveal a real wrong; bring it to prayer and wise action rather than denying or weaponizing it.",
        ]
    )

    static let kindness = pathway(
        id: .kindness,
        title: "Kindness",
        summary: "Make charity tangible through attentive, gentle, generous words and actions.",
        catholicRelationship:
            "Kindness is a fruit of the Holy Spirit and a concrete expression of charity. It honors another person's dignity through mercy, truthful speech, hospitality, generosity, and practical care.",
        teaching:
            "Kindness notices the person close at hand and chooses a good that can actually be received. It can be warm or firm, quiet or courageous. Its measure is the neighbor's true good, not the giver's image.",
        whatItIsNot: [
            "It is not flattery, conflict avoidance, or saying yes to every request.",
            "It is not performative niceness, superiority, or help that ignores what the other person truly needs.",
        ],
        sources: [fruitsOfTheSpirit, theologicalVirtues],
        scripture: [
            encounter(
                "kindness-speech", "Words that give grace",
                "Paul contrasts corrosive speech with words and actions that build up.", "EPH", 4, 29, 32),
            encounter(
                "kindness-enemies", "Mercy beyond reciprocity",
                "Jesus calls disciples to do good without limiting love to those who repay it.", "LUKE", 6, 27, 36),
            encounter(
                "kindness-clothe", "Put on kindness",
                "Paul places kindness with compassion, humility, patience, forgiveness, and love.", "COL", 3, 12, 14),
        ],
        practices: [
            practice(
                "kindness-specific-encouragement", "Offer specific encouragement",
                "Tell one person the particular good you have seen in an action, effort, or character.",
                [.relationships, .work, .family], .small, 3),
            practice(
                "kindness-practical-care", "Meet one concrete need",
                "Notice and complete one helpful act that makes another person's day lighter.",
                [.family, .work, .serviceAndCommunity], .ordinary, 15),
            practice(
                "kindness-repair-speech", "Repair one word",
                "If your words harmed or dismissed someone, apologize plainly and try the truthful sentence again.",
                [.speechAndConflict, .relationships], .demanding, 10),
        ],
        examen: [
            "Who became more visible to me today?",
            "Did my words give grace, tell truth, or cause avoidable harm?",
            "Where would a boundary be kinder than reluctant agreement?",
        ],
        prayer:
            "Holy Spirit, make me attentive to the person before me. Let my words and actions carry truth, gentleness, and practical care.",
        boundaries: [
            "Kindness includes truthful boundaries and does not demand access, agreement, or reconciliation without safety and repair.",
            "Do not take over another person's agency; ask what help is welcome when the need is not clear.",
        ]
    )

    static let humility = pathway(
        id: .humility,
        title: "Humility",
        summary:
            "Live truthfully before God: dependent on grace, honest about gifts and limits, and ready to serve and learn.",
        catholicRelationship:
            "Humility is the foundation of prayer because it receives life and grace as gifts. It frees a person from both self-exaltation and false self-contempt to stand truthfully before God and neighbor.",
        teaching:
            "Humility neither inflates nor erases the self. It names gifts without claiming authorship, admits fault without despair, receives correction, asks for help, and uses entrusted strength in service rather than status.",
        whatItIsNot: [
            "It is not humiliation, self-hatred, denying gifts, or accepting degrading treatment.",
            "It is not weakness, silence in the face of wrong, or pretending every opinion is equally sound.",
        ],
        sources: [
            humanVirtues,
            source(
                id: "ccc-prayer-gift",
                title: "Catechism of the Catholic Church — Prayer as God's Gift",
                url:
                    "https://www.vatican.va/content/catechism/en/part_four/section_one/chapter_one/article_1/i_prayer_as_gods_gift.html",
                locator: "CCC 2559–2561"
            ),
        ],
        scripture: [
            encounter(
                "humility-christ", "The mind of Christ",
                "Jesus' self-emptying service reveals humility joined to divine dignity.", "PHIL", 2, 3, 11),
            encounter(
                "humility-lower-place", "Do not grasp for honor",
                "Jesus teaches freedom from arranging life around status.", "LUKE", 14, 7, 11),
            encounter(
                "humility-care", "Entrust yourself to God",
                "Peter joins humility toward others with casting anxiety on the God who cares.", "1PET", 5, 5, 7),
        ],
        practices: [
            practice(
                "humility-credit", "Give truthful credit",
                "Name another person's contribution clearly and without inserting your own claim to recognition.",
                [.work, .relationships], .small, 3),
            practice(
                "humility-ask-help", "Ask for needed help",
                "Make one honest, specific request instead of hiding a real limit.",
                [.work, .family, .difficultSeason], .ordinary, 10),
            practice(
                "humility-receive-correction", "Receive before defending",
                "When offered fair correction, restate what you heard and consider it before explaining yourself.",
                [.speechAndConflict, .relationships], .demanding, 10),
        ],
        examen: [
            "Where did I receive a gift, limit, or correction truthfully today?",
            "When did I seek status, control, or invisibility instead of service?",
            "What grace or help do I need to receive rather than manufacture?",
        ],
        prayer:
            "Jesus, meek and humble of heart, keep me truthful about my gifts, limits, sins, and dependence. Make every gift fruitful in service.",
        boundaries: [
            "Humility never justifies humiliation, coercion, abuse, discrimination, or the erasure of God-given dignity.",
            "Naming competence, accepting responsibility, and speaking against wrong can be acts of humility when ordered to truth and service.",
        ]
    )

    private static func pathway(
        id: VirtueIdentifier,
        title: String,
        summary: String,
        catholicRelationship: String,
        teaching: String,
        whatItIsNot: [String],
        sources: [VirtueContentSource],
        scripture: [VirtueScriptureEncounter],
        practices: [VirtuePracticeDefinition],
        examen: [String],
        prayer: String,
        boundaries: [String]
    ) -> VirtueFormationPathway {
        VirtueFormationPathway(
            id: id,
            contentVersion: 1,
            title: title,
            summary: summary,
            catholicRelationship: catholicRelationship,
            teaching: teaching,
            whatItIsNot: whatItIsNot,
            sources: sources,
            scriptureEncounters: scripture,
            practices: practices,
            examenPrompts: examen.enumerated().map {
                VirtueExamenPrompt(id: "\(id.rawValue)-examen-\($0.offset + 1)", text: $0.element)
            },
            prayer: prayer,
            pastoralBoundaries: boundaries,
            review: VirtueContentReview(
                state: .inReview,
                reviewerRole: "Qualified Catholic reviewer pending",
                reviewedAt: nil,
                reviewBy: nil
            )
        )
    }

    private static func source(
        id: String,
        title: String,
        url: String,
        locator: String
    ) -> VirtueContentSource {
        VirtueContentSource(
            id: id,
            title: title,
            url: URL(string: url)!,
            locator: locator,
            sourceClass: .catechism,
            checkedAt: checkedAt
        )
    }

    private static func encounter(
        _ id: String,
        _ title: String,
        _ context: String,
        _ bookID: String,
        _ chapter: Int,
        _ verseStart: Int,
        _ verseEnd: Int
    ) -> VirtueScriptureEncounter {
        VirtueScriptureEncounter(
            id: id,
            title: title,
            context: context,
            reference: try! CanonicalScriptureReference(
                bookID: bookID,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd
            )
        )
    }

    private static func practice(
        _ id: String,
        _ title: String,
        _ instruction: String,
        _ contexts: Set<VirtuePracticeContext>,
        _ commitment: VirtuePracticeCommitment,
        _ estimatedMinutes: Int?
    ) -> VirtuePracticeDefinition {
        VirtuePracticeDefinition(
            id: id,
            title: title,
            instruction: instruction,
            contexts: contexts,
            commitment: commitment,
            estimatedMinutes: estimatedMinutes
        )
    }
}

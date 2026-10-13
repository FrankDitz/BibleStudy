import Foundation

enum VirtueStudyCatalog {
    static let foundationCourse = VirtueStudyCourse(
        id: "virtue-foundations",
        collection: .foundations,
        virtueID: nil,
        title: "How a Virtuous Life Grows",
        subtitle: "A six-lesson foundation before studying any one virtue",
        overview:
            "Learn what Catholics mean by virtue, why repeated free choices shape character, how the four cardinal virtues work together, and why Christian growth depends on grace rather than willpower alone.",
        whyItMatters:
            "Without this foundation, virtue can look like a checklist, a mood, or a contest in self-control. This course gives you a map for every course that follows.",
        systemImage: "building.columns",
        contentVersion: 1,
        lessons: foundationLessons,
        sources: foundationSources,
        review: draftReview
    )

    static let cardinalCourses: [VirtueStudyCourse] = [
        prudenceCourse,
        justiceCourse,
        fortitudeCourse,
        cardinalTemperanceCourse,
    ]

    static let christianCourses: [VirtueStudyCourse] =
        VirtueFoundationLibrary.pathways.compactMap(christianCourse)

    static let courses: [VirtueStudyCourse] =
        [foundationCourse] + cardinalCourses + christianCourses

    static func course(id: String) -> VirtueStudyCourse? {
        courses.first { $0.id == id }
    }

    static func course(for virtueID: VirtueIdentifier) -> VirtueStudyCourse? {
        courses.first { $0.virtueID == virtueID }
    }

    private static let checkedAt = Date(timeIntervalSince1970: 1_791_892_800)

    private static let draftReview = VirtueContentReview(
        state: .inReview,
        reviewerRole: "Qualified Catholic reviewer pending",
        reviewedAt: nil,
        reviewBy: nil
    )

    private static let rickaby = source(
        id: "rickaby-four-square",
        title: "Four-Square, or The Cardinal Virtues — Joseph Rickaby, S.J.",
        url: "https://archive.org/details/foursquare00rick",
        locator: "Complete work, especially chapters I–XII (1908)",
        sourceClass: .reviewedSecondary
    )

    private static let catechismHumanVirtues = source(
        id: "ccc-human-virtues-study",
        title: "Catechism of the Catholic Church — The Human Virtues",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/i_the_human_virtues.html",
        locator: "CCC 1803–1811",
        sourceClass: .catechism
    )

    private static let catechismTheologicalVirtues = source(
        id: "ccc-theological-virtues-study",
        title: "Catechism of the Catholic Church — The Theological Virtues",
        url:
            "https://www.vatican.va/content/catechism/en/part_three/section_one/chapter_one/article_7/ii_the_theological_virtues.index.html",
        locator: "CCC 1812–1829",
        sourceClass: .catechism
    )

    private static let wisdomEight = source(
        id: "usccb-wisdom-eight",
        title: "Wisdom 8 — United States Conference of Catholic Bishops",
        url: "https://bible.usccb.org/bible/wisdom/8",
        locator: "Wisdom 8:7 and study note",
        sourceClass: .scripture
    )

    private static let popeGrace = source(
        id: "pope-francis-grace-virtues",
        title: "Pope Francis — The Life of Grace According to the Spirit",
        url:
            "https://www.vatican.va/content/francesco/en/audiences/2024/documents/20240424-udienza-generale.html",
        locator: "General Audience, 24 April 2024",
        sourceClass: .universalChurch
    )

    private static let popePrudence = source(
        id: "pope-francis-prudence",
        title: "Pope Francis — Prudence",
        url:
            "https://www.vatican.va/content/francesco/en/audiences/2024/documents/20240320-udienza-generale.html",
        locator: "General Audience, 20 March 2024",
        sourceClass: .universalChurch
    )

    private static let popeJustice = source(
        id: "pope-francis-justice",
        title: "Pope Francis — Justice",
        url:
            "https://www.vatican.va/content/francesco/en/audiences/2024/documents/20240403-udienza-generale.html",
        locator: "General Audience, 3 April 2024",
        sourceClass: .universalChurch
    )

    private static let popeFortitude = source(
        id: "pope-francis-fortitude",
        title: "Pope Francis — Fortitude",
        url:
            "https://www.vatican.va/content/francesco/en/audiences/2024/documents/20240410-udienza-generale.html",
        locator: "General Audience, 10 April 2024",
        sourceClass: .universalChurch
    )

    private static let popeTemperance = source(
        id: "pope-francis-temperance",
        title: "Pope Francis — Temperance",
        url:
            "https://www.vatican.va/content/francesco/en/audiences/2024/documents/20240417-udienza-generale.html",
        locator: "General Audience, 17 April 2024",
        sourceClass: .universalChurch
    )

    private static let foundationSources = [
        rickaby,
        catechismHumanVirtues,
        catechismTheologicalVirtues,
        wisdomEight,
        popeGrace,
    ]

    private static let foundationLessons: [VirtueStudyLesson] = [
        lesson(
            "foundations-meaning",
            "What virtue really is",
            "Move beyond isolated good deeds to a stable readiness for the good.",
            9,
            [
                section(
                    "A firm disposition",
                    "The Catechism describes human virtues as stable perfections of intellect and will. A virtue is not merely knowing the right answer or performing one impressive act. It is a formed readiness to recognize and choose the good freely, with increasing steadiness and joy."
                ),
                section(
                    "A living skill",
                    "Rickaby compares virtue to a skill acquired through practice. The comparison is useful if we remember that moral action is personal and free: repeated choices do not turn a person into a machine. They shape character while leaving room for grace, effort, repentance, and renewed choice."
                ),
            ],
            [
                encounter(
                    "foundations-think-good", "Train attention toward the good",
                    "Paul asks believers to attend to what is true, honorable, just, pure, lovely, and worthy of praise.",
                    "PHIL", 4, 8, 9)
            ],
            [
                "Which good choice already comes more readily because you have practiced it?",
                "Where do you confuse admiring a virtue with possessing it?",
            ],
            [rickaby.id, catechismHumanVirtues.id]
        ),
        lesson(
            "foundations-habit",
            "How choices become character",
            "Understand repetition without reducing spiritual growth to self-optimization.",
            10,
            [
                section(
                    "Acts are both fruit and seed",
                    "A good act expresses the character already present and also strengthens the disposition to act well again. Small choices matter because a life is usually formed in ordinary decisions before it is tested in an extraordinary moment."
                ),
                section(
                    "Failure is not the end",
                    "Learning any demanding skill includes awkward beginnings and mistakes. Virtue grows through honest repentance, repair, and beginning again. The goal is not a flawless record but a person increasingly free for truth and love."
                ),
            ],
            [
                encounter(
                    "foundations-small-seed", "The mustard seed",
                    "Jesus uses a tiny seed to reveal how God brings surprising growth from small beginnings.", "MATT",
                    13, 31, 32)
            ],
            [
                "What ordinary choice is quietly forming you now?",
                "What would beginning again look like without shame or excuses?",
            ],
            [rickaby.id, catechismHumanVirtues.id]
        ),
        lesson(
            "foundations-freedom",
            "Freedom, feelings, and human acts",
            "Distinguish temptation and emotion from deliberate consent.",
            11,
            [
                section(
                    "Responsibility needs knowledge and freedom",
                    "Catholic moral formation takes freedom seriously. Feelings, intrusive thoughts, bodily reactions, and temptation are not identical with deliberate choices. A human act involves enough knowledge and freedom for the person to make the act his or her own."
                ),
                section(
                    "Formation prepares freedom",
                    "We cannot prevent every difficult feeling or surprise. We can shape the conditions around our choices: pray, seek counsel, avoid predictable occasions of harm, practice smaller acts of fidelity, and ask for help. This lesson should relieve scrupulosity, not create it."
                ),
            ],
            [
                encounter(
                    "foundations-temptation", "A faithful way through temptation",
                    "Paul teaches that temptation is human and that God provides a way to endure it.", "1COR", 10, 13,
                    13)
            ],
            [
                "What feeling have you mistaken for a moral verdict?",
                "What preparation would make tomorrow's good choice freer?",
            ],
            [rickaby.id, catechismHumanVirtues.id]
        ),
        lesson(
            "foundations-hinges",
            "The four hinges",
            "See prudence, justice, fortitude, and temperance as one living structure.",
            10,
            [
                section(
                    "Why they are cardinal",
                    "Cardinal comes from the Latin word for hinge. Prudence helps reason recognize the true good and choose fitting means. Justice steadies the will in giving God and neighbor their due. Fortitude supplies firmness when good is difficult. Temperance orders attraction to pleasure and created goods."
                ),
                section(
                    "They need one another",
                    "Courage without prudence can become rashness. Prudence without justice can become clever self-interest. Temperance without charity can become sterile control. The virtues are distinct, but a mature life brings them into harmony."
                ),
            ],
            [
                encounter(
                    "foundations-wisdom", "Wisdom teaches the four",
                    "Wisdom names moderation, prudence, righteousness, and fortitude together.", "WIS", 8, 7, 7)
            ],
            [
                "Which hinge is easiest for you to recognize in a real decision?",
                "Where would one virtue protect another from distortion?",
            ],
            [rickaby.id, catechismHumanVirtues.id, wisdomEight.id]
        ),
        lesson(
            "foundations-grace",
            "Human effort and divine grace",
            "Hold practice and dependence on God together.",
            10,
            [
                section(
                    "Practice is real",
                    "Education, deliberate acts, and perseverance cultivate human virtue. Christians should not use grace as an excuse to neglect practice, responsibility, repair, or the patient training of desire."
                ),
                section(
                    "Grace elevates and heals",
                    "Human effort is not self-salvation. The theological virtues—faith, hope, and charity—come from God and orient Christian life directly to him. Grace purifies and elevates human virtues, strengthens perseverance, and makes growth participation in divine love rather than a private achievement."
                ),
            ],
            [
                encounter(
                    "foundations-abide", "Fruit comes from abiding",
                    "Jesus joins fruitful action to dependence on him.", "JOHN", 15, 4, 5)
            ],
            [
                "Where are you tempted to rely only on willpower?",
                "Where are you tempted to ask for grace while refusing the next available act?",
            ],
            [rickaby.id, catechismHumanVirtues.id, catechismTheologicalVirtues.id, popeGrace.id]
        ),
        lesson(
            "foundations-christ",
            "The person at the center",
            "Let virtue become imitation of Christ rather than admiration of an abstraction.",
            9,
            [
                section(
                    "More than an ideal",
                    "Rickaby's closing insight is decisive: an abstract principle may inform the mind, but Christians are drawn by a person. Jesus reveals the good as a life of obedient love, courage, truth, mercy, self-mastery, and complete gift of self."
                ),
                section(
                    "A lifelong path",
                    "Completing lessons is only intellectual progress. Virtue continues through prayer, the sacraments, community, work, suffering, service, repentance, and countless ordinary acts. Course completion should therefore open into practice, never claim mastery."
                ),
            ],
            [
                encounter(
                    "foundations-follow", "Learn from Christ",
                    "Jesus invites disciples to learn his gentleness and humility of heart.", "MATT", 11, 28, 30)
            ],
            [
                "Which quality of Christ do you most desire to imitate?",
                "What is one concrete response to his invitation this week?",
            ],
            [rickaby.id, catechismHumanVirtues.id, catechismTheologicalVirtues.id]
        ),
    ]

    private static let prudenceCourse = cardinalCourse(
        id: "cardinal-prudence",
        virtueID: .prudence,
        title: "Prudence",
        subtitle: "See the true good and choose the right way toward it",
        overview:
            "Prudence is practical wisdom: reason attentive to reality, formed by truth, and ready to guide action. It is the virtue that gives moral knowledge its concrete next step.",
        whyItMatters:
            "Good intentions can still choose poor means. Prudence helps every other virtue meet the real person, duty, timing, risk, and circumstance before you.",
        systemImage: "eye.circle",
        popeSource: popePrudence,
        lessons: [
            cardinalLesson(
                "prudence-true-good", "The true good", "Prudence begins with the end worth seeking.",
                "Prudence is not timidity or endless caution. The Catechism calls it the virtue that disposes practical reason to discern our true good in every circumstance and choose the right means. It asks first what is genuinely good—not merely convenient, popular, or immediately pleasant.",
                "Rickaby describes prudence as right reason applied to action. It turns moral principles toward a particular decision without pretending that a rule can remove every need for judgment.",
                encounter(
                    "prudence-build", "Count the cost",
                    "Jesus uses the image of a builder who considers what a faithful undertaking requires.", "LUKE", 14,
                    28, 33),
                ["What good am I actually seeking?", "Have I confused avoiding discomfort with choosing wisely?"],
                popePrudence.id
            ),
            cardinalLesson(
                "prudence-reality", "Memory, docility, and counsel", "Wise action listens before it decides.",
                "Prudence learns from remembered experience, accurate attention, and people who understand what we do not. Docility is not gullibility; it is the humility to receive truth from experience, competent counsel, and prayer.",
                "Rickaby insists that serious decisions should not rely on private cleverness alone. Prayer and counsel widen the field of vision, especially in new situations, difficulty, or temptation.",
                encounter(
                    "prudence-counsel", "Plans need counsel",
                    "Proverbs joins sound plans to the willingness to receive advice.", "PROV", 15, 22, 22),
                ["Whose counsel is both wise and appropriately informed?", "What fact am I tempted to ignore?"],
                popePrudence.id
            ),
            cardinalLesson(
                "prudence-command", "Judgment that becomes action", "A decision must finally be carried out.",
                "Prudence gathers relevant truth, judges among fitting options, and then commands action. Hesitation can be wise while facts are missing, but chronic postponement can disguise fear or unwillingness.",
                "Pope Francis emphasizes that prudent action belongs to intelligence and freedom. It is creative and responsible, not passive obedience to an algorithm.",
                encounter(
                    "prudence-wise-builder", "Hear and act",
                    "Jesus calls the person who hears and acts wise, like a builder on rock.", "MATT", 7, 24, 27),
                [
                    "What decision already has enough light?",
                    "What is the smallest faithful action that makes the judgment real?",
                ],
                popePrudence.id
            ),
            cardinalLesson(
                "prudence-counterfeits", "Prudence and its counterfeits",
                "Separate wisdom from fear, calculation, and manipulation.",
                "Cowardice calls every risk imprudent. Rashness refuses counsel. Cunning finds efficient means toward a selfish or unjust end. Genuine prudence serves truth and the whole good of the person; it cannot be separated from justice, courage, or love.",
                "Because no one sees every circumstance clearly, prudent people remain teachable after acting. They examine results, repair harm, and let experience educate the next choice.",
                encounter(
                    "prudence-serpents-doves", "Wise and innocent", "Jesus pairs prudence with simplicity of heart.",
                    "MATT", 10, 16, 16),
                [
                    "Which counterfeit most often borrows the name of prudence in my life?",
                    "What would truth and charity add to my plan?",
                ],
                popePrudence.id
            ),
            applicationLesson(
                id: "prudence-practice",
                title: "A rule for discernment",
                opening:
                    "Bring one real decision through five movements: name the good, gather the facts, seek counsel and prayer, judge the fitting means, and act at the proper time.",
                scripture: encounter(
                    "prudence-path", "A lamp for the path", "God's word forms practical judgment one step at a time.",
                    "PS", 119, 105, 105),
                prompts: [
                    "Write the decision in one sentence.",
                    "Name the good, the people affected, the counsel needed, and the next faithful act.",
                ],
                sourceID: popePrudence.id
            ),
        ]
    )

    private static let justiceCourse = cardinalCourse(
        id: "cardinal-justice",
        virtueID: .justice,
        title: "Justice",
        subtitle: "Give God and neighbor what is due",
        overview:
            "Justice is the constant and firm will to give God and neighbor their due. It forms truthful relationships, protects dignity, repairs wrong, and turns private goodness toward the common good.",
        whyItMatters:
            "A spiritual life that ignores obligations, truthful speech, fair dealing, and repair is incomplete. Justice is the durable structure that lets love become trustworthy.",
        systemImage: "scalemass",
        popeSource: popeJustice,
        lessons: [
            cardinalLesson(
                "justice-due", "To each what is due", "Justice begins where another person's real claim begins.",
                "Justice resides in the steady will to recognize and honor what belongs to God and neighbor. It concerns more than courts: promises, wages, property, reputation, work, authority, truth, and ordinary respect all create moral claims.",
                "Rickaby calls justice the framework of social life. Pope Francis brings it to the smallest scale: truthful speech and honest daily relationships are already matters of justice.",
                encounter(
                    "justice-do-right", "Do justice, love goodness",
                    "Micah joins justice, faithful love, and humble life before God.", "MIC", 6, 8, 8),
                [
                    "Who has a legitimate claim on my time, work, honesty, or repair?",
                    "Which obligation have I renamed as an optional kindness?",
                ],
                popeJustice.id
            ),
            cardinalLesson(
                "justice-god-neighbor", "God, neighbor, and the common good",
                "Justice widens the circle of responsibility.",
                "Justice toward God is expressed in the virtue of religion: worship recognizes the Creator and our dependence on him. Justice toward neighbor honors each person's dignity. Social and distributive justice ask whether laws, institutions, rewards, burdens, and opportunities serve the common good rather than the strongest alone.",
                "Not every legal arrangement is automatically just, and legality does not exhaust goodness. Christian conscience remains accountable to truth, human dignity, and God's law.",
                encounter(
                    "justice-great-commandments", "Love of God and neighbor",
                    "Jesus refuses to separate devotion to God from responsibility for the neighbor.", "MATT", 22, 34,
                    40),
                ["How does worship reshape the way I treat people?", "Whose dignity is easiest for me to overlook?"],
                popeJustice.id
            ),
            cardinalLesson(
                "justice-truth-repair", "Truth, promises, and repair",
                "A wrong is not finished merely because it is regretted.",
                "Justice tells the truth, keeps valid promises, pays what is owed, protects reputation, and respects what belongs to another. When a person unjustly takes, damages, or withholds, repentance normally includes restitution or proportionate repair where possible.",
                "Repair is not self-punishment. It is the practical restoration of the neighbor's good and the re-establishment of truthful relationship.",
                encounter(
                    "justice-zacchaeus", "Repentance that repairs",
                    "Zacchaeus responds to Christ with concrete restitution and generosity.", "LUKE", 19, 1, 10),
                [
                    "Is there an apology, payment, correction, or returned responsibility still due?",
                    "What repair is possible without causing a new wrong?",
                ],
                popeJustice.id
            ),
            cardinalLesson(
                "justice-charity", "Justice and charity", "Love fulfills justice; it does not excuse injustice.",
                "Rickaby pictures justice as the skeleton and charity as the living flesh of society. The image keeps two truths together: charity often gives beyond what is owed, but generosity cannot compensate for refusing a person's rightful due.",
                "Charity can freely forgive a personal claim, seek reconciliation, and serve beyond obligation. It must not be used to silence victims, conceal harm, or avoid fair repair.",
                encounter(
                    "justice-love-fulfills", "Love fulfills the law",
                    "Paul teaches that genuine love does no evil to the neighbor.", "ROM", 13, 8, 10),
                [
                    "Where am I generous but not just?",
                    "Where can I go beyond strict obligation without enabling harm?",
                ],
                popeJustice.id
            ),
            applicationLesson(
                id: "justice-practice",
                title: "An examination of what is due",
                opening:
                    "Review one relationship or responsibility under four headings: truth to speak, promise to keep, good to protect, and wrong to repair.",
                scripture: encounter(
                    "justice-yes", "Let your yes mean yes", "Jesus calls for speech that can be trusted.", "MATT", 5,
                    33, 37),
                prompts: [
                    "Name one due obligation without exaggerating or minimizing it.",
                    "Choose one concrete act of truth, fulfillment, protection, or repair.",
                ],
                sourceID: popeJustice.id
            ),
        ]
    )

    private static let fortitudeCourse = cardinalCourse(
        id: "cardinal-fortitude",
        virtueID: .fortitude,
        title: "Fortitude",
        subtitle: "Remain firm in difficulty and constant in the good",
        overview:
            "Fortitude is courage governed by reason and love. It steadies a person against fear, restrains recklessness, and sustains faithful action through danger, resistance, suffering, and weariness.",
        whyItMatters:
            "Knowing the good does not make it easy. Fortitude carries prudent and just choices across the distance between conviction and costly action.",
        systemImage: "shield.lefthalf.filled",
        popeSource: popeFortitude,
        lessons: [
            cardinalLesson(
                "fortitude-fear", "Courage is not fearlessness", "Fortitude faces fear without surrendering judgment.",
                "The brave person can feel fear intensely. Fortitude does not erase emotion; it keeps fear from governing action when a serious good must be protected. It also restrains impulsive aggression, because unnecessary danger is not courage.",
                "Rickaby presents fortitude between cowardice and rashness. Pope Francis describes it as firmness in difficulty and constancy in pursuit of the good.",
                encounter(
                    "fortitude-fear-not", "God is with you",
                    "Joshua is called to courage rooted in God's faithful presence.", "JOSH", 1, 6, 9),
                [
                    "What fear is giving me useful information?",
                    "What part of that fear is trying to rule the decision?",
                ],
                popeFortitude.id
            ),
            cardinalLesson(
                "fortitude-motive", "The right cause and motive", "Difficulty alone does not make an act brave.",
                "An impressive risk may come from anger, vanity, pressure, intoxication, or disregard for life. Fortitude serves a proportionate good for a morally sound reason. Skill and preparation do not cheapen courage; they help courage act responsibly.",
                "Christian courage seeks fidelity rather than spectacle. It does not manufacture danger or confuse stubbornness with conscience.",
                encounter(
                    "fortitude-love", "Love lays down its life",
                    "Jesus places self-gift within love rather than thrill or self-display.", "JOHN", 15, 12, 13),
                [
                    "What good makes this difficulty worth facing?",
                    "Am I defending conscience or merely defending my pride?",
                ],
                popeFortitude.id
            ),
            cardinalLesson(
                "fortitude-endurance", "Endurance, patience, and perseverance",
                "Often the harder courage is to remain.",
                "Fortitude appears in bold action, but Rickaby stresses its quieter form: endurance. Patience bears present difficulty without becoming bitter; perseverance continues the good through repetition, delay, and disappointment.",
                "This is not passive acceptance of abuse or injustice. Fortitude may require seeking help, setting a boundary, leaving danger, reporting harm, or resisting publicly.",
                encounter(
                    "fortitude-endurance-scripture", "Endurance forms character",
                    "Paul traces a path through affliction, endurance, proven character, and hope.", "ROM", 5, 3, 5),
                [
                    "Is courage asking me to act, endure, seek help, or withdraw from danger?",
                    "What faithful good needs patient repetition?",
                ],
                popeFortitude.id
            ),
            cardinalLesson(
                "fortitude-grace", "Christian courage and grace", "Courage is strengthened by hope in Christ.",
                "Christian fortitude is not solitary toughness. Prayer, sacraments, community, sound counsel, and hope strengthen a person to resist evil and suffer for the good. The martyrs are the clearest witness, but daily courage also appears in truthfulness, mercy, recovery, vocation, and service.",
                "A person may need pastoral, medical, or psychological care while acting courageously. Receiving help can itself be an act of fortitude.",
                encounter(
                    "fortitude-power-love", "Power, love, and self-control",
                    "Paul contrasts cowardice with the Spirit's gifts of power, love, and self-control.", "2TIM", 1, 6,
                    8),
                [
                    "Which help have I resisted because I wanted courage to look self-sufficient?",
                    "Where can hope make courage patient?",
                ],
                popeFortitude.id
            ),
            applicationLesson(
                id: "fortitude-practice",
                title: "One courageous fidelity",
                opening:
                    "Choose one avoided good: a truthful conversation, a needed apology, a request for help, a protected boundary, or a duty that has become difficult.",
                scripture: encounter(
                    "fortitude-armor", "Stand firm",
                    "Paul's image of spiritual armor joins truth, justice, faith, peace, and perseverance.", "EPH", 6,
                    10, 18),
                prompts: [
                    "Name the good, the fear, and the support you need.",
                    "Take one proportionate step rather than demanding a dramatic victory.",
                ],
                sourceID: popeFortitude.id
            ),
        ]
    )

    private static let cardinalTemperanceCourse = cardinalCourse(
        id: "cardinal-temperance",
        virtueID: .cardinalTemperance,
        title: "Temperance",
        subtitle: "Order desire so created goods can be received in freedom",
        overview:
            "Temperance moderates attraction to pleasure and provides balance in the use of created goods. It is not hostility to desire but the freedom to enjoy, refuse, or limit a good according to reason, vocation, and love.",
        whyItMatters:
            "Unruled appetite narrows attention to the immediate. Temperance restores enough interior space to choose what is fitting and to delight more deeply in what truly matters.",
        systemImage: "dial.low",
        popeSource: popeTemperance,
        lessons: [
            cardinalLesson(
                "cardinal-temperance-measure", "The right measure",
                "Temperance seeks fitting order, not the smallest possible amount.",
                "The Catechism defines temperance as moderation of pleasure and balance in the use of created goods. The right measure varies with the person, good, responsibility, and circumstance. For some, freedom requires complete abstinence from a particular substance or behavior; for others, a grateful limit is fitting.",
                "Rickaby distinguishes command from counsel and warns against treating one discipline as the whole of virtue. A voluntary sacrifice can be generous, but it should remain ordered to a real good.",
                encounter(
                    "temperance-sober", "Live with self-control",
                    "Titus joins self-control to justice, devotion, and hope.", "TITUS", 2, 11, 14),
                [
                    "What is enough in this circumstance?",
                    "Does my chosen limit protect freedom, responsibility, and love?",
                ],
                popeTemperance.id
            ),
            cardinalLesson(
                "cardinal-temperance-desire", "Self-mastery, not repression",
                "Desire is educated rather than despised.",
                "Temperance does not call the body or pleasure evil. It helps the whole person direct desire toward the good. Over time, repeated free choices can make right order less strained and more joyful.",
                "Pope Francis describes temperance as power over oneself and the art of creating order within the human heart. This power is stewardship, not violence toward the self.",
                encounter(
                    "temperance-body", "Glorify God in the body", "Paul grounds bodily freedom in belonging to Christ.",
                    "1COR", 6, 12, 20),
                [
                    "Do I respond to desire with indulgence, fear, or wise attention?",
                    "What greater good is this appetite meant to serve?",
                ],
                popeTemperance.id
            ),
            cardinalLesson(
                "cardinal-temperance-domains", "Food, drink, sexuality, media, and more",
                "The same virtue serves many forms of desire.",
                "Temperance traditionally includes sobriety, abstinence, and chastity. Its logic also helps with spending, entertainment, technology, speech, and rest. Each area needs its own truthful judgment; one universal restriction cannot replace prudence.",
                "Compulsion, addiction, disordered eating, trauma, or other clinical concerns need qualified care. A spiritual course can support treatment and pastoral guidance but cannot replace them.",
                encounter(
                    "temperance-sirach", "Do not follow every appetite",
                    "Sirach teaches freedom from being led by every desire.", "SIR", 18, 30, 33),
                [
                    "Which appetite most reduces my freedom?",
                    "What professional, pastoral, or relational support belongs in the plan?",
                ],
                popeTemperance.id
            ),
            cardinalLesson(
                "cardinal-temperance-grace", "Temperance in the whole Christian life",
                "Self-control belongs with love, joy, and the Spirit.",
                "Temperance needs prudence to find the right measure, justice to respect duties and people, fortitude to bear discomfort, and charity to identify the greater love. Christian self-mastery is therefore not an isolated contest of willpower.",
                "Prayer and the sacraments orient discipline toward communion with God. Gratitude protects temperance from contempt for creation; mercy protects it from shame after failure.",
                encounter(
                    "temperance-fruit", "The fruit of the Spirit",
                    "Paul places self-control within a living pattern of love, joy, peace, patience, kindness, generosity, faithfulness, and gentleness.",
                    "GAL", 5, 22, 25),
                [
                    "Which neighboring virtue would steady this practice?",
                    "How can gratitude and grace change the tone of restraint?",
                ],
                popeTemperance.id
            ),
            applicationLesson(
                id: "cardinal-temperance-practice",
                title: "A humane rule of enough",
                opening:
                    "Choose one created good. Name its proper place, a humane limit, the greater good protected by that limit, and the support needed to keep it.",
                scripture: encounter(
                    "temperance-training", "Train for what lasts",
                    "Paul uses athletic discipline to point desire toward an enduring good.", "1COR", 9, 24, 27),
                prompts: [
                    "State the limit positively and specifically.",
                    "Review it with prudence; revise any rule that becomes unsafe, punitive, or detached from love.",
                ],
                sourceID: popeTemperance.id
            ),
        ]
    )

    private static func christianCourse(_ pathway: VirtueFormationPathway) -> VirtueStudyCourse? {
        guard let descriptor = VirtueFormationCatalog.descriptors.first(where: { $0.id == pathway.id }) else {
            return nil
        }
        let sourceIDs = pathway.sources.map(\.id)
        return VirtueStudyCourse(
            id: "christian-\(pathway.id.rawValue.replacingOccurrences(of: ".", with: "-"))",
            collection: .christian,
            virtueID: pathway.id,
            title: pathway.title,
            subtitle: descriptor.emphasis,
            overview: pathway.summary,
            whyItMatters: pathway.catholicRelationship,
            systemImage: descriptor.systemImage,
            contentVersion: 1,
            lessons: [
                lesson(
                    "\(pathway.id.rawValue)-meaning",
                    "Understanding \(pathway.title.lowercased())",
                    "Learn its Catholic meaning and place within a whole life of virtue.",
                    10,
                    [
                        section("The virtue", pathway.teaching),
                        section("Its place in Catholic formation", pathway.catholicRelationship),
                    ],
                    Array(pathway.scriptureEncounters.prefix(1)),
                    Array(pathway.examenPrompts.prefix(2)).map(\.text),
                    sourceIDs
                ),
                lesson(
                    "\(pathway.id.rawValue)-distortions",
                    "What it is—and is not",
                    "Protect the virtue from common counterfeits, shame, and misuse.",
                    9,
                    [
                        section("Common distortions", pathway.whatItIsNot.joined(separator: "\n\n")),
                        section("Pastoral boundaries", pathway.pastoralBoundaries.joined(separator: "\n\n")),
                    ],
                    Array(pathway.scriptureEncounters.dropFirst().prefix(1)),
                    [
                        "Which distortion most often borrows this virtue's name?",
                        "What boundary keeps this pursuit truthful and humane?",
                    ],
                    sourceIDs
                ),
                lesson(
                    "\(pathway.id.rawValue)-scripture",
                    "\(pathway.title) in Scripture",
                    "Read the virtue in context rather than as an isolated proof-text.",
                    12,
                    [
                        section(
                            "Read slowly",
                            "Open each passage in the Bible reader. Notice what comes before and after it, what God reveals, how the people respond, and which concrete action the text invites."
                        ),
                        section(
                            "Let Scripture correct the imagination",
                            "Biblical virtue is not a polished self-image. It is a response to God's initiative, tested in real relationships and made visible through faithful action."
                        ),
                    ],
                    pathway.scriptureEncounters,
                    pathway.examenPrompts.map(\.text),
                    sourceIDs
                ),
                lesson(
                    "\(pathway.id.rawValue)-practice",
                    "Living \(pathway.title.lowercased())",
                    "Choose one concrete practice and carry the lesson into ordinary life.",
                    10,
                    [
                        section(
                            "Begin with one practice",
                            pathway.practices.map { "\($0.title): \($0.instruction)" }.joined(separator: "\n\n")
                        ),
                        section(
                            "Pray",
                            pathway.prayer
                        ),
                    ],
                    Array(pathway.scriptureEncounters.suffix(1)),
                    [
                        "Which practice is concrete enough to begin today?",
                        "What will help you return after an imperfect day?",
                    ],
                    sourceIDs
                ),
            ],
            sources: pathway.sources,
            review: pathway.review
        )
    }

    private static func cardinalCourse(
        id: String,
        virtueID: VirtueIdentifier,
        title: String,
        subtitle: String,
        overview: String,
        whyItMatters: String,
        systemImage: String,
        popeSource: VirtueContentSource,
        lessons: [VirtueStudyLesson]
    ) -> VirtueStudyCourse {
        VirtueStudyCourse(
            id: id,
            collection: .cardinal,
            virtueID: virtueID,
            title: title,
            subtitle: subtitle,
            overview: overview,
            whyItMatters: whyItMatters,
            systemImage: systemImage,
            contentVersion: 1,
            lessons: lessons,
            sources: [rickaby, catechismHumanVirtues, wisdomEight, popeSource, popeGrace],
            review: draftReview
        )
    }

    private static func cardinalLesson(
        _ id: String,
        _ title: String,
        _ summary: String,
        _ firstBody: String,
        _ secondBody: String,
        _ scripture: VirtueScriptureEncounter,
        _ prompts: [String],
        _ popeSourceID: String
    ) -> VirtueStudyLesson {
        lesson(
            id,
            title,
            summary,
            11,
            [section("The heart of the lesson", firstBody), section("A deeper distinction", secondBody)],
            [scripture],
            prompts,
            [rickaby.id, catechismHumanVirtues.id, popeSourceID]
        )
    }

    private static func applicationLesson(
        id: String,
        title: String,
        opening: String,
        scripture: VirtueScriptureEncounter,
        prompts: [String],
        sourceID: String
    ) -> VirtueStudyLesson {
        lesson(
            id,
            title,
            "Turn the course into one prudent, concrete response.",
            9,
            [
                section("Practice", opening),
                section(
                    "Keep the meaning honest",
                    "Completing this exercise records a lesson learned, not a virtue mastered. Return to the practice, seek counsel when needed, and let prayer and the sacraments sustain the work."
                ),
            ],
            [scripture],
            prompts,
            [rickaby.id, catechismHumanVirtues.id, sourceID]
        )
    }

    private static func lesson(
        _ id: String,
        _ title: String,
        _ summary: String,
        _ estimatedMinutes: Int,
        _ sections: [VirtueLessonSection],
        _ scripture: [VirtueScriptureEncounter],
        _ prompts: [String],
        _ sourceIDs: [String]
    ) -> VirtueStudyLesson {
        VirtueStudyLesson(
            id: id,
            title: title,
            summary: summary,
            estimatedMinutes: estimatedMinutes,
            sections: sections,
            scriptureEncounters: scripture,
            reflectionPrompts: prompts,
            sourceIDs: sourceIDs
        )
    }

    private static func section(_ title: String, _ body: String) -> VirtueLessonSection {
        VirtueLessonSection(
            id: title.lowercased().replacingOccurrences(of: " ", with: "-"),
            title: title,
            body: body
        )
    }

    private static func source(
        id: String,
        title: String,
        url: String,
        locator: String,
        sourceClass: VirtueSourceClass
    ) -> VirtueContentSource {
        VirtueContentSource(
            id: id,
            title: title,
            url: URL(string: url)!,
            locator: locator,
            sourceClass: sourceClass,
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
}

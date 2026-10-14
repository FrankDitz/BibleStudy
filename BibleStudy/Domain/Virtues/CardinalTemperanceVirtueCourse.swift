import Foundation

enum CardinalTemperanceVirtueCourse {
    private typealias Sources = VirtueCurriculumSources
    private typealias Build = VirtueCurriculumBuilder

    static let course = Build.course(
        id: "cardinal-temperance",
        collection: .cardinal,
        virtueID: .cardinalTemperance,
        title: "Temperance: Freedom in the Use of Good Things",
        subtitle: "Ten lessons on desire, measure, delight, fasting, and self-mastery",
        overview:
            "Temperance orders attraction to pleasure and the use of created goods. It does not despise the body or erase delight. It makes enjoyment truthful, proportionate, grateful, and free enough to serve love.",
        whyItMatters:
            "Appetite becomes a poor master when food, drink, spending, entertainment, speech, or digital attention is asked to carry needs it cannot satisfy. Temperance restores choice and teaches the person to enjoy gifts without being possessed by them.",
        systemImage: "dial.medium",
        lessons: lessons,
        sources: [
            Sources.catechismHumanVirtues,
            Sources.catechismPassions,
            Sources.catechismHealth,
            Sources.catechismSunday,
            Sources.catechismGoodsAndProperty,
            Sources.catechismGrace,
            Sources.popeTemperance,
            Sources.popeGluttony,
            Sources.rickaby,
        ]
    )

    private static let lessons: [VirtueStudyLesson] = [
        lesson(
            "cardinal-temperance-measure", "The fitting measure",
            "Temperance seeks proportion, not the smallest possible amount.",
            "A temperate person uses created goods according to truth: the good itself, the person's condition, duties to others, and the circumstances. The fitting measure may be abstinence in one case, moderate enjoyment in another, and generous celebration in another. Mere quantity cannot replace practical judgment.",
            "Before one ordinary pleasure, pause and name its fitting purpose and limit. Receive it deliberately rather than automatically.",
            "temperance-measure", "Self-control in the race",
            "Paul's athletic image connects discipline with a worthy end rather than punishment for its own sake.",
            "1COR", 9, 24, 27, [Sources.catechismHumanVirtues.id, Sources.popeTemperance.id]),
        lesson(
            "cardinal-temperance-desire", "Desire educated, not erased",
            "Learn how feelings become partners in the good.",
            "Pleasure and desire are part of embodied human life. They are not sins simply because they are strong. Temperance educates them so the person can recognize a real good, wait, choose, and stop. Repression refuses to acknowledge desire; indulgence gives desire command. Integration tells the truth and brings appetite into the service of the whole person.",
            "Notice one desire without immediately obeying or condemning it. Name the good it seeks, the deeper need it may be carrying, and the response consistent with your duties.",
            "temperance-desire", "Desire under grace",
            "Paul contrasts being ruled by bodily impulse with a life whose members are offered to God.", "ROM", 6, 12,
            14, [Sources.catechismPassions.id, Sources.catechismHumanVirtues.id]),
        lesson(
            "cardinal-temperance-created-goods", "Good things are still good",
            "Reject both contempt for creation and dependence upon it.",
            "Christian temperance begins with gratitude. Food, rest, celebration, beauty, technology, possessions, and bodily delight can serve genuine human goods. Their goodness is limited, not false. Trouble begins when a gift is treated as a god, a right without responsibility, or anesthesia for every sorrow. Gratitude receives; temperance orders; charity shares.",
            "Choose one ordinary good and receive it today with a brief prayer of thanks. Then ask how gratitude changes the way you use, finish, share, or put it away.",
            "temperance-gifts", "Received with thanksgiving",
            "Paul rejects contempt for created gifts while insisting they be received in holiness and gratitude.",
            "1TIM", 4, 1, 5, [Sources.catechismHumanVirtues.id, Sources.popeTemperance.id]),
        lesson(
            "cardinal-temperance-domains", "Food, drink, and festivity",
            "Practice freedom where nourishment, pleasure, hospitality, and habit meet.",
            "Eating and drinking sustain life and create fellowship; they can also become compulsive, wasteful, or harmful. Temperance asks about health, gratitude, solidarity, occasion, and freedom. A feast and an ordinary meal rightly have different measures. Alcohol requires special prudence because impairment, dependency, medication, age, safety, and responsibility can make abstinence necessary.",
            "Plan one meal with a clear beginning and end, gratitude, attention, and no digital distraction. If alcohol is unsafe for you or others, choose abstinence and appropriate support.",
            "temperance-banquet", "A feast received and shared",
            "Jesus accepts table fellowship while redirecting hospitality away from status and toward generous love.",
            "LUKE", 14, 7, 14, [Sources.catechismHealth.id, Sources.popeGluttony.id]),
        lesson(
            "cardinal-temperance-digital", "Attention in a persuasive world",
            "Apply temperance to devices designed to prolong desire.",
            "Digital tools can connect, teach, create, and serve. They can also fragment attention through endless novelty, social comparison, and engineered cues. Temperance protects the freedom to begin, remain, and stop. The moral question is larger than screen minutes: what receives attention, what duty is displaced, what desire is intensified, and who is present but unseen?",
            "Create one protected daily boundary: a device-free prayer, meal, conversation, first half-hour, or final half-hour. Make the cue visible and the alternative ready.",
            "temperance-attention", "Keep watch",
            "Jesus' command to watch and pray joins spiritual attention to honest knowledge of human weakness.", "MATT",
            26, 40, 41, [Sources.catechismHumanVirtues.id, Sources.popeTemperance.id]),
        lesson(
            "cardinal-temperance-possessions", "Possessions, spending, and enough",
            "Let material goods serve life rather than define it.",
            "Temperance moderates the desire to acquire and consume; justice asks whether possessions are used with regard for others and the common good. Buying may answer a real need, support beauty, or enable service. It may also chase status, novelty, control, or relief. Freedom includes the capacity to delay, repair, share, and say that enough is enough.",
            "Delay one nonessential purchase for forty-eight hours. Write the good it promises, the cost beyond money, and whether borrowing, repairing, or sharing would serve better.",
            "temperance-treasure", "Life beyond abundance",
            "Jesus warns that possessions cannot secure life and redirects attention toward richness before God.",
            "LUKE", 12, 13, 21, [Sources.catechismGoodsAndProperty.id, Sources.catechismHumanVirtues.id]),
        lesson(
            "cardinal-temperance-speech", "Restraint in speech and anger",
            "Learn the strength of a pause that protects truth and charity.",
            "Temperance concerns more than bodily appetite. It can govern the pleasure of having the last word, displaying private information, receiving attention, or discharging anger. Restraint is not silence before injustice. It creates space for truthful speech to become proportionate, timely, and aimed at the good rather than emotional release alone.",
            "Before one charged reply, wait long enough to state the fact, the legitimate concern, and the action requested without insult, exaggeration, or mind-reading.",
            "temperance-tongue", "Slow to speak and anger",
            "James joins careful listening, measured speech, and restraint of anger in the pursuit of righteousness.",
            "JAS", 1, 19, 21, [Sources.catechismPassions.id, Sources.popeTemperance.id]),
        lesson(
            "cardinal-temperance-fasting", "Fasting, feasting, and rest",
            "Use voluntary limits to make room for worship, solidarity, and joy.",
            "Christian fasting is not body-hatred or a contest of severity. It trains freedom, expresses repentance, deepens prayer, and should open the person to charity. Feasting receives God's abundance with gratitude; Sabbath rest refuses to value persons only by output. Together they teach rhythm: abstain without pride, celebrate without excess, and rest without abandoning necessary care.",
            "Choose one safe, modest fast from food or another comfort and connect it explicitly to prayer and an act of generosity. Respect health needs and Church guidance.",
            "temperance-fast", "A fast God sees",
            "Jesus directs fasting away from performance and toward sincere relationship with the Father.", "MATT", 6,
            16, 18, [Sources.catechismSunday.id, Sources.catechismHumanVirtues.id]),
        lesson(
            "cardinal-temperance-grace", "When self-help is not enough",
            "Receive grace and qualified care where patterns have become compulsive or harmful.",
            "A habit may involve dependency, trauma, an eating disorder, addiction, or another condition requiring professional help. Temperance never justifies shame or simplistic commands to try harder. Grace works through truthful disclosure, medicine, therapy, recovery communities, pastoral care, sacramental life, changed environments, and patient rebuilding. Asking for help is an act of truth and hope.",
            "Identify whether a pattern is merely inconvenient or is impairing health, safety, relationships, or duties. Where harm is present, take one concrete step toward qualified support.",
            "temperance-freedom", "For freedom Christ set us free",
            "Paul describes Christian freedom as service through love, not surrender to a new form of slavery.", "GAL",
            5, 1, 13, [Sources.catechismGrace.id, Sources.catechismHealth.id]),
        lesson(
            "cardinal-temperance-practice", "A rule of grateful freedom",
            "Bring desire, limits, celebration, and help into a sustainable practice.",
            "Temperance matures through many small acts: pausing before use, naming purpose, choosing a fitting measure, enjoying attentively, stopping freely, and repairing excess without despair. Its fruit is not a sterile life but a spacious one. Created goods return to their proper place, leaving the person freer for worship, relationship, work, rest, and generosity.",
            "Write a four-week rule for one domain: your purpose, normal limit, exceptions for hospitality or need, warning signs, and support if the limit repeatedly fails. Review it as formation, not a score of worth.",
            "temperance-all-things", "Not mastered by anything",
            "Paul affirms freedom while refusing to let even lawful things become masters.", "1COR", 6, 12, 13,
            [Sources.catechismHumanVirtues.id, Sources.popeTemperance.id, Sources.rickaby.id]),
    ]

    private static func lesson(
        _ id: String, _ title: String, _ summary: String, _ teaching: String, _ practice: String,
        _ encounterID: String, _ encounterTitle: String, _ context: String,
        _ book: String, _ chapter: Int, _ start: Int, _ end: Int, _ sourceIDs: [String]
    ) -> VirtueStudyLesson {
        Build.lesson(
            id: id, title: title, summary: summary, teaching: teaching,
            distinction:
                "Temperance is neither indulgence nor contempt for pleasure. Test the pattern by gratitude, proportion, freedom to stop, responsibilities to others, and whether the good remains a servant rather than a master.",
            witness:
                "Catholic tradition treats temperance as a cardinal virtue because its ordering work reaches many domains. Rickaby's historical treatment can illuminate that work; the Catechism and current Church teaching govern this course.",
            caseStudy:
                "Consider a good thing used for nourishment or service, then the same thing used automatically to escape discomfort. What changed: the object, the intention, the measure, the circumstances, or freedom?",
            practice: practice,
            prayer:
                "Creator of every good gift, order my desires without deadening them. Make me grateful in enjoyment, free in restraint, generous in sharing, and humble enough to seek help.",
            scripture: [Build.encounter(encounterID, encounterTitle, context, book, chapter, start, end)],
            remember: [
                "What good is this desire seeking?",
                "What would a fitting measure protect?",
                "Can you receive, enjoy, stop, and share this good freely?",
            ], sourceIDs: sourceIDs
        )
    }
}

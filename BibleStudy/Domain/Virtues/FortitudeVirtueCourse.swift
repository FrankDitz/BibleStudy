import Foundation

enum FortitudeVirtueCourse {
    private typealias Sources = VirtueCurriculumSources
    private typealias Build = VirtueCurriculumBuilder

    static let course = Build.course(
        id: "cardinal-fortitude",
        collection: .cardinal,
        virtueID: .fortitude,
        title: "Fortitude: Courage for the Difficult Good",
        subtitle: "Ten lessons on fear, endurance, sacrifice, and hope",
        overview:
            "Fortitude steadies a person in difficulty and makes perseverance in the good possible. This course distinguishes courage from bravado, explores both bold action and patient endurance, and keeps Christian courage rooted in love, justice, grace, and hope.",
        whyItMatters:
            "Many important goods become costly precisely when they must be chosen. Fortitude helps a person face fear without worshiping danger, endure without becoming passive, seek help without shame, and remain faithful when enthusiasm has disappeared.",
        systemImage: "shield.lefthalf.filled",
        lessons: lessons,
        sources: [
            Sources.catechismHumanVirtues,
            Sources.catechismFreedom,
            Sources.catechismPassions,
            Sources.catechismGrace,
            Sources.popeFortitude,
            Sources.popePatience,
            Sources.gaudete,
            Sources.rickaby,
        ]
    )

    private static let lessons: [VirtueStudyLesson] = [
        lesson(
            "fortitude-fear", "Courage begins with a worthy good",
            "Fortitude does not begin by proving fearlessness; it begins by seeing a good worth serving.",
            "Fear alerts us to possible harm. Fortitude neither mocks that signal nor gives it final authority. It strengthens the will to pursue a genuinely difficult good despite reasonable fear and to resist pressures that would abandon that good. The first question is therefore not, 'Am I afraid?' but, 'What good, duty, or person calls for fidelity here?'",
            "Name one fear you currently face. Identify the concrete good on the other side of it, the real risks involved, and one morally sound step toward that good.",
            "fortitude-courage-call", "Courage for a mission",
            "Joshua receives courage as a command tied to God's presence and a definite responsibility.",
            "JOSH", 1, 6, 9, [Sources.catechismHumanVirtues.id, Sources.popeFortitude.id]
        ),
        lesson(
            "fortitude-rashness", "Between cowardice and recklessness",
            "Learn why unnecessary danger and impulsive confrontation are not Christian courage.",
            "Fortitude is governed by prudence. Cowardice abandons a required good because suffering is feared; rashness seeks danger, ignores proportionate precautions, or confuses intensity with holiness. A brave act has a worthy end, fitting means, and risks proportionate to one's responsibility. Choosing safety can be courageous when safety protects life and permits truthful action.",
            "Review a risky choice. Ask what duty is actually yours, which precautions respect life, and whether urgency is coming from love or from the need to appear bold.",
            "fortitude-test", "Do not test God",
            "Jesus refuses a dramatic leap that would turn trust into spectacle and needless danger.",
            "MATT", 4, 5, 7, [Sources.catechismHumanVirtues.id, Sources.rickaby.id]
        ),
        lesson(
            "fortitude-motive", "Courage governed by love",
            "Purify the motive beneath a difficult action.",
            "A person may do something externally daring for pride, revenge, recognition, or domination. Christian fortitude serves the true good and is perfected by charity. It can speak firmly without hatred, accept cost without self-display, and protect another person without treating an opponent as less than human. The moral beauty lies not in pain itself but in faithful love through pain.",
            "Before a hard conversation, write the good you seek for every person involved. Remove any sentence whose real purpose is humiliation or revenge.",
            "fortitude-love", "Strength perfected in love",
            "Paul places endurance inside a love that bears, hopes, and refuses self-seeking.",
            "1COR", 13, 4, 7, [Sources.catechismHumanVirtues.id, Sources.gaudete.id]
        ),
        lesson(
            "fortitude-daily-courage", "Ordinary moral courage",
            "Recognize the quiet acts of courage hidden in daily duties.",
            "Most courage is not dramatic. It appears when someone admits an error, keeps a promise after the mood has passed, refuses a degrading joke, tells a necessary truth, returns to prayer, or asks forgiveness first. These ordinary acts train the heart for larger trials. Smallness does not make them insignificant; it makes them available for formation today.",
            "Choose one quiet act you have delayed because of embarrassment, inconvenience, or fear of disapproval. Complete it without announcing it as an achievement.",
            "fortitude-small-faithful", "Faithful in little things",
            "Jesus connects trustworthiness in small matters with readiness for greater responsibility.",
            "LUKE", 16, 10, 12, [Sources.popeFortitude.id, Sources.gaudete.id]
        ),
        lesson(
            "fortitude-endurance", "The courage that remains",
            "Discover why patient endurance is one of fortitude's strongest forms.",
            "Fortitude is not only attack or visible resistance. Often its principal act is to stand firm: to sustain care, fidelity, recovery, study, or prayer when hardship cannot be removed immediately. Endurance is active constancy, not numb resignation. It keeps choosing the good available today while refusing despair about what cannot yet be changed.",
            "Name a good commitment that has become tiring. Reduce it to today's faithful portion and do that portion deliberately, without demanding the emotion of a fresh beginning.",
            "fortitude-race", "Run with endurance",
            "Hebrews directs weary disciples to perseverance by fixing their attention on Jesus.",
            "HEB", 12, 1, 3, [Sources.catechismHumanVirtues.id, Sources.popePatience.id]
        ),
        lesson(
            "fortitude-passion", "Christ's courage in the Passion",
            "Contemplate courage that is truthful, sorrowful, obedient, and self-giving.",
            "In Gethsemane Jesus does not deny anguish. He names it, prays, receives companionship imperfectly offered, and freely gives himself to the Father's will. The Passion corrects fantasies of courage as emotional invulnerability. Christian courage can tremble, grieve, ask for help, and still remain faithful. Its center is obedient love, not an image of toughness.",
            "Pray slowly with Gethsemane. Name before God what you wish could pass, then name the next act of love that remains possible without pretending the suffering is good in itself.",
            "fortitude-gethsemane", "Sorrow and fidelity",
            "Attend to Jesus' honest anguish, prayer, and free obedience in Gethsemane.",
            "MATT", 26, 36, 46, [Sources.gaudete.id, Sources.catechismGrace.id]
        ),
        lesson(
            "fortitude-justice", "Courage in the service of justice",
            "Stand for another person's dignity without becoming what you oppose.",
            "Justice often knows what is due before fortitude is ready to bear the cost of giving it. Fear of conflict, exclusion, retaliation, or inconvenience can silence action. Fortitude lends justice staying power. Yet righteous action remains disciplined: it seeks truth, uses proportionate means, protects the vulnerable, and rejects contempt. Courage serves justice; it does not authorize cruelty.",
            "Identify one injustice within your real sphere of responsibility. Choose a proportionate act: document facts, support the harmed person, report appropriately, or speak a precise truth.",
            "fortitude-esther", "Courage with preparation",
            "Esther accepts risk for her people after counsel, fasting, and a deliberate plan.",
            "ESTH", 4, 13, 17, [Sources.catechismHumanVirtues.id, Sources.popeFortitude.id]
        ),
        lesson(
            "fortitude-help", "Seeking help can be brave",
            "Reject the false courage that isolates people in danger, illness, addiction, or abuse.",
            "Fortitude does not require a person to remain alone where specialized help, protection, medical care, pastoral counsel, or legal intervention is needed. Enduring preventable harm is not automatically virtuous. Honest disclosure can be the courageous act, especially when shame or manipulation demands secrecy. Prudence identifies fitting helpers and immediate safety needs.",
            "Write the name and contact path of one trustworthy person or qualified service you could approach in a serious difficulty. If danger is current, prioritize safety and seek appropriate help now.",
            "fortitude-bear-burdens", "Carry one another's burdens",
            "Paul presents mutual burden-bearing, not isolated self-sufficiency, as life in Christ.",
            "GAL", 6, 1, 5, [Sources.catechismHumanVirtues.id, Sources.catechismFreedom.id]
        ),
        lesson(
            "fortitude-grace", "Strength received, not manufactured",
            "Place effort inside grace, prayer, sacrament, community, and hope.",
            "Christian fortitude is a human virtue cultivated by action and also a life opened to grace. The disciple does not manufacture unlimited resilience. God strengthens freedom through prayer, the sacraments, Scripture, wise companions, and the theological virtue of hope. Weakness honestly offered can become a place of dependence rather than humiliation.",
            "Choose one support for a present trial: prayer with Scripture, Mass, Reconciliation, a trusted companion, professional care, or practical rest. Receive it as part of courage rather than as evidence of failure.",
            "fortitude-power-weakness", "Grace in weakness",
            "Paul learns that Christ's power is not defeated by acknowledged weakness.",
            "2COR", 12, 7, 10, [Sources.catechismGrace.id, Sources.popeFortitude.id]
        ),
        lesson(
            "fortitude-practice", "A rule for courageous fidelity",
            "Gather fear, prudence, endurance, help, and hope into a sustainable practice.",
            "Mature fortitude reads difficulty truthfully, identifies the good, chooses proportionate means, and remains faithful without idolizing pain. It knows when to advance, when to stand, when to retreat from needless danger, and when to call for help. Progress is not measured by how little fear is felt but by increasing freedom to love responsibly in fear's presence.",
            "Create a four-week courage rule: one truth to tell, one duty to sustain, one support to receive, and one weekly prayer of hope. Review it without scoring your worth.",
            "fortitude-complete", "Finish the race",
            "Paul describes fidelity as a life poured out and a course completed, with hope fixed on the Lord.",
            "2TIM", 4, 6, 8, [Sources.gaudete.id, Sources.catechismHumanVirtues.id, Sources.rickaby.id]
        ),
    ]

    private static func lesson(
        _ id: String, _ title: String, _ summary: String, _ teaching: String, _ practice: String,
        _ encounterID: String, _ encounterTitle: String, _ context: String,
        _ book: String, _ chapter: Int, _ start: Int, _ end: Int, _ sourceIDs: [String]
    ) -> VirtueStudyLesson {
        Build.lesson(
            id: id,
            title: title,
            summary: summary,
            terms: [],
            teaching: teaching,
            distinction:
                "Ask whether the response serves a true good through fitting means. Feeling afraid does not prove cowardice, and feeling bold does not prove courage. Fortitude is judged by faithful action ordered by prudence and love.",
            witness:
                "The Catholic tradition joins acquired courage to grace. Saints are not admired because pain made them less human, but because Christ made them freer to love, endure, repent, protect, and hope within real human limits.",
            caseStudy:
                "Imagine the same difficult situation handled by avoidance, reckless force, and prudent courage. What good does each response see or miss? What would love require if recognition and applause were removed?",
            practice: practice,
            prayer:
                "Jesus, courageous and gentle, steady me in the difficult good. Govern my strength by wisdom and charity, and teach me to receive help with humility.",
            scripture: [Build.encounter(encounterID, encounterTitle, context, book, chapter, start, end)],
            remember: [
                "What true good is fortitude protecting here?",
                "How would prudent courage differ from avoidance and rashness?",
                "What concrete act or support belongs to the next step?",
            ],
            sourceIDs: sourceIDs
        )
    }
}

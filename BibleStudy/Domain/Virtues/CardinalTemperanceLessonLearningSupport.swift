import Foundation

/// Authored reasoning, Scripture integration, examination, and checkpoints for the
/// complete cardinal Temperance course. These supports form judgment without scoring restraint.
enum CardinalTemperanceLessonLearningSupport {
    static func support(for lessonID: String) -> VirtueLessonFormationSupport? {
        supports[lessonID]
    }

    private static func make(
        analysis: String,
        synthesis: String,
        transfer: String,
        witnessTitle: String,
        witnessBody: String,
        sourceIDs: [String] = [],
        examenIntroduction: String,
        examenExample: String,
        specificExamen: String,
        checks: [VirtueKnowledgeCheck] = []
    ) -> VirtueLessonFormationSupport {
        VirtueLessonFormationSupport(
            workedCaseAnalysis: analysis,
            scriptureSynthesis: synthesis,
            scriptureTransferQuestion: transfer,
            witnessTitle: witnessTitle,
            witnessBody: witnessBody,
            supportingSourceIDs: sourceIDs,
            selfExaminationIntroduction: examenIntroduction,
            selfExaminationExample: examenExample,
            selfExaminationSteps: examinationSteps(specificExamen: specificExamen),
            knowledgeChecks: checks
        )
    }

    private static func examinationSteps(specificExamen: String) -> [VirtueSelfExaminationStep] {
        [
            VirtueSelfExaminationStep(
                id: "facts", title: "Name the concrete event",
                question: "What happened, what did I choose, and what remains uncertain rather than proved?",
                guidance:
                    "Describe one bounded event, including sequence, amount, duration, words, bodily conditions, and reliable reports. Separate observable facts from motives, labels, excuses, and predictions."
            ),
            VirtueSelfExaminationStep(
                id: "created-good", title: "Name the created good",
                question: "Which real pleasure, relief, resource, relationship, or bodily good was I seeking?",
                guidance:
                    "Do not begin by calling the desired thing evil. Name its proper purpose and the good it can serve, while noticing promises of status, escape, control, or completion attached to it."
            ),
            VirtueSelfExaminationStep(
                id: "whole-person", title: "Read the whole person",
                question: "Which bodily, emotional, spiritual, social, and vocational conditions shaped this choice?",
                guidance:
                    "Include hunger, fatigue, pain, medication, stress, loneliness, celebration, trauma, work, prayer, disability, and health. These facts guide care and responsibility without deciding the good automatically."
            ),
            VirtueSelfExaminationStep(
                id: "motive-trigger", title: "Trace motive and occasion",
                question: "What cue, story, emotion, or repeated setting moved desire toward this response?",
                guidance:
                    "Identify triggers without treating them as destiny. Ask what happened immediately before the choice, what relief or identity was promised, and which preparation might widen freedom next time."
            ),
            VirtueSelfExaminationStep(
                id: "measure", title: "Judge the fitting measure",
                question:
                    "What amount, timing, manner, or abstention served health, vocation, worship, and genuine enjoyment?",
                guidance:
                    "Use prudence rather than an arbitrary universal number. Consider relevant vulnerability, duties, legitimate celebration, available resources, medical guidance, and the difference between use and domination."
            ),
            VirtueSelfExaminationStep(
                id: "effects", title: "Trace freedom and effects",
                question:
                    "What did the choice do to freedom, truth, health, duties, relationships, resources, and other people?",
                guidance:
                    "Look beyond immediate pleasure or guilt. Include secrecy, ability to stop, transferred burdens, gratitude, presence, repairable harm, and whether repetition is changing what now feels possible."
            ),
            VirtueSelfExaminationStep(
                id: "lesson-connection", title: "Use this lesson's lens",
                question: specificExamen,
                guidance:
                    "Apply the lesson's distinction to this event. Seek truthful freedom and a loving next act rather than calculating a score of temperance, guilt, or personal worth."
            ),
            VirtueSelfExaminationStep(
                id: "next-step", title: "Prepare the next free act",
                question:
                    "What concrete boundary, replacement good, conversation, environment, or repair belongs next?",
                guidance:
                    "Give the step a verb, setting, person, and time. Prepare before desire is strongest, define legitimate exceptions, and choose a review point rather than making an unlimited promise."
            ),
            VirtueSelfExaminationStep(
                id: "grace-help", title: "Receive grace and fitting help",
                question:
                    "Which prayer, sacrament, companion, professional, treatment, recovery, or safety resource is needed?",
                guidance:
                    "Do not spiritualize a medical or safety risk. Receive ordinary expertise as gift, protect affected people, and seek urgent care for overdose, withdrawal, self-harm, violence, abuse, or medical instability."
            ),
        ]
    }

    private static func check(
        _ id: String, _ prompt: String, _ options: [String], correct: Int,
        explanation: String
    ) -> VirtueKnowledgeCheck {
        VirtueKnowledgeCheck(
            id: id, prompt: prompt, options: options, correctOptionIndex: correct,
            explanation: explanation)
    }

    private static let supports: [String: VirtueLessonFormationSupport] = [
        "cardinal-temperance-measure": make(
            analysis:
                "The host's welcome is a genuine good, and the guest's medical limit is not ingratitude. Pressuring another drink turns hospitality into control and makes the host's preferred expression more important than the guest's health and freedom. The host should accept the refusal without demanding disclosure, offer an appealing alternative, and keep the celebration focused on relationship. The guest may state a clear boundary without defending a diagnosis. If social drinking repeatedly makes either person unable to respect limits, that pattern deserves honest review. Fitting measure here is not a universal quantity; it includes the guest's vulnerability, the duty of care, the meaning of the occasion, and the possibility of joyful communion without the pressured good.",
            synthesis:
                "Sirach praises wine's created goodness and warns against excess in the same passage. First Corinthians places bodily discipline inside mission and service, while Philippians shows Paul receiving abundance and scarcity through learned freedom in Christ. Together they reject both contempt and slavery. Created pleasures may be gratefully received, but their measure comes from the whole good of the person, neighbor, vocation, and communion with God. Freedom is shown not merely by access to a pleasure but by the ability to enjoy, limit, or relinquish it when love requires.",
            transfer:
                "Which repeated pleasure would become more intelligible if you named both the good it offers and the greater good that sometimes sets its limit?",
            witnessTitle: "Pope Francis on temperance as joyful maturity",
            witnessBody:
                "Pope Francis describes temperance as the capacity for self-mastery and wise measure, not a gray hostility toward pleasure. The temperate person can enjoy goods because no single good must carry the weight of total fulfillment. This maturity also appears in speech and relationship: it knows when to act, when to pause, and how to correct without humiliating. Temperance therefore enlarges life by preserving joy, freedom, and respect together.",
            sourceIDs: [VirtueCurriculumSources.popeTemperance.id],
            examenIntroduction:
                "Choose one recent event involving a pleasant created good and one identifiable limit. Examine the event rather than declaring your whole lifestyle temperate or excessive.",
            examenExample:
                "Example: At a celebration you accepted another drink mainly because refusing felt socially costly. The examination would name hospitality, bodily facts, freedom, pressure, likely effects, and a prepared sentence for the next invitation.",
            specificExamen:
                "Did the chosen amount, time, and manner let this particular good serve the whole person and communion, or did immediate pleasure obscure a greater claim?"
        ),
        "cardinal-temperance-desire": make(
            analysis:
                "The worker's nightly snacking is not understood by calling appetite bad or prescribing a harsher rule immediately. Long shifts, missed meals, fatigue, loneliness, and easy access all shape the event. A first response includes adequate daytime nutrition, sleep and medical review if needed, and a prepared evening routine. The worker can distinguish hunger from the learned promise that food will end every form of strain. A planned snack may be more temperate than rigid restriction followed by loss of control. If episodes involve distress, secrecy, compensating behavior, or a sense of being unable to stop, professional assessment is appropriate. Grace supports truthful care; shame will likely deepen the cycle.",
            synthesis:
                "Romans 6 describes baptismal freedom as a new relationship to sin, not the disappearance of every impulse. First Corinthians insists the body belongs to the Lord and refuses the slogan that whatever is possible is therefore fitting. Sirach warns against following every desire while acknowledging the need to govern rather than erase appetite. Read together, desire is human material for formation. The person is neither identical with an urge nor disembodied reason. Grace, bodily stewardship, repeated choices, and wise limits integrate desire into love.",
            transfer:
                "What desire have you treated either as a command or an enemy, and what would it mean to hear it as information under a larger vocation?",
            witnessTitle: "Paul's language of embodied freedom",
            witnessBody:
                "Paul does not present Christian freedom as escape from the body. He calls the body a member of Christ and a temple of the Holy Spirit, grounding discipline in belonging and redemption. This vision protects against indulgence and contempt at once. The body is not a disposable obstacle or an appetite sovereign over the person; it is received, honored, trained, and offered within communion with Christ.",
            sourceIDs: [VirtueCurriculumSources.catechismPassions.id],
            examenIntroduction:
                "Choose one desire that became noticeable in a specific setting. Examine its bodily and emotional information, the judgment attached to it, and the response that followed.",
            examenExample:
                "Example: After a lonely evening you ordered more food than you wanted and kept eating while distracted. The examination would include hunger, loneliness, access, attention, health, and a prepared meal or call next time.",
            specificExamen:
                "Did I receive desire as part of an embodied person to be understood and ordered, or did I obey, shame, suppress, or spiritualize it without truth?"
        ),
        "cardinal-temperance-created-goods": make(
            analysis:
                "The parish group's proposal to remove every enjoyable element from its retreat mistakes severity for holiness. Simple meals may support prayer and solidarity, but beauty, nourishing food, rest, and shared laughter can also serve communion. The group should name the retreat's purpose, consider health and accessibility, preserve the Church's applicable discipline, and choose restraint that releases attention or resources for prayer and mercy. Participants should not be pressured to disclose medical conditions publicly. A modest feast at the conclusion could express gratitude rather than cancel the penitential purpose. The measure is whether creation is received from God and ordered toward love, not whether discomfort is maximized.",
            synthesis:
                "Genesis calls creation good and entrusts it to human stewardship. First Timothy rejects the teaching that created foods are impure in themselves and restores thanksgiving and God's word. Psalm 104 praises an abundant world in which creatures depend upon God's provision and human life receives work, bread, wine, and oil. These readings make gratitude the grammar of temperance. One can abstain from a good precisely because it is good, receive it without idolatry, and care for the web of life and labor through which it arrives.",
            transfer:
                "Which ordinary created gift could you receive more gratefully by learning its purpose, origin, human labor, and environmental cost?",
            witnessTitle: "Creation received through thanksgiving",
            witnessBody:
                "The First Letter to Timothy answers false asceticism by insisting that God's creation is good when received with thanksgiving. This does not remove moral limits or stewardship; it places them inside gratitude rather than disgust. The Christian can fast without calling food evil, enjoy beauty without worshiping it, and accept creaturely dependence without pretending that holiness means needing nothing.",
            sourceIDs: [VirtueCurriculumSources.catechismHumanVirtues.id],
            examenIntroduction:
                "Choose one meal, possession, landscape, work tool, or bodily pleasure you recently received or refused. Examine its goodness, origin, proper use, and relationship to the Giver.",
            examenExample:
                "Example: You rushed through a meal while complaining about it. The examination would name nourishment, labor, affordability, waste, company, health, and one practice of attention or gratitude at the next meal.",
            specificExamen:
                "Did I receive or relinquish this created good with gratitude and stewardship, or did indulgence, contempt, waste, or entitlement obscure both gift and Giver?"
        ),
        "cardinal-temperance-domains": make(
            analysis:
                "The student cannot solve declining sleep and study by declaring all gaming bad. Gaming supplies recreation and friendship, but sessions begun after midnight predictably defeat duties and health. A fitting plan preserves a bounded social session earlier in the week, uses device and friend support for a stopping time, and prepares a quieter transition to sleep. Exam weeks may require a stricter temporary limit; a promised event may justify a planned exception. If attempts repeatedly fail or use produces serious distress and impairment, professional assessment is appropriate. The measure considers the whole pattern: worship, work, body, relationships, joy, and ability to stop—not one dramatic act of deletion.",
            synthesis:
                "Deuteronomy warns Israel not to forget God when abundance satisfies bodily and material needs. Luke contrasts accusations against John and Jesus, showing that neither abstinence nor feasting can be judged apart from divine wisdom and mission. Philippians names those ruled by appetite and directs citizenship and hope toward Christ. Together the passages show that temperance is not one lifestyle aesthetic. Different goods and seasons require different measures, while memory of God, vocation, and final destiny keeps any appetite from becoming the horizon of life.",
            transfer:
                "Which domain should be judged less by one isolated amount and more by its fruits across worship, body, duties, relationship, and freedom?",
            witnessTitle: "Israel's danger in satisfied abundance",
            witnessBody:
                "Deuteronomy treats abundance as blessing and spiritual danger. Fullness can conceal dependence until a people says its own power produced everything. The commanded response is memory: God, covenant, wilderness, gift, and responsibility. Temperance uses this memory to prevent comfort from becoming self-sufficiency. Enjoyment remains possible, but satisfaction no longer erases gratitude, history, or the neighbor whose life is joined to the same gifts.",
            sourceIDs: [VirtueCurriculumSources.popeTemperance.id],
            examenIntroduction:
                "Choose one domain—food, drink, work, exercise, entertainment, or rest—and one recent week. Examine patterns and fruits rather than selecting the most flattering or shameful moment.",
            examenExample:
                "Example: Exercise improved your mood but repeatedly displaced family dinner. The examination would honor health, name the relationship cost, review schedule and intensity, and test a fitting alternative.",
            specificExamen:
                "What measure lets this good strengthen the whole vocation, and which repeated fruit shows that appetite, rigidity, or another hidden motive is now setting the measure?",
            checks: [
                check(
                    "temperance-check-good", "What does temperance assume about created goods?",
                    [
                        "They are usually evil", "They are good but require ordered use",
                        "They matter only spiritually", "They should always be refused",
                    ],
                    correct: 1,
                    explanation:
                        "Temperance begins from the goodness of creation and orders attraction and use so a limited good serves the whole person and love."
                ),
                check(
                    "temperance-check-measure", "What most reliably determines a fitting measure?",
                    [
                        "The strictest available rule", "Whatever feels natural",
                        "The whole good, duties, circumstances, vulnerability, and effects", "What other people post",
                    ],
                    correct: 2,
                    explanation:
                        "Prudence identifies a proportionate measure in concrete life. Severity and impulse are both inadequate substitutes for judgment."
                ),
                check(
                    "temperance-check-virtues", "Why does temperance need the other cardinal virtues?",
                    [
                        "To make rules complicated", "Because measure requires judgment, justice, and endurance",
                        "To eliminate pleasure", "Because temperance has no object",
                    ],
                    correct: 1,
                    explanation:
                        "Prudence judges means, justice protects what is due, and fortitude sustains the good when restraint or correction is difficult."
                ),
            ]),
        "cardinal-temperance-digital": make(
            analysis:
                "The parent's work can include true emergencies, but continuous checking treats every notification as equally urgent and transfers uncertainty to the family. The parent should clarify actual on-call expectations, establish an emergency route, tell coworkers when routine replies will resume, and place the phone outside reach during a bounded dinner. The family can agree on exceptions rather than relying on resentment. News and anxious checking should receive a separate time and source limit. If employment genuinely requires availability, a shorter protected ritual may be more truthful than an impossible total ban. The test is not perfect disconnection but whether attention remains available to the people and duties present.",
            synthesis:
                "Ephesians commands careful walking, wise use of time, truthful exposure, sobriety, worship, and thanksgiving. Psalm 101 brings integrity into what is set before the eyes and into the household. Mark's parable names anxieties, wealth, and other desires that enter and choke the word. Together these passages treat attention as a moral environment. What repeatedly enters the eyes and occupies time can nourish or crowd out relationship with God and neighbor. Watchfulness is therefore positive stewardship, not fear of technology.",
            transfer:
                "Which person, prayer, duty, or form of rest should become the named replacement good for one digital boundary?",
            witnessTitle: "The watchful household of Psalm 101",
            witnessBody:
                "Psalm 101 joins public justice to household attention. The psalmist considers what is placed before the eyes, which voices receive trust, and how deceit enters a community. Applied carefully, it does not demand fearful isolation from media. It witnesses that attention and environment participate in character. A household can choose what it welcomes while remaining engaged with the world in truth and service.",
            sourceIDs: [VirtueCurriculumSources.catechismPassions.id],
            examenIntroduction:
                "Choose one digital episode with a clear beginning and end. Examine what prompted it, what you sought, what occurred, and which person or duty received less attention.",
            examenExample:
                "Example: You opened one message during dinner and then read news for twenty minutes. The examination would distinguish the message's urgency, the transition cue, anxiety, family impact, and an emergency route.",
            specificExamen:
                "Did this technology serve a chosen good, or did persuasive cues and unexamined anxiety capture attention that belonged to God, another person, a duty, or embodied rest?"
        ),
        "cardinal-temperance-possessions": make(
            analysis:
                "The couple's upgrades are not wrong merely because they are pleasant, but credit, secrecy, postponed promises, and conflict show that desire has escaped a shared measure. They should pause discretionary purchases, disclose accounts and debts safely, verify essential household needs, and create a joint plan that honors both partners' agency. The debt payment and charitable promise cannot be treated as leftovers after novelty. A neutral financial counselor may help if conversation has become controlling or avoidant. Enough should include a stable home and beauty while refusing comparison as a household duty. If one partner uses money coercively, specialized domestic or legal support is needed rather than ordinary budgeting alone.",
            synthesis:
                "Luke's rich fool accumulates without God, neighbor, or mortality entering his reasoning, while Jesus then teaches trust, almsgiving, and treasure of the heart. First Timothy joins contentment to necessities, warns about desire for wealth, and calls the rich to generous hope in God. Acts portrays possessions voluntarily made available so need is answered. Together they protect property and provision from absolutism. Goods serve life when received, planned, and shared within communion; they impoverish when storage becomes identity and security becomes endless postponement of love.",
            transfer:
                "What category needs an explicit purpose and threshold so acquisition can stop without making your life feel unfinished?",
            witnessTitle: "Barnabas makes property available to communion",
            witnessBody:
                "Acts names Barnabas as one who sells a field and entrusts the proceeds to the apostles for the community's needs. The act is concrete and relational rather than a performance of vague detachment. His witness does not establish one compulsory financial arrangement for every Christian. It shows property becoming available to grace and need, so ownership serves communion instead of closing the owner inside private security.",
            sourceIDs: [VirtueCurriculumSources.catechismGoodsAndProperty.id],
            examenIntroduction:
                "Choose one acquisition, retained item, debt, or disposal decision whose costs and purpose can be named. Examine it within actual duties and shared resources.",
            examenExample:
                "Example: You bought an upgrade on credit while delaying an agreed bill. The examination would distinguish real usefulness, novelty, debt, promise, household voice, and a repair plan.",
            specificExamen:
                "Did ownership remain stewardship ordered to vocation and the common good, or did comparison, secrecy, convenience, waste, or imagined security make accumulation its own purpose?"
        ),
        "cardinal-temperance-speech": make(
            analysis:
                "The leader must protect the client from an error promptly, but the group catalog of the sender's failures is retaliatory and unnecessary. She should verify the disputed fact, correct the actionable information through the smallest sufficient audience, and preserve the original message. Once urgency is addressed, she can ask the sender privately what was intended and address any unfair accusation with clear boundaries. If the pattern affects accountability, a supervisor or formal process may be appropriate. She should not deny anger; it identifies possible injustice. She should refuse to let anger choose irrelevant disclosures, humiliation, or certainty beyond the evidence. A trusted reviewer can help separate the necessary correction from the desired counterattack.",
            synthesis:
                "James joins listening, slow speech, governed anger, action, and care for vulnerable persons. Proverbs shows that gentle answers and truthful correction alter the course of conflict, while Sirach warns that a mouth can become a snare within friendship. Together the readings make restraint relational rather than merely private. Speech has audience, effects, and power. The temperate speaker listens for reality, chooses proportionate truth, and remains ready to repair. Silence can also be disordered when protection or testimony is due.",
            transfer:
                "Which recurring conflict would change if you prepared the legitimate audience and smallest truthful sentence before anger became strongest?",
            witnessTitle: "Christ's meek strength in speech",
            witnessBody:
                "The Gospels show Jesus using varied speech without being mastered by provocation. He asks questions, teaches, rebukes, remains silent, protects the vulnerable, and names hypocrisy. His meekness is not one soft tone but freedom under love. Because identity and mission come from the Father, an opponent does not get to determine his manner. This freedom offers a pattern for truth that refuses both cowardice and cruelty.",
            sourceIDs: [VirtueCurriculumSources.popeTemperance.id],
            examenIntroduction:
                "Choose one recent statement, message, joke, correction, or silence that affected another person. Examine its facts, purpose, audience, tone, timing, and repairable effects.",
            examenExample:
                "Example: You copied a group on a criticism that could have been resolved privately. The examination would identify the needed truth, unnecessary audience, anger, reputational effect, correction, and future channel.",
            specificExamen:
                "Did my pause prepare truthful and proportionate action, or did impulse, contempt, fear, audience, or avoidance govern what I said and what I refused to say?",
            checks: [
                check(
                    "temperance-check-anger", "What role can anger play in a temperate response?",
                    [
                        "It always proves guilt", "It can signal a threatened good but must be judged",
                        "It should be expressed immediately", "It removes responsibility",
                    ],
                    correct: 1,
                    explanation:
                        "Anger can reveal that something appears wrong, but facts, justice, charity, role, and proportion must govern the response."
                ),
                check(
                    "temperance-check-pause", "What is the purpose of a moral pause?",
                    [
                        "To avoid every conflict", "To make emotion disappear",
                        "To let truth, purpose, audience, and safety govern action", "To guarantee agreement",
                    ],
                    correct: 2,
                    explanation:
                        "A pause serves prepared action. In urgent danger it may be brief; in ordinary conflict it may include verification, prayer, counsel, or a changed channel."
                ),
                check(
                    "temperance-check-meekness", "Which best describes meekness?",
                    [
                        "Power governed by charity", "Inability to set boundaries", "Quietness at any cost",
                        "Approval of wrongdoing",
                    ],
                    correct: 0,
                    explanation:
                        "Meekness restrains disordered anger while preserving strength for truth, protection, correction, and mercy."
                ),
            ]),
        "cardinal-temperance-fasting": make(
            analysis:
                "The clinician's structured-meal recommendation protects health and should not be treated as weak faith. A severe private food fast could reactivate illness and obscure the purpose of penance. The parishioner should discuss safe practice with the treatment team and a pastor who understands the condition, follow legitimate exemptions, and choose an alternative such as reduced discretionary spending, a media limit, additional prayer, or a work of mercy. Privacy does not require secrecy from necessary support. The practice should have a bounded form and be reviewed by fruits. Obedience to care can itself relinquish the desire to prove holiness and make room for solidarity without placing the body in danger.",
            synthesis:
                "Isaiah exposes fasting severed from justice and directs restraint toward liberation, shared bread, shelter, and repair. Matthew places fasting before the Father's hidden gaze rather than an audience. Mark identifies Christ as Bridegroom, giving disciples reasons for both feasting and fasting. Deuteronomy's feast includes household and vulnerable neighbors in remembered salvation. Together the readings form a complete rhythm: conversion, mercy, hidden intention, bodily restraint, communal joy, inclusion, and hope centered upon God's saving work.",
            transfer:
                "What safe act of restraint could become more Christian by naming its prayer, neighbor, released resource, and fitting occasion for joyful reception?",
            witnessTitle: "Isaiah's fast that rebuilds community",
            witnessBody:
                "Isaiah refuses to let visible deprivation stand in for conversion. The chosen fast loosens unjust bonds, shares bread, welcomes the homeless, and repairs ruined places. Bodily practice matters, but its authenticity appears in restored relationship with God and neighbor. This witness keeps fasting from becoming self-absorption. Hunger becomes a summons to mercy, and religious observance becomes participation in God's healing justice.",
            sourceIDs: [VirtueCurriculumSources.catechismPenance.id],
            examenIntroduction:
                "Choose one fast, abstinence, feast, or rest practice. Examine its purpose, bodily reality, communal setting, effect on others, and relationship to prayer and mercy.",
            examenExample:
                "Example: You skipped a meal, became harsh with family, and kept the saved money. The examination would honor the intended sacrifice while adding health, charity, almsgiving, preparation, and repair.",
            specificExamen:
                "Did this restraint or celebration deepen conversion, gratitude, communion, and mercy, or did performance, severity, excess, fixation, or neglect distort its purpose?"
        ),
        "cardinal-temperance-grace": make(
            analysis:
                "The gambling pattern has moved beyond a private promise: concealment and missed bills expose the spouse and household to material harm. Immediate steps include stopping access to shared funds, full financial disclosure through a safe process, qualified gambling assessment, and recovery support. The spouse may need independent financial and therapeutic counsel and is not required to trust new promises without safeguards. Prayer and confession can support repentance, but refusing practical help preserves the conditions of harm. Restitution and debt planning belong to recovery. If confrontation could produce violence or coercion, safety and professional guidance come first. The man remains responsible for truthful participation even if impaired control affects culpability.",
            synthesis:
                "Jesus calls sinners while describing himself as physician, joining dignity, illness, mercy, and conversion. Galatians asks the community to restore gently, carry burdens, remain watchful, and preserve personal responsibility. Romans announces no condemnation in Christ and life through the Spirit within real weakness. Together these readings reject isolated willpower and hopeless labeling. Grace creates a community of return where harm is named, help is received, responsibility is practiced, and identity rests deeper than the pattern.",
            transfer:
                "Which serious recurring pattern needs to move from a private promise into a layered plan of safety, treatment, community, sacrament, and repair?",
            witnessTitle: "Christ the physician at the table",
            witnessBody:
                "Jesus does not wait for the sick to become impressive before sharing the table, nor does he deny their need for healing. His call gives dignity and direction at once. The scene protects recovery from shame-based exclusion and from a mercy emptied of conversion. Belonging becomes the place from which a person can answer the call, receive help, and learn a new life in truthful community.",
            sourceIDs: [VirtueCurriculumSources.catechismGrace.id],
            examenIntroduction:
                "Choose one recurring pattern only if private examination is safe and appropriate. Focus on a recent episode and the support plan; do not attempt self-diagnosis or replace treatment.",
            examenExample:
                "Example: You concealed a relapse and missed a household obligation. The examination would begin with safety, disclose to the agreed support, document effects, resume treatment, and plan repair.",
            specificExamen:
                "Am I naming both harm and diminished freedom truthfully, receiving the level of help required, and protecting others without letting shame or excuse become the plan?"
        ),
        "cardinal-temperance-practice": make(
            analysis:
                "The student's twelve rules pursue control rather than a sustainable vocation and leave no structure for illness or caregiving. He should first repair any burdens transferred to his spouse and listen to what the household actually needs. Then he can choose at most three domains with clear positive purposes, measures, exceptions, and review dates. Care of the sick child is not a failure of discipline; it is a vocational claim that may require adapted prayer, food, sleep, and device patterns. Hiding the collapse shows that the rule has become an image. A one-sentence lapse response and weekly review can replace dramatic abandonment. Clinical or pastoral guidance remains necessary where any domain carries health or compulsive risk.",
            synthesis:
                "Titus presents grace as the teacher of temperate, just, and devout life ordered toward hope and good works. First Corinthians uses disciplined training within service of the Gospel, refusing aimless effort or a merely private prize. Galatians locates freedom in loving service and the Spirit's integrated fruit. Together they show that a rule of temperance is cooperative, purposeful, communal, and hopeful. Practice serves charity; it does not manufacture worth or turn control into salvation.",
            transfer:
                "Which one restraint would become more sustainable if you named its replacement good, legitimate exceptions, environmental support, and review date?",
            witnessTitle: "Grace that trains rather than merely commands",
            witnessBody:
                "Titus describes saving grace as a teacher. Grace pardons, but it also forms a people capable of renunciation, temperate life, justice, devotion, hope, and good works. Training implies patience, practice, correction, and renewed effort. The learner is not self-created and does not graduate from dependence upon God. This witness gives a rule of life both seriousness and mercy: the purpose is readiness for love while awaiting Christ.",
            sourceIDs: [VirtueCurriculumSources.catechismGrace.id],
            examenIntroduction:
                "Choose one week under your current rule or informal pattern. Review facts and fruits without converting compliance, lapse, body size, spending, or screen time into a judgment of worth.",
            examenExample:
                "Example: A bedtime phone boundary worked four nights and failed during travel. The examination would name improved sleep, the travel trigger, emergency needs, a portable charging plan, and resumption tonight.",
            specificExamen:
                "Did my rule protect a larger yes and remain truthful under real conditions, or did severity, vagueness, image, uncontrolled exceptions, or self-surveillance replace formation?",
            checks: [
                check(
                    "temperance-check-rule", "What should every restraint in a rule of life identify?",
                    ["A punishment", "A larger good it protects", "A public score", "The strictest possible limit"],
                    correct: 1,
                    explanation:
                        "Temperance serves a positive freedom for God, persons, duties, health, gratitude, and joy rather than prohibition as an end in itself."
                ),
                check(
                    "temperance-check-exception", "What makes an exception legitimate?",
                    [
                        "The rule feels difficult", "It preserves the rule's purpose under a relevant circumstance",
                        "No one notices", "It happens frequently",
                    ],
                    correct: 1,
                    explanation:
                        "Illness, hospitality, duty, travel, celebration, or safety may require adaptation. The exception remains answerable to the purpose and ends or is reviewed with the circumstance."
                ),
                check(
                    "temperance-check-completion", "What does completing the course establish?",
                    [
                        "Perfect self-mastery", "Superior holiness", "That the lessons were studied",
                        "Freedom from future temptation",
                    ],
                    correct: 2,
                    explanation:
                        "Course completion records study only. Virtue remains lifelong cooperation with grace across changing situations, failures, and responsibilities."
                ),
            ]),
    ]
}

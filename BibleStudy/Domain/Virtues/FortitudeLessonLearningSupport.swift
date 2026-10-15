import Foundation

/// Authored reasoning, Scripture integration, examination, and checkpoints for the
/// complete Fortitude course. These supports form judgment without scoring courage.
enum FortitudeLessonLearningSupport {
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
                id: "facts",
                title: "Name the facts",
                question: "What happened, what is known, and what remains uncertain or inferred?",
                guidance:
                    "Record observable events, reliable reports, timing, and present conditions. Separate facts from assigned motives, feared predictions, remembered patterns, and questions that still require competent inquiry."
            ),
            VirtueSelfExaminationStep(
                id: "difficult-good",
                title: "Name the difficult good",
                question: "Which person, truth, duty, promise, vocation, or just cause requires strength?",
                guidance:
                    "State the good concretely enough to guide action. Difficulty, pain, conflict, or risk alone does not make an act courageous or the cause worthy."
            ),
            VirtueSelfExaminationStep(
                id: "fear",
                title: "Listen to fear truthfully",
                question: "What harm do I fear, and which part is real, probable, possible, or imagined?",
                guidance:
                    "Include bodily and emotional reactions without shame. Ask what fear accurately protects, where it distorts, and whether trauma, anxiety, coercion, or immediate danger requires specialized help."
            ),
            VirtueSelfExaminationStep(
                id: "motive-and-means",
                title: "Test motive and means",
                question: "Am I moved by love and duty, or also by pride, anger, approval, revenge, or thrill?",
                guidance:
                    "Mixed motives need truthful ordering, not automatic paralysis. Remove any proposed means involving deception, humiliation, needless risk, self-harm, or another moral wrong."
            ),
            VirtueSelfExaminationStep(
                id: "role-and-proportion",
                title: "Judge role and proportion",
                question: "What is actually mine to do, and what level of risk and preparation fits?",
                guidance:
                    "Identify authority, competence, dependents, likely effects, safer means, and duties held by other people or institutions. Courage should not transfer avoidable danger to someone else."
            ),
            VirtueSelfExaminationStep(
                id: "movement",
                title: "Choose the courageous movement",
                question: "Does the good require advance, endurance, retreat, help, or a sequence of them?",
                guidance:
                    "Do not rank these movements by drama. Advancing acts, endurance remains, retreat protects from needless danger, and help joins freedom to community and competence."
            ),
            VirtueSelfExaminationStep(
                id: "lesson-connection",
                title: "Use this lesson's lens",
                question: specificExamen,
                guidance:
                    "Apply the lesson's distinction to this one situation. Seek clearer freedom and a faithful response rather than a numerical judgment of courage, guilt, or worth."
            ),
            VirtueSelfExaminationStep(
                id: "next-step",
                title: "Choose the next faithful step",
                question: "What is the smallest protected action that genuinely serves the difficult good now?",
                guidance:
                    "Give the step a verb, person, channel, and time. Add preparation and a review point instead of waiting for fear to disappear or escalating for appearance."
            ),
            VirtueSelfExaminationStep(
                id: "support-and-safety",
                title: "Receive support and protect life",
                question: "Which grace, companion, safeguard, professional, authority, or emergency path is needed?",
                guidance:
                    "Include prayer and sacramental help with appropriate medical, psychological, legal, recovery, safeguarding, or emergency care. Do not use a private exercise in place of immediate protection."
            ),
        ]
    }

    private static func check(
        _ id: String,
        _ prompt: String,
        _ options: [String],
        correct: Int,
        explanation: String
    ) -> VirtueKnowledgeCheck {
        VirtueKnowledgeCheck(
            id: id,
            prompt: prompt,
            options: options,
            correctOptionIndex: correct,
            explanation: explanation
        )
    }

    private static let supports: [String: VirtueLessonFormationSupport] = [
        "fortitude-fear": make(
            analysis:
                "The nurse's fear contains several goods: patient safety, professional responsibility, truthful collaboration, and the risk of unfairly accusing a supervisor before facts are complete. Courage does not require immediate public confrontation. She should document the observed errors precisely, check the procedure and reporting duty, protect any patient facing immediate risk, and consult the appropriate clinical or safety lead. A confidential report can ask for investigation without claiming motives she does not know. If internal channels are compromised, professional or regulatory guidance may be needed. Fear of being labeled difficult should not silence a safety duty, while humility about incomplete data should govern language and channel.",
            synthesis:
                "Joshua receives courage within a mission, obedience to the law, and God's promised presence. Psalm 27 names enemies and abandonment while directing desire toward God, petition, waiting, and a strengthened heart. Mark's storm presents real danger, frightened disciples, Christ's presence, and authority beyond their control. Together the readings show that courage neither denies danger nor manufactures certainty. It identifies the entrusted good, acts under God's word, and lets divine presence enlarge freedom when fear claims to be the entire reality.",
            transfer:
                "Which fear would become more intelligible if you named the worthy good and the concrete responsibility before trying to feel brave?",
            witnessTitle: "Joshua's courage for an entrusted mission",
            witnessBody:
                "Joshua is not told to become impressive or immune to fear. He receives a people to lead, a law to keep, ground to cross, and the promise that God will be with him. His witness gives courage an objective shape: strength answers a vocation and remains governed by obedience rather than self-created confidence. Divine presence does not cancel planning or action; it frees both from the demand that Joshua personally guarantee the future.",
            sourceIDs: [VirtueCurriculumSources.catechismHumanVirtues.id],
            examenIntroduction:
                "Choose one bounded situation in which fear affects a real duty. Examine one event and one next decision rather than trying to determine whether you are generally courageous or cowardly.",
            examenExample:
                "Example: You notice a possible error in a shared report and fear embarrassing a colleague. The examination would identify the uncertain fact, the client's good, the proper verification channel, and a private correction before any public claim.",
            specificExamen:
                "Did I let fear provide information under reason and faith, or did I let either fearlessness or anxiety define the good and the action?"
        ),
        "fortitude-rashness": make(
            analysis:
                "The threatening messages create a legitimate concern, but the proposed solo confrontation is rash. The friend lacks a full risk assessment, may alert or provoke the suspected sender, and could expose the coworker whose agency and safety should guide the response. Avoidance would ignore the evidence. Prudent courage preserves screenshots lawfully, asks the coworker what is already known where safe, contacts the appropriate workplace security, safeguarding, law-enforcement, or advocacy resource, and follows trained safety guidance. If danger is immediate, emergency services replace gradual planning. The friend can accompany and share practical burdens without making himself the rescuer or choosing a dramatic act that others must survive.",
            synthesis:
                "Sirach joins humility and teachability to respect for human limits. Proverbs commends the person who sees danger and takes refuge rather than walking into harm. Matthew's arrest scene shows impulsive force interrupted by Jesus, who understands the mission and refuses the disciple's attempt to control it by the sword. These readings make prudence internal to fortitude. Courage neither hides indefinitely nor treats preparation and protection as shameful; it serves the good through means proportionate to responsibility and truth.",
            transfer:
                "Which proposed act would become more courageous—not less—if you added counsel, protection, a review point, or a safer channel?",
            witnessTitle: "Christ's strength without spectacle",
            witnessBody:
                "At his arrest Jesus does not confuse force with freedom. He stops a disciple's sword, speaks truth, protects the mission, and accepts what he has freely discerned before the Father. His strength is neither passive collapse nor frantic control. It shows how courage can remain decisive while refusing unnecessary violence and theatrical proof. The disciple's sincerity cannot make the sword fitting; love must govern both the end and the means.",
            sourceIDs: [VirtueCurriculumSources.catechismHumanLife.id],
            examenIntroduction:
                "Choose one situation where you leaned toward avoiding all discomfort or taking a dramatic risk. Examine the good, your actual role, foreseeable harm, available safeguards, and facts that would require revision.",
            examenExample:
                "Example: You want to confront an aggressive neighbor alone about threats. The examination would preserve evidence, protect household members, clarify urgency, consult the appropriate authority, and reject a meeting that creates needless danger.",
            specificExamen:
                "Was I protecting the difficult good through proportionate means, or using avoidance, rashness, or stubbornness to protect comfort or self-image?"
        ),
        "fortitude-motive": make(
            analysis:
                "The council member has a just concern, but her desire to return humiliation risks making another wrong the means of correction. She should preserve the examples, seek consent before using volunteers' stories, and activate the confidential review process with a clear deadline and accountability. If earlier delays create ongoing danger, escalation may be necessary, possibly including public action, but disclosure should reveal no more than protection and truth require. A trusted person should review her language for exaggeration and retaliation. The leader's dignity does not cancel consequences, and charity does not require silence. It governs the action toward protection, repentance, and repaired community rather than emotional victory.",
            synthesis:
                "John 15 places the laying down of life within Christ's love, obedience, friendship, joy, and lasting fruit. Matthew 6 examines good religious practices distorted by the desire to be seen. First Corinthians 13 declares that speech, knowledge, faith, generosity, and bodily sacrifice can remain empty without charity. Together the passages test courage by cause, motive, and manner. Christian fortitude accepts cost for love, not because pain, audience, or self-display can make an act holy.",
            transfer:
                "If your difficult action succeeded but no one admired you and your opponent was treated with dignity, would you still desire the same good?",
            witnessTitle: "The martyrs as witnesses to moral truth",
            witnessBody:
                "Veritatis Splendor presents the martyrs not as lovers of death but as witnesses who refuse to commit evil even under extreme pressure. Their sacrifice is governed by fidelity to Christ and the dignity protected by moral truth. They reveal that a worthy cause cannot be served through a chosen evil merely because circumstances are severe.",
            sourceIDs: [VirtueCurriculumSources.veritatisSplendor.id],
            examenIntroduction:
                "Choose one difficult act in which anger, approval, loyalty, guilt, or desire for recognition may accompany a genuine good. The aim is to order motives and means rather than wait for a perfectly simple heart.",
            examenExample:
                "Example: You plan to correct a false claim online and also want to embarrass its author. The examination would preserve the needed correction while removing ridicule, excess disclosure, and the audience-seeking part of the response.",
            specificExamen:
                "Would love still choose this act, audience, language, and risk if revenge, applause, victory, and the identity of being brave were removed?"
        ),
        "fortitude-daily-courage": make(
            analysis:
                "Laughing along would cooperate with humiliation, while a grand speech could center the junior employee and expose the colleague further. A precise interruption—“That comment is not appropriate; let's stop”—can set a norm without assigning motives. Privately, he can ask the colleague whether support or documentation would help rather than assuming what the colleague wants. If the pattern continues, a responsible workplace channel may be necessary, especially if power or discrimination is involved. The response should record facts, avoid circulating the insult, and accept social awkwardness. Courage here is neither silence nor performance but dependable solidarity shaped by the harmed person's agency.",
            synthesis:
                "Esther moves from fear through counsel and communal fasting to a deliberate risk for her people. Acts 4 joins apostolic boldness to prayer, the Spirit, Scripture, threats, and community. Susanna's account includes Daniel refusing to participate silently in an unjust judgment. The witnesses differ in role and action, yet all move from recognized responsibility to concrete speech supported by truth and community. Ordinary moral courage becomes possible when the next act is prepared rather than imagined only as heroic impulse.",
            transfer:
                "Which sentence, boundary, apology, or request for help can you rehearse now so discomfort no longer decides when the moment arrives?",
            witnessTitle: "Esther's prepared and communal courage",
            witnessBody:
                "Esther does not begin fearless or act alone. She hears the danger, voices the risk, receives a difficult challenge, asks the community to fast, and then chooses a plan. Her witness honors preparation and dependence. Courage becomes a concrete service to others rather than a spontaneous claim about her own strength. Her deliberate approach also shows that urgency need not eliminate counsel, timing, community, or a wise use of position.",
            sourceIDs: [VirtueCurriculumSources.popeFortitude.id],
            examenIntroduction:
                "Choose one ordinary moment involving truth, apology, boundary, protection, or help. Examine the sentence or action you chose or avoided, the social cost, and the person whose good was at stake.",
            examenExample:
                "Example: A meeting repeats an inaccurate claim, and you remain silent to avoid seeming difficult. The examination would identify the factual correction, proper timing, exact sentence, and whether a follow-up channel is safer or more effective.",
            specificExamen:
                "What quiet act did love and duty require, and how can precision, rehearsal, support, and a fitting channel make that act reliably possible?",
            checks: [
                check(
                    "fortitude-check-fear", "Which statement best describes fear in relation to fortitude?",
                    [
                        "Any fear proves cowardice", "Fear is always accurate",
                        "Fear can provide information but does not make the final moral judgment",
                        "Courage requires suppressing bodily reactions",
                    ],
                    correct: 2,
                    explanation:
                        "Fear can alert a person to real danger or distort perception. Prudence interprets it, and fortitude preserves freedom for the good while fear may remain."
                ),
                check(
                    "fortitude-check-rashness", "What most clearly distinguishes fortitude from rashness?",
                    [
                        "Fortitude always takes the largest risk",
                        "Fortitude uses proportionate means, preparation, and safeguards for a worthy good",
                        "Fortitude never retreats", "Fortitude feels more confident",
                    ],
                    correct: 1,
                    explanation:
                        "Rashness pursues unnecessary or disproportionate danger. Fortitude is governed by prudence and may advance, retreat, or seek help as the good requires."
                ),
                check(
                    "fortitude-check-motive", "Why can an externally daring act fail to be virtuous?",
                    [
                        "Virtue avoids every conflict", "Only hidden acts matter",
                        "The cause, motive, and means may be disordered", "Pain is never accepted in Christianity",
                    ],
                    correct: 2,
                    explanation:
                        "Difficulty alone does not make an act good. Fortitude serves a just cause through moral means and is perfected by charity rather than vanity or revenge."
                ),
            ]
        ),
        "fortitude-endurance": make(
            analysis:
                "The promise to care remains a real good, but one person silently absorbing every task is not the only faithful form. The caregiver's own health, work, and limits are also morally relevant, and the parent should participate in decisions as able. He should tell siblings the facts without accusation, seek a care assessment and respite options, define tasks he can sustain, and address his missed medical care. If others refuse, professional or community support may still redistribute the burden. Abandonment would leave needs unaddressed without responsible transition; revision preserves care by making it truthful. Enduring the process of coordination may be harder and more courageous than continuing toward collapse.",
            synthesis:
                "Romans 5 places endurance between suffering and tested character, ending in hope grounded in the Holy Spirit's poured-out love. Hebrews remembers a community that endured loss and urges it not to discard confidence. James joins trial, steadfastness, maturity, and prayer for wisdom while warning about temptation. Together the readings show endurance as active faithfulness sustained by grace, memory, wisdom, and promised fulfillment—not silent submission to every harm or a refusal of human support.",
            transfer:
                "Which good commitment would become more faithful if you reduced it to today's portion and allowed another person to carry a real part of the burden?",
            witnessTitle: "Christ's patience as the fruit of love",
            witnessBody:
                "Pope Francis teaches that Jesus' patience in the Passion is not stoic resistance but the fruit of a greater love. This patience refuses to answer evil with evil and remains open to mercy. It is meek strength, not numbness. The distinction keeps endurance directed toward love rather than pain, pride, or passive surrender. Patient love can still name wrongdoing, protect the vulnerable, set limits, and seek justice without letting retaliation shape the heart.",
            sourceIDs: [VirtueCurriculumSources.popePatience.id],
            examenIntroduction:
                "Choose one commitment made difficult by repetition, delay, grief, illness, or discouragement. Examine a recent week and the good still possible, without treating exhaustion as a moral verdict.",
            examenExample:
                "Example: A caregiver keeps every task private until resentment erupts. The examination would name the parent's needs, the caregiver's limits, shared duties, available respite, and one sustainable week of care rather than an unlimited promise.",
            specificExamen:
                "Am I actively persevering in the good with truthful limits and support, or confusing endurance with numbness, isolation, an unchangeable method, or continued exposure to preventable harm?"
        ),
        "fortitude-passion": make(
            analysis:
                "Threats and coercive control are not a cross the man is morally required to preserve. Jesus' free obedience to the Father cannot be transferred to an abuser's demand. The man should prioritize safety, contact a qualified domestic-violence or safeguarding service, include emergency authorities where danger is immediate, and seek legal and pastoral counsel from people who understand coercion. Direct confrontation or announcing departure may increase danger and should follow trained planning. Marriage is a serious covenant, but protection, separation where necessary, truthful reporting, and boundaries can serve dignity and life. Forgiveness must not be forced into secrecy, restored access, or abandonment of justice.",
            synthesis:
                "Mark and Luke show Jesus sorrowful, prayerful, bodily distressed, strengthened, and faithful. Luke's crucifixion account then joins unjust suffering with mercy, promised paradise, lamenting creation, and final trust in the Father. The Passion therefore rejects emotional invulnerability and passive worship of pain. Christ's courage is free obedient love that refuses evil's interior logic. The readings invite honest petition, companionship, protection of truth, mercy, and hope without making another person's imposed harm into God's command.",
            transfer:
                "What sorrow or desired relief do you need to name honestly before discerning the next act of faithful love?",
            witnessTitle: "Jesus' honest prayer in Gethsemane",
            witnessBody:
                "Jesus does not hide anguish to protect an image of spiritual strength. He names sorrow, asks companions to remain, petitions the Father for another way, and freely consents to the mission. His witness sanctifies truthful need and prayer. Courage can tremble and still act; companionship and desired relief do not negate obedience. The scene gives believers language for suffering while denying anyone permission to equate imposed abuse with the Father's will.",
            sourceIDs: [VirtueCurriculumSources.popePatience.id],
            examenIntroduction:
                "Choose one unavoidable suffering or feared duty, not a situation where immediate safety action should replace private reflection. Examine desire, companionship, freedom, and the faithful act before God.",
            examenExample:
                "Example: You fear a necessary medical procedure and think holy courage should feel calm. The examination would name fear, ask questions, arrange accompaniment, seek appropriate relief, pray honestly, and consent without pretending the procedure is pleasant.",
            specificExamen:
                "Did I bring anguish, desire for relief, human support, and the real duty into prayer—or use the Cross to suppress need, remain in preventable harm, or avoid faithful action?"
        ),
        "fortitude-justice": make(
            analysis:
                "The analyst should not delete the evidence or release private files impulsively. The safety of customers and integrity of records provide a just cause, while confidentiality and due process remain goods. She should preserve material lawfully, document provenance, obtain protected legal or professional advice, and use the regulator's secure channel if appropriate. Coworkers and leaders with greater authority should share the cost instead of making the junior employee stand alone. Public disclosure could become necessary in an extreme failure of accountable channels, but it requires expert guidance and redaction. Courage accepts retaliation risk proportionately; it does not ignore the privacy and safety of those represented in the files.",
            synthesis:
                "Daniel 3 presents fidelity that refuses idolatry without demanding a guaranteed rescue. Second Timothy joins God's gift with power, love, self-control, suffering, grace, vocation, and guarded trust. Acts 5 shows apostles obeying God, enduring unjust punishment, and continuing witness. Together the passages form resistance that is neither timid nor hateful. Courage answers divine truth, accepts cost, remains disciplined by love, and refuses to make visible success the condition of faithfulness.",
            transfer:
                "Where can you share the cost of truthful action so the person with least power is not required to become the sole courageous witness?",
            witnessTitle: "Susanna and the inviolability of moral truth",
            witnessBody:
                "Saint John Paul II points to Susanna as a witness who refuses a sinful act even when corrupt judges threaten her life and reputation. Her courage does not make coercion good or danger desirable. It testifies that extreme pressure cannot transform evil into a moral means and that human dignity remains answerable to God. Her innocence also exposes the community's duty to investigate truthfully rather than romanticize the victim's suffering.",
            sourceIDs: [VirtueCurriculumSources.veritatisSplendor.id],
            examenIntroduction:
                "Choose one injustice or pressured cooperation within your real knowledge and responsibility. Examine evidence, affected persons, authority, channel, danger, and allies without assuming that public conflict is the only brave response.",
            examenExample:
                "Example: A worker is asked to backdate a required inspection. The examination would identify the false act, people exposed, refusal language, documentation, reporting duty, retaliation protection, and qualified counsel.",
            specificExamen:
                "What just cause requires firmness, and which truthful, proportionate, accountable action resists evil without using hatred, falsehood, needless exposure, or another person's story as a weapon?",
            checks: [
                check(
                    "fortitude-check-endurance", "Which description best distinguishes endurance from resignation?",
                    [
                        "Endurance never changes methods",
                        "Endurance actively continues the good with support and truthful limits",
                        "Endurance refuses all relief", "Endurance guarantees visible success",
                    ],
                    correct: 1,
                    explanation:
                        "Endurance remains free for the good. It can rest, seek help, revise means, grieve, and protect life rather than passively accepting every condition."
                ),
                check(
                    "fortitude-check-passion", "What does Christ's anguish in Gethsemane teach about courage?",
                    [
                        "Fear or sorrow disproves holiness", "Human companionship is a lack of faith",
                        "Honest sorrow, petition, support, and faithful obedience can coexist",
                        "Every painful event is God's will",
                    ],
                    correct: 2,
                    explanation:
                        "Jesus names sorrow, desires relief, seeks companions, prays, and remains faithful. Emotional invulnerability is not the Christian measure of courage."
                ),
                check(
                    "fortitude-check-resistance", "What governs courageous resistance to injustice?",
                    [
                        "The intensity of anger", "Truth, justice, charity, proportion, and respect for life",
                        "Guaranteed victory", "Maximum public exposure",
                    ],
                    correct: 1,
                    explanation:
                        "Fortitude strengthens justice. Its means remain accountable to truth, charity, prudence, dignity, and protection of persons."
                ),
            ]
        ),
        "fortitude-help": make(
            analysis:
                "Thoughts that others would be better without him, severe sleep disruption, and escalating panic require prompt real-world assessment. The friend should not promise secrecy that prevents protection. He can remain calm, listen, ask directly about immediate safety if able, stay with the student where appropriate, and contact campus crisis, medical, emergency, or other qualified services according to urgency and location. Pastoral help may accompany but not replace clinical care. The friend should involve responsible adults or professionals even if the student is angry, sharing only information needed for protection. After connection, ongoing friendship can remain while trained people carry the assessment and treatment the friend cannot provide.",
            synthesis:
                "Moses' raised hands are supported by Aaron and Hur while others fulfill distinct roles. Elijah's collapse meets sleep, food, divine presence, renewed mission, and future companions rather than a lecture about trying harder. Galatians joins gentle restoration and mutual burden-bearing to personal responsibility and perseverance in good. Together the readings reject both isolation and takeover. Courage can receive material, spiritual, relational, and competent support while the person remains a responsible participant in the good.",
            transfer:
                "Which burden needs a specific request to a fitting person rather than another private promise to become stronger?",
            witnessTitle: "Elijah receives care before a renewed mission",
            witnessBody:
                "Elijah's fear and despair are met first through sleep, food, water, journey, and God's quiet presence. Only then does renewed commission and companionship become explicit. The story does not shame bodily or emotional limits. It witnesses to providence that can strengthen a person through ordinary care, truth, and another human being. Mission is renewed within creaturely need, not by pretending hunger, exhaustion, fear, and isolation have ceased to matter.",
            sourceIDs: [VirtueCurriculumSources.catechismGrace.id],
            examenIntroduction:
                "Choose one difficulty you have hidden or carried alone. Examine what kind of help it actually requires and the fear attached to disclosure, without using the exercise for an emergency assessment.",
            examenExample:
                "Example: Someone conceals mounting debt from a spouse and asks only friends for reassurance. The examination would identify truthful disclosure, financial competence, relational support, and safeguards rather than expecting one confidant to solve everything.",
            specificExamen:
                "Did I receive the competent support and protection the good requires, or did shame, pride, loyalty, or an unsafe helper turn isolation into a false image of courage?"
        ),
        "fortitude-grace": make(
            analysis:
                "Stopping recovery and medical supports is not stronger faith. The person should disclose the cravings promptly to the treatment or recovery team, resume the agreed safety process, consult the prescriber before changing medication, and contact emergency help if relapse or other danger is imminent. Prayer, Confession, Eucharist, and pastoral accompaniment can deepen truth and hope while remaining distinct from clinical care. Presumption expects God to protect a private plan that rejects available means; hope trusts grace enough to use them humbly. A companion can help the person make calls and attend support without taking over responsibility. Hiding weakness preserves an image while increasing danger; honest dependence restores freedom.",
            synthesis:
                "Paul's thorn leads through repeated petition to Christ's sufficient grace and power in weakness. Romans 8 places groaning, intercession, suffering, divine purpose, and inseparable love within hope. Ephesians commands believers to be strong in the Lord and then names armor received through truth, righteousness, peace, faith, salvation, God's word, and prayer. The texts do not celebrate helplessness. They relocate strength from isolated self-production into grace that equips responsible action and sustains love beyond visible control.",
            transfer:
                "Which ordinary means of care have you treated as competition with grace rather than a possible instrument of providence?",
            witnessTitle: "Paul's weakness opened to sufficient grace",
            witnessBody:
                "Paul does not hide the thorn or pretend not to want relief. He petitions repeatedly and receives a vocation within a weakness not removed. His witness is not a ban on treatment. It shows that acknowledged limitation need not destroy mission, because Christ's grace can sustain faithful action where self-sufficiency ends. The center is Christ's sufficient grace, not the pain considered by itself or an image of heroic independence.",
            sourceIDs: [VirtueCurriculumSources.catechismGrace.id],
            examenIntroduction:
                "Choose one present limitation, temptation, or long trial. Examine your practice, prayer, sacramental life, human support, and the outcome you are trying to control rather than judging the strength of your faith.",
            examenExample:
                "Example: A person facing depression prays but skips medical appointments from shame. The examination would honor prayer, restore professional care, identify a companion, and reject the claim that receiving treatment proves spiritual failure.",
            specificExamen:
                "Am I cooperating with grace through truthful human action and help, or falling into self-reliance, passivity, despair, or presumption about the result God must provide?"
        ),
        "fortitude-practice": make(
            analysis:
                "The employee's worthy goods are accurate safety records, protection of people affected, and integrity of professional responsibility. He should preserve the record lawfully, verify the discrepancy without alerting the colleague unnecessarily, and obtain confidential advice about reporting and retaliation. A small step is documentation and counsel; a medium step is the protected internal or regulatory report; a larger step depends on continued danger or failed accountable channels and requires expert guidance before public disclosure. Deletion is avoidance, while indiscriminate posting is rash. The plan needs a safety and employment support, a review date, and thresholds for urgent external action. He cannot control whether leaders respond well, but he can keep his means truthful and proportionate.",
            synthesis:
                "First Corinthians gathers watchfulness, firmness, courage, strength, service, peace, grace, and the command that everything be done in love. Second Timothy views a life of witness through endurance, faithful teaching, a poured-out offering, a finished race, and hope in the Lord. Psalm 31 holds distress, refuge, mercy, truth, answered prayer, and strengthened hope together. The readings present mature fortitude as faithful action received from God and ordered by love, not an emotion or isolated heroic event.",
            transfer:
                "What first protected action would make a worthy good real this week without pretending you can control the final outcome?",
            witnessTitle: "Christ's courage carried into ordinary fidelity",
            witnessBody:
                "The Gospel reveals Jesus as neither fragile before opposition nor hardened by it. He speaks, withdraws, confronts, grieves, receives help, protects, endures, gives himself, and entrusts the outcome to the Father. Christian fortitude learns this range. Its unity lies not in one posture but in faithful love governing every movement. This breadth frees disciples from copying a heroic pose when the actual good calls for a quieter or more dependent action.",
            sourceIDs: [VirtueCurriculumSources.popeFortitude.id],
            examenIntroduction:
                "Choose one difficult good for the full course examination. The aim is a graduated plan and a repeatable rule, not proof that you are brave or a judgment about culpability and worth.",
            examenExample:
                "Example: A worker finds a suspicious safety record. The examination would verify facts, name people at risk, clarify role, preserve evidence, obtain protected counsel, and establish thresholds for internal and external reporting.",
            specificExamen:
                "Across good, fear, motive, proportion, action, endurance, retreat, help, and grace, what first step is faithful now, and what facts would require escalation or revision?",
            checks: [
                check(
                    "fortitude-final-help", "Which statement best describes seeking help?",
                    [
                        "It always proves weak faith", "It transfers all responsibility",
                        "It can be courageous when fitting support protects and enlarges responsible action",
                        "Only spiritual help is relevant to virtue",
                    ],
                    correct: 2,
                    explanation:
                        "Human beings are interdependent. Pastoral, medical, psychological, legal, recovery, relational, and emergency supports can serve responsible freedom according to their competence."
                ),
                check(
                    "fortitude-final-hope", "How does theological hope differ from optimism?",
                    [
                        "Hope guarantees the visible outcome desired",
                        "Hope trusts Christ and grace beyond outcomes while sustaining faithful action",
                        "Hope avoids grief", "Hope removes the need for preparation",
                    ],
                    correct: 1,
                    explanation:
                        "Hope desires God's kingdom and relies on the Holy Spirit. It can pursue earthly goods fully without making one visible result the condition of meaning."
                ),
                check(
                    "fortitude-final-plan", "What makes a graduated courage plan responsible?",
                    [
                        "It always ends in public confrontation", "It increases risk at every stage",
                        "It ties steps and escalation to evidence, role, safeguards, and named thresholds",
                        "It waits until fear disappears",
                    ],
                    correct: 2,
                    explanation:
                        "Graduated action avoids both paralysis and reckless escalation. It defines fitting steps, support, safety conditions, review, and facts that require a changed response."
                ),
            ]
        ),
    ]
}

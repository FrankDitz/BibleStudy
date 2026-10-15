import Foundation

/// Builds the seven capital-sin counter-virtue courses from course-specific manuscripts
/// and a shared Catholic learning sequence. The shared sequence supplies consistent
/// moral reasoning while each profile supplies its own doctrine, practices, sources,
/// Scripture witnesses, and vice-specific applications.
enum CounterVirtueLectureFactory {
    typealias Profile = CounterVirtueCurriculum.Profile
    private typealias Build = VirtueCurriculumBuilder
    private typealias Sources = VirtueCurriculumSources

    private struct Stage {
        let summary: String
        let question: String
        let terms: [String]
        let lens: String
        let misconception: String
        let caseStudy: String
        let examen: String
    }

    static func lesson(profile: Profile, index: Int, suffix: String) -> VirtueStudyLesson {
        let stage = stages[index]
        let lessonID = "\(profile.virtueID.rawValue)-\(suffix)"
        let sourceIDs = unique(
            [
                Sources.catechismHumanVirtues.id,
                Sources.catechismCapitalSins.id,
                Sources.catechismGrace.id,
                Sources.gaudete.id,
            ] + profile.sources.map(\.id)
        )
        let encounters = profile.scripture.enumerated().map { offset, seed in
            Build.encounter(
                "\(lessonID)-\(seed.id)-\(offset)",
                offset == 0 ? "Primary reading — \(seed.title)" : "Further reading — \(seed.title)",
                seed.context,
                seed.book,
                seed.chapter,
                seed.start,
                seed.end
            )
        }
        let support = support(
            profile: profile,
            index: index,
            lessonID: lessonID,
            stage: stage,
            sourceIDs: sourceIDs
        )
        let sections = [
            Build.section("Opening question", stage.question),
            Build.section(
                "Learning goal",
                "By the end, you should be able to explain \(profile.lessonTitles[index].lowercased()) within Catholic teaching, identify how \(profile.vice.lowercased()) distorts a real good, judge one concrete situation without assigning culpability, and choose a practice of \(profile.virtue.lowercased()) ordered to love."
            ),
            Build.section("Terms to know", stage.terms.joined(separator: "\n\n")),
            Build.section("Lecture I — The virtue and its proper good", coreTeaching(profile, index)),
            Build.section("Lecture II — Read the capital vice at its root", viceTeaching(profile, stage)),
            Build.section("Lecture III — Judge the concrete moral act", discernmentTeaching(profile, index)),
            Build.section("Lecture IV — Grace, community, and durable formation", formationTeaching(profile, index)),
            Build.section(
                "Misconception check",
                "\(stage.misconception) In this course, \(profile.virtue.lowercased()) never means protecting an image, erasing another person's agency, excusing injustice, or refusing qualified help. Likewise, naming \(profile.vice.lowercased()) does not diagnose a person or establish full culpability. Catholic formation holds objective moral truth together with freedom, knowledge, circumstances, mercy, repair, and the inviolable dignity of the person."
            ),
            Build.section(
                "A case to consider",
                "\(stage.caseStudy) Read the situation through \(profile.virtue.lowercased()) and \(profile.vice.lowercased()). Identify facts, the worthy good underneath the temptation, persons and duties affected, the chosen object, intention, relevant circumstances, unequal power, foreseeable effects, and the smallest faithful next act. Do not invent motives or use the virtue as a label for who is superior."
            ),
            Build.section("Practice before the next lesson", profile.practices[index]),
            Build.section(
                "Prayer",
                "Jesus, heal in me the roots of \(profile.vice.lowercased()) and form the freedom of \(profile.virtue.lowercased()). Give me truth without harshness, mercy without evasion, courage to repair harm, and one faithful next step today."
            ),
        ]

        return Build.lectureLesson(
            id: lessonID,
            title: profile.lessonTitles[index],
            summary: stage.summary,
            sections: sections,
            scripture: encounters,
            remember: reviewPrompts(profile, index: index),
            sourceIDs: sourceIDs,
            formationSupport: support
        )
    }

    private static func coreTeaching(_ profile: Profile, _ index: Int) -> String {
        """
        \(profile.teachings[index])

        The course begins from a Catholic account of virtue. \(profile.virtue) is not a passing feeling, a personality style, or one admired performance. A virtue is a stable readiness of intellect, will, desire, and action for a true human good. Repetition matters because choices gradually make some responses more available, yet habit never turns a person into a machine. Freedom, conscience, circumstances, grace, counsel, and new responsibilities remain active. The learner should therefore ask what good this virtue protects and how that good becomes concrete before asking whether someone appears virtuous.

        \(profile.overview) This definition prevents a merely negative course. The aim is not to think about \(profile.vice.lowercased()) all day, but to become free for worship, communion, responsibility, joy, and service. The contrary virtue redirects a real human capacity rather than destroying it. Confidence, possession, recognition, anger, sexuality, appetite, rest, and achievement can each answer genuine goods. They become dangerous when a limited good is isolated from truth and asked to govern the whole person.

        Because every moral virtue is ordered by prudence and perfected by charity, outward resemblance is not enough. The same visible act can arise from love, fear, vanity, coercion, fatigue, trauma, duty, or a mixture of motives. Catholic moral reasoning attends to what is chosen, why it is chosen, and the relevant circumstances. This lesson offers formation and questions; it does not pronounce another person's heart or calculate the learner's worth.
        """
    }

    private static func viceTeaching(_ profile: Profile, _ stage: Stage) -> String {
        """
        \(profile.whyItMatters) The Catechism calls certain vices capital because they can generate other sins and organize repeated choices around a distorted center. Capital does not mean that every temptation is grave, that one failure defines a person, or that all outward forms carry equal responsibility. It means the root deserves attention because it can teach perception to overlook God, neighbor, duty, and the common good.

        \(stage.lens) Apply that lens specifically to \(profile.vice.lowercased()). First identify the worthy good the vice promises: safety, rest, affection, justice, pleasure, excellence, recognition, or relief. Then identify the false claim: that this good must be secured without limit, immediately, through another person's diminishment, or apart from dependence upon God. Finally trace the fruit. A capital pattern often becomes visible in secrecy, comparison, rationalization, inability to rejoice, transferred burdens, damaged trust, neglected worship, or a narrowing ability to choose otherwise.

        Temptation, passion, consent, habit, and culpability must be distinguished. An unwanted thought or felt movement is not identical with a chosen act. Strong emotion can alert a person to a need or threat without deciding the moral response. Habit, fear, ignorance, addiction, trauma, mental illness, coercion, and other factors may affect freedom and responsibility; only God judges the whole person perfectly. These distinctions do not make harm unreal. They make repentance more truthful by directing spiritual, relational, medical, psychological, legal, recovery, or safeguarding help toward the kind of difficulty actually present.

        The contrary movement of \(profile.virtue.lowercased()) begins before a dramatic act. It appears when the person notices the false promise, remembers the real good, receives enough freedom to pause, and chooses a response that preserves truth and another person's dignity. Small decisions matter because they form attention. They should be concrete and repeatable, but never converted into a private score of holiness.
        """
    }

    private static func discernmentTeaching(_ profile: Profile, _ index: Int) -> String {
        """
        A useful examination starts with facts. Describe the event in sequence and separate observation from interpretation. Name the people affected, including anyone absent or less powerful. State the relationship and role: spouse, friend, worker, employer, parent, child, citizen, minister, owner, guest, caregiver, or recipient. Roles do not determine every answer, but they disclose promises and duties that appetite or self-protection can hide.

        Next name the chosen act in plain language. A good intention cannot make an intrinsically disordered means good, and an unfortunate outcome does not by itself prove a bad intention. Circumstances can increase or diminish responsibility and can make an otherwise good act prudent or imprudent. Ask what \(profile.virtue.lowercased()) would notice that \(profile.vice.lowercased()) prefers not to see: a neighbor's good, a limit, a promise, received grace, an unequal burden, an opportunity for repair, or the need to ask help.

        The Scripture assignments in this lesson must be read as passages rather than slogans. Their movements include \(profile.scripture.map(\.context).joined(separator: " ")) No single verse should be used to force disclosure, preserve danger, shame a body, demand reconciliation, silence lament, or bypass competent care. Read each text within the Catholic canon, the Church's living faith, and the command to love God and neighbor.

        Then choose a proportionate act. \(profile.practices[index]) Preparation may include a sentence rehearsed in advance, a changed environment, a calendar commitment, restitution, a protected channel, sacramental confession, or counsel. If immediate danger, abuse, self-harm, medical instability, addiction, or serious legal or financial harm is present, ordinary reflection yields to appropriate professional, emergency, or safeguarding action. Virtue does not require carrying alone what rightly belongs to a community or competent authority.
        """
    }

    private static func formationTeaching(_ profile: Profile, _ index: Int) -> String {
        let sourceTitles = profile.sources.map(\.title).joined(separator: "; ")
        return """
            Human effort is real, but Christian formation is not self-salvation. Grace precedes, accompanies, heals, elevates, and completes free cooperation. Prayer tells the truth about dependence; Scripture reforms imagination; Eucharist joins the learner to Christ's self-gift; Reconciliation names sin and receives mercy; community supplies examples, correction, patience, and burdens shared. These gifts do not eliminate practice. They make practice a response rather than a manufacture of worth.

            This course is grounded in the Catechism's teaching on human virtue, capital sin, and grace, together with *Gaudete et Exsultate* and the profile's principal sources: \(sourceTitles). Sources perform different roles. The Catechism supplies doctrinal norms; universal-Church teaching offers authoritative pastoral development; Scripture is received as God's word in the Church. The draft remains pending qualified Catholic review, so the source trail is visible and correction remains possible.

            Growth in \(profile.virtue.lowercased()) should be reviewed through fruits rather than appearance. Ask whether truth is easier to face, another person's good more visible, repair more prompt, prayer more honest, help easier to receive, and a faithful response more available under pressure. A setback does not erase real formation. It may reveal an occasion, unsupported burden, unrealistic practice, or wound requiring better care. Return includes naming the act, receiving mercy, repairing reasonable harm, revising the environment, and beginning at the next concrete opportunity.

            Lesson \(index + 1) belongs to a ten-part course, not a closed achievement. Completion records that the material was studied. It does not certify mastery of \(profile.virtue.lowercased()), freedom from \(profile.vice.lowercased()), sanctity, or culpability. The mature goal is a lifelong school in which changing vocations and circumstances repeatedly invite the same movement: receive reality from God, choose the good in love, accept help, and return after failure without denial or self-contempt.
            """
    }

    private static func reviewPrompts(_ profile: Profile, index: Int) -> [String] {
        [
            "How does Catholic teaching define \(profile.virtue.lowercased()) in this lesson?",
            "Which worthy good does \(profile.vice.lowercased()) distort, and what false promise does it make?",
            "Which fact, person, duty, or limit becomes difficult to see under that promise?",
            "How do the assigned Scripture passages correct both indulgence and a counterfeit severity?",
            "What concrete practice joins truth, grace, another person's dignity, and a reviewable next step?",
        ]
    }

    private static func support(
        profile: Profile,
        index: Int,
        lessonID: String,
        stage: Stage,
        sourceIDs: [String]
    ) -> VirtueLessonFormationSupport {
        VirtueLessonFormationSupport(
            workedCaseAnalysis:
                "The case should not be solved by calling one character \(profile.virtue.lowercased()) and another \(profile.vice.lowercased()). Begin with verified facts, roles, and the worthy good each person may be seeking. Identify the act actually proposed, not merely the emotion surrounding it. Test intention and circumstances, especially promises, vulnerability, power, safety, and burdens transferred to others. The faithful response should protect truth and dignity together: name harm without humiliation, preserve agency, make proportionate repair, and use the proper channel. Where the facts suggest medical illness, addiction, coercion, abuse, or serious legal or financial danger, qualified help belongs in the answer. The smallest responsible step is better than a dramatic gesture that creates new harm or protects an image.",
            scriptureSynthesis:
                "The course's five passages approach \(profile.virtue.lowercased()) from complementary directions. \(profile.scripture.map { "\($0.title): \($0.context)" }.joined(separator: " ")) Read together, they do not offer a slogan or personality test. They locate conversion within God's initiative, embodied freedom, truthful relationship, concrete responsibility, and hope. The learner should let the whole movement of each text correct both the vice and a counterfeit virtue that uses religious language to excuse control, passivity, shame, or neglect.",
            scriptureTransferQuestion:
                "Which movement across these passages most directly corrects the false promise of \(profile.vice.lowercased()) in one situation you actually face?",
            witnessTitle: "The Church's living school of \(profile.virtue)",
            witnessBody:
                "The Catechism places stable human virtue inside the larger life of grace, theological virtue, gifts of the Spirit, sacrament, prayer, and communion. The Church's teaching on capital sins names generative roots so conversion can reach beneath isolated symptoms. The profile's sources then apply that tradition specifically to \(profile.virtue.lowercased()). This witness resists a self-improvement project closed upon the individual: growth is received from Christ and becomes visible in truthful responsibility for God and neighbor.",
            supportingSourceIDs: sourceIDs,
            selfExaminationIntroduction:
                "Choose one bounded situation related to this lesson. Examine what happened and the next faithful response; do not decide whether you are generally virtuous, vicious, worthy, or condemned.",
            selfExaminationExample:
                "Example: A familiar trigger led you to protect comfort or image at another person's expense. The examination would distinguish facts, the worthy good sought, the false promise, the chosen act, effects, repair, support, and one prepared alternative.",
            selfExaminationSteps: examinationSteps(
                profile: profile,
                specificExamen: stage.examen
            ),
            knowledgeChecks: checkpointChecks(profile: profile, index: index, lessonID: lessonID)
        )
    }

    private static func examinationSteps(
        profile: Profile,
        specificExamen: String
    ) -> [VirtueSelfExaminationStep] {
        [
            VirtueSelfExaminationStep(
                id: "facts", title: "Name one event",
                question: "What happened in sequence, and what remains interpretation or an unanswered question?",
                guidance:
                    "Record observable actions, words, timing, and reliable reports. Avoid assigning motives, diagnosing a person, or turning a repeated impression into a fact without evidence."
            ),
            VirtueSelfExaminationStep(
                id: "worthy-good", title: "Name the worthy good",
                question:
                    "Which real good, relief, protection, recognition, pleasure, rest, or relationship was being sought?",
                guidance:
                    "Naming the good does not excuse the act. It reveals what \(profile.vice.lowercased()) distorts and what \(profile.virtue.lowercased()) must restore rather than merely suppress."
            ),
            VirtueSelfExaminationStep(
                id: "persons-roles", title: "Name persons and duties",
                question:
                    "Who was affected, and which promise, role, dignity, or responsibility connected each person?",
                guidance:
                    "Include absent and less powerful people. Distinguish a real obligation from a preference, and notice where authority, money, information, reputation, or safety was unequal."
            ),
            VirtueSelfExaminationStep(
                id: "interior", title: "Attend to the interior movement",
                question: "Which thought, desire, emotion, bodily state, and spiritual movement preceded the choice?",
                guidance:
                    "Feelings provide morally relevant information without becoming automatic verdicts. Include fatigue, fear, shame, trauma, illness, compulsion, consolation, and resistance truthfully."
            ),
            VirtueSelfExaminationStep(
                id: "act", title: "Describe the moral act",
                question: "What did I choose, for what intention, and under which relevant circumstances?",
                guidance:
                    "Use plain language. A good intention cannot make a wrongful means good; circumstances and diminished freedom can affect responsibility without erasing objective harm."
            ),
            VirtueSelfExaminationStep(
                id: "vice-fruit", title: "Trace the capital pattern",
                question: "What false promise did \(profile.vice.lowercased()) make, and which fruits followed?",
                guidance:
                    "Look for narrowed attention, secrecy, comparison, control, transferred burdens, neglected worship, damaged trust, or reduced freedom. Do not treat one symptom as a diagnosis."
            ),
            VirtueSelfExaminationStep(
                id: "lesson", title: "Use this lesson's lens",
                question: specificExamen,
                guidance:
                    "Apply the distinction to this event rather than measuring your entire character. Ask what \(profile.virtue.lowercased()) would make visible and possible now."
            ),
            VirtueSelfExaminationStep(
                id: "next", title: "Choose and prepare one response",
                question: "What specific act of truth, restraint, service, repair, or courage belongs next?",
                guidance:
                    "Give the step a verb, person, channel, time, and review point. Prepare the environment or sentence before pressure returns, and preserve legitimate safety boundaries."
            ),
            VirtueSelfExaminationStep(
                id: "grace-help", title: "Receive grace and help",
                question:
                    "Which prayer, sacrament, companion, authority, professional, or emergency resource is needed?",
                guidance:
                    "Human help can cooperate with grace. Do not substitute private reflection for medical, psychological, recovery, legal, safeguarding, or emergency action when serious risk is present."
            ),
        ]
    }

    private static func checkpointChecks(
        profile: Profile,
        index: Int,
        lessonID: String
    ) -> [VirtueKnowledgeCheck] {
        guard [3, 6, 9].contains(index) else { return [] }
        return [
            check(
                "\(lessonID)-definition",
                "Which statement best describes \(profile.virtue.lowercased())?",
                [
                    "A passing feeling or public image",
                    "A stable readiness for a true good, formed through freedom and grace",
                    "The absence of every temptation",
                    "One identical outward rule for everyone",
                ],
                correct: 1,
                explanation:
                    "Virtue is a stable disposition toward the good. It is embodied in concrete acts but cannot be reduced to mood, appearance, or universalized circumstance."
            ),
            check(
                "\(lessonID)-vice",
                "Why is \(profile.vice.lowercased()) called a capital vice?",
                [
                    "Every temptation is equally grave",
                    "It can become a generative root for other sins",
                    "It proves a person has no freedom",
                    "It can be diagnosed from appearance",
                ],
                correct: 1,
                explanation:
                    "Capital describes a root from which other disordered choices may grow. It does not settle gravity, diagnosis, or personal culpability in a particular case."
            ),
            check(
                "\(lessonID)-formation",
                "What is the most faithful response after a failure?",
                [
                    "Hide it until confidence returns",
                    "Adopt the harshest possible rule",
                    "Name it, receive mercy, repair harm, learn the occasion, and begin again",
                    "Treat the completed lesson as proof the failure does not matter",
                ],
                correct: 2,
                explanation:
                    "Christian return rejects denial and self-contempt. Grace supports truth, responsible repair, wiser preparation, appropriate help, and renewed action."
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

    private static func unique(_ values: [String]) -> [String] {
        var seen = Set<String>()
        return values.filter { seen.insert($0).inserted }
    }

    private static let stages: [Stage] = [
        Stage(
            summary: "Learn the virtue's Catholic meaning before trying to measure it in yourself.",
            question:
                "What changes when this virtue is understood as truth and freedom for love rather than a personality trait or impressive act?",
            terms: [
                "Virtue — a stable and freely formed readiness of the person to know, desire, and choose the good.",
                "Moral virtue — a human virtue governing acts and passions according to reason and faith, acquired through practice and healed and elevated by grace.",
                "Habit — a durable disposition that makes a kind of response more available without eliminating freedom.",
                "Charity — the theological virtue that loves God above all and neighbor for God's sake, giving every moral virtue its fullest Christian form.",
            ],
            lens:
                "Begin with definition and final purpose. A beginner easily mistakes a visible style for the virtue: quietness for humility, agreeable behavior for kindness, intensity for diligence, or lack of conflict for patience. The proper question is what good the disposition reliably serves and whether truth, freedom, justice, and charity remain together. A virtue can require different outward actions in different roles while retaining the same interior orientation toward the good.",
            misconception:
                "The virtue is not an inborn temperament, a badge for naturally easy behavior, or a demand to erase strengths and emotions. It can be learned, deepened, wounded, restored, and expressed through different personalities and vocations.",
            caseStudy:
                "A parish volunteer performs a visible behavior associated with the virtue and receives praise, while a quieter prior duty is neglected. Another person questions the choice and is dismissed as less spiritual.",
            examen:
                "Did I seek the proper good of the virtue, or preserve an admired appearance while a less visible truth, duty, or person was overlooked?"
        ),
        Stage(
            summary: "See how the opposing capital vice disorders a real desire and spreads into other choices.",
            question:
                "Which good does this vice promise to secure, and how can that promise become a root that recruits otherwise good abilities?",
            terms: [
                "Capital vice — a recurrent disordered disposition called capital because other sins may grow from it.",
                "Temptation — an invitation or pressure toward sin; temptation itself is not identical with consent.",
                "Consent — the will's participation in a proposed act, which can be affected by knowledge, freedom, habit, fear, or coercion.",
                "Occasion — an internal or external circumstance that predictably makes a particular temptation more likely or resistance more difficult.",
            ],
            lens:
                "Study the vice as a false strategy for a real good. It offers a narrowed route to safety, worth, justice, pleasure, relief, or belonging, then teaches the person to protect that route at growing cost. Intelligence can rationalize it, work can supply it, religion can decorate it, and relationships can be reorganized around it. Tracing this generative movement is more useful than collecting isolated failures because repentance can then address attention, environment, belief, and repair.",
            misconception:
                "Calling a vice capital does not mean every related thought is sinful, every failure is grave, or every person showing an outward behavior has the same interior pattern. The category guides formation; it is not a remote diagnosis or verdict.",
            caseStudy:
                "A person repeatedly chooses a short-term good after a familiar trigger, explains each event as exceptional, and becomes defensive when family members describe a pattern and its effects.",
            examen:
                "Which worthy good and false promise formed this pattern, and which repeated fruit shows that the strategy now harms the very good it claims to protect?"
        ),
        Stage(
            summary: "Protect formation from counterfeits, shame, passivity, and self-serving definitions.",
            question:
                "What counterfeit version of the virtue would look admirable while actually protecting fear, control, superiority, or avoidance?",
            terms: [
                "Counterfeit virtue — conduct resembling a virtue outwardly while its object, motive, means, or effects contradict the true good.",
                "Rigorism — imposing a severity beyond moral truth or prudent circumstance and treating that excess as fidelity.",
                "Permissiveness — calling a harmful or irresponsible choice acceptable in order to avoid truth, conversion, or proportionate boundaries.",
                "Dignity — the worth of every person grounded in creation and vocation in God, never earned by success or lost through weakness.",
            ],
            lens:
                "Every virtue has counterfeits on more than one side. A permissive counterfeit removes difficult truth; a severe counterfeit removes mercy, proportion, or creaturely limits. A self-protective counterfeit performs the expected behavior while avoiding responsibility. Test the proposed virtue by its object, means, and fruits. Does it serve the real good? Preserve another person's dignity and agency? Allow correction? Acknowledge health and safety? Produce truth, communion, responsibility, and peace rather than secrecy, fear, or domination?",
            misconception:
                "Rejecting a counterfeit does not weaken the real virtue. Boundaries, confidence, lament, rest, appropriate pleasure, authority, and professional treatment can all belong to holiness when they serve truth and love.",
            caseStudy:
                "A respected leader defines the virtue in a way that always supports the leader's preferred outcome and treats questions, boundaries, or appeals to competent help as moral failure.",
            examen:
                "Did my definition protect the full good, or did it make another person easier to control, silence, use, shame, or ignore?"
        ),
        Stage(
            summary: "Let the whole movement of biblical passages reshape imagination and judgment.",
            question:
                "What becomes visible when several Scripture passages are read in context instead of using one verse as a slogan?",
            terms: [
                "Context — the literary, historical, canonical, and ecclesial setting needed to understand a passage faithfully.",
                "Canonical reading — receiving a passage within the whole Catholic canon rather than isolating it from the rest of revelation.",
                "Spiritual sense — the meaning of Scripture in Christ and the life of the Church, grounded in rather than opposed to the literal sense.",
                "Lectio divina — prayerful reading that receives, meditates, prays, contemplates, and responds to God's word.",
            ],
            lens:
                "Scripture forms virtue through narrative, command, lament, wisdom, worship, warning, promise, and the person of Christ. Read who acts, what changes, where resistance appears, and which relationships are restored or judged. Compare passages so one text guards another from misuse. A command to forgive cannot erase safeguarding; a call to sacrifice cannot authorize abuse; praise of work cannot condemn needed rest; celebration of creation cannot justify mastery by appetite.",
            misconception:
                "A biblical reading is not a decorative quotation or a shortcut around prudence. Fidelity includes context, Catholic interpretation, the whole moral law, and respect for the person to whom the text is applied.",
            caseStudy:
                "Two people in conflict quote different short verses at one another. Each verse names a real Christian duty, but neither person reads the passage's context or addresses safety, power, prior promises, and actual harm.",
            examen:
                "Did I receive Scripture as a word that judges and converts me, or select a line that gives religious force to the response I already wanted?"
        ),
        Stage(
            summary: "Bring thoughts, desires, emotions, bodily states, and motives into truthful prayer.",
            question:
                "How can honest self-knowledge deepen freedom without turning examination into rumination, shame, or self-absorption?",
            terms: [
                "Passion — an emotion or movement of the sensitive appetite that inclines a person toward perceived good or away from perceived evil.",
                "Motive — a reason or desire moving action; motives can be mixed and require ordering rather than perfect simplicity before action.",
                "Discernment — prayerful judgment of movements and choices under Scripture, Church teaching, vocation, facts, counsel, and their fruits.",
                "Scrupulosity — distressing moral doubt or fear that can require skilled pastoral and mental-health care rather than more private checking.",
            ],
            lens:
                "Interior life is morally significant but not self-interpreting. Feelings can reveal love, fear, grief, desire, fatigue, trauma, or a mistaken judgment. Prayer names them before God and asks what they say and what they cannot decide. Mixed motives do not always require paralysis; one can reject vanity and still perform the duty. Examination should move outward toward truth, worship, neighbor, and action rather than keep the self under endless surveillance.",
            misconception:
                "Virtue does not require emotional numbness, certainty about every motive, or repeated examination until anxiety disappears. Persistent scrupulosity, trauma symptoms, depression, compulsion, or other clinical concerns deserve qualified care.",
            caseStudy:
                "Before an important act, a person notices sincere love mixed with anger and desire for recognition. Fearing impurity of motive, the person considers doing nothing although another person needs a timely response.",
            examen:
                "Which interior movement contains useful truth, which judgment needs correction, and what good act remains possible even while motives are still being purified?"
        ),
        Stage(
            summary: "Practice the virtue where another person's dignity and good are at stake.",
            question:
                "How does this virtue change when the neighbor is treated as a subject with agency rather than material for my self-improvement?",
            terms: [
                "Neighbor — the concrete person whose dignity and good make a claim upon love, including the stranger and enemy.",
                "Common good — social conditions allowing persons and communities to reach fulfillment more fully and readily.",
                "Solidarity — stable commitment to another's good and the common good, willing to share responsibility and cost.",
                "Boundary — a truthful limit on one's participation, access, or responsibility that can protect dignity, vocation, safety, and love.",
            ],
            lens:
                "Virtue becomes visible in relationship. The neighbor is not an audience for goodness, a problem to fix, or a source of merit. Ask what is due, what can be freely given, whose voice is missing, and whether help preserves agency. Love may require welcome, correction, restitution, refusal, advocacy, accompaniment, or distance. Boundaries are evaluated by truth and purpose rather than by whether they avoid all discomfort or produce approval.",
            misconception:
                "Relational virtue is not constant availability, forced reconciliation, enabling, control, or sacrificing another person's privacy for an inspiring story. Charity and justice both require consent, proportion, and safety.",
            caseStudy:
                "Someone offers public help to a vulnerable neighbor without first listening, shares the story for encouragement, and becomes offended when the neighbor asks for privacy and a different form of support.",
            examen:
                "Did my response seek this person's actual good with appropriate consent and responsibility, or use the relationship to secure my comfort, image, influence, or innocence?"
        ),
        Stage(
            summary: "Use small repeated acts to make the good more available in ordinary life.",
            question:
                "What makes a practice genuinely formative instead of performative, severe, vague, or impossible to sustain?",
            terms: [
                "Practice — a concrete repeated act chosen to make a good response more available and intelligent over time.",
                "Asceticism — prudent training in freedom through prayer, discipline, and renunciation ordered to love rather than punishment.",
                "Environment — material and social conditions that cue, support, obstruct, or reshape repeated action.",
                "Review point — a scheduled moment to examine facts and fruits and then retain, revise, seek help, or end a practice.",
            ],
            lens:
                "A good practice names the virtue, context, action, frequency, greater good, affected persons, safeguards, exceptions, and review date. It is small enough to repeat and real enough to cost something. Environment matters: prepare words, time, tools, routes, budgets, food, devices, companions, and accountability before the pressure arrives. External structure supports freedom but cannot replace interior conversion or qualified treatment.",
            misconception:
                "The strictest practice is not necessarily the best, and a streak does not measure holiness. Practices should never contradict medical care, transfer unreasonable burdens, bind another adult without consent, or become material for comparison.",
            caseStudy:
                "A learner adopts several dramatic practices at once, announces them publicly, overlooks household effects, and abandons all of them after an ordinary disruption breaks the streak.",
            examen:
                "Was the practice specific, proportionate, supported, and ordered to a greater love, or designed mainly to produce intensity, control, admiration, or a perfect record?"
        ),
        Stage(
            summary: "Meet temptation, failure, discouragement, and repair without surrender or self-contempt.",
            question:
                "What does Christian return look like after failure when neither denial nor shame is allowed to become the plan?",
            terms: [
                "Contrition — sorrow for sin with rejection of the evil chosen and desire for forgiveness and changed life.",
                "Confession — truthful acknowledgment of sin; sacramental Confession receives absolution and includes satisfaction according to the Church's practice.",
                "Reparation — action answering damage done to truth, property, reputation, relationship, or another good as far as reasonably possible.",
                "Perseverance — continued fidelity through time, difficulty, delay, and repeated return rather than an unbroken appearance of success.",
            ],
            lens:
                "A failure is named specifically enough for mercy and repair. Avoid euphemism, but do not turn the act into an identity. Address immediate safety, confess where appropriate, correct falsehood, restore what is owed, and learn the occasion. Repair must consider the harmed person's agency and may require counsel; direct contact can be unsafe or self-serving. Resume at the next faithful opportunity rather than demanding a dramatic future restart.",
            misconception:
                "Mercy is not pretending harm did not occur, and contrition is not self-hatred. Forgiveness does not automatically restore trust, access, office, or relationship, and a harmed person is not responsible for proving another's conversion.",
            caseStudy:
                "After repeating a harmful act, a person alternates between excuses and sweeping declarations of worthlessness. An apology demands immediate reassurance but offers no repair, safeguard, or changed environment.",
            examen:
                "Have I named the act without excuse or self-condemnation, protected those affected, received mercy, made proportionate repair, and changed the conditions of the next choice?"
        ),
        Stage(
            summary: "Receive growth as cooperation with grace rather than a private feat of willpower.",
            question:
                "How do grace, freedom, sacrament, community, and ordinary professional help cooperate without competing?",
            terms: [
                "Grace — God's free and undeserved help and participation in divine life, healing and elevating the person for communion with him.",
                "Justification — God's merciful work freeing from sin and giving a new life of grace, received in faith and Baptism and lived through cooperation.",
                "Sacrament — an efficacious sign of grace instituted by Christ and entrusted to the Church.",
                "Communion — shared life in Christ that makes formation ecclesial rather than isolated, including worship, responsibility, correction, and mutual care.",
            ],
            lens:
                "Grace does not humiliate human agency; it creates and heals the freedom by which a person can respond. Practice, planning, treatment, education, and accountability remain real forms of cooperation. Prayer without responsible action can become evasion, while effort without dependence can become pride or despair. Sacraments join the person to Christ and the Church; they are not techniques for controlling outcomes or substitutes for medical, psychological, legal, recovery, and safeguarding competence.",
            misconception:
                "Depending on grace is not passivity, and receiving ordinary help is not weak faith. No person earns divine love through performance, and no course can certify sanctity or replace the Church's sacramental and pastoral life.",
            caseStudy:
                "A learner prays sincerely about a persistent pattern but refuses treatment, accountability, or environmental safeguards because needing them seems to contradict trust in God.",
            examen:
                "Am I cooperating with grace through the truthful human means available, or using either spirituality or self-reliance to avoid dependence, responsibility, and help?"
        ),
        Stage(
            summary: "Build a sustainable rule of life and continue after the course ends.",
            question:
                "How can a rule preserve lifelong growth without becoming control, a holiness score, or a substitute for vocation?",
            terms: [
                "Rule of life — a flexible and reviewable pattern of prayer, relationship, work, rest, service, and support ordered to vocation.",
                "Vocation — God's call to holiness and the concrete form of love and responsibility through which a person answers him.",
                "Fruit — a real effect of formation such as greater truth, freedom, peace, patience, responsibility, repair, worship, or charity.",
                "Lifelong formation — continuing conversion through changing duties and seasons rather than completing virtue as a finished credential.",
            ],
            lens:
                "A sustainable rule begins with vocation and a larger yes. Select a few practices that protect worship, persons, duties, health, rest, service, and joy. For each, name purpose, measure, triggers, preparation, legitimate exceptions, support, and review. Include sacramental and communal rhythms. Review by fruits and changed circumstances. Keep what serves love, revise what is unrealistic, and retire a practice whose season has ended without treating change as failure.",
            misconception:
                "Finishing the course records study, not mastery. A rule is not a total-control system, and quantities cannot measure charity, culpability, or worth. Mature formation remains teachable and revisable.",
            caseStudy:
                "At the course's end, a learner writes an elaborate permanent rule for every domain of life, leaves no exceptions for illness or caregiving, and interprets the first disrupted week as proof that nothing was learned.",
            examen:
                "Does my rule protect the concrete goods of vocation and remain open to grace, counsel, limits, and revision, or has control and measurement replaced love?"
        ),
    ]
}

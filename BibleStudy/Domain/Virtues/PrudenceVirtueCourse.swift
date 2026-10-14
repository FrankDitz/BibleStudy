import Foundation

enum PrudenceVirtueCourse {
    private typealias Sources = VirtueCurriculumSources
    private typealias Build = VirtueCurriculumBuilder

    static let course = Build.course(
        id: "cardinal-prudence",
        collection: .cardinal,
        virtueID: .prudence,
        title: "Prudence",
        subtitle: "See the true good and choose the fitting way toward it",
        overview:
            "Prudence is practical wisdom: reason attentive to truth, moral principle, persons, circumstances, counsel, consequences, prayer, and timely action. It is the charioteer of the moral virtues because it helps every good intention become a fitting concrete choice.",
        whyItMatters:
            "Sincerity alone cannot guarantee a wise act. We can pursue a partial good, use unjust means, wait too long, act too quickly, or call fear prudence. This course teaches a complete discernment that ends in responsible action rather than anxiety.",
        systemImage: "eye.circle",
        lessons: lessons,
        sources: [
            Sources.catechismHumanVirtues,
            Sources.catechismFreedom,
            Sources.popePrudence,
            Sources.popeGrace,
            Sources.gaudete,
            Sources.rickaby,
        ]
    )

    private static let lessons: [VirtueStudyLesson] = [
        Build.lesson(
            id: "prudence-true-good",
            title: "Right reason in action",
            summary: "Begin prudence by naming the true good rather than merely an efficient plan.",
            terms: [
                "Prudence - the virtue that disposes practical reason to discern the true good and choose fitting means.",
                "End - the good or goal for the sake of which an action is chosen.",
                "Means - the actions used to reach an end; a good end cannot justify an evil means.",
            ],
            teaching:
                "Prudence is not vague common sense, caution, or private cleverness. It is moral reason at work in a concrete situation. The prudent person asks what good is truly at stake, which duties and principles apply, and which morally sound action can serve that good here and now. The first question must concern the end. An efficient plan toward a selfish, dishonest, or unjust end is not prudent. Nor does a sincere intention purify a means that violates another person's dignity. Prudence receives moral truth and applies it without pretending that general rules eliminate the need to understand circumstances.",
            distinction:
                "An apparent good attracts but cannot withstand truthful examination. Immediate relief, approval, profit, or victory may be real partial goods while still damaging vocation, justice, or communion. Prudence orders partial goods rather than denying that they attract.",
            witness:
                "The Catechism calls prudence 'right reason in action' and the charioteer of the virtues. Rickaby develops that classical insight through practical examples, while Pope Francis emphasizes that prudence belongs to intelligence and freedom rather than to paralysis.",
            caseStudy:
                "A manager can hide a mistake and protect the team's quarterly result. The plan is likely to work. Ask: what end is being chosen, which goods are partial, which duties remain, and why does successful concealment still fail prudence?",
            practice:
                "Take one decision and write two sentences: 'The good I seek is...' and 'The means I am considering are...' Test the means independently rather than letting urgency or a good intention excuse them.",
            prayer:
                "God of wisdom, purify the ends I seek and the means I choose. Give me practical reason ready to serve truth, justice, and love.",
            scripture: [
                Build.encounter(
                    "prudence-build", "Count the cost",
                    "Jesus uses the image of a builder who considers what a faithful undertaking requires.",
                    "LUKE", 14, 28, 33)
            ],
            remember: [
                "Why must prudence begin with the true good?",
                "Can a good intention justify an evil means?",
                "What partial good most easily distracts you from the whole good?",
            ],
            sourceIDs: [
                Sources.catechismHumanVirtues.id, Sources.popePrudence.id, Sources.rickaby.id,
            ]
        ),
        Build.lesson(
            id: "prudence-reality",
            title: "Attend to reality",
            summary: "Learn to separate facts, interpretations, wishes, fears, and missing information.",
            terms: [
                "Circumstance - a relevant feature of who, when, where, how, or with what consequences an act occurs.",
                "Practical truth - reality known sufficiently for responsible action, not impossible certainty about everything.",
            ],
            teaching:
                "Prudence cannot guide a person who refuses to see. It needs attention to facts, remembered experience, the people affected, available resources, limits, timing, and foreseeable consequences. Wishful thinking can minimize risk; fear can exaggerate it. Resentment can present an interpretation as a fact; eagerness can hide inconvenient evidence. Truthful attention does not promise total certainty. It gathers information proportionate to the stakes and remains willing to revise an assumption when reality contradicts it.",
            distinction:
                "Suspicion is not insight, and information volume is not wisdom. Endless research may become a way to avoid responsibility. Prudence asks which facts could genuinely change the choice and which searches only postpone it.",
            witness:
                "Solomon asks for an understanding heart able to distinguish good from evil in governing real people. His request recognizes both responsibility and limitation: wisdom begins when the decision-maker stops pretending to know enough alone.",
            caseStudy:
                "A friend has not replied for two days. 'She is angry with me' feels certain, but it remains an interpretation. What facts are known? What alternatives are possible? What proportionate inquiry respects both friendship and uncertainty?",
            practice:
                "Make two columns for one decision: known facts and untested interpretations. Circle the two missing facts that would most affect action and identify a respectful way to learn them.",
            prayer:
                "Lord, free me from wishful thinking, fear, and the need to be right. Give me courage to see reality as it is and humility to learn what I do not know.",
            scripture: [
                Build.encounter(
                    "prudence-solomon", "An understanding heart",
                    "Solomon asks for wisdom adequate to the people and responsibility entrusted to him.",
                    "1KGS", 3, 5, 14)
            ],
            remember: [
                "How do facts differ from interpretations?",
                "Why is impossible certainty not required for prudence?",
                "Which missing fact would actually change your decision?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.popePrudence.id]
        ),
        Build.lesson(
            id: "prudence-counsel",
            title: "Memory, docility, and counsel",
            summary: "Let experience and trustworthy people enlarge what you can see.",
            terms: [
                "Docility - teachability before truth, not passive agreement with every opinion.",
                "Counsel - advice sought from someone morally trustworthy, competent, and sufficiently informed.",
            ],
            teaching:
                "A prudent person learns from remembered experience without assuming every new case is identical to an old one. Memory should be honest: neither rewriting failure nor letting one wound dictate the future. Because no individual possesses every kind of knowledge, prudence also requires docility. Good counsel may supply moral clarity, technical expertise, knowledge of a person, or freedom from the seeker's blind spot. Choosing counsel is itself an act of prudence. Popularity, confidence, affection, or agreement are not enough; the counselor should be trustworthy and relevantly informed.",
            distinction:
                "Docility is neither gullibility nor outsourcing conscience. Advice assists judgment; it does not remove the person's responsibility to seek truth and choose. Asking many people until someone approves a preferred answer is reassurance-seeking, not counsel.",
            witness:
                "Jethro observes Moses exhausting himself and the people. His counsel joins concern, experience, delegation, and the condition that Moses discern the advice before God. Wise reception does not diminish Moses' vocation; it helps him fulfill it.",
            caseStudy:
                "A person seeks marriage advice only from a coworker who has heard one angry version of events. What knowledge is missing? Who might offer morally serious, relationally informed, and appropriately confidential counsel?",
            practice:
                "Choose one counselor for one precise question. Before asking, write why this person is competent, trustworthy, and sufficiently informed. Afterward, summarize the advice without deciding merely from emotional relief.",
            prayer:
                "God, protect me from private cleverness and from surrendering responsibility. Give me honest memory, a teachable spirit, and wise companions.",
            scripture: [
                Build.encounter(
                    "prudence-jethro", "Counsel that serves vocation",
                    "Notice Jethro's observation, concern, proposal, and invitation to discern before God.",
                    "EXOD", 18, 13, 24)
            ],
            remember: [
                "What makes counsel trustworthy?",
                "How does docility differ from gullibility?",
                "Are you seeking truth or permission?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.rickaby.id]
        ),
        Build.lesson(
            id: "prudence-conscience",
            title: "Forming and following conscience",
            summary: "Distinguish conscience from preference, emotion, approval, and private certainty.",
            terms: [
                "Conscience - a judgment of reason recognizing the moral quality of a concrete act.",
                "Formation - the lifelong education of conscience through truth, Scripture, Church teaching, prayer, counsel, and practice.",
            ],
            teaching:
                "Conscience is not a feeling that an action is comfortable, nor a license to declare personal preference morally final. It is reason's judgment about what should be done or avoided in a concrete case. A person must follow a certain judgment of conscience, yet also carries the duty to form conscience rather than preserve convenient ignorance. Formation requires humility before moral truth, serious attention to Church teaching, Scripture read in communion, prayer, examination of motives, and counsel appropriate to difficult cases.",
            distinction:
                "A formed conscience is not the same as a loud inner voice or freedom from anxiety. Scrupulosity may produce intense false alarms; rationalization may produce calm approval. Emotional intensity cannot substitute for truth. Persistent or grave uncertainty belongs with qualified pastoral guidance rather than endless private checking.",
            witness:
                "Paul asks Christians to be transformed by renewal of the mind so they may discern what is good. Discernment is therefore not self-authorization. It is the mind being converted and educated within life in Christ.",
            caseStudy:
                "Someone says, 'My conscience says it is fine,' but refuses to learn what the Church teaches or to hear the people harmed. Another fears every minor imperfection is grave sin. What formation does each need?",
            practice:
                "For one case, write the moral principle, concrete facts, duties, people affected, and authoritative teaching involved. Note where emotion is useful information and where it is trying to become the verdict.",
            prayer:
                "Holy Spirit, form my conscience in truth. Deliver me from both self-authorization and fear, and make me ready to obey the good I come to know.",
            scripture: [
                Build.encounter(
                    "prudence-renew-mind", "A renewed mind",
                    "Paul links transformed thinking with discernment and embodied self-offering.",
                    "ROM", 12, 1, 2)
            ],
            remember: [
                "What is conscience?",
                "Why must conscience be formed?",
                "Why can neither calm nor anxiety prove a judgment true?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.catechismFreedom.id]
        ),
        Build.lesson(
            id: "prudence-deliberation",
            title: "Deliberation without paralysis",
            summary: "Compare morally sound options with care proportionate to the stakes.",
            teaching:
                "Once the good, principles, and facts are clear enough, prudence compares available means. Deliberation asks which options are morally permissible, which duties have priority, who depends on the decision, what consequences are foreseeable, and what resources or risks each path carries. Serious stakes justify greater care; ordinary choices do not require a tribunal. The goal is not to predict every outcome but to make a responsible judgment under real limits. A deadline can serve prudence when further delay no longer yields meaningful truth.",
            distinction:
                "Perfectionism demands an option with no loss, uncertainty, criticism, or possibility of regret. Prudence often chooses among good but limited paths. Indecision can become a decision that burdens others while protecting the chooser from responsibility.",
            witness:
                "Jesus' image of counting the cost does not commend endless planning. The builder and king consider what the undertaking requires precisely so a real commitment can be made with open eyes.",
            caseStudy:
                "Two morally legitimate jobs differ in pay, time, service, and family impact. No option maximizes every good. What criteria deserve greatest weight, and when would more research stop being useful?",
            practice:
                "List no more than three morally acceptable options. Give each the same four headings: duties served, people affected, foreseeable benefits and harms, and facts still capable of changing the judgment. Set a fitting decision time.",
            prayer:
                "Lord of providence, free me from demanding control over every outcome. Help me deliberate honestly and accept the limits that accompany responsible choice.",
            scripture: [
                Build.encounter(
                    "prudence-cost", "Deliberation ordered to commitment",
                    "Read Christ's examples of counting the cost within his larger call to discipleship.",
                    "LUKE", 14, 25, 33)
            ],
            remember: [
                "What makes deliberation proportionate?",
                "How can perfectionism disguise itself as prudence?",
                "When does delay become a choice of its own?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.popePrudence.id]
        ),
        Build.lesson(
            id: "prudence-command",
            title: "Judgment that becomes action",
            summary: "Complete discernment by commanding and carrying out the fitting act.",
            teaching:
                "Prudence is incomplete if judgment never reaches action. After counsel and deliberation, practical reason judges what should be done and commands the act. This command is not domination of other people; it is the inner movement from 'this is right' to 'do it now.' Fear, fatigue, the wish to remain blameless, or attraction to more options can interrupt that movement. Timely action accepts responsibility while remaining teachable. If new facts reveal an error, prudence also permits revision, apology, or repair.",
            distinction:
                "Impulsiveness skips truthful judgment; paralysis refuses to act after sufficient judgment. Decisiveness is neither speed nor stubbornness. It is action at the time appropriate to the good and the people depending on it.",
            witness:
                "Jesus calls the person who hears and acts wise, like a builder on rock. Wisdom is not admiration of the teaching. Its stability appears when truth becomes practiced obedience.",
            caseStudy:
                "You know a bill is owed, have the funds, and have already confirmed the amount, but keep revisiting whether this is the best week to pay. What judgment is already complete, and what small act would make it real?",
            practice:
                "Identify one decision that has enough light. State the judgment in one sentence and take the smallest action that genuinely commits to it today.",
            prayer:
                "God, give me courage to do the good I already know. Keep my action timely, responsible, and ready for correction.",
            scripture: [
                Build.encounter(
                    "prudence-wise-builder", "Hear and act",
                    "Jesus identifies wisdom with hearing his words and putting them into practice.",
                    "MATT", 7, 24, 27)
            ],
            remember: [
                "Why is action part of prudence?",
                "How does decisiveness differ from impulsiveness?",
                "Which decision already has enough light?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.popePrudence.id]
        ),
        Build.lesson(
            id: "prudence-foresight",
            title: "Foresight, timing, and gradualness",
            summary: "Anticipate foreseeable effects without pretending to control the future.",
            teaching:
                "Prudence looks ahead. It considers how an action may affect persons, promises, resources, habits, scandal, safety, and future freedom. Foresight is not fortune-telling; it identifies consequences a reasonable person can anticipate. Timing belongs here too. A true word may need privacy and preparation; a danger may require immediate action. Pope Francis warns that excessive zeal can damage a good work that requires gradual development. Prudence respects growth without using gradualness to postpone a clear obligation forever.",
            distinction:
                "Catastrophizing imagines remote harms as certainties. Carelessness ignores probable harms because the immediate act feels good. Foresight holds possibility and probability in proportion and prepares for what can reasonably be prevented.",
            witness:
                "Joseph receives wisdom to prepare Egypt during abundance for a coming famine. His plan is neither panic nor passive trust. It joins foresight, administration, restraint, and service to people who will depend on stored grain.",
            caseStudy:
                "A truthful correction is needed, but giving it publicly tonight would humiliate the person and inflame a group. Delay until a private conversation tomorrow is possible. Is that cowardice or prudent timing? What would turn the delay into avoidance?",
            practice:
                "Write a brief pre-mortem for one good plan: 'If this failed through my choices, what likely went wrong?' Add one proportionate safeguard and one date for review.",
            prayer:
                "Provident Father, teach me to prepare without fear, to act without haste, and to respect the patient way good work often grows.",
            scripture: [
                Build.encounter(
                    "prudence-joseph", "Wisdom that prepares",
                    "Joseph interprets, plans, stores, and serves through years of abundance and famine.",
                    "GEN", 41, 33, 40)
            ],
            remember: [
                "How does foresight differ from prediction?",
                "Why can timing change the fitting form of an act?",
                "When is gradualness wise, and when is it avoidance?",
            ],
            sourceIDs: [Sources.popePrudence.id, Sources.catechismHumanVirtues.id]
        ),
        Build.lesson(
            id: "prudence-prayer",
            title: "Prayerful discernment",
            summary: "Let communion with God purify attention, motive, counsel, and readiness.",
            teaching:
                "Prayer does not replace facts, doctrine, counsel, or action. It places all of them before God. In prayer a person can become more honest about hidden motives, receive Scripture rather than use it as a slogan, ask for wisdom, relinquish the demand for control, and become willing to obey an answer that costs something. Peace may accompany discernment, but emotional peace alone is not proof; difficult duties can remain frightening. Prayer serves prudence by deepening truth and freedom.",
            distinction:
                "A private impression should not be called God's command merely because it arrived during prayer. Genuine discernment remains accountable to revealed truth, moral teaching, vocation, duties, reality, and wise counsel. God does not inspire an action contrary to goodness.",
            witness:
                "James invites those lacking wisdom to ask God in faith. Christian asking is not a technique for extracting certainty. It is dependence upon a generous Father joined to a readiness to live the wisdom received.",
            caseStudy:
                "A person says prayer produced permission to abandon a serious promise without conversation or repair. Which objective duties and relationships must still be examined before treating the impression as discernment?",
            practice:
                "Pray one decision in four movements: thank God for known goods; confess fear or attachment; ask for wisdom and freedom; remain silent, then write the next truthful act rather than a prediction of the whole future.",
            prayer:
                "Speak, Lord, for your servant is listening. Purify my motives and make me willing to follow truth even when it is not the answer I preferred.",
            scripture: [
                Build.encounter(
                    "prudence-ask-wisdom", "Ask God for wisdom",
                    "James directs the person who lacks wisdom toward trusting petition and steadfast faith.",
                    "JAS", 1, 5, 8)
            ],
            remember: [
                "What does prayer contribute to prudence?",
                "Why is emotional peace not a complete test?",
                "To what objective truths must a private impression remain accountable?",
            ],
            sourceIDs: [Sources.popePrudence.id, Sources.gaudete.id]
        ),
        Build.lesson(
            id: "prudence-counterfeits",
            title: "Prudence and its counterfeits",
            summary: "Separate wisdom from fear, calculation, respectability, and manipulation.",
            teaching:
                "Several habits borrow prudence's name. Timidity calls every risk unwise. Cunning finds efficient means toward a selfish end. Worldly calculation protects status while neglecting conscience. Respectability treats social approval as moral truth. Indecision demands impossible certainty. Rash confidence refuses counsel because hesitation feels weak. Genuine prudence serves the integral good and remains joined to justice, fortitude, temperance, faith, hope, and charity.",
            distinction:
                "Prudence can recommend risk, sacrifice, protest, generosity, or a costly truth when the good requires it. It can also recommend waiting or withdrawal. The test is not whether an action appears bold or safe but whether truthful reason directs fitting means toward a worthy end.",
            witness:
                "Jesus tells the disciples to be wise as serpents and innocent as doves. Wisdom and purity of intention belong together. Strategy detached from innocence becomes manipulation; innocence detached from wisdom can become avoidable naivete.",
            caseStudy:
                "A colleague recommends silence about exploitation because speaking could damage your prospects. Another urges an immediate public accusation without verifying facts. Which counterfeit appears in each response, and what would prudent courage require?",
            practice:
                "Name the counterfeit most likely to impersonate prudence in your life. Write its usual sentence, then answer it with a sentence joining truth, justice, courage, and charity.",
            prayer:
                "Jesus, make me wise and innocent. Expose the fear and self-interest that imitate prudence, and give me clean judgment in service of love.",
            scripture: [
                Build.encounter(
                    "prudence-serpents-doves", "Wise and innocent",
                    "Jesus prepares disciples for danger without authorizing either naivete or manipulation.",
                    "MATT", 10, 16, 20)
            ],
            remember: [
                "Name three counterfeits of prudence.",
                "Can prudence require a costly risk?",
                "Why must wisdom and innocence remain together?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.popePrudence.id]
        ),
        Build.lesson(
            id: "prudence-practice",
            title: "Capstone: a complete discernment",
            summary: "Bring one real decision from the true good through counsel, judgment, action, and review.",
            teaching:
                "A complete discernment names the good, identifies moral principles and duties, gathers proportionate facts, listens to experience and counsel, prays honestly, generates morally sound options, anticipates effects, judges, commands action, and reviews the result. The sequence is not a rigid algorithm. Urgent danger may shorten it; grave and complex decisions may need time and specialized advice. Its purpose is to keep a single attractive feature from silently controlling the whole choice.",
            distinction:
                "Completion does not mean certainty about every outcome. It means enough truthful work to act responsibly and remain ready to learn. If the action harms someone, review asks whether the harm was foreseen, avoidable, disproportionate, or in need of repair.",
            witness:
                "Mary's response to the Annunciation includes attention, a truthful question, reception of God's word, free consent, and prompt action. Her prudence is neither suspicious refusal nor unthinking passivity; it is intelligent faith ready for mission.",
            caseStudy:
                "Apply the entire course to a decision that will affect at least one other person. If the issue is grave, dangerous, clinical, legal, or sacramental, the capstone should identify proper counsel rather than offer a private final answer.",
            practice:
                "Write a one-page discernment: true good; duties; facts and interpretations; counsel; prayer; acceptable options; foreseeable effects; judgment; first act; and review date. Carry out the first act.",
            prayer:
                "God of counsel, gather everything I have learned into faithful action. Keep me teachable after I choose and ready to repair whatever truth reveals.",
            scripture: [
                Build.encounter(
                    "prudence-mary", "Intelligent faith and prompt action",
                    "Notice Mary's attention, question, consent, and movement into concrete service.",
                    "LUKE", 1, 26, 45)
            ],
            remember: [
                "What are the principal movements of a complete discernment?",
                "What does responsible completion mean when certainty is impossible?",
                "What is your first real action and review date?",
            ],
            sourceIDs: [
                Sources.catechismHumanVirtues.id, Sources.popePrudence.id, Sources.gaudete.id,
            ]
        ),
    ]
}

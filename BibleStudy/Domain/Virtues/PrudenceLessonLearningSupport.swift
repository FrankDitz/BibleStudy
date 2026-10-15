import Foundation

/// Authored reasoning, Scripture integration, examination, and checkpoints for the
/// complete Prudence course. The supports teach a process; they do not infer guilt.
enum PrudenceLessonLearningSupport {
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
                question: "What happened, in the order it happened?",
                guidance:
                    "Record what you directly observed, said, did, or reliably know. Keep interpretations and guesses separate until the evidence for them can be tested."
            ),
            VirtueSelfExaminationStep(
                id: "true-good",
                title: "Name the true good",
                question: "Which genuine good, person, promise, or duty was at stake?",
                guidance:
                    "Include partial goods such as relief, approval, safety, or success, then ask how they should be ordered within truth, justice, love, and your actual vocation."
            ),
            VirtueSelfExaminationStep(
                id: "inner-movement",
                title: "Notice what moved you",
                question: "Which emotion, desire, fear, pressure, habit, or wound was active?",
                guidance:
                    "Treat interior movements as meaningful information rather than automatic commands. Notice where a free response became possible without condemning an involuntary reaction."
            ),
            VirtueSelfExaminationStep(
                id: "moral-act",
                title: "Describe the choice",
                question: "What act did you choose, why, and in which relevant circumstances?",
                guidance:
                    "Use plain language for the moral object, intention, and circumstances. Avoid flattering labels that hide the action or global labels that condemn the whole person."
            ),
            VirtueSelfExaminationStep(
                id: "counsel-and-conscience",
                title: "Test conscience and counsel",
                question: "Which moral truth and trustworthy counsel should inform this judgment?",
                guidance:
                    "Recall Scripture and the Church's teaching, then identify any pastoral, relational, technical, legal, medical, or clinical competence the situation genuinely requires."
            ),
            VirtueSelfExaminationStep(
                id: "effects",
                title: "Trace effects and duties",
                question: "Whom did the choice affect, and what foreseeable consequences followed?",
                guidance:
                    "Include effects you did not intend, obligations that already existed, and what delay changed. Do not claim responsibility for outcomes no reasonable person could foresee."
            ),
            VirtueSelfExaminationStep(
                id: "lesson-connection",
                title: "Use this lesson's lens",
                question: specificExamen,
                guidance:
                    "Apply the lesson's central distinction to this single situation. Seek clearer understanding and a faithful response, not a perfect answer or a numerical judgment of yourself."
            ),
            VirtueSelfExaminationStep(
                id: "next-step",
                title: "Choose the next faithful step",
                question: "What is the smallest concrete action that genuinely serves the good now?",
                guidance:
                    "Give the action a verb, person, and time. It may be truth-telling, counsel, a boundary, preparation, prayer, or another fitting act rather than a dramatic gesture."
            ),
            VirtueSelfExaminationStep(
                id: "repair-and-help",
                title: "Repair and receive help",
                question: "What repair, grace, safeguard, or human help is needed?",
                guidance:
                    "Consider apology, restitution, changed practice, Confession, spiritual direction, professional care, or a safety process. Use only the help appropriate to the actual situation."
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
        "prudence-true-good": make(
            analysis:
                "The manager's first duty is to stop describing concealment as protection. Replacing the file secretly would choose deception, even if jobs and reputation are real goods. Prudence begins by naming the complete good: the client needs reliable information, the team deserves truthful and proportionate leadership, and the manager must accept responsibility. She should verify the error and its effect, consult any contractual or professional obligations, notify the appropriate internal authority, and correct the client without exposing employees unnecessarily. Consequences to the contract matter when planning timing, communication, and repair; they cannot turn deception into an acceptable means. If uncertainty remains about disclosure duties, qualified legal or professional counsel should clarify how truth is owed, not whether a knowingly false record may stand.",
            synthesis:
                "Luke 14 places calculation inside costly discipleship: the builder and king must face what commitment requires. Wisdom 8 orders honor, wealth, health, and practical government beneath the gift of wisdom. Matthew 7 contrasts paths, fruits, speech, and foundations, ending with the person who hears and acts. Together the readings show that prudence does not merely improve execution. It chooses a life-giving end, tests means by truth, and carries Christ's teaching into action even when a clever shortcut appears safer.",
            transfer:
                "Where are you asking whether a plan will succeed before asking whether the act itself is truthful and just?",
            witnessTitle: "Christ, the wise builder's foundation",
            witnessBody:
                "Jesus does not present wisdom as verbal mastery or successful appearance. In Matthew 7, the wise person receives his words and builds by doing them. Storms still come, so prudence is not a promise of painless outcomes. The stable foundation is obedient truth embodied before pressure arrives. Christ therefore remains both teacher and measure: practical intelligence becomes Christian wisdom when it serves the life he reveals.",
            sourceIDs: [VirtueCurriculumSources.catechismHumanVirtues.id],
            examenIntroduction:
                "Choose one recent decision in which efficiency, relief, approval, or self-protection competed with a larger good. Examine one concrete act rather than trying to evaluate your character as a whole.",
            examenExample:
                "Example: A worker notices an error before a deadline and considers hiding it so the team will not look careless. The examination would name the value of timely work, identify concealment as a separate chosen means, and seek a truthful correction that limits avoidable harm.",
            specificExamen:
                "Did I name the whole true good, or did one attractive partial good become the standard that excused my means?"
        ),
        "prudence-reality": make(
            analysis:
                "The friend's silence is a fact; anger, rejection, and lack of care remain interpretations. The hurt and fear are real interior events, but they do not establish the friend's motive. A prudent response first checks whether there is reason to fear for safety. If not, it can send one direct, non-accusing message and allow proportionate time, perhaps naming the practical deadline if an answer is needed. Past patterns may supply context without proving this instance. The cutting message would act on an untested story and create a new injury. If later evidence confirms avoidance or hostility, prudence can address that pattern plainly. Charity does not require pretending repeated facts are harmless; it requires judging them without inventing what is not known.",
            synthesis:
                "Solomon asks for an understanding heart because judgment serves real people and exceeds private confidence. Proverbs warns against answering before hearing and shows that a first account may change when examined. Jesus asks his listeners to interpret the present time and move toward reconciliation. The passages join humility, evidence, speech, and timely action. Attention to reality is not detached observation: the purpose of seeing accurately is to judge and respond in a way that serves persons before assumption hardens into harm.",
            transfer:
                "Which conflict in your life would look different if you separated what you observed from the motive you assigned?",
            witnessTitle: "Solomon's request for an understanding heart",
            witnessBody:
                "At the beginning of his rule, Solomon does not ask first for victory or personal security. He recognizes the weight of governing a people he cannot adequately judge by his own resources and asks for a listening heart able to distinguish good from evil. Whatever later failures belong to his story, this prayer witnesses to the starting posture of prudence: responsibility joined to acknowledged limitation and receptive wisdom.",
            sourceIDs: [VirtueCurriculumSources.popePrudence.id],
            examenIntroduction:
                "Choose one emotionally charged interaction in which you made a quick judgment about another person's motive. The purpose is not to force a favorable interpretation but to make every conclusion answer to evidence.",
            examenExample:
                "Example: A colleague passes without greeting, and you conclude that she is deliberately disrespectful. The examination would record the observable event, acknowledge embarrassment or anger, list plausible meanings, and decide whether a simple question or a repeated pattern justifies further action.",
            specificExamen:
                "Which part of my account is observed fact, which part is interpretation, and what missing information could genuinely change my judgment?"
        ),
        "prudence-counsel": make(
            analysis:
                "The coworker's support may be sincere, but the adviser lacks a full account, relational knowledge, and necessarily any competence in marital or pastoral care. Asking more groups until one agrees turns counsel into permission-shopping. The man should first calm the immediate conflict, record facts from interpretation, and include his own conduct honestly. A trustworthy friend may support accountability; a qualified therapist may help the couple understand patterns and safety; a priest may address sacramental, moral, and spiritual questions. None should be used to expose private details for entertainment or to manufacture a verdict. If abuse or danger is present, safety and specialized assistance take priority. Advice should illuminate reasons and options while the person remains responsible for the judgment and action.",
            synthesis:
                "Exodus 18 presents counsel with remarkable completeness: Jethro observes strain, names harm, proposes delegation, and leaves Moses responsible before God. Proverbs 11 connects reliable guidance with restrained speech, while Proverbs 15 joins plans, correction, humility, justice, and reverence. Counsel therefore requires more than agreement. It needs an honest account, a fitting adviser, moral seriousness, and a teachable recipient. Wisdom received from another should strengthen vocation and the common good rather than create dependence or gossip.",
            transfer:
                "For your present question, who possesses the moral trustworthiness, relevant competence, and sufficient information that wise counsel actually requires?",
            witnessTitle: "Jethro, Moses, and counsel that shares a burden",
            witnessBody:
                "Jethro sees what Moses cannot see clearly from inside an exhausting role: the current pattern will wear out both leader and people. He does not seize authority or flatter Moses. He offers reasons, a concrete structure, moral qualifications for helpers, and the condition that Moses discern before God. Moses' willingness to listen does not weaken his leadership; docility enables him to govern more faithfully.",
            sourceIDs: [VirtueCurriculumSources.rickaby.id],
            examenIntroduction:
                "Choose one decision where you sought advice or avoided it. Examine the actual question, the story you told, the competence of the adviser, and what you wanted the conversation to give you.",
            examenExample:
                "Example: Someone asks a friend whether to quit a job but omits the recent warning and the available appeal. The examination would identify the missing facts, the desire for immediate validation, and the different expertise needed for moral, financial, and workplace questions.",
            specificExamen:
                "Was I seeking truth from a trustworthy and informed person, or seeking approval, control, relief, or someone to carry my responsibility?"
        ),
        "prudence-conscience": make(
            analysis:
                "The first employee substitutes social permission for conscience. A truthful process would identify the claim customers hear, the harm caused by deception, and the actual Church teaching on truth and justice; refusing to learn preserves convenient ignorance. The second employee substitutes anxiety for conscience. The email should receive ordinary care, then be sent under a stable rule rather than reviewed until fear disappears. Neither description permits an app to assign culpability. One person may need moral correction and workplace counsel; the other may need a consistent confessor and a clinician familiar with obsessive-compulsive patterns. Both need freedom directed toward truth: one from rationalization, the other from impossible certainty.",
            synthesis:
                "Romans 12 joins renewed understanding with humble membership and service. Hebrews 5 says discernment is trained through practice, not obtained merely by aging or collecting information. First John holds a troubled heart within God's greater knowledge while connecting confidence to concrete love and obedience. Sirach affirms real choice under God's wisdom and rejects blaming God for sin. Together they present conscience as reason formed in truth, practiced in community, honest about freedom, and anchored in divine mercy rather than private permission or fear.",
            transfer:
                "When you call a conclusion conscientious, what formation, evidence, and willingness to obey make that claim credible?",
            witnessTitle: "Saint Thomas More and conscience formed in truth",
            witnessBody:
                "Saint John Paul II presents Thomas More as a witness to the dignity of conscience, not because More invented a private truth, but because study, faith, public responsibility, and fidelity were integrated in a costly judgment. His witness should not be reduced to stubborn individualism. A mature conscience listens, reasons, accepts consequence, and refuses to make political pressure or personal safety the measure of moral truth.",
            sourceIDs: [VirtueCurriculumSources.catechismConscience.id],
            examenIntroduction:
                "Choose one recent moral judgment that brought either strong confidence or strong fear. Examine how the judgment was formed without using emotion alone as evidence of truth or error.",
            examenExample:
                "Example: An employee feels calm about repeating a misleading script because it is normal at work. The examination would separate calm from moral truth, identify whom the claim affects, consult authoritative teaching, and determine what honest action and qualified counsel are needed.",
            specificExamen:
                "What have I done to form this judgment, and am I willing to receive truth that corrects either my preference or my fear?",
            checks: [
                check(
                    "prudence-conscience-definition",
                    "Which description best matches Catholic teaching on conscience?",
                    [
                        "A feeling that makes a choice personally authentic",
                        "A judgment of reason about the moral quality of a concrete act",
                        "A private permission that cannot be questioned",
                    ],
                    correct: 1,
                    explanation:
                        "Conscience is a judgment of reason. A person must follow a certain conscience and also bears the lifelong duty to form it in truth."
                ),
                check(
                    "prudence-conscience-emotion",
                    "What do calm and anxiety establish about a moral judgment?",
                    [
                        "Calm proves it is right", "Anxiety proves it is wrong",
                        "Neither is decisive; each may be information that reason must interpret",
                    ],
                    correct: 2,
                    explanation:
                        "Emotions matter but do not supply an automatic verdict. Rationalization may feel calm, while a costly faithful act may feel frightening."
                ),
                check(
                    "prudence-conscience-doubt",
                    "What is usually the prudent response to serious, reasonable moral doubt when time permits?",
                    [
                        "Act on the preferred option immediately", "Seek proportionate formation and qualified counsel",
                        "Continue researching until no imaginable doubt remains",
                    ],
                    correct: 1,
                    explanation:
                        "The person should clarify the moral question, facts, and relevant teaching through proportionate inquiry, avoiding both carelessness and endless checking."
                ),
            ]
        ),
        "prudence-deliberation": make(
            analysis:
                "The two jobs are not decided by adding every benefit as though duties and preferences had equal weight. The family should first name genuine financial needs, existing promises, care responsibilities, travel effects, and the voices of those who will carry the consequences. Prestige and growth are real goods but not automatic priorities. The chooser should investigate schedule flexibility, compensation, duration, and alternatives, then compare no more than a few morally sound options. Some loss is unavoidable. A decision date can follow the receipt of specified facts and family counsel. Sadness about the relinquished path may remain after a responsible choice and should not be confused with proof of error.",
            synthesis:
                "Luke 14 makes counting the cost serve wholehearted discipleship rather than indefinite analysis. Tobit 4 places practical advice among worship, kinship, almsgiving, justice to workers, chastity, friendship, and humility, showing that choices are judged inside a moral life. Philippians prays for love to grow in knowledge and insight so believers can discern what is best. Deliberation is thus ordered love at work: it excludes evil means, weighs real duties, accepts finite loss, and moves toward mature commitment.",
            transfer:
                "Which present choice becomes clearer when you distinguish an actual duty from a good you simply wish you did not have to relinquish?",
            witnessTitle: "Tobit as a teacher of integrated practical wisdom",
            witnessBody:
                "Tobit's counsel to his son does not isolate financial, relational, sexual, spiritual, and social duties. He teaches a whole pattern of life before God, including honest wages, almsgiving, wise company, and humility. The witness is useful because deliberation often becomes distorted when one decision is detached from the promises and habits already forming a person's life.",
            examenIntroduction:
                "Choose one decision you keep reopening or one choice you made too quickly. Examine the permissible options, the weight of duties, and the kind of certainty you were demanding.",
            examenExample:
                "Example: A parent compares two jobs and keeps delaying because neither preserves income, time, status, and family presence equally. The examination would rank actual obligations, obtain high-impact facts, accept unavoidable loss, and set a decision point.",
            specificExamen:
                "Did my deliberation compare morally sound options according to real duties, or did perfectionism demand a path with no uncertainty, cost, or criticism?"
        ),
        "prudence-command": make(
            analysis:
                "The original bill presents no unresolved moral or factual question. The payer has verified the amount, possesses the funds, and knows the due date. Reopening the choice protects the feeling of financial security but transfers risk to the creditor and may create fees. The judgment is complete: the bill should be paid. Command makes that conclusion concrete by scheduling or submitting payment now. In the altered case, credible evidence of a duplicate charge is genuinely new and could change what is owed. Pausing, preserving funds, and contacting the biller would then be responsive revision rather than avoidance. The difference lies in evidence, not in how strongly anxiety is felt.",
            synthesis:
                "Matthew 7 identifies wisdom with hearing and doing, not correct profession alone. James 1 develops the same movement through receptive listening, governed speech, mercy, and enacted religion. Ananias in Acts 9 raises a reasonable fear, receives a concrete answer, and goes to Saul. These passages do not praise unthinking speed. They show judgment reaching completion when truth directs the body toward obedient service, even while fear remains present and outcomes are not controlled.",
            transfer:
                "Which sound judgment in your life needs a verb, a time, and a first visible act rather than another round of internal debate?",
            witnessTitle: "Ananias and obedience that names its fear",
            witnessBody:
                "Ananias does not pretend Saul's violence is imaginary. He tells the Lord what he has heard, and the Lord answers with a mission. Ananias then goes, speaks, and lays hands on the former persecutor. His witness shows command as intelligent obedience: concern is brought into prayer, a judgment is received, and fear no longer prevents concrete service.",
            sourceIDs: [VirtueCurriculumSources.popePrudence.id],
            examenIntroduction:
                "Choose one good judgment that remained incomplete or one action you defended after relevant facts changed. Examine the precise point where reflection should have become action—or action should have become revision.",
            examenExample:
                "Example: Someone has confirmed that an apology is owed but keeps drafting it without making contact. The examination would name the fear, preserve any needed safety boundary, and set the smallest action that makes repair real.",
            specificExamen:
                "Was I still missing truth that could change the judgment, or was I using continued thought to avoid the vulnerability of action?"
        ),
        "prudence-foresight": make(
            analysis:
                "The supervisor should not choose between public humiliation and passive waiting. Immediate protection may include stopping the disclosure and securing the information. Fact verification should distinguish one allegation from a repeated pattern. A private meeting can state what occurred, explain the duty, hear relevant context, and set clear expectations and proportionate consequences. Training or access changes may reduce recurrence. Documentation and a review date preserve accountability. Public communication should reveal no more confidential detail than the responsible process requires. Delay becomes avoidance if no date, owner, or protective measure exists. If the conduct triggers formal safeguarding, privacy, or legal obligations, the established procedure and qualified authority must govern the response.",
            synthesis:
                "Joseph's plan in Genesis 41 joins interpretation, administration, restraint, and provision for future need. Proverbs 22 links foresight with humility, reputation, justice, generosity, and formation. Luke 16 uses an unsettling manager to provoke alertness, then lets Jesus interpret the lesson through faithfulness in small matters and freedom from service to money. Together they distinguish foresight from anxious self-protection: wise preparation safeguards people, forms faithful habits, and remains answerable to the true master.",
            transfer:
                "What foreseeable effect of a current choice deserves a proportionate safeguard before it becomes a preventable injury?",
            witnessTitle: "Joseph and stewardship across seasons",
            witnessBody:
                "Joseph receives insight about the coming famine, but the insight immediately becomes administration: collection, storage, oversight, and provision across years. His example does not promise that every future can be predicted. It shows that when a serious need can reasonably be anticipated, wisdom prepares during abundance for people who will later depend upon that preparation.",
            sourceIDs: [VirtueCurriculumSources.popePrudence.id],
            examenIntroduction:
                "Choose one decision whose consequences extend beyond the immediate moment. Examine probability, seriousness, timing, safeguards, and the people who may inherit the result.",
            examenExample:
                "Example: A leader plans a necessary correction and feels tempted either to confront publicly tonight or postpone indefinitely. The examination would protect immediate safety, choose a private and dated process where fitting, and define what evidence would require escalation.",
            specificExamen:
                "Which consequence could I reasonably foresee, and have I chosen fitting timing and safeguards without demanding control over every possibility?",
            checks: [
                check(
                    "prudence-foresight-responsibility",
                    "For which effects is foresight principally responsible?",
                    [
                        "Every outcome imaginable after the fact", "Consequences a reasonable person could anticipate",
                        "Only consequences explicitly intended",
                    ],
                    correct: 1,
                    explanation:
                        "Prudence attends to reasonably foreseeable effects. It neither ignores unintended harm nor claims impossible responsibility for every remote chain of events."
                ),
                check(
                    "prudence-foresight-timing",
                    "What best distinguishes prudent delay from avoidance?",
                    [
                        "Delay always feels peaceful", "No one criticizes the delay",
                        "The delay has a truthful purpose, protective action, and a defined end",
                    ],
                    correct: 2,
                    explanation:
                        "Prudent timing serves preparation, dignity, or safety and identifies when action will occur. Avoidance leaves the duty indefinitely undefined."
                ),
                check(
                    "prudence-gradualness",
                    "What does Catholic gradualness mean in prudent action?",
                    [
                        "Moral truth changes with readiness",
                        "Growth may require faithful stages toward an unchanged good",
                        "Clear duties can always be postponed",
                    ],
                    correct: 1,
                    explanation:
                        "Gradualness respects the real process of growth and reform; it does not redefine the good or make delay itself the goal."
                ),
            ]
        ),
        "prudence-prayer": make(
            analysis:
                "The first person treats a pleasant movement as exemption from marital duty and factual inquiry. Authentic discernment would bring the desire for the move into shared responsibility, verify the job, and remain open to a costly answer. The second treats anxiety as prohibition. A faithful reconciliation may remain frightening; the person should review safety, moral reasons, counsel, and likely fruits rather than wait for calm alone. Both should pray in a listening posture: naming desire and fear, receiving Scripture and Church teaching, hearing affected persons, testing reality, and surrendering control. If several morally sound options remain after duties are honored, freedom may choose without claiming a private revelation.",
            synthesis:
                "James asks God for wisdom amid trial while warning against divided allegiance. Samuel learns to listen through Eli's guidance and must receive a difficult word rather than a flattering one. In Gethsemane, Jesus speaks his desire and anguish while surrendering to the Father and moving toward obedient love. Together these readings prevent sentimental discernment. Prayer welcomes gift, community, truth, and costly freedom; it neither suppresses human feeling nor makes feeling an oracle.",
            transfer:
                "What would change if your prayer asked for freedom to receive the truth rather than for a feeling that removes the need to choose?",
            witnessTitle: "Samuel learning the posture of a servant",
            witnessBody:
                "Samuel hears a call but initially misidentifies its source. Eli's guidance gives him a posture of receptive service, not a prediction about what the message will contain. The word is difficult, and Samuel must speak it truthfully. His witness shows why discernment needs humility, accompaniment, and readiness to receive more than comfort. Listening matures when it becomes faithful speech and action.",
            sourceIDs: [VirtueCurriculumSources.gaudete.id],
            examenIntroduction:
                "Choose one decision for which you have interpreted peace, anxiety, resistance, or enthusiasm as God's answer. Examine the movement respectfully while testing it against truth, duty, reality, and fruit.",
            examenExample:
                "Example: After an uplifting prayer, someone feels called to a major move but has not consulted a spouse or confirmed practical facts. The examination would honor the desire, restore existing duties, gather reality, and ask whether the movement deepens humble love.",
            specificExamen:
                "Did prayer make me more willing to hear God, the Church, other people, and reality, or did I use a feeling to close the question?"
        ),
        "prudence-counterfeits": make(
            analysis:
                "Indefinite private monitoring leaves people exposed and uses concern for scandal to protect reputation rather than the vulnerable. Immediate public accusation risks error, unnecessary disclosure, and harm to due process. The third proposal has prudent elements because it addresses immediate safety, preserves evidence, uses an established safeguarding channel, and limits communication to legitimate need. Even that path must be tested: the reporter should verify what can be verified, avoid investigating beyond competence, and follow mandatory procedures. True scandal is not prevented by concealment. The Church's credibility is served by truth and protection, not by managing appearance. If responsible authorities fail, escalation through the proper independent channel may be required.",
            synthesis:
                "Matthew 10 holds shrewdness and innocence together under mission and persecution. James 3 identifies wisdom by its source and fruits, exposing ambition that calls itself insight. First Corinthians 1 subjects worldly calculations of power and status to Christ crucified. These readings reveal why counterfeits can appear intelligent yet remain unwise: Christian prudence is strategically awake but governed by purity, mercy, sincerity, and the self-giving pattern of Christ. Its fruit must agree with its claimed wisdom.",
            transfer:
                "Which counterfeit most often borrows the name of prudence in your choices, and what good does it pretend to protect?",
            witnessTitle: "The disciples sent as wise and innocent",
            witnessBody:
                "Jesus sends disciples into genuine danger without promising social safety. They must be alert as serpents and innocent as doves, neither naïve about hostility nor converted to its methods. Their witness corrects the idea that holiness means helplessness or that effectiveness excuses manipulation. Christian practical wisdom protects mission by joining moral integrity to a truthful reading of danger.",
            sourceIDs: [VirtueCurriculumSources.popePrudence.id],
            examenIntroduction:
                "Choose one situation where you called yourself prudent, careful, brave, faithful, or certain. Test whether the action expressed virtue or a counterfeit without assigning a permanent label to yourself.",
            examenExample:
                "Example: Someone delays reporting a safety problem because attention might harm the group, then calls the silence discretion. The examination would name the real concern for reputation, the duty to protect, and the fitting confidential process.",
            specificExamen:
                "Did my caution serve preparation, my courage serve truth, and my flexibility serve principle—or did fear, cunning, haste, or rigidity take control?"
        ),
        "prudence-practice": make(
            analysis:
                "The professional should state the decision neutrally: whether and how she can fulfill her responsibility for an accurate report. The true goods include truth, customer welfare, colleagues' livelihoods, lawful employment, and fair correction. Knowingly approving a materially misleading claim is not made good by team protection. She should preserve the record, verify materiality and authority, consult policy and appropriate professional or legal expertise, and use protected internal channels where available. Options may include correction, qualified wording, refusal to approve, or escalation. Foresight considers retaliation and customer harm, so safeguards may include documentation and independent counsel. Her decision rule should reflect truth and duty, not merely predicted career cost. Review should address results, any repair, and whether further escalation is required.",
            synthesis:
                "Mary at the Annunciation receives a disruptive call, asks a real question, consents freely, and moves into service. Acts 15 shows communal discernment through dispute, testimony, Scripture, authority, concern for burdens, judgment, and communication. Colossians 3 gathers compassion, forgiveness, love, peace, the word of Christ, gratitude, speech, and action. Together the readings present a complete Christian prudence: personal freedom and ecclesial listening, moral truth and concrete means, prayer and service, judgment and embodied action.",
            transfer:
                "Which step of the full prudential cycle do you habitually skip, and how does that omission affect the people who depend on your judgment?",
            witnessTitle: "Mary's discerning and active consent",
            witnessBody:
                "Mary is neither passive nor controlling. She receives the angel's word, is troubled, asks how, hears what God will do, and freely consents. Her fiat is followed by movement toward Elizabeth and concrete service. The pattern keeps prayerful discernment from becoming private absorption: grace elicits intelligent freedom, and consent takes bodily, relational form. Her witness also shows that a faithful yes can enter history before every consequence is visible.",
            sourceIDs: [VirtueCurriculumSources.gaudete.id],
            examenIntroduction:
                "Choose one current non-crisis decision substantial enough to use the full process. Work with a single decision and a real next step rather than writing a general self-assessment.",
            examenExample:
                "Example: A professional is asked to approve a misleading report. The examination would define the act, identify duties and affected people, verify facts, seek moral and technical counsel, compare truthful options, act through a protected process, and schedule review.",
            specificExamen:
                "Where did I move faithfully from truth to action, and which neglected stage—good, facts, conscience, counsel, foresight, command, or review—needs repair?",
            checks: [
                check(
                    "prudence-capstone-order",
                    "What should normally be established before comparing tactics?",
                    [
                        "Which option is easiest", "The true good and the relevant moral boundaries",
                        "Which option receives the most approval",
                    ],
                    correct: 1,
                    explanation:
                        "Prudence first receives the good and moral truth. Only morally sound means should proceed into comparison."
                ),
                check(
                    "prudence-capstone-counsel",
                    "What is the purpose of counsel in the complete process?",
                    [
                        "To transfer responsibility to an expert", "To guarantee the outcome",
                        "To enlarge informed judgment while the chooser remains responsible",
                    ],
                    correct: 2,
                    explanation:
                        "A fitting adviser contributes trustworthy knowledge and perspective; counsel assists rather than replaces conscience and judgment."
                ),
                check(
                    "prudence-capstone-command",
                    "When is prudential judgment complete?",
                    [
                        "When every uncertainty disappears", "When it reaches a fitting concrete action",
                        "When the person has considered every imaginable option",
                    ],
                    correct: 1,
                    explanation:
                        "Prudence is right reason in action. Sufficient judgment should command and execute a concrete act rather than remain only an idea."
                ),
                check(
                    "prudence-capstone-review",
                    "What should cause a completed decision to be revised?",
                    [
                        "The return of the same anxiety", "Any criticism from another person",
                        "Relevant new evidence or effects that materially change the judgment",
                    ],
                    correct: 2,
                    explanation:
                        "Review remains teachable to reality. It distinguishes genuinely new reasons from predictable discomfort and makes correction or repair when truth requires it."
                ),
            ]
        ),
    ]
}

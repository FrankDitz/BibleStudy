import Foundation

/// Authored reasoning, Scripture integration, examination, and checkpoints for the
/// complete Justice course. These supports form judgment without assigning culpability.
enum JusticeLessonLearningSupport {
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
                question: "What happened, in the order it happened, without assigning motives?",
                guidance:
                    "Record what you directly observed, said, did, received, or reliably know. Separate documented facts, another person's report, interpretation, and unanswered questions."
            ),
            VirtueSelfExaminationStep(
                id: "persons-and-roles",
                title: "Name persons and roles",
                question: "Who is affected, and what relationship or responsibility connects each person?",
                guidance:
                    "Include people who are absent or have little power. Identify roles such as parent, worker, owner, leader, citizen, friend, caregiver, or recipient without reducing anyone to that role."
            ),
            VirtueSelfExaminationStep(
                id: "due",
                title: "Identify what is due",
                question: "Which claim arises from dignity, promise, role, law, property, harm, or worship?",
                guidance:
                    "Distinguish a legitimate claim from a preference and a strict duty from a generous gift. State the source of the claim rather than relying only on the strength of someone's demand."
            ),
            VirtueSelfExaminationStep(
                id: "power-and-partiality",
                title: "Test power and partiality",
                question: "Who controls the choice, and which advantage or bias may distort the standard?",
                guidance:
                    "Notice control of money, time, information, access, reputation, safety, or appeal. Ask whether the same rule would seem just if roles or identities were reversed."
            ),
            VirtueSelfExaminationStep(
                id: "moral-act",
                title: "Describe the chosen act",
                question: "What was chosen, for what reason, and under which relevant circumstances?",
                guidance:
                    "Use plain language for the act, intention, and circumstances. Good intention does not make an unjust means good, while pressure, knowledge, and freedom can matter to responsibility."
            ),
            VirtueSelfExaminationStep(
                id: "effects-and-common-good",
                title: "Trace effects and shared goods",
                question: "Which rights, relationships, institutions, or common goods were strengthened or harmed?",
                guidance:
                    "Include foreseeable effects and burdens transferred to others, but do not claim responsibility for every remote outcome. Note whether an individual act participates in a recurring pattern."
            ),
            VirtueSelfExaminationStep(
                id: "lesson-connection",
                title: "Use this lesson's lens",
                question: specificExamen,
                guidance:
                    "Apply the lesson's central distinction to this one situation. Seek truth and a faithful response rather than a numerical judgment of virtue, guilt, or personal worth."
            ),
            VirtueSelfExaminationStep(
                id: "next-step",
                title: "Choose the next just step",
                question: "What concrete action gives what is due now, through fitting means and timing?",
                guidance:
                    "Give the action a verb, person, channel, and time. It may be fulfillment, truthful disclosure, a boundary, participation, counsel, or restraint rather than a dramatic confrontation."
            ),
            VirtueSelfExaminationStep(
                id: "repair-and-help",
                title: "Repair and receive help",
                question: "What restitution, correction, safeguard, grace, or qualified help is needed?",
                guidance:
                    "Consider apology, restoration, changed practice, Confession, pastoral counsel, professional care, legal advice, or a safeguarding process. Do not make direct contact when it would be unsafe or improper."
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
        "justice-due": make(
            analysis:
                "The unpaid time is not made voluntary by the supervisor's use of the word generosity. The request occurs within an authority relationship, the same agreeable employee bears the repeated burden, refusal appears costly, and the work benefits the employer. The supervisor should first verify the governing agreement and law, record and compensate time where due, stop retaliation or implied pressure, and establish a transparent process for genuine emergencies. Rotation alone would not make unpaid labor just. If optional help is ever requested, consent must be real and the employee must know that refusal will not affect opportunity. The case also requires listening to the employee and correcting past loss rather than praising sacrifice as a substitute for repair.",
            synthesis:
                "Micah places doing justice beside faithful love and humble walking with God. Matthew's Beatitudes bless hunger for righteousness and move disciples toward visible light, reconciliation, truth, and faithful love. Psalm 15 turns dwelling with God into concrete reliability in speech, promises, money, and treatment of neighbor. Together the passages show justice as worship embodied in ordinary relationship. It is neither cold calculation nor occasional outrage; it is a stable life in which another person's claim remains visible when self-interest could erase it.",
            transfer:
                "Which obligation in your life has been described as optional kindness because the person owed has less power to insist?",
            witnessTitle: "Pope Francis and the upright person",
            witnessBody:
                "Pope Francis describes the just person through ordinary moral texture: upright speech, gratitude, respect for law, rejection of slander and favoritism, responsibility, and concern for the common good. His portrait resists reducing justice to public controversy. The just person becomes recognizable in daily dealings because advantage does not silently rewrite what another is due. This quiet consistency lets families, workplaces, and communities rely upon words and roles without requiring constant force.",
            sourceIDs: [VirtueCurriculumSources.popeJustice.id],
            examenIntroduction:
                "Choose one bounded relationship in which someone depends on your word, work, resources, care, or authority. Examine a specific event rather than evaluating whether you are a just person overall.",
            examenExample:
                "Example: A friend loaned you equipment with an agreed return date, but you kept it because the friend did not ask again. The examination would identify the agreement, your control of the item, the friend's claim, and the return or repair now required.",
            specificExamen:
                "Did I distinguish what was truly due from what would have been a free gift, and did lower power make the claim easier to ignore?"
        ),
        "justice-god-neighbor": make(
            analysis:
                "The volunteer's parish service is a real good, but it does not erase a specific caregiving promise. Public visibility may be reinforcing the choice, while the relative bears the hidden cost. He should acknowledge the missed duty, learn what care is actually needed, share responsibility if possible, and reduce new commitments until the promise is reliable. The caregiver's service is also real, yet usefulness does not make worship superfluous. She can begin with an honest return to prayer and seek pastoral help about Sunday obligations and her demanding circumstances. Neither person should condemn the other's whole spiritual life. Each needs an ordered pattern in which worship receives God's gift and existing neighborly duties become concrete.",
            synthesis:
                "Deuteronomy's command to love God enters memory, household, teaching, and daily signs; it refuses a devotion confined to an idea. The healed Samaritan in Luke recognizes the giver within the gift and returns in praise. Romans 12 begins with embodied worship and unfolds immediately into humble judgment, membership, gifts, and service. Taken together, the passages show that grace precedes response, worship orders the person, and gratitude becomes responsibility. God and neighbor are not rival projects, yet neither may be used to make the other disappear.",
            transfer:
                "What existing obligation toward God or neighbor must be scheduled rather than left to whichever demand feels most urgent or visible?",
            witnessTitle: "The grateful Samaritan who returned",
            witnessBody:
                "All ten lepers receive healing, but one turns back, praises God, and gives thanks at Jesus' feet. His return does not purchase the gift already received. It recognizes relationship within the benefit. Gratitude becomes truthful attention to the giver, offering a pattern for worship that receives grace and returns the whole person rather than bargaining for control.",
            sourceIDs: [VirtueCurriculumSources.catechismReligion.id],
            examenIntroduction:
                "Choose one week in which prayer or religious activity competed with a family, work, or community duty. Examine the actual claims and limits without assuming that the busier activity was automatically holier.",
            examenExample:
                "Example: Someone accepts another parish role while repeatedly arriving late to a promised caregiving shift. The examination would honor parish service, name the prior promise, and seek a schedule or shared-care arrangement that does not use devotion to transfer the burden.",
            specificExamen:
                "Did my worship become embodied in responsibility, or did I use religious activity or useful service to avoid the other great commandment?"
        ),
        "justice-dignity": make(
            analysis:
                "The adjustment should be evaluated by whether it enables the candidate to demonstrate the role's actual requirements, not by whether every interview looks identical. Shared background and social ease may feel relevant while predicting little about the work. The decision-maker should define essential functions and objective criteria before choosing, consult the appropriate accessibility or human-resources process, ask only the information needed to arrange participation, and assess both candidates by the same job-related standards. The colleague's phrase special treatment confuses identical procedure with equal opportunity. None of this predetermines selection; it creates a process in which disability and familiarity do not silently replace merit or dignity.",
            synthesis:
                "Genesis grounds human worth in God's creative act and vocation rather than later achievement. James exposes a worshiping community that ranks rich and poor by expected advantage, then calls it back to the royal law and mercy. Matthew 25 makes overlooked bodily need a meeting with Christ himself. The three readings join origin, community judgment, and final accountability: the person possesses dignity before usefulness, partiality corrupts even religious space, and treatment of the vulnerable reveals what our stated beliefs have become in practice.",
            transfer:
                "Which recurring decision would change if you defined the relevant criterion before knowing the person's status, familiarity, or ability to benefit you?",
            witnessTitle: "The Church's social teaching on transcendent dignity",
            witnessBody:
                "The Catechism makes respect for the transcendent dignity of the human person the foundation of social justice. Rights are not favors granted by stronger people, and institutions remain answerable to a worth they did not create. This foundation protects equality while allowing relevant differences in role, need, and responsibility to be judged truthfully. It also explains why attention to the vulnerable is not sentimental preference but protection of a dignity already present.",
            sourceIDs: [VirtueCurriculumSources.catechismSocialJustice.id],
            examenIntroduction:
                "Choose one decision in which status, familiarity, health, productivity, wealth, race, age, disability, or social confidence may have influenced whose claim received attention. Focus on a real choice you can describe.",
            examenExample:
                "Example: A meeting leader repeatedly recognizes confident senior members while a quieter person using assistive technology cannot enter the discussion. The examination would identify the shared good of participation, the leader's control, and a fitting process change.",
            specificExamen:
                "Was a difference genuinely relevant to the good being decided, or did familiarity, advantage, discomfort, or prejudice determine whose dignity became effective?"
        ),
        "justice-truth-repair": make(
            analysis:
                "The report of possible danger should not be circulated among curious friends or treated as proof of a complete moral story. The listener should record the words accurately, distinguish direct facts from inference, and assess whether immediate safety action is needed. Confidentiality protects the friend, but a promise of absolute secrecy cannot override a child's protection or lawful reporting duties. The appropriate next step is consultation with the established safeguarding authority or qualified professional, sharing only relevant information. Direct confrontation could increase risk or compromise a process. Gossip differs because it serves curiosity or social alignment without legitimate audience, disciplined evidence, or protective responsibility.",
            synthesis:
                "Matthew 5 calls for speech whose ordinary yes and no are trustworthy. James 3 shows that small acts of speech can direct or burn an entire community and exposes the contradiction of blessing God while cursing persons made in God's likeness. Ephesians 4 places truth within a transformed social life where anger is governed, work replaces theft, words build, and forgiveness follows God's mercy. Together the texts show that truthful speech is not blunt disclosure. It protects reality, neighbor, community, and the speaker's integrity.",
            transfer:
                "Before your next disclosure about an absent person, who has a genuine right or responsibility to know, and what is the least information that serves that good?",
            witnessTitle: "The Catechism's demand for reparation",
            witnessBody:
                "The Catechism does not end the teaching on harmful speech with a prohibition. It teaches that injury to reputation and truth creates a duty of reparation, even after forgiveness. This keeps repentance directed toward the neighbor's good: correction, restored standing, changed practice, and prudent limits on further disclosure matter alongside remorse. Speech cannot always be retrieved, but conversion can still become public enough to answer the audience and harm involved.",
            sourceIDs: [VirtueCurriculumSources.catechismTruth.id],
            examenIntroduction:
                "Choose one promise, misleading statement, accusation, or disclosure whose effects are still reasonably identifiable. Examine the truth, audience, purpose, reliance, and possible repair without replaying every conversation you have had.",
            examenExample:
                "Example: You repeated an unverified criticism in a group chat, and the subject lost an opportunity. The examination would separate what you knew from what you inferred, identify who received the claim, and plan a correction that does not spread it further.",
            specificExamen:
                "Did my speech give the hearer needed truth through the right channel, or did deception, assumption, curiosity, anger, or self-protection injure another's freedom or reputation?",
            checks: [
                check(
                    "justice-check-due", "Which action is best described as justice rather than optional generosity?",
                    [
                        "Paying agreed wages", "Giving an unexpected bonus", "Offering an extra gift",
                        "Volunteering for an unassigned task",
                    ],
                    correct: 0,
                    explanation:
                        "Agreed wages are due for work and therefore concern justice. A bonus, gift, or freely chosen extra task may be generous, but it does not replace the prior obligation."
                ),
                check(
                    "justice-check-impartial", "When can different treatment be consistent with equal dignity?",
                    [
                        "Whenever the decision-maker prefers it",
                        "When a relevant need, role, duty, or barrier justifies it",
                        "Only when everyone receives the same amount", "Whenever it rewards higher social status",
                    ],
                    correct: 1,
                    explanation:
                        "Justice is proportionate rather than mechanically identical. Relevant needs, roles, duties, and barriers can justify different treatment; irrelevant advantage and status cannot."
                ),
                check(
                    "justice-check-speech", "What most clearly distinguishes responsible reporting from gossip?",
                    [
                        "The event is interesting", "The speaker feels certain",
                        "A legitimate audience, protective purpose, sufficient evidence, and proportionate disclosure",
                        "The information is true",
                    ],
                    correct: 2,
                    explanation:
                        "Truth alone does not give every audience a right to know. Responsible reporting uses the fitting channel, purpose, evidence, and amount of information."
                ),
            ]
        ),
        "justice-property": make(
            analysis:
                "The employee should stop the unauthorized use and preserve accurate facts about equipment, software, time, profit, and governing policies. Because the company may have property, licensing, confidentiality, tax, or contractual claims, simply returning the device is incomplete. Donating profit elsewhere would choose a different beneficiary and leave the injured party's claim unanswered. The next step should use an appropriate confidential organizational, legal, or pastoral channel to determine disclosure and restitution without unnecessarily exposing coworkers or creating false records. Repair may include repayment, license cost, compensation for wear, corrected accounting, and changed controls. The employee must not demand quick reassurance from the company or treat consequences as proof that repentance failed.",
            synthesis:
                "Exodus places theft and coveting within covenant duties to God, family, life, marriage, and truth. Leviticus joins provision for the poor, timely wages, honest judgment, restrained speech, and love of neighbor. Zacchaeus then shows conversion reshaping both generosity and specific restitution. Together the readings protect ownership without making it absolute: goods belong to persons and must not be seized, possession carries social responsibilities, and repentance seeks the actual neighbor whose good was lost.",
            transfer:
                "Which possession or entrusted resource would you use differently if you named the owner, worker, community, or future person who bears the cost of misuse?",
            witnessTitle: "Zacchaeus and repair made concrete",
            witnessBody:
                "Zacchaeus does not answer Christ with a private feeling alone. He names generosity toward the poor and restitution toward people he has defrauded. The distinction is morally important: a broad gift cannot choose a substitute beneficiary for a particular debt. Grace bears fruit in a changed relation to goods and neighbors. His response witnesses that money is not outside discipleship and that repentance can accept measurable cost without trying to purchase salvation.",
            sourceIDs: [VirtueCurriculumSources.catechismGoodsAndProperty.id],
            examenIntroduction:
                "Choose one specific object, payment, license, account, piece of information, or environmental resource that you own or have been entrusted. Examine the agreement and effects rather than assuming possession removes every duty.",
            examenExample:
                "Example: A borrowed tool was returned damaged without explanation. The examination would identify ownership, the duty of care, the cost transferred, and a truthful offer to repair or replace it rather than an unrelated charitable gift.",
            specificExamen:
                "Did I respect legitimate ownership and the wider purpose of goods, and if loss occurred, what restoration belongs to the actual injured party?"
        ),
        "justice-work": make(
            analysis:
                "Protecting jobs is a genuine good, but removing a safety practice makes less powerful workers bear an undisclosed risk as the means to that end. The owner should not implement the proposal. She should verify the financial problem and safety requirement, consult competent safety and financial advisers, communicate truthfully within appropriate limits, and examine alternatives such as reduced owner return, delayed expansion, process changes, negotiated schedules, financing, or transparent shared sacrifice. Employees need a safe channel for input and retaliation protection. If no viable path remains, lawful restructuring may still be painful without being unjust. The distinction is between accepting unavoidable loss through a fair process and deliberately exposing persons to preventable danger for another's benefit.",
            synthesis:
                "James makes withheld wages a cry heard by the Lord and exposes luxury built upon another's deprivation. Colossians directs work toward the Lord and places those with authority under a Master who judges without partiality. Deuteronomy connects wages, pledges, migrants, widows, orphans, and harvest practices, showing economic life as covenant responsibility. The readings assign duties across roles rather than dividing society into innocent and guilty classes: labor, leadership, possession, and need all remain before God.",
            transfer:
                "In which economic role do you possess enough knowledge or power to make one person's labor, safety, time, or payment more visible?",
            witnessTitle: "James and the wages that cry out",
            witnessBody:
                "The Letter of James gives economic injustice spiritual immediacy: withheld wages are not merely an accounting irregularity but a cry reaching the Lord of hosts. The image corrects distance and abstraction. Behind compensation, schedules, and contracts stands a worker whose labor and household needs are seen by God. Economic records therefore belong within moral and spiritual examination rather than a separate sphere governed only by convenience or leverage.",
            sourceIDs: [VirtueCurriculumSources.catechismWork.id],
            examenIntroduction:
                "Choose one economic relationship where your real agency is substantial: a job, contract, invoice, purchase, leadership decision, or investment. Avoid trying to solve an entire industry in a single examination.",
            examenExample:
                "Example: A client repeatedly requests small revisions outside a freelancer's scope and assumes they are free. The examination would name the agreement, power to withhold future work, cumulative labor, and a fair clarification or payment.",
            specificExamen:
                "Did the arrangement honor the person and reciprocal duties, or did price, consent, productivity, or convenience conceal unequal power and transferred cost?"
        ),
        "justice-common-good": make(
            analysis:
                "The route concerns more than raw ridership because it helps make work, health, and civic participation accessible. Fiscal stewardship is also real: resources are limited and officials owe the whole community responsible use. A just process should publish accurate costs and alternatives, consult riders and employers, study disparate burdens, and invite proposals such as schedule reduction, route redesign, employer partnership, or targeted service. Subsidiarity favors local knowledge and participation, while higher support may be warranted if the local body cannot protect a necessary good. No principle guarantees that the route must remain unchanged. Justice requires that those most affected become visible before the majority's convenience is treated as the entire common good.",
            synthesis:
                "Amos refuses worship separated from public justice. Isaiah 58 joins fasting to liberation, shelter, food, truthful speech, repair, and communal flourishing. Acts 4 portrays property, witness, unity, and distribution according to need in a concrete community. Romans 13 places authority, conscience, contributions, honor, and the continuing debt of love in one moral field. Together these texts show that shared life needs both personal conversion and responsible structures. Authority is real, but it remains accountable to God and the good of persons.",
            transfer:
                "Which communal decision would become more just if the people carrying its heaviest burden were heard before the standard was finalized?",
            witnessTitle: "Catholic teaching on the common good",
            witnessBody:
                "The Catechism defines the common good through respect for persons and rights, social well-being and development, and peace within a just order. This threefold account prevents both individualism and collectivism. Shared goods require participation and authority, while no majority or institution may erase the dignity that gives common life its purpose. The definition also gives communities a practical test: policy should be examined by all three elements, not by efficiency alone.",
            sourceIDs: [VirtueCurriculumSources.catechismCommonGood.id],
            examenIntroduction:
                "Choose one policy, rule, or shared practice in a community where you actually belong. Examine the authority, purpose, process, affected persons, and your own duty of participation without assuming disagreement proves bad faith.",
            examenExample:
                "Example: A parish changes its schedule for administrative ease, unintentionally excluding people dependent on transit. The examination would name the legitimate scheduling need, unheard members, possible alternatives, and the proper channel for participation.",
            specificExamen:
                "Did I consider the good of persons together—including rights, participation, development, and peace—or reduce the common good to my group, convenience, or preferred outcome?",
            checks: [
                check(
                    "justice-check-property", "Why does an unrelated donation not ordinarily replace restitution?",
                    [
                        "Donations are never good", "The injured party retains the particular claim to restoration",
                        "Restitution must always be secret", "Only courts can recognize property",
                    ],
                    correct: 1,
                    explanation:
                        "Generosity toward one beneficiary cannot redirect what is due to another. Restitution aims to restore the person or good actually injured."
                ),
                check(
                    "justice-check-wage", "Why can consent alone fail to establish a just work arrangement?",
                    [
                        "Workers never consent freely", "All unequal roles are unjust",
                        "Severe need, misinformation, or retaliation risk can distort bargaining power",
                        "Profit is always immoral",
                    ],
                    correct: 2,
                    explanation:
                        "Consent matters, but justice also considers truthful information, real freedom, human dignity, safety, and unequal power."
                ),
                check(
                    "justice-check-common", "Which set best summarizes the common good?",
                    [
                        "Majority preference, efficiency, and growth", "Private success, uniformity, and security",
                        "Respect for persons, social well-being, and peace in a just order",
                        "Whatever lawful authority decides",
                    ],
                    correct: 2,
                    explanation:
                        "The Catechism identifies respect for the person, social well-being and development, and peace as the essential elements of the common good."
                ),
            ]
        ),
        "justice-charity": make(
            analysis:
                "The food drive is a genuine good if it respects recipients, but it cannot substitute for correcting payroll and scheduling practices. Workers possess particular claims arising from labor and agreement; accepting donated food does not waive them. Leaders should promptly investigate errors, repay what is owed, establish reliable correction deadlines, and create a schedule process that gives reasonable notice and voice. Only then can voluntary generosity be evaluated on its own terms. Continuing the drive may be fitting, but public praise should not exploit employee hardship or disclose private need. Charity becomes credible when it grows from justice rather than compensating for an avoidable injury left in place.",
            synthesis:
                "Romans 13 names love as an enduring debt that fulfills commandments protecting the neighbor. The Good Samaritan turns compassion into approach, treatment, transport, payment, and continued responsibility. Matthew 23 joins justice, mercy, and fidelity as weightier matters that meticulous religion must not neglect. Together the readings refuse both bare minimum compliance and sentimental generosity. Love becomes concrete, justice remains indispensable, and religious practice is tested by the neighbor's real good.",
            transfer:
                "Which visible act of generosity should be examined for a quieter obligation that belongs to someone before your gift is offered?",
            witnessTitle: "Benedict XVI on the place of justice and love",
            witnessBody:
                "In Deus Caritas Est, Benedict XVI insists both that creating a just order belongs to social responsibility and that even a just society will always need personal love. No charitable gift may excuse an unjust structure, and no efficient system can replace compassionate encounter. Christian service holds institutional duty and personal presence together. This vision frees charity from becoming either publicity for injustice or a cold confidence that correct systems can meet every human sorrow.",
            sourceIDs: [VirtueCurriculumSources.deusCaritasEst.id],
            examenIntroduction:
                "Choose one act of service, giving, forgiveness, or help. Examine whether it fulfills a duty, exceeds a duty, or attempts to replace a duty that remains unmet. Keep the recipient's good at the center.",
            examenExample:
                "Example: A parent buys a costly gift after missing a promised event and asks the child to stop being upset. The examination would distinguish the broken promise from generosity and seek apology, listening, and reliable future presence.",
            specificExamen:
                "Did charity animate and exceed justice, or did visible generosity, easy forgiveness, or sentimental concern conceal what truth, repair, safety, or duty still required?"
        ),
        "justice-mercy": make(
            analysis:
                "The volunteer rightly sees an urgent housing need, but private action without consent, competence, or safeguards could expose the family, children, and volunteer to additional risk. The established ministry can verify the need, preserve confidentiality, coordinate legal or housing expertise, and prevent one relationship from carrying everything. The volunteer can accompany the family through that process, contribute within the approved structure, provide requested practical help, and keep a bounded commitment. Bureaucracy can become indifferent, so delays and gaps should be raised responsibly. Yet process is not the enemy of love when it protects dignity and continuity. The family's choices should shape the response rather than the volunteer's desire to rescue.",
            synthesis:
                "Matthew 25 makes bodily need an encounter with Christ and judges unnoticed omission. Luke 4 announces a Spirit-led mission of good news, liberty, sight, and freedom. James 2 rejects pious wishes that withhold concrete necessities. Together the passages move mercy from sentiment to action while preserving the recipient's whole good. Christ remains the savior; disciples become reliable servants whose faith takes material form and whose help should increase rather than absorb another person's agency.",
            transfer:
                "What would change in your service if you first asked what the person and a competent community identify as the real need?",
            witnessTitle: "The Church's constant love for the poor",
            witnessBody:
                "The Catechism roots love for the poor in the Beatitudes, Jesus' own poverty, and his attention to people who suffer. This is not romanticism about deprivation. It is a permanent claim upon Christian attention that includes material help, defense of dignity, and the works of mercy practiced with humility and truth. The poor remain neighbors and participants, never instruments for the helper's identity, spiritual comfort, or public reputation.",
            sourceIDs: [VirtueCurriculumSources.catechismMercy.id],
            examenIntroduction:
                "Choose one recent response to another person's need, including a decision not to help. Examine your role, the person's stated good, competence, boundaries, and the next sustainable act without making yourself responsible for every need.",
            examenExample:
                "Example: Someone repeatedly gives unsolicited advice to a grieving coworker. The examination would name the desire to help, the coworker's agency, the limits of competence, and a simpler offer to listen or connect the person with chosen support.",
            specificExamen:
                "Did my response make the neighbor more visible and supported, or did avoidance, control, publicity, rescuing, or impossible promises place my needs at the center?"
        ),
        "justice-practice": make(
            analysis:
                "The sibling's missed paid work and accumulated caregiving are concrete effects, while the expensive gift would not make the schedule dependable. The person should acknowledge the broken commitments without demanding reassurance, ask what repair the sibling considers relevant, and reimburse identifiable loss if fitting and possible. Future help must be based on a truthful review of work constraints. A smaller recurring shift, paid outside support, shared family schedule, or conversation with the employer may be more just than another broad promise. The elderly parent's needs and choices remain central. If family conflict, health decisions, or finances are complex, a care professional or mediator may help. Repair joins apology, restitution, and a safeguard that another can reasonably trust.",
            synthesis:
                "Tobit gathers worship, family duty, mercy, wages, counsel, and reciprocal love into one practical instruction. Proverbs 21 teaches that righteousness and justice please God more than sacrifice while examining power, diligence, wealth, speech, and mercy. Matthew 7 places the Golden Rule within prayerful dependence on the Father's gifts. Together they present justice as a received and practiced way of life: God gives wisdom and grace, the learner acts toward real neighbors, and worship becomes credible through dependable relationships.",
            transfer:
                "Which one relationship needs a modest repeatable safeguard more than another strong intention or dramatic promise?",
            witnessTitle: "Christ, the measure and fulfillment of justice",
            witnessBody:
                "Jesus does not merely issue a rule from a distance. He receives the vulnerable, exposes hypocrisy, honors truth, bears injustice without committing it, offers mercy, and gives himself in love. Christian justice remains a moral habit formed by action, yet its deepest life comes from communion with Christ, whose grace heals the will and directs every due toward love.",
            sourceIDs: [VirtueCurriculumSources.catechismHumanVirtues.id],
            examenIntroduction:
                "Choose one relationship or role for the complete course examination. The goal is a truthful next step and a small rule of justice, not a verdict about your character, culpability, or spiritual worth.",
            examenExample:
                "Example: A sibling has repeatedly carried your share of a parent's appointments. The examination would identify the promise, effects, work constraints, possible reimbursement, the parent's voice, and a schedule or support system that can actually be kept.",
            specificExamen:
                "Across worship, dignity, truth, goods, work, authority, charity, and mercy, what is actually due here, what repair remains, and what practice will make fulfillment dependable?",
            checks: [
                check(
                    "justice-final-charity", "Which statement best describes the relationship of justice and charity?",
                    [
                        "Charity replaces strict obligations", "Justice matters only in public institutions",
                        "Charity animates and exceeds justice but cannot excuse injustice",
                        "Justice and charity are unrelated virtues",
                    ],
                    correct: 2,
                    explanation:
                        "Justice gives what is due; charity loves God and neighbor and can give beyond that due. Authentic charity never makes deception, exploitation, or neglected duties acceptable."
                ),
                check(
                    "justice-final-mercy", "Which response best respects mercy and dignity in complex need?",
                    [
                        "Promise unlimited personal availability",
                        "Use competent, safe processes while preserving personal attention and the recipient's agency",
                        "Avoid direct need until every structure is reformed", "Assume the helper knows what is best",
                    ],
                    correct: 1,
                    explanation:
                        "Mercy becomes concrete through fitting action. Competence, safeguards, boundaries, and recipient participation protect rather than weaken love."
                ),
                check(
                    "justice-final-rule", "What is the purpose of a personal rule of justice?",
                    [
                        "To calculate a holiness score", "To prosecute every past failure",
                        "To make a few important obligations visible, repeatable, and reviewable",
                        "To replace Confession and counsel",
                    ],
                    correct: 2,
                    explanation:
                        "A rule of justice supports dependable practice. It records actions and adjustments without claiming to measure virtue, guilt, or holiness."
                ),
            ]
        ),
    ]
}

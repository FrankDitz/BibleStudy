import Foundation

extension PrudenceVirtueLectures {
    static let partOne: [VirtueStudyLesson] = [
        lecture(
            id: "prudence-true-good",
            title: "Right reason in action",
            summary: "Begin prudence by naming the true good rather than merely finding an efficient plan.",
            opening:
                "Recall a choice that worked exactly as planned but still left you uneasy. Was the plan defective, or had success itself been defined too narrowly?",
            goal:
                "By the end, you should be able to define prudence, distinguish ends from means, test a choice through object, intention, and circumstances, and explain why a sincere or efficient choice is not necessarily a good one.",
            terms: [
                "Prudence — the cardinal virtue that disposes practical reason to discern the true good in every circumstance and choose the right means of achieving it.",
                "End — the good or goal for whose sake an action is chosen.",
                "Means — the concrete action used to pursue an end; an evil means cannot be made good by a desirable goal.",
                "Moral object — what the will actually chooses to do, considered as a human act rather than merely as a physical motion.",
            ],
            chapters: [
                (
                    "Lecture I — The intelligence of faithful action",
                    """
                    Prudence is sometimes reduced to being careful, practical, or good at avoiding trouble. Catholic teaching gives it a more demanding meaning. The Catechism calls prudence the virtue that enables practical reason to discern the true good in each circumstance and to choose fitting means toward it. Practical reason is intelligence engaged with action. It asks not only what is possible or effective, but what should be done by this person, with these responsibilities, for the sake of a genuinely human and holy good. Prudence therefore belongs to freedom. It does not replace choice with a formula; it educates choice so that freedom can serve truth.

                    Pope Francis describes the prudent person as creative, able to evaluate the complexity of reality without being ruled by emotion, laziness, pressure, or illusion. That creativity is morally governed. A fraud may require planning, memory, and quick thinking, but clever execution does not make it prudent. Prudence does not invent the good; it receives moral truth and discovers how to embody it here and now. General commandments remain essential, yet “do not lie” does not tell a teacher how much detail to give a frightened child, when a difficult conversation should occur, or how to protect legitimate confidentiality without deception. Concrete wisdom is needed because persons and circumstances are real.

                    This is why older Catholic tradition calls prudence the charioteer of the virtues. The image does not mean prudence is more holy than justice, fortitude, or temperance. It means those virtues need wise direction in action. Courage without prudent judgment can become reckless display. A desire for justice can become indiscriminate punishment. Restraint can become cold refusal to celebrate. Prudence asks what the virtue requires now, toward whom, in what measure, by which truthful means, and at what time. It turns admiration of goodness into a course of action.
                    """
                ),
                (
                    "Lecture II — Begin with the true good",
                    """
                    The first work of prudence is not comparing tactics. It is naming the end truthfully. Every deliberate act reaches toward something presented as good: relief, protection, friendship, victory, income, approval, service, holiness, or peace. Many bad choices attract through a real but partial good. Concealing an error may protect a reputation. Breaking a promise may create immediate freedom. Harsh words may produce the feeling of control. The attraction should be named rather than denied, because an unnamed partial good can quietly become the whole standard of judgment.

                    A true good respects the complete moral horizon: God, the dignity of persons, objective moral truth, actual duties, and the common good. It does not require treating a person as a tool or pretending that one responsibility cancels every other. Sometimes goods genuinely compete. Time given to a sick parent cannot also be given to work; money saved for a child's needs cannot be spent twice. Prudence orders goods without claiming that every loss is evil or every attractive option can be preserved. It asks which duties are prior, which goods are entrusted to this person, and which sacrifice belongs to faithful love.

                    Jesus' image of counting the cost appears within a summons to discipleship. The builder must see what the undertaking requires, but calculation serves commitment to a worthy end. A person could count the cost flawlessly and still build something unjust. Therefore the question “Will this work?” must follow “Is this good?” and “Is it mine to do?” The sequence protects us from baptizing ambition after the plan is already loved. It also protects us from vague idealism: once the good is known, prudence takes resources, obstacles, skills, and consequences seriously enough to seek a workable path.
                    """
                ),
                (
                    "Lecture III — Object, intention, and circumstances",
                    """
                    Catholic moral teaching examines a human act through what is chosen, why it is chosen, and the relevant circumstances. Prudence needs all three. The object asks what the person is actually deciding to do. Intention asks the purpose for which it is done. Circumstances include who is involved, what consequences are foreseeable, when and where the act occurs, and what duties shape it. A morally good act requires harmony; a noble intention cannot transform an evil object into a good one, while a good kind of act can be spoiled by a corrupt intention or made irresponsible by circumstances.

                    Consider telling the truth. Truthfulness is good, yet revealing another person's private medical information to entertain a group violates justice and charity. The speaker cannot defend the act merely by saying the words were accurate. Conversely, silence can protect legitimate privacy, but silence used to help an abuser continue harming someone is not made prudent by the language of discretion. Prudence identifies the act with precision and refuses labels that conceal what is really being chosen.

                    This moral map prevents two opposite errors. Consequentialism says a desirable outcome can justify any means. Subjectivism says sincerity settles the matter. Catholic prudence accepts neither. Consequences matter because love must notice foreseeable harm; they simply do not create permission to do evil. Intention matters because acts are personal; it simply does not redefine reality. Circumstances matter because moral life is concrete; they do not make every principle negotiable. The prudent person brings the whole act into the light, then seeks a means that is morally sound, proportionate, and genuinely capable of serving the good.
                    """
                ),
            ],
            misconception:
                "Prudence is not a technique for guaranteeing success, avoiding every loss, or protecting oneself from blame. A prudent choice can fail because other people are free, information is limited, and created life is vulnerable. Nor is prudence moral compromise—the habit of choosing the least controversial option. It may require a costly refusal when every efficient path depends on wrongdoing. What prudence offers is not control but a responsible judgment: the good was named truthfully, the means respected moral truth, relevant circumstances were considered, and action was taken with reasonable care.",
            caseStudy:
                "A department manager discovers that her team sent a client an inaccurate report. Correcting it promptly may cost a contract and expose her own failure of supervision. Quietly replacing the file would probably prevent discovery and preserve jobs. Several goods are real: truth, the client's decisions, the team's livelihood, the manager's responsibility, and the possibility of repair. Identify the moral object of each proposed action, the intentions that attract her, and the circumstances that affect how—not whether—the truth should be addressed. What truthful means could protect people from unnecessary harm without making concealment the plan?",
            practice:
                "Choose one live decision. Write four headings: the true good, partial goods that attract me, actions that are morally excluded, and fitting means still available. Then describe the proposed act in a plain verb-and-object sentence, without flattering language. If the stakes are grave or the moral object remains unclear, bring the case to a qualified priest, spiritual director, or other competent adviser rather than treating this exercise as a verdict.",
            prayer:
                "God of wisdom, purify the ends I seek and the means I choose. Teach my intelligence to serve truth, my freedom to serve love, and every practical decision to become faithful action.",
            scripture: [
                build.encounter(
                    "prudence-build", "Primary reading — Count the cost",
                    "Read the images of family allegiance, carrying the cross, building, and kingship as one summons to truthful commitment rather than isolated advice about efficiency.",
                    "LUKE", 14, 25, 33),
                build.encounter(
                    "prudence-wisdom-good", "Second reading — Wisdom and the order of goods",
                    "Notice what Solomon loves in Wisdom, what goods are compared with her, and how wisdom equips rather than erases practical responsibility.",
                    "WIS", 8, 2, 8),
                build.encounter(
                    "prudence-two-ways", "Further reading — Hearing that becomes action",
                    "Follow the contrasts between the narrow and broad ways, true and false fruit, words and obedience, and foundations that survive testing.",
                    "MATT", 7, 13, 27),
            ],
            remember: [
                "What makes prudence a moral virtue rather than mere cleverness?",
                "Why should the true good be named before possible tactics are compared?",
                "How do object, intention, and circumstances contribute to judging a human act?",
                "Why can neither good intentions nor desirable consequences justify an evil means?",
                "How does prudence guide the other cardinal virtues without replacing them?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismMoralActs.id,
                sources.popePrudence.id, sources.rickaby.id,
            ]
        ),
        lecture(
            id: "prudence-reality",
            title: "Attend to reality",
            summary: "Learn to separate facts, interpretations, wishes, fears, and missing information.",
            opening:
                "Think of a recent moment when you reacted to what you believed another person meant. Which part was directly observed, and which part was interpretation?",
            goal:
                "By the end, you should be able to construct a truthful account of a situation, identify emotional and cognitive distortions without dismissing emotion, and gather information proportionate to the decision.",
            terms: [
                "Fact — something directly observed or reliably established, distinct from the meaning assigned to it.",
                "Interpretation — an account of what facts mean, including inferred motives, patterns, causes, and consequences.",
                "Circumstance — a morally relevant feature of who, when, where, how, or with what foreseeable effects an act occurs.",
                "Moral certainty — sufficient confidence for responsible action, not the elimination of every imaginable doubt.",
            ],
            chapters: [
                (
                    "Lecture I — Prudence begins by receiving reality",
                    """
                    Prudence cannot guide a person who refuses to see. Before choosing, practical reason receives a world it did not invent: other persons have dignity and freedom; promises create obligations; bodies have limits; time and money are finite; actions form habits; words have histories; institutions possess rules and power. The prudent person does not begin with “How do I make reality fit my preferred answer?” but with “What is actually here, and what good does this reality ask me to serve?” This receptive posture is intellectual humility.

                    Facts and interpretations both matter, but they must not be confused. “He arrived twenty minutes after the agreed time” is an observable claim. “He does not respect me” is an interpretation that may be correct, partly correct, or false. The second judgment requires context: Was the agreement clear? Is this repeated? Was there an emergency? Has the person acknowledged the effect? Prudence does not forbid conclusions; it makes conclusions answer to evidence. In relationships especially, treating an inferred motive as an observed fact can turn one injury into a cycle of accusation and defense.

                    Pope Francis says the prudent person tries to understand the complexity of reality without being overwhelmed by emotions, pressure, idleness, or illusions. Complexity is not an excuse to say nothing can be known. It is a reason to look carefully. A clear moral boundary may coexist with uncertain details. A supervisor can know harassment must stop before knowing every disciplinary consequence. A parent can know a child's fever needs attention before knowing its cause. Prudence names what is settled, what remains uncertain, and what responsible action is possible at each level.
                    """
                ),
                (
                    "Lecture II — Emotion informs but does not decide",
                    """
                    Emotions are not enemies of prudence. Fear may alert us to danger; anger may reveal perceived injustice; sadness may disclose loss; attraction may reveal a valued good. Because human beings are embodied, a decision made as though emotion contained no information would be unreal. Yet emotion presents reality under an aspect—it focuses attention, supplies energy, and can narrow the field. It does not by itself prove that danger is present, that an act was unjust, or that an attractive good should be pursued.

                    Wishful thinking and catastrophizing illustrate opposite distortions. Wishful thinking minimizes evidence because an outcome is desired: “The debt will somehow resolve itself,” or “This relationship cannot be unsafe because I need it.” Catastrophizing promotes a possibility into a certainty: “If I make one mistake, everything will collapse.” Resentment collects facts that confirm guilt and forgets counterevidence. Infatuation reverses the selection. Fatigue can make a solvable problem appear final. Naming these influences is not self-accusation; it creates room for freedom.

                    A useful discipline is to write separate lists: what I know, what I infer, what I feel, what I fear, what I hope, and what I still need to learn. This does not turn life into paperwork. It slows the moment enough for each kind of information to occupy its proper place. Feelings can then be honored without becoming verdicts, interpretations tested without being mocked, and missing facts pursued without pretending that total knowledge is possible. The aim is an integrated judgment made by the whole person under reason, grace, and truth.
                    """
                ),
                (
                    "Lecture III — Enough light for responsible action",
                    """
                    Prudence seeks information proportionate to the stakes. Buying a household item and consenting to major surgery do not require the same investigation. The seriousness, reversibility, urgency, competence required, and number of people affected all influence what care is reasonable. Some facts would change the moral judgment; others merely reduce discomfort. A person who researches every remote possibility may appear conscientious while actually postponing responsibility. Another who acts on the first impression may call speed confidence. Prudence avoids both shortcuts.

                    Ask which unanswered question could change the act, the priority of duties, or the likely effect. Then identify a lawful and respectful way to learn it. This may mean examining records, asking a direct question, consulting expertise, listening to more than one affected person, or conducting a limited trial. Sources should be judged for competence and interest. An anonymous confident voice is not equal to a qualified professional; a person who benefits from your decision may still speak truth but should not be the only source.

                    Sometimes action is needed before the picture is complete. Moral certainty means enough well-founded confidence to act responsibly, not immunity from error. Emergency care, protection from credible danger, or a deadline may require a provisional step. The prudent response can be staged: secure immediate safety, preserve evidence, seek expertise, and revisit the decision. Such humility is stronger than pretending certainty. It allows a person to say, “On the facts reasonably available, this is the next duty; if relevant facts change, I will correct the course.”
                    """
                ),
            ],
            misconception:
                "Attending to reality does not mean distrusting everyone, collecting limitless data, or refusing to act until motives are proven. Suspicion can be as distorting as naïveté. Nor does charitable interpretation require ignoring patterns or remaining in danger. Charity refuses to invent guilt; justice and safety still respond to credible evidence. In situations involving abuse, self-harm, medical danger, crime, or serious legal exposure, prudent fact-finding includes timely help from the appropriate professional or authority rather than private investigation alone.",
            caseStudy:
                "A close friend has not replied to three messages over two days. You notice the thought, “She is angry and no longer values me,” followed by an urge to send a cutting message first. The silence is factual; the motive is inferred. Past conflict, the friend's work schedule, your fear of rejection, and the urgency of the message may all be relevant. Build the six lists—know, infer, feel, fear, hope, need to learn. What respectful inquiry fits the relationship? What action would become appropriate if there were evidence of danger rather than ordinary delay?",
            practice:
                "Use the six-list exercise on one decision this week. Mark each missing fact as high, medium, or low impact: would it truly change the moral choice or only make you feel more certain? Obtain one high-impact fact through a respectful source, then state the next decision point and the date by which you will act.",
            prayer:
                "Lord of truth, free me from illusion, suspicion, and the need to control every uncertainty. Give me courage to see what is present, humility to learn what is missing, and freedom to act on sufficient light.",
            scripture: [
                build.encounter(
                    "prudence-solomon", "Primary reading — An understanding heart",
                    "Notice what Solomon admits about his limits, whom his judgment must serve, and why discernment between good and evil is a gift for responsibility.",
                    "1KGS", 3, 5, 14),
                build.encounter(
                    "prudence-answer-before-hearing", "Second reading — Hearing before answering",
                    "Attend to the sayings about listening, speech, offense, partial stories, and the power of words. Ask which failures of attention they expose.",
                    "PROV", 18, 13, 21),
                build.encounter(
                    "prudence-signs-times", "Further reading — Interpret the present time",
                    "Jesus challenges people who can read visible signs but avoid moral judgment. Notice how discernment leads toward timely reconciliation.",
                    "LUKE", 12, 54, 59),
            ],
            remember: [
                "Why must facts and interpretations be distinguished without pretending interpretations are unnecessary?",
                "How can emotion contribute information while remaining an unreliable verdict?",
                "What makes information gathering proportionate to a decision?",
                "How does moral certainty differ from absolute certainty?",
                "What kind of new fact should cause a prudent person to revise a judgment?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismMoralActs.id,
                sources.popePrudence.id, sources.gaudete.id,
            ]
        ),
        lecture(
            id: "prudence-counsel",
            title: "Memory, docility, and counsel",
            summary: "Let honest experience and trustworthy people enlarge what you can see.",
            opening:
                "When advice has genuinely helped you, what made the adviser trustworthy—and what allowed you to hear something you had not already decided?",
            goal:
                "By the end, you should be able to use memory without becoming trapped by it, define docility as teachability, select fitting advisers, and receive counsel without outsourcing conscience.",
            terms: [
                "Memory — the truthful preservation of relevant experience so that the past can instruct present action.",
                "Docility — readiness to be taught by reality, tradition, experience, and wise persons; it is not passive compliance.",
                "Counsel — advice sought from someone morally trustworthy, competent for the question, and sufficiently informed.",
                "Reassurance-seeking — repeated consultation aimed at removing anxiety or securing approval rather than learning truth.",
            ],
            chapters: [
                (
                    "Lecture I — Memory as a school of practical wisdom",
                    """
                    Every decision arrives with a history. We have seen promises kept and broken, impulses rewarded and regretted, people respond in characteristic ways, and plans encounter limits. Prudence preserves this experience as memory. Pope Francis describes tradition as a patrimony of wisdom and warns against acting as though the world begins with us. Personal memory participates in that discipline: it lets yesterday teach today instead of making every difficulty a first experiment.

                    But memory must be truthful. Shame can enlarge a failure until it becomes an identity: “I chose badly once, so I cannot judge.” Pride can edit out warnings and remember only successes. A wound can make one betrayal the pattern for every future relationship. Nostalgia can present an earlier practice as automatically suitable now. The prudent question is not merely, “What happened before?” but “What exactly did that experience teach, which features are similar now, and which are different?” Memory supplies evidence, not destiny.

                    A brief decision review can train this capacity. After a significant choice, record what you knew, what you missed, what influenced you, what happened, and what you would repeat or change. The point is not obsessive replay or assigning total blame. Outcomes do not perfectly reveal the quality of a decision: a reckless gamble can succeed, and a responsible act can meet misfortune. Review the process as well as the result. Over time, honest records reveal patterns that mood-dependent recollection hides and create practical wisdom available for future service.
                    """
                ),
                (
                    "Lecture II — Docility is strength before truth",
                    """
                    No person has every kind of knowledge. A parent may understand a child but lack medical expertise. A priest may offer sound moral and sacramental guidance while referring a legal or psychiatric question to another professional. A new employee may see a fresh possibility but not know why an old safeguard exists. Prudence therefore requires docility: the stable willingness to learn from persons and realities beyond one's present understanding.

                    Docility differs from gullibility. The docile person asks whether a teacher is competent, honest, appropriately informed, and speaking within the limits of that competence. The person can ask questions, compare advice with moral truth, and decline manipulation. What docility surrenders is not judgment but the prideful claim that nothing outside the self can correct it. This virtue can be especially difficult for intelligent or experienced people because their real strengths make self-sufficiency plausible.

                    The posture also differs from passivity. Good counsel expects the seeker to supply facts, identify the actual question, listen without defensiveness, and make a responsible judgment afterward. “Tell me what to do” may sometimes be appropriate in a genuine chain of authority or technical emergency, but ordinary moral counsel assists conscience rather than replacing it. A teachable person can say both, “I may be wrong,” and “I remain responsible for what I freely choose.” That combination protects against both stubborn isolation and dependence.
                    """
                ),
                (
                    "Lecture III — Seeking and testing counsel",
                    """
                    Choosing an adviser is itself an act of prudence. Moral trustworthiness matters because a clever person may normalize dishonesty. Competence matters because goodwill cannot substitute for knowledge. Sufficient information matters because advice built on a one-sided summary may answer a different case. Freedom from conflicts of interest matters, especially when money, authority, romance, reputation, or safety is involved. Confidentiality matters, but it must not become secrecy that protects wrongdoing.

                    Ask what kind of knowledge the decision requires. A spiritual director can help distinguish prayer, motive, vocation, and freedom. A pastor can clarify Church teaching and sacramental life. A physician, therapist, lawyer, financial adviser, safeguarding officer, or other professional may be necessary for questions within that field. Trusted family or friends may know character and commitments in a way a specialist does not. Complex decisions can require more than one voice, not because truth is decided by a vote but because different aspects must be seen.

                    Counsel becomes distorted when a person shops for permission, gives each adviser a different story, or asks the same question repeatedly after receiving a sound answer. It is also distorted when the adviser demands control, isolates the seeker, claims universal expertise, or treats disagreement as disobedience. Receive advice by restating it fairly, identifying its reasons, testing it against moral truth and facts, and noticing resistance without letting comfort decide. Then judge and act. The goal of counsel is a freer, better-informed responsibility—not permanent dependence on the counselor.
                    """
                ),
            ],
            misconception:
                "Having many advisers does not automatically produce wisdom, and consulting only one familiar person does not automatically produce depth. Agreement may reflect a biased presentation; disagreement may reveal that advisers are answering different questions. Docility also does not require remaining with an unsafe or manipulative authority. When advice involves abuse, exploitation, illegal conduct, serious medical risk, or threats, prudence may require independent expertise and formal reporting channels. Respect for office never makes coercion truthful.",
            caseStudy:
                "After a serious argument with his spouse, a man asks a coworker whether he should leave the marriage. The coworker knows only his angry retelling and quickly affirms that he deserves better. He then asks several online groups until one supplies the same answer. What kinds of memory are shaping the story? Which facts and voices are missing? Identify the distinct roles that a trustworthy friend, qualified therapist, and priest might play. How can he seek help without exposing private details for entertainment or pretending another person can make the moral judgment for him?",
            practice:
                "Choose one precise question and one appropriate adviser. Before the conversation, write the relevant facts, what you may be omitting, the adviser's competence, and any conflict of interest. Afterward, summarize the advice and its reasons in words the adviser would recognize. Wait long enough for defensiveness or relief to settle, then decide what further truth—not further approval—is needed.",
            prayer:
                "God of wisdom, make my memory honest and my spirit teachable. Send trustworthy companions, protect me from manipulation, and help me receive counsel without surrendering the responsibility you have entrusted to me.",
            scripture: [
                build.encounter(
                    "prudence-jethro", "Primary reading — Counsel that serves vocation",
                    "Trace Jethro's observation, concern, proposal, conditions, and respect for Moses' responsibility before God.",
                    "EXOD", 18, 13, 27),
                build.encounter(
                    "prudence-many-counselors", "Second reading — Counsel and the common good",
                    "Notice how discretion in speech and a plurality of advisers protect persons and communities rather than merely validating a ruler.",
                    "PROV", 11, 12, 14),
                build.encounter(
                    "prudence-listen-reproof", "Further reading — The ear that listens",
                    "Read the sayings as a portrait of teachability: plans, correction, humility, reverence, justice, and speech belong together.",
                    "PROV", 15, 22, 33),
            ],
            remember: [
                "How can memory teach without becoming a prison?",
                "Why is docility compatible with personal responsibility?",
                "What three qualities should a fitting adviser possess?",
                "How does counsel differ from reassurance-seeking or permission-shopping?",
                "Which kinds of decisions require several forms of expertise?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.popePrudence.id,
                sources.gaudete.id, sources.rickaby.id,
            ]
        ),
        lecture(
            id: "prudence-conscience",
            title: "Forming and following conscience",
            summary: "Distinguish conscience from preference, emotion, approval, and private certainty.",
            opening:
                "When you say, “My conscience tells me,” do you mean a judgment about what is right, a strong feeling, a personal preference, or a desire to end the discussion?",
            goal:
                "By the end, you should be able to define conscience as a judgment of reason, explain the duties to form and follow it, use the Church's basic rules for doubtful choices, and distinguish sound formation from scrupulosity or rationalization.",
            terms: [
                "Conscience — a judgment of reason by which a person recognizes the moral quality of a concrete act to be performed, presently being performed, or already completed.",
                "Formation — the lifelong education of conscience through Scripture, Church teaching, prayer, reason, counsel, experience, and practice.",
                "Certain judgment — a settled practical conclusion sincerely held after proportionate inquiry; certainty is not the same as emotional calm.",
                "Scrupulosity — a pattern of unreasonable moral fear and repeated doubt that may require stable pastoral guidance and, at times, clinical care.",
            ],
            chapters: [
                (
                    "Lecture I — Conscience is judgment, not permission",
                    """
                    Conscience is often described as a private voice that approves whatever feels authentic. The Catechism describes something more objective and demanding: conscience is a judgment of reason about the moral quality of a concrete act. It applies moral truth to “this action I am considering” or “this action I performed.” Because it is a judgment, conscience can reason well or badly, possess relevant truth or lack it, resist bias or be shaped by it. Its dignity does not rest on infallibility but on the person's obligation to seek and obey truth.

                    A person must act according to a certain judgment of conscience; deliberately doing what one judges evil would set the will against the known good. Yet this duty cannot be separated from the duty to form conscience. “My conscience permits it” is not a conversation-ending formula if the speaker refuses evidence, Church teaching, the rights of others, or honest examination. Private sincerity matters, but sincerity cannot turn an unjust act into justice. Conscience stands before God and truth, not above them.

                    Neither emotion nor social approval supplies the definition. Calm may accompany rationalization, while anxiety may accompany a faithful but costly choice. A crowd may normalize exploitation, while an isolated person may still judge rightly. Emotion and community are important evidence: fear can expose coercion, and trusted believers can correct isolation. They remain inputs to reason rather than automatic verdicts. Prudence guides conscience by gathering the facts, recalling moral principles, seeking counsel, and making the concrete judgment that action requires.
                    """
                ),
                (
                    "Lecture II — A conscience must be educated",
                    """
                    Formation is not a one-time transfer of rules. It begins in childhood and continues throughout life because new responsibilities expose untrained areas of judgment. Scripture reveals God's action and the shape of discipleship. The Church's moral teaching preserves and interprets truth received in Christ. Prayer places the person before God rather than before a self-created ideal. Examination exposes patterns. Wise counsel and the lives of saints show truth embodied. Repeated acts make attention more honest and obedience more available.

                    The Catechism points to the Word of God, assimilated in faith and prayer, as light for the path, together with the gifts of the Holy Spirit, the witness or advice of others, and the authoritative teaching of the Church. These do not eliminate reasoning. They form the person who reasons. A mature Catholic does not merely search for a rule that produces the preferred result, nor assume that a private impression is the Holy Spirit. The learner asks what the Church actually teaches, why it teaches it, and how the relevant principle applies to the complete facts.

                    Formation also includes intellectual honesty about ignorance. Some ignorance is unavoidable; some is maintained because knowledge would inconvenience desire. A person who suspects a business practice is exploitative but refuses to investigate is not exercising innocent simplicity. Conversely, a new learner should not be crushed by the belief that every missing detail is culpable. Growth proceeds through proportionate responsibility. Learn what the present duty requires, seek qualified help for difficult cases, act faithfully, and remain ready for further conversion.
                    """
                ),
                (
                    "Lecture III — Doubt, error, and reliable guidance",
                    """
                    A doubtful conscience should not be treated casually. If a person reasonably doubts whether a proposed act is gravely wrong and time permits, prudence seeks clarification before acting. The effort should be proportionate and directed: identify the moral question, consult authoritative teaching, verify facts, and seek a qualified adviser. Endless searching is not automatically reverence. Once a scrupulous person has received stable guidance, repeated checking may strengthen the disorder rather than improve judgment.

                    The Church offers durable principles. One may never do evil so that good may result. The Golden Rule directs attention to the dignity of the neighbor. Charity respects both the good of another and that person's conscience; it does not manipulate vulnerability. These principles do not solve every factual question, but they rule out false solutions. In cases of uncertainty, choose what protects moral truth and the person while further light is sought.

                    Conscience can err. When error is discovered after action, prudence does not collapse into self-condemnation or denial. It asks what responsibility was present, what truth was missed, what repair is owed, and what formation can prevent repetition. Personal culpability involves knowledge and freedom and cannot be calculated by an app. Grave or recurring matters belong within sacramental and pastoral care; mental-health conditions may also need clinical help. The aim of conscience formation is freedom for truthful love, not constant self-surveillance.
                    """
                ),
            ],
            misconception:
                "A well-formed conscience is not one that never feels doubt, and a poorly formed conscience is not simply one that reaches a conclusion others dislike. Formation must be judged by fidelity to truth, serious engagement with the Church's teaching, adequate facts, honest motives, and readiness to obey. Scrupulosity is not greater holiness, while the absence of guilt is not proof of innocence. This course can teach a process; it cannot replace Confession, spiritual direction, qualified mental-health care, or competent advice in grave individual cases.",
            caseStudy:
                "One employee says, “My conscience says the company's misleading sales script is fine because everyone uses it,” but refuses to read the policy or consider customers who cannot evaluate the claim. Another reviews an ordinary, truthful email twenty times because one imperfect phrase might be sinful. Explain how both have confused conscience with something else. What formation, facts, authoritative guidance, and boundaries on further checking would fit each person? What should neither person conclude about personal culpability from this short description?",
            practice:
                "Take one non-emergency question and write: the proposed act, your intention, relevant circumstances, the moral principle, the authoritative source you consulted, people affected, and your current judgment. Note whether the remaining uncertainty is factual, moral, emotional, or scrupulous. If the issue is grave, recurring, or tied to compulsive fear, seek a stable human adviser instead of repeatedly using the worksheet.",
            prayer:
                "Holy Spirit, form my conscience in truth and charity. Deliver me from self-authorization, convenient ignorance, and needless fear; make me willing to know the good and ready to follow it.",
            scripture: [
                build.encounter(
                    "prudence-renew-mind", "Primary reading — A renewed mind",
                    "Read the movement from self-offering and transformed thinking to humble discernment and service within the body of Christ.",
                    "ROM", 12, 1, 8),
                build.encounter(
                    "prudence-trained-discernment", "Second reading — Faculties trained by practice",
                    "Notice why immaturity is not cured by information alone and how repeated practice trains discernment between good and evil.",
                    "HEB", 5, 11, 14),
                build.encounter(
                    "prudence-truth-heart", "Third reading — Truth before God",
                    "Hold together concrete love, a troubled heart, confidence before God, obedience, and the gift of the Spirit.",
                    "1JOHN", 3, 18, 24),
                build.encounter(
                    "prudence-choice-commandments", "Further reading — Freedom and moral truth",
                    "Sirach rejects blaming God for sin and places real human choice within God's wisdom and commandments.",
                    "SIR", 15, 11, 20),
            ],
            remember: [
                "What does it mean to call conscience a judgment of reason?",
                "Why must the duties to follow and to form conscience remain together?",
                "Which sources and practices contribute to Catholic conscience formation?",
                "How do scrupulosity and rationalization distort conscience in opposite directions?",
                "What should a person do after discovering that a conscientious judgment was mistaken?",
            ],
            sourceIDs: [
                sources.catechismConscience.id, sources.catechismMoralActs.id,
                sources.catechismFreedom.id, sources.gaudete.id,
            ]
        ),
        lecture(
            id: "prudence-deliberation",
            title: "Deliberation without paralysis",
            summary: "Compare morally sound options with care proportionate to the stakes.",
            opening:
                "Name one decision you delayed because no option preserved every good. What did the delay protect, and what did it quietly cost?",
            goal:
                "By the end, you should be able to generate morally permissible options, rank criteria and duties, deliberate under uncertainty, and recognize when further comparison has stopped serving truth.",
            terms: [
                "Deliberation — the reasoned comparison of possible means toward a good end before judgment and choice.",
                "Proportionality — matching the depth and length of inquiry to the seriousness, urgency, reversibility, and reach of a decision.",
                "Opportunity cost — a good relinquished because finite time, attention, or resources are committed elsewhere.",
                "Perfectionism — the demand for an option without uncertainty, loss, criticism, or risk; it can imitate conscientious care while preventing action.",
            ],
            chapters: [
                (
                    "Lecture I — Deliberate among good means",
                    """
                    Deliberation begins after the governing end and moral boundaries are sufficiently clear. Its question is not “Can I justify the option I already want?” but “Among morally sound paths, which means fittingly serves the good?” Any option that requires an intrinsically wrong act should be removed rather than assigned a lower score. This prevents a desirable consequence from quietly converting wrongdoing into one factor among many.

                    Generate a small set of genuine alternatives. Binary thinking often creates false traps: remain silent or destroy a relationship; accept an unjust demand or resign immediately; solve a whole problem tonight or do nothing. Prudence may discover a direct conversation, a temporary boundary, a request for clarification, a staged transition, a formal appeal, or a limited experiment. Creativity does not mean evading moral truth. It searches within truth for a workable response.

                    Each option should then be tested through duties, persons, resources, benefits, harms, reversibility, and formation of character. Duties do not all carry equal weight. A solemn promise normally weighs differently from a casual preference. Dependents may create obligations strangers do not have, without erasing duties to the common good. Foreseeable harm matters, including harm caused by delay. The exercise is not mathematical, because persons are not numbers and some boundaries cannot be traded. A structured comparison simply prevents the loudest emotion from becoming the only criterion.
                    """
                ),
                (
                    "Lecture II — Accepting limits and real loss",
                    """
                    Created life makes tradeoffs unavoidable. Choosing one vocation closes other possible lives. Giving time to a sick relative may reduce professional opportunity. Keeping a financial promise may postpone a desired purchase. Deliberation becomes paralyzed when it treats every relinquished good as evidence that the choice is wrong. Opportunity cost is not necessarily moral failure; it is often the price of finite, committed love.

                    Perfectionism resists this truth. It demands complete information, unanimous approval, permanent certainty, and an option that cannot be regretted. Because no ordinary decision meets that standard, the chooser remains “careful” forever while other people carry the cost. The fear may be understandable: a person wants to avoid harming others, repeating a past mistake, or losing a cherished identity. Prudence responds compassionately but firmly. It asks what care is actually owed, not what fantasy would remove all vulnerability.

                    Regret also needs interpretation. Feeling sadness after a decision does not prove it was mistaken. A person can rightly choose hospice care and still grieve; accept a necessary boundary and still miss the relationship; choose one good vocation and still wonder about another. Prudence evaluates the reasons and process, receives new facts, and distinguishes grief from evidence of error. This makes stable commitment possible without hardening the heart.
                    """
                ),
                (
                    "Lecture III — Deadlines, uncertainty, and judgment",
                    """
                    Deliberation should have a stopping rule. Ask which facts could materially alter the moral judgment, how likely they are to become available, and what delay costs. High-stakes and irreversible choices deserve more time and expertise when circumstances allow. Urgent safety decisions may require immediate provisional action. Ordinary reversible choices should not consume the energy required for genuine duties. Proportionate care is itself part of prudence.

                    A deadline can serve freedom. It might be external, such as a medical window or contractual date, or deliberately chosen after counsel. Before the deadline, gather the defined information and pray. At the deadline, state the best judgment available and choose unless a genuinely new reason appears. Reopening a decision because the same anxiety returned is not new evidence. This distinction is especially important for people prone to obsessive checking; a stable confessor, therapist, or adviser can help establish healthy limits.

                    The Book of Tobit places practical counsel inside a larger moral life of remembering God, honoring relationships, giving alms, guarding conduct, paying workers fairly, and seeking wisdom. Deliberation is not an isolated optimization exercise. It belongs to a formed person with duties and a history. Philippians prays that love may abound in knowledge and full insight so believers can discern what is best. Christian judgment therefore seeks more than acceptable efficiency. It asks which choice lets truthful love take mature form.
                    """
                ),
            ],
            misconception:
                "Deliberation is not avoidance dressed as responsibility. More spreadsheets, opinions, or prayers do not necessarily mean more prudence if they repeat the same information. Nor is quick choice automatically mature; speed can hide impulsiveness or pressure. A prudent process is as long as the truth and stakes require, and no longer. It also remains open to the possibility that the best option is to wait for a defined reason—not merely because choosing feels uncomfortable.",
            caseStudy:
                "A married parent is choosing between two morally legitimate jobs. One provides greater income and advancement but requires frequent travel; the other offers less money, steadier presence at home, and work that feels less prestigious. The family needs income but is not in crisis. No option maximizes service, security, family time, and ambition. Identify actual duties, negotiable desires, people whose knowledge matters, facts that could change the choice, and losses that must simply be accepted. What deadline and decision rule would keep care from becoming paralysis?",
            practice:
                "For one choice, list no more than three morally permissible options. Compare each under five headings: duties honored, persons affected, resources required, foreseeable benefits and harms, and character being formed. Mark facts that could truly change your judgment. Set a proportionate deadline and write what will count as a new reason to reconsider after it.",
            prayer:
                "Lord of providence, teach me to compare honestly, accept the limits of created life, and choose without demanding control over every outcome. Let love become knowledgeable and insight become action.",
            scripture: [
                build.encounter(
                    "prudence-cost", "Primary reading — Deliberation ordered to commitment",
                    "Read Christ's examples of counting the cost inside the larger call to discipleship. Planning serves a whole-hearted yes.",
                    "LUKE", 14, 25, 33),
                build.encounter(
                    "prudence-tobit-counsel", "Second reading — Practical wisdom within covenant life",
                    "Notice how worship, family duty, almsgiving, justice to workers, friendship, and counsel form one pattern rather than separate tips.",
                    "TOB", 4, 5, 19),
                build.encounter(
                    "prudence-discern-best", "Further reading — Love with knowledge and insight",
                    "Paul does not oppose love to judgment. Observe what kind of discernment he asks to grow and what fruit it should bear.",
                    "PHIL", 1, 3, 11),
            ],
            remember: [
                "Why should morally impermissible options be removed before tradeoffs are compared?",
                "How can binary thinking hide a fitting third path?",
                "Why is the loss of a real good not automatic evidence of a wrong choice?",
                "What makes a deadline an aid to prudence rather than an arbitrary pressure?",
                "How can you distinguish new evidence from the return of old anxiety?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismMoralActs.id,
                sources.popePrudence.id, sources.gaudete.id,
            ]
        ),
    ]
}

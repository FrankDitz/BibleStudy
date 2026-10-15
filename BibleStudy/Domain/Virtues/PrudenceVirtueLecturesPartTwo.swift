import Foundation

extension PrudenceVirtueLectures {
    static let partTwo: [VirtueStudyLesson] = [
        lecture(
            id: "prudence-command",
            title: "Judgment that becomes action",
            summary: "Complete discernment by commanding and carrying out the fitting act.",
            opening:
                "Which good decision have you already made in principle but not yet translated into a dated, visible action? What keeps the judgment on paper?",
            goal:
                "By the end, you should be able to distinguish deliberation, judgment, command, and execution; recognize avoidance after sufficient clarity; act decisively without becoming stubborn; and review outcomes without judging solely by success.",
            terms: [
                "Judgment — practical reason's conclusion that a particular course should be chosen here and now.",
                "Command — reason's direction of the person toward carrying out the judged act; it is self-government, not domination of another.",
                "Execution — the bodily, relational, and practical completion of the choice through concrete action.",
                "Decisiveness — timely commitment based on sufficient judgment, joined to readiness for correction when relevant facts change.",
            ],
            chapters: [
                (
                    "Lecture I — Prudence is completed in command",
                    """
                    A person can study the good, gather facts, seek counsel, and compare options while still failing to act. Classical accounts of prudence therefore give a central place to command: practical reason says not only “this would be right” but “do this now.” Command is not a harsh internal voice and does not mean controlling other people. It is the moment in which judgment governs one's own powers—attention, speech, movement, resources—toward the chosen good.

                    This completes rather than abandons reflection. Before judgment, openness protects against impulse. After sufficient judgment, continued openness to every possibility can become refusal. Fear may ask for one more opinion; vanity may prefer the identity of a thoughtful person to the vulnerability of being responsible; fatigue may make a small task feel indefinite; perfectionism may demand ideal conditions. Prudence identifies when these forces are no longer supplying information and begins the act.

                    Jesus' wise builder hears and does. The difference between rock and sand is not admiration for sound teaching but embodied obedience that survives pressure. James likewise warns against hearing without doing. Christian wisdom must enter calendars, conversations, budgets, boundaries, apologies, and works of mercy. A judgment such as “I should reconcile” remains incomplete until it becomes a fitting act—perhaps requesting a conversation, naming harm truthfully, offering repair, or establishing a boundary when reconciliation is not yet safe.
                    """
                ),
                (
                    "Lecture II — Make the next action concrete",
                    """
                    Many good intentions fail because they are not operational. “Be more responsible” names a direction, not an act. Prudence asks who will do what, for whom, by when, with which resources, and what first visible step creates real commitment. The first step should be small enough to perform but substantial enough to matter. Opening a document may prepare for a hard report; scheduling the required meeting commits more than thinking about it. The right size depends on the decision.

                    Implementation should anticipate friction. If the good action requires courage, arrange support before the moment. If distraction repeatedly wins, alter the environment. If another person depends on the act, communicate the plan without making promises beyond your control. If a decision requires stages, define the first checkpoint. This is not lack of trust in grace. Grace ordinarily perfects rather than erases human agency, and responsible preparation can become cooperation with it.

                    Timeliness belongs to justice. A delayed wage, apology, report, or safety response can injure others even if the person remains sincerely undecided. Not every task is urgent, but duties have temporal shape. “Someday” may protect the chooser while transferring cost to someone else. The prudent question is not simply whether an act will eventually occur, but when the good of the persons involved requires it. A deadline should be honest, feasible, and visible enough to guide action.
                    """
                ),
                (
                    "Lecture III — Correction, repair, and review",
                    """
                    Decisiveness is not stubbornness. Human judgment is fallible, and action reveals information that planning could not provide. A prudent person monitors morally relevant effects, distinguishes normal difficulty from evidence of error, and revises when new facts alter the case. The statement “I made a decision, so I must never change it” can be pride masquerading as consistency. At the same time, discomfort or criticism alone does not prove that revision is necessary.

                    When a decision was mistaken, prudence directs repair. Name the error without rewriting the original facts. Stop preventable harm. Tell affected people the truth appropriate to them. Restore what can be restored, seek forgiveness where owed, and change the process that produced the error. The purpose is neither image protection nor endless self-punishment. It is renewed service of the good. Some consequences cannot be undone; accepting that limit can be part of honest responsibility.

                    Review the decision by both process and outcome. Did you seek the true good, respect moral boundaries, gather proportionate facts, hear counsel, and act at the fitting time? What unforeseen result is now known? A good process may still meet a bad outcome, and a reckless process may receive lucky success. Wisdom learns from both without treating providence as a machine that guarantees visible reward. The review should end with one lesson carried forward and one present duty, not an indefinite trial of the self.
                    """
                ),
            ],
            misconception:
                "Decisiveness is not speed, loud confidence, or refusal to apologize. Impulse jumps over judgment; stubbornness ignores relevant correction; command follows sufficient judgment and remains responsible to truth. Nor must every prudent action feel peaceful. Courageous obedience may bring fear, grief, or conflict. Emotional relief is not the measure. The act is prudent when it embodies a sound judgment through fitting means at a fitting time and remains open to truthful review.",
            caseStudy:
                "You confirmed the amount of a bill, have sufficient funds, and know the payment is due. For a week you have reopened the question because paying now reduces the comfort of your account balance. No new fact has appeared. Separate deliberation already completed from emotion still present. State the practical judgment, the command, and the first act. Then change the facts: suppose a credible duplicate charge appears. Explain why pausing to investigate would now be revision based on evidence rather than avoidance.",
            practice:
                "Choose one decision that already has enough light. Write a command sentence beginning with an active verb, name the first visible step, assign a time, and identify one person or system that will support execution. After acting, schedule one review point. At review, ask what the process and result teach without reopening the choice merely because discomfort returned.",
            prayer:
                "God who calls and sustains, give me courage to do the good I already know. Make my action timely and concrete, my resolve humble, and my mistakes occasions for truth, repair, and renewed fidelity.",
            scripture: [
                build.encounter(
                    "prudence-wise-builder", "Primary reading — Hear and act",
                    "Read the conclusion of the Sermon on the Mount as a test of embodied wisdom: profession, hearing, doing, and endurance are not interchangeable.",
                    "MATT", 7, 21, 27),
                build.encounter(
                    "prudence-doers-word", "Second reading — The implanted word in practice",
                    "Notice the sequence of listening, restraint, reception, action, speech, mercy, and integrity. Wisdom becomes visible in conduct.",
                    "JAS", 1, 19, 27),
                build.encounter(
                    "prudence-ananias", "Further reading — Obedience through fear",
                    "Ananias names a reasonable concern, receives a concrete command, and acts. Observe how dialogue with God leads to embodied service rather than paralysis.",
                    "ACTS", 9, 10, 19),
            ],
            remember: [
                "How do deliberation, judgment, command, and execution differ?",
                "Why is a vague intention not yet a prudent action?",
                "How can delay become an injustice to another person?",
                "What distinguishes humble revision from indecision?",
                "Why should a decision review examine both process and outcome?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismFreedom.id,
                sources.popePrudence.id, sources.popeGrace.id,
            ]
        ),
        lecture(
            id: "prudence-foresight",
            title: "Foresight, timing, and gradualness",
            summary: "Anticipate foreseeable effects without pretending to control the future.",
            opening:
                "Think of a good action whose effect depended heavily on timing. What made the same words or deed fitting at one moment and harmful at another?",
            goal:
                "By the end, you should be able to assess foreseeable consequences, distinguish probability from mere possibility, choose fitting timing, plan safeguards, and use gradualness without turning it into indefinite avoidance.",
            terms: [
                "Foresight — practical reason's attention to consequences and needs that can reasonably be anticipated.",
                "Probability — the supported likelihood that an effect will occur, distinct from the mere possibility that it could occur.",
                "Safeguard — a proportionate measure that reduces foreseeable harm or protects a good while action proceeds.",
                "Gradualness — ordered development through fitting stages; it respects real growth but does not redefine moral truth or postpone clear duties forever.",
            ],
            chapters: [
                (
                    "Lecture I — Looking ahead without claiming control",
                    """
                    Prudence looks beyond the immediate act. Choices affect persons, promises, resources, habits, reputation, safety, institutions, and future freedom. A private joke can normalize contempt in a group; repeated borrowing can narrow tomorrow's options; one generous exception can create an expectation an organization cannot sustain. Foresight asks what a reasonable person with the available knowledge should anticipate, not what an omniscient observer could know afterward.

                    This distinction protects against both carelessness and impossible responsibility. “I did not intend it” does not excuse every foreseeable harm. If a driver ignores obvious fatigue, intention alone is inadequate. Yet a person is not morally required to predict a rare chain no reasonable inquiry would reveal. Prudence weighs the seriousness and probability of harm, the vulnerability of those affected, and the cost of prevention. A low-probability catastrophic risk may deserve a safeguard; a remote trivial possibility may not justify paralysis.

                    Foresight also considers character. Repeated acts shape what becomes easy and what we notice. An apparently small deception can prepare larger ones by making concealment normal. A small faithful routine can preserve freedom before crisis arrives. Joseph's planning in Egypt turns years of abundance into provision for famine. His foresight is not anxious stockpiling for private control; it is disciplined stewardship ordered to a people who will depend on decisions made before the need becomes visible.
                    """
                ),
                (
                    "Lecture II — The morality of timing",
                    """
                    A true word can be spoken at a destructive time or in a humiliating setting. A needed intervention can arrive too late. Timing belongs to prudence because human beings receive truth through bodies, relationships, attention, and circumstance. Private correction usually respects dignity better than public exposure; an emergency can reverse that preference. Preparation may allow a person to hear; delay may also permit continued harm. The question is which timing serves truth and the persons involved.

                    Several tests help. Is there immediate danger? Does another person have a right to timely information? Will delay improve understanding or merely reduce the chooser's discomfort? Is the proposed setting proportionate and confidential? What preparation is needed? What date or event will end the delay? By answering explicitly, a person can distinguish patient timing from avoidance. “Tomorrow at 10:00, in private, after I verify the record” is different from “when it feels right.”

                    Pope Francis warns that excessive zeal can ruin a construction needing gradual development and produce conflict or even violence. Zeal sees a real good but may demand its complete appearance immediately, regardless of persons and process. Prudence gives the good a human path. This is not moral laxity. An unjust act should stop; yet rebuilding trust, learning a discipline, healing an addiction, or reforming a system often requires stages, accountability, and repeated help. Truth names the destination; gradualness plans faithful movement toward it.
                    """
                ),
                (
                    "Lecture III — Plans, safeguards, and future freedom",
                    """
                    Foresight becomes practical through contingency planning. Ask what must go right, what could reasonably go wrong, how warning signs will be noticed, and what response will follow. A safeguard should fit the risk. Two-person financial approval, a medical follow-up, a trusted check-in, a content filter, a written boundary, or an emergency contact can protect freedom. Safeguards are not admissions that failure is inevitable; they are humble acknowledgment that good intentions meet predictable pressures.

                    Good plans preserve room for correction. A pilot phase can reveal effects before a full commitment. A review date keeps temporary arrangements from becoming permanent by neglect. A reserve of time or money can absorb ordinary setbacks. Communication prevents others from building expectations on unstated assumptions. None of this guarantees success. It makes responsibility visible and reduces foreseeable harm without attempting to control every future event.

                    Foresight must finally serve hope rather than fear. Catastrophizing treats imagined disaster as certain and can justify never beginning. Carelessness treats hope as though God had promised to cancel natural consequences. Christian trust avoids both. Providence does not exempt us from planning; Joseph plans precisely within God's gift. Nor does planning save us. We act with care, entrust what lies beyond our control to God, and remain available to neighbors whose needs disrupt the schedule. Prudence prepares for tomorrow while still obeying today's duty.
                    """
                ),
            ],
            misconception:
                "Foresight is not fortune-telling, pessimism, or the attempt to eliminate vulnerability. It does not make a person responsible for every imaginable outcome. Gradualness is not permission to keep choosing evil in the name of eventual growth, and urgency is not permission to disregard dignity or due process. Prudent timing names a real reason, a fitting setting, and a point at which action will occur. Serious safety, medical, legal, or safeguarding concerns require the relevant professional procedures rather than an improvised private plan.",
            caseStudy:
                "A supervisor must correct a team member who has repeatedly shared confidential details. Confronting him angrily in tonight's public meeting might stop the immediate conversation but humiliate him and expose more information. Waiting without action leaves others vulnerable. Design a prudent sequence: immediate protection, fact verification, private correction, expectations, support, consequences, and review. Which parts require urgency, which benefit from privacy, and what would turn careful timing into avoidance?",
            practice:
                "Choose one action planned for the next month. List three foreseeable effects on people, promises, resources, habits, or future freedom. Rate each by seriousness and probability, then add no more than two proportionate safeguards. Name the date or signal that will trigger review. End by identifying what remains beyond your control and entrusting it to God.",
            prayer:
                "Provident Father, teach me to prepare without fear and to trust without carelessness. Give me foresight for those who depend on me, patience for real growth, and courage to act when the fitting time arrives.",
            scripture: [
                build.encounter(
                    "prudence-joseph", "Primary reading — Provision before famine",
                    "Trace the movement from interpretation to appointment, policy, years of preparation, and stored provision. Notice whom foresight ultimately serves.",
                    "GEN", 41, 33, 49),
                build.encounter(
                    "prudence-foresee-danger", "Second reading — Reputation, stewardship, and foresight",
                    "Read the sayings together: a good name, treatment of rich and poor, foresight, humility, generosity, and formation belong to practical wisdom.",
                    "PROV", 22, 1, 9),
                build.encounter(
                    "prudence-faithful-little", "Further reading — Shrewdness ordered to faithfulness",
                    "Attend to the difficult image of the manager, then let Jesus' conclusions about small things, trust, money, and masters govern the reading.",
                    "LUKE", 16, 1, 13),
            ],
            remember: [
                "How does foreseeability differ from perfect prediction?",
                "Why must both seriousness and probability shape safeguards?",
                "What questions distinguish prudent timing from avoidance?",
                "How can gradualness serve growth without changing moral truth?",
                "Why are planning and trust in providence partners rather than rivals?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.popePrudence.id,
                sources.gaudete.id, sources.rickaby.id,
            ]
        ),
        lecture(
            id: "prudence-prayer",
            title: "Prayerful discernment",
            summary: "Let prayer open practical reason to God, the Church, other people, and reality.",
            opening:
                "When you bring a decision to prayer, are you asking to receive God's light—or asking God to remove every uncertainty and confirm the option you already prefer?",
            goal:
                "By the end, you should be able to relate prudence to spiritual discernment, pray with a listening posture, test interior movements without making them oracles, and integrate Scripture, Church teaching, counsel, reality, and freedom.",
            terms: [
                "Spiritual discernment — prayerful recognition of what leads toward faithful response to God within a concrete life; it includes prudence but is also dependent on grace.",
                "Interior movement — a thought, desire, attraction, resistance, peace, fear, or impulse noticed within the person; it requires interpretation.",
                "Consolation — in Catholic spiritual tradition, an interior movement toward faith, hope, charity, and God; it is richer than pleasant emotion.",
                "Desolation — a movement toward darkness, discouragement, isolation, or diminished faith, hope, and charity; it is not identical with clinical illness or ordinary sadness.",
            ],
            chapters: [
                (
                    "Lecture I — Prayer does not replace practical reason",
                    """
                    Christian prudence lives before God. Prayer remembers that the good is received, that the person is loved before performing, and that wisdom is gift as well as practice. Yet prayer is not a device for escaping facts, moral law, expertise, or responsibility. “I prayed about it” cannot make deception just, erase another person's rights, or substitute for a physician's diagnosis. Authentic prayer makes the person more available to truth, not less accountable to it.

                    Gaudete et Exsultate teaches that discernment includes reason and prudence but goes beyond them as grace, seeking the unique mission of a life before the Father. This does not create a secret morality for each person. God's personal call never contradicts the Gospel. Rather, among good and permissible ways of serving, the Spirit can shape a concrete response through gifts, responsibilities, circumstances, and the needs of others. A vocation is personal without becoming arbitrary.

                    Prayer also purifies the goal. A decision may be framed as “Which option will make me feel peaceful?” when the deeper question is “How can I love faithfully in the mission entrusted to me?” Peace may come, but emotional comfort is not the final end. Christ's prayer in Gethsemane contains anguish, honest desire, surrender, and obedient action. The presence of distress does not prove the path is wrong. Prayer brings distress into communion so that fear is neither denied nor enthroned.
                    """
                ),
                (
                    "Lecture II — Listen to the Lord, others, and reality",
                    """
                    Pope Francis describes prayerful discernment as readiness to listen to the Lord, to other people, and to reality itself. These are not competing channels. Scripture and the Church give the language and boundaries by which supposed inspiration is tested. Other people reveal needs, wisdom, consequences, and blind spots. Reality resists fantasy: a claimed call must meet actual duties, abilities, limits, and opportunities. Prayer gathers these forms of attention before God.

                    Samuel's story shows discernment maturing through help. He hears but does not yet recognize the Lord; Eli supplies the posture, “Speak, for your servant is listening.” The guidance does not manufacture God's word, and Samuel must still receive a difficult message. Likewise, a spiritual director does not decide what God says by personal authority. A sound guide helps the person notice patterns, remain faithful to the Church, resist self-deception, and act freely.

                    Silence matters because anxiety and habitual noise can drown subtle truth. Prolonged prayer may expose the difference between a stable desire and a passing impulse. Yet duration alone does not certify an idea. Record the movement, its fruits, its consistency with faith and duty, and how it changes over time. A movement toward secrecy, contempt, grandiosity, manipulation, or rejection of moral truth should not be baptized as divine guidance. The Holy Spirit forms charity and communion, even when obedience is costly.
                    """
                ),
                (
                    "Lecture III — Testing movements and choosing freely",
                    """
                    Interior peace can accompany truth, but it can also accompany avoidance once a hard duty is dismissed. Anxiety can signal danger, but it can also persist after a sound decision. Therefore movements should be tested by their direction and fruit: Do they deepen faith, hope, charity, humility, honesty, patience, and responsibility? Do they respect the dignity and freedom of others? Do they survive contact with Scripture, Church teaching, facts, and wise counsel? Do they lead toward concrete service or endless preoccupation with the self?

                    Discernment should not become spiritualized compulsion. Repeating prayers until a particular feeling appears, treating coincidences as commands, opening Scripture at random as an oracle, or asking many spiritual advisers for certainty can weaken freedom. A person experiencing scrupulosity should follow consistent pastoral and clinical guidance rather than invent ever more tests. God can guide without trapping the conscience in riddles.

                    After prayer and proportionate testing, choose. Freedom does not need a supernatural sensation before every ordinary decision. Many choices remain genuinely open; God can be served through more than one. Make the best faithful judgment, ask for grace to carry it out, and entrust the outcome. Continue daily examination not to retry the verdict but to notice fruits, correction, and new duties. Prayerful prudence ends in love of God and neighbor, not fascination with the process of deciding.
                    """
                ),
            ],
            misconception:
                "Prayerful discernment is not divination, private revelation on demand, or a way to label preference as God's command. Consolation is not simply feeling good, and desolation is not proof that a choice is wrong. Mental illness, trauma, and bodily conditions can affect interior experience without being spiritual failure. Distressing voices, commands to harm, or loss of contact with reality require prompt professional help; an app or private discernment method is not appropriate crisis care.",
            caseStudy:
                "A person considering a major move feels exhilarated after prayer and says, “God gave me peace, so I do not need to discuss it with my spouse or check whether the job exists.” Another feels anxious about a well-considered act of reconciliation and concludes God is warning against it. Test both movements through moral truth, existing duties, facts, counsel, freedom, and likely fruits. What would a listening prayer sound like for each? Which matters remain genuinely open after obligations are honored?",
            practice:
                "Bring one decision to a twenty-minute period of prayer. Begin with Scripture, name the true good and your existing duties, then sit in silence. Record interior movements without interpreting them immediately. Over the next days, test them through Church teaching, relevant facts, one wise person, and their fruits. End with a decision date rather than waiting for a perfect feeling.",
            prayer:
                "Speak, Lord, for your servant is listening. Quiet what is false, strengthen what leads to faith, hope, and love, and make me attentive to your word, your Church, my neighbor, and the reality you have given.",
            scripture: [
                build.encounter(
                    "prudence-ask-wisdom", "Primary reading — Ask in faith",
                    "James places the request for wisdom amid trials, endurance, poverty, and divided allegiance. Notice what kind of person is being formed.",
                    "JAS", 1, 2, 8),
                build.encounter(
                    "prudence-samuel", "Second reading — Learning to listen",
                    "Follow Samuel's mistaken recognition, Eli's guidance, the difficult message, and the faithful reception of God's word.",
                    "1SAM", 3, 1, 18),
                build.encounter(
                    "prudence-gethsemane", "Further reading — Desire, anguish, and obedience",
                    "Observe Jesus' honest petition, surrender to the Father's will, need for prayer, and movement toward the act he has accepted.",
                    "LUKE", 22, 39, 46),
            ],
            remember: [
                "How does spiritual discernment include prudence while also depending on grace?",
                "Why can neither peace nor anxiety function as an automatic verdict?",
                "What does it mean to listen to the Lord, others, and reality together?",
                "Which fruits help test an interior movement?",
                "When does a discernment practice become reassurance-seeking or divination?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismConscience.id,
                sources.gaudete.id, sources.popeGrace.id,
            ]
        ),
        lecture(
            id: "prudence-counterfeits",
            title: "Prudence and its counterfeits",
            summary: "Expose the forms of fear, cunning, rashness, and rigidity that borrow prudence's name.",
            opening:
                "Which phrase are you most likely to use when avoiding a difficult good: “I am being careful,” “I am just being honest,” or “I have to do something now”?",
            goal:
                "By the end, you should be able to distinguish prudence from timidity, cunning, rashness, rigidity, and scrupulosity; identify the partial good each counterfeit exploits; and choose a corrective practice.",
            terms: [
                "Timidity — disproportionate fear that withdraws from a good or duty while presenting avoidance as caution.",
                "Cunning — practical cleverness directed toward manipulation, concealment, or self-interest rather than the true good.",
                "Rashness — action that bypasses proportionate attention, counsel, or consequence.",
                "Rigidity — attachment to one procedure or interpretation that refuses relevant circumstances, growth, or correction.",
            ],
            chapters: [
                (
                    "Lecture I — Fear and cleverness can imitate prudence",
                    """
                    Counterfeits resemble a virtue closely enough to borrow its language. Timidity says, “It is not the right time,” even after the duty, means, and moment are clear. It notices real risk but lets self-protection become the governing good. Genuine prudence can delay for preparation or safety; timidity supplies no truthful condition that would end the delay. The corrective is not reckless exposure but a concrete, proportionate act of courage under wise counsel.

                    Cunning displays the opposite energy. It reads people, predicts reactions, and chooses efficient means, yet directs these powers toward control, concealment, advantage, or escape. Because the plan is sophisticated, it can feel like wisdom. But prudence is inseparable from the true good. A manipulative apology designed only to restore access, a technically legal scheme that exploits the vulnerable, or a selective disclosure that creates a false impression may be clever without being prudent.

                    Jesus tells disciples to be wise as serpents and innocent as doves. The two belong together. Innocence without practical alertness can expose people to preventable harm; shrewdness without innocence becomes manipulation. Christian prudence does not require naïveté about power or evil. It can document facts, set boundaries, use formal procedures, and protect confidential information. The question is whether intelligence remains governed by truth, justice, and love rather than by victory over another person.
                    """
                ),
                (
                    "Lecture II — Rashness and rigidity refuse reality",
                    """
                    Rashness can masquerade as courage, spontaneity, or trust in God. It sees a good and leaps without asking whether the act is morally sound, whether the person has the authority or competence, or who will bear foreseeable harm. The rash speaker calls cruelty candor; the rash giver makes promises someone else must fund; the rash reformer destroys a working support before a replacement exists. Urgency can be real, but urgent action still requires the best judgment the moment permits.

                    Rigidity can masquerade as fidelity. It takes a rule, past solution, or personal method and applies it without receiving the concrete situation. Moral principles do not change with convenience, but applications require attention. The same duty of care may require different actions for a child and an adult, a first mistake and a dangerous pattern, a private weakness and a public responsibility. Prudence does not dilute truth; it prevents a formula from ignoring the person truth is meant to serve.

                    Both counterfeits protect the self from listening. Rashness says there is no time to hear; rigidity says nothing new can matter. The prudent person remains anchored and teachable. In emergency, the person takes the safest morally sound next step and seeks more knowledge as soon as possible. In continuity, the person honors accumulated wisdom while asking whether changed facts require a different embodiment. Stability of principle and flexibility of means are partners.
                    """
                ),
                (
                    "Lecture III — Scrupulosity, superficiality, and worldly wisdom",
                    """
                    Scrupulosity imitates moral seriousness while making certainty itself the goal. A person repeatedly reviews settled matters, multiplies obligations, or treats minor ambiguity as grave guilt. The sufferer is not helped by being told simply to try harder. Stable guidance, limits on repeated checking, trust in God's mercy, and sometimes specialized mental-health care may be needed. Prudence accepts reasonable moral certainty and acts; it does not demand an impossible feeling of total safety.

                    Superficiality is the opposite refusal. It jokes away complexity, adopts whatever a group says, or treats consequences as somebody else's problem. Pope Francis contrasts prudence with dismissing problems through shallow jokes or inciting controversy. A superficial person may seem relaxed, but ease purchased by refusing reality is not freedom. The corrective is sustained attention: name the affected people, the actual duty, and the fact most convenient to ignore.

                    Saint James contrasts earthly wisdom marked by bitter envy and selfish ambition with wisdom from above that is pure, peaceable, gentle, open to reason, merciful, fruitful, impartial, and sincere. This offers a diagnostic portrait. Prudence can be firm and strategically intelligent, yet its fruits are not deception, faction, and self-exaltation. When a process consistently produces secrecy, contempt, domination, or moral isolation, the name “prudence” should be questioned. True wisdom remains recognizable by truth and good fruit.
                    """
                ),
            ],
            misconception:
                "Naming a counterfeit does not authorize diagnosing another person's heart. The same outward delay may arise from prudent fact-finding, trauma, ordinary fear, manipulation, or a mixture. Examine evidence and your own choices first. Likewise, prudence is not perpetual moderation between extremes: sometimes the fitting act is an unambiguous refusal, urgent report, or costly commitment. The mean of virtue is measured by reason and the good, not by what appears socially balanced.",
            caseStudy:
                "A parish volunteer discovers a recurring safety shortcut. One leader says reporting it would create scandal and proposes indefinite private monitoring; another wants to post accusations online before facts are verified. A third suggests preserving records, stopping the immediate risk, using the safeguarding process, and communicating only what responsible authorities and affected persons need. Identify timidity, rashness, possible cunning, and prudent elements. What facts and procedures matter? Why can concern for reputation never become a reason to leave people exposed?",
            practice:
                "Review one recurring decision and name the counterfeit most likely to distort it. Write the partial good that makes the counterfeit attractive, the fact or duty it ignores, and one corrective practice: a dated courageous step, honest disclosure, a pause for counsel, flexible application, or a limit on repeated checking. Share the plan with a trustworthy person if the pattern is strong.",
            prayer:
                "Jesus, make me innocent without naïveté and wise without deceit. Free me from fear, haste, rigidity, and false certainty so that my intelligence may bear the good fruit of truth and love.",
            scripture: [
                build.encounter(
                    "prudence-serpents-doves", "Primary reading — Wise and innocent",
                    "Read Jesus' mission instructions as a whole: vulnerability, alertness, truthful witness, persecution, trust, and endurance shape Christian prudence.",
                    "MATT", 10, 16, 26),
                build.encounter(
                    "prudence-wisdom-above", "Second reading — Wisdom known by its fruits",
                    "Compare the sources, traits, and communal results of selfish ambition and wisdom from above.",
                    "JAS", 3, 13, 18),
                build.encounter(
                    "prudence-cross-wisdom", "Further reading — The cross judges worldly wisdom",
                    "Paul does not reject intelligence; he exposes boasting and power that cannot recognize God's saving wisdom in Christ crucified.",
                    "1COR", 1, 18, 31),
            ],
            remember: [
                "How does timidity borrow the language of prudent delay?",
                "Why is cunning incompatible with prudence even when it succeeds?",
                "How do rashness and rigidity each refuse reality?",
                "What distinguishes scrupulosity from a well-formed concern for conscience?",
                "Which fruits in James help reveal whether practical intelligence is truly wise?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismConscience.id,
                sources.popePrudence.id, sources.gaudete.id, sources.rickaby.id,
            ]
        ),
        lecture(
            id: "prudence-practice",
            title: "Capstone: a complete discernment",
            summary: "Bring the whole course together in one repeatable process from truth to review.",
            opening:
                "What current decision is important enough to deserve the full prudential process, but concrete enough that you can take a real next step this week?",
            goal:
                "By the end, you should be able to carry a decision through the complete cycle of receiving the good, forming conscience, gathering reality, seeking counsel, deliberating, judging, acting, and reviewing in prayer.",
            terms: [
                "Discernment record — a concise written account of the good, facts, principles, counsel, options, judgment, action, and review point.",
                "Decision rule — a truthful criterion established before choice that indicates what evidence or priority will govern the judgment.",
                "Provisional action — a reversible, morally sound step taken under limited information while safety or further inquiry continues.",
                "Review — reflection after action that learns from process and effects, makes repair, and carries wisdom forward.",
            ],
            chapters: [
                (
                    "Lecture I — Receive the decision before trying to solve it",
                    """
                    Begin by stating the decision in neutral language. “How do I escape this impossible job?” already assumes the only good is departure; “How should I fulfill my responsibilities amid an unhealthy workplace?” leaves room to discover the answer. Name the true good, the people and promises involved, and the authority or role you actually possess. Then identify moral boundaries. What actions would be untruthful, unjust, coercive, or otherwise excluded regardless of their efficiency?

                    Form conscience before optimizing. Consult the relevant teaching of the Church rather than relying on a remembered slogan. Describe the proposed acts through object, intention, and circumstances. Ask whether ignorance is being maintained because truth threatens a preferred result. Prayer belongs from the beginning: offer the desire, fear, and outcome to God, and ask for freedom to receive an answer that costs something.

                    Now build the factual picture. Separate observations, interpretations, emotions, hopes, fears, and unanswered questions. Determine which missing facts could change the choice and gather them through proportionate means. Attend to urgency and safety. If immediate harm is credible, take the safest morally sound provisional action and contact the appropriate person or authority. The full process is not a reason to postpone protection; it organizes the next faithful step under the light actually available.
                    """
                ),
                (
                    "Lecture II — Counsel, options, and judgment",
                    """
                    Review relevant memory: what previous choices teach, what patterns recur, and where old wounds may be overgeneralized. Seek counsel matched to the question. A complete decision may need moral, relational, technical, financial, medical, or legal knowledge. Give advisers the relevant truth, note their competence and interests, and listen for reasons rather than permission. Advice should enlarge responsible judgment, not replace it.

                    Generate a limited set of morally permissible options. Include staged or creative means when a false binary has formed. Compare duties, affected persons, benefits, harms, resources, timing, reversibility, and the habits each option strengthens. Identify opportunity costs rather than pretending one path preserves every good. Add foresight: likely consequences, warning signs, safeguards, and a review date. Then state the decision rule that will govern the choice.

                    Set a deadline proportionate to stakes and urgency. At that point, distinguish unresolved facts that genuinely matter from discomfort that no research can remove. Pray again, not to summon a sign, but to listen and surrender. Make the practical judgment in one sentence: “Given these duties, facts, and moral limits, I should…” Then issue the command through a concrete action, person, and time. A decision that never reaches the body remains an idea.
                    """
                ),
                (
                    "Lecture III — Act, review, and remain teachable",
                    """
                    Execution should embody the same virtues that shaped judgment. Speak truth with charity, protect legitimate confidentiality, document what responsibility requires, and avoid promises beyond your control. Use safeguards without treating them as guarantees. If fear rises, return to the reasons already judged rather than reopening every option. Ask for grace to do what is possible now.

                    Responsible execution also communicates enough for other people to act freely. A decision that changes shared obligations should not remain hidden until the last moment merely because disclosure feels uncomfortable. State what has been decided, what remains uncertain, which responsibilities belong to whom, and when the next review will occur. Clarity prevents prudence from becoming private control and lets the common good shape implementation.

                    At the review point, examine process and effects. Which facts were accurate? What consequence was unforeseen? Did the act serve the intended good through sound means? What did affected people experience? Is correction, apology, restitution, escalation, perseverance, or no change required? New evidence can justify revision; repeated anxiety without new evidence does not. Record one lesson so future memory becomes more truthful.

                    The Council of Jerusalem in Acts 15 offers a communal picture: a real dispute is named, testimony and tradition are heard, Scripture is interpreted, authority judges, burdens are considered, and a concrete communication is sent. The process is not mechanical or conflict-free. It seeks fidelity and communion through human voices under the Holy Spirit. Mary's response at the Annunciation offers the personal center: she questions how, receives an answer, consents in freedom, and moves in service. Christian prudence is neither solitary calculation nor passive waiting. It is intelligent, ecclesial, prayerful cooperation with grace.
                    """
                ),
            ],
            misconception:
                "The full process is a scaffold, not a ritual that every small choice must complete in writing. Use it in proportion to the decision. It cannot guarantee a painless outcome, reveal another person's conscience, calculate culpability, or replace competent help. Nor should a person in immediate danger finish a worksheet before seeking safety. Prudence serves life and love; tools serve prudence. The mature goal is an increasingly stable habit of seeing, judging, choosing, and reviewing well.",
            caseStudy:
                "A professional is asked to approve a report containing a claim she believes is materially misleading. Refusal could affect colleagues and her own employment; approval could harm customers and make her responsible for deception. Walk the case through every stage: neutral decision statement, true good, moral boundaries, object-intention-circumstances, facts and interpretations, urgency, counsel, permissible options, affected persons, foreseeable effects, safeguards, decision rule, command, and review. Identify which aspects require a priest or moral adviser, workplace expertise, legal advice, or a protected reporting process.",
            practice:
                "Complete one discernment record for a current, non-crisis decision. Keep each stage concise enough that the process remains usable. Name a decision date, the first concrete action, one safeguard, and one review date. If the matter concerns danger, abuse, medical care, law, severe mental distress, or grave moral uncertainty, use the record only to organize facts and questions while obtaining qualified help.",
            prayer:
                "Father of light, gather memory, reason, conscience, counsel, freedom, and love within your grace. Teach me to receive reality, judge truthfully, act faithfully, repair humbly, and entrust every outcome to you through Christ.",
            scripture: [
                build.encounter(
                    "prudence-mary-consent", "Primary reading — Question, consent, and service",
                    "Follow Mary's movement from interruption and questioning to free consent, concrete journey, greeting, and shared praise.",
                    "LUKE", 1, 26, 45),
                build.encounter(
                    "prudence-jerusalem-council", "Second reading — Discernment in the Church",
                    "Map the dispute, testimony, remembered action of God, Scripture, judgment, concern for people, and concrete next steps.",
                    "ACTS", 15, 1, 21),
                build.encounter(
                    "prudence-peace-word-action", "Further reading — Let peace and the word govern",
                    "Paul joins virtues, forgiveness, love, peace, shared teaching, gratitude, speech, and action in the name of Christ.",
                    "COL", 3, 12, 17),
            ],
            remember: [
                "Why should a decision be stated neutrally before possible solutions are compared?",
                "What belongs in the factual, moral, consultative, and deliberative stages of discernment?",
                "How does a decision rule protect freedom at the moment of judgment?",
                "When is a provisional action more prudent than either final action or passive delay?",
                "How should new evidence, ordinary difficulty, and recurring anxiety affect review?",
                "What do Mary and the Council of Jerusalem reveal about personal and ecclesial discernment?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismMoralActs.id,
                sources.catechismConscience.id, sources.catechismFreedom.id,
                sources.gaudete.id, sources.popePrudence.id, sources.rickaby.id,
            ]
        ),
    ]
}

import Foundation

extension CardinalTemperanceVirtueLectures {
    static let partOne: [VirtueStudyLesson] = [
        lecture(
            id: "cardinal-temperance-measure",
            title: "The fitting measure",
            summary:
                "Define temperance as self-mastery and learn why the right measure is ordered to a greater good rather than always meaning less.",
            opening:
                "In which area do you rely on a number or rule without being able to name the human good that the limit is meant to protect?",
            goal:
                "By the end, you should be able to define temperance, distinguish measure from mere quantity, relate it to prudence and freedom, and identify purpose, person, duties, and circumstances when setting a limit.",
            terms: [
                "Temperance — the moral virtue that moderates the attraction of pleasures and provides balance in the use of created goods.",
                "Self-mastery — the developed freedom to direct desire and action rather than being carried by impulse; it is service of the good, not domination or hatred of the self.",
                "Fitting measure — the amount, manner, timing, and context that allow a created good to serve integral human flourishing.",
                "Abstinence — freely refraining from a good or pleasure for a moral, spiritual, health, relational, or practical reason.",
            ],
            chapters: [
                (
                    "Lecture I — Temperance is power ordered toward freedom",
                    """
                    The Catechism defines temperance through moderation, balance, mastery of instinct, and direction of sensitive appetite toward what is good. Pope Francis calls it power over oneself and the art of bringing order into the human heart. This power is not contempt for feeling or the body. It means that desire can become part of a complete human choice rather than the only voice heard. A temperate person can receive, enjoy, delay, stop, share, or abstain because the good of the whole person remains visible.

                    Temperance is cardinal because its ordering work reaches many domains: food, drink, sexuality, rest, entertainment, possessions, speech, anger, comfort, attention, and social approval. These are not all governed by identical rules. The shared task is to keep a partial good in truthful relationship with health, vocation, worship, justice, love, and final happiness in God. Pleasure is real, but it cannot determine by itself whether an action is fitting.

                    Self-mastery differs from tight control motivated by fear or perfectionism. A person can follow severe rules while remaining obsessed, proud, ashamed, or unable to adapt. Virtue makes action more reasonable, grateful, and available to love. The question is not merely, “Did I stay under the limit?” but “Did this use of the good serve its purpose and preserve freedom for my actual duties?” A rule assists virtue when it trains that judgment rather than replacing it forever.
                    """
                ),
                (
                    "Lecture II — The right measure is not always less",
                    """
                    Temperance is often reduced to restriction, yet the fitting measure can require enough nourishment, adequate sleep, genuine rest, appropriate celebration, and generous hospitality. Too little can violate the good as surely as too much. A person who deprives the body to secure admiration or control is not necessarily temperate. A host who refuses festivity out of fear may miss a relational good. A worker who never rests may be immoderate in labor even while avoiding conventional pleasures.

                    Measure depends upon the good, person, responsibilities, health, history, vocation, and circumstances. Alcohol may be moderately enjoyed by one adult and require total abstinence for another because of recovery, medication, pregnancy, age, safety, or duty. A feast and an ordinary meal rightly differ. A phone may need to remain available for an on-call physician while another person needs it outside the bedroom. Universal moral truths remain; practical limits translate them into a concrete life.

                    This is why prudence governs temperance. Quantity alone cannot answer every question. Ask the purpose of the good, the normal amount and context, warning signs of lost freedom, effects on others, and exceptions serving hospitality or need. Define enough positively: enough food to nourish, enough entertainment to restore, enough spending to meet a need, enough speech to communicate truth. A positive purpose makes a limit intelligible and less vulnerable to arbitrary severity.
                    """
                ),
                (
                    "Lecture III — Discipline serves a crown that lasts",
                    """
                    Paul compares Christian discipline to athletes training for a prize. The body is not the enemy; it is trained for a worthy end. Athletes structure sleep, practice, nutrition, and effort because scattered impulse cannot carry a vocation. Christian asceticism similarly gives desire a purpose. Yet the imperishable crown exceeds performance, and grace prevents discipline from becoming self-salvation.

                    Proverbs warns against excess in honey and against a city with broken walls. The image connects pleasure and self-governance: a good thing can be misused when no capacity to stop protects the person. Philippians adds a different dimension. Paul has learned how to live with abundance and need through Christ who strengthens him. Temperance is not only restraint under abundance; it is stable freedom across changing circumstances, neither possessed by having nor destroyed by lacking.

                    Begin with one domain rather than redesigning the entire life. Name its purpose, current pattern, ordinary measure, legitimate exceptions, and warning signs. Choose a short experiment and review its effects on prayer, body, relationship, work, and joy. The rule should be safe and revisable. If a pattern includes addiction, an eating disorder, self-harm, severe anxiety, or medical risk, private rule-making is not enough. Qualified care belongs to truthful self-mastery.
                    """
                ),
            ],
            misconception:
                "Temperance does not always mean consuming less, choosing the least pleasant option, or following the strictest available rule. It seeks the measure that serves the good. Adequate nourishment, sleep, treatment, celebration, and rest can be acts of temperance. Severity motivated by shame, control, or admiration can remain disordered, and serious health or compulsive patterns require more than a private limit. A demanding rule is not automatically a mature rule: its object, motive, circumstances, effects, and relationship to vocation still require judgment. The ability to revise a mistaken limit can itself show greater self-mastery than stubbornly preserving it for appearance.",
            caseStudy:
                "A worker sets a rigid five-hour sleep rule to gain more productive time and prides himself on discipline. He becomes irritable, drives while exhausted, misses prayer, and uses increasing caffeine. He says comfort must not rule him. Identify the good he seeks, the body's legitimate claim, effects on others, the difference between training and domination, and what information or medical care may be needed before setting a fitting measure.",
            practice:
                "Choose one ordinary pleasure or comfort. Write its purpose, the greater good a limit should protect, a normal measure, one legitimate exception, and two warning signs. Practice that measure for seven days and review effects without scoring your worth. Do not create a food, medication, sleep, or substance rule contrary to professional care.",
            prayer:
                "Creator of body and soul, teach me the measure that serves love. Free me from excess and needless severity, and make discipline a grateful servant of the life you give.",
            scripture: [
                build.encounter(
                    "cardinal-temperance-measure-race", "Primary reading — Discipline for a lasting crown",
                    "Read freedom, service, mission, athletic training, purpose, and bodily discipline together rather than isolating one image of severity.",
                    "1COR", 9, 19, 27),
                build.encounter(
                    "cardinal-temperance-measure-proverbs", "Second reading — Enough and guarded freedom",
                    "Notice the sayings about honey, honor, self-seeking, words, and the unguarded city as a portrait of measure in relationship.",
                    "PROV", 25, 16, 28),
                build.encounter(
                    "cardinal-temperance-measure-content", "Further reading — Freedom in abundance and need",
                    "Trace concern, circumstance, contentment, hunger, abundance, need, strength in Christ, and generous partnership.",
                    "PHIL", 4, 10, 20),
            ],
            remember: [
                "How does the Catechism define temperance?",
                "Why is self-mastery different from contempt or rigid control?",
                "Why can a fitting measure require more rather than less?",
                "Which factors help prudence translate temperance into a concrete limit?",
                "What positive good should your present discipline protect?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.catechismPassions.id,
                sources.popeTemperance.id, sources.rickaby.id,
            ]
        ),
        lecture(
            id: "cardinal-temperance-desire",
            title: "Desire educated, not erased",
            summary:
                "Understand embodied desire without shame and learn the difference between repression, indulgence, and integration.",
            opening:
                "When a strong desire appears, do you treat it as a command, an enemy, or meaningful information that still needs judgment?",
            goal:
                "By the end, you should be able to distinguish desire from choice, explain integration, identify the goods and needs carried by appetite, and create a free pause between impulse and action.",
            terms: [
                "Desire — an inclination toward a perceived good; it can be fitting, misdirected, disproportionate, or carrying several needs at once.",
                "Repression — refusal to acknowledge or truthfully engage a desire, often leaving it hidden rather than integrated.",
                "Indulgence — giving desire practical command because it is present or intense, without adequate judgment of the whole good.",
                "Integration — bringing body, emotion, reason, relationship, moral truth, and vocation into a unified free response.",
            ],
            chapters: [
                (
                    "Lecture I — Desire belongs to embodied human life",
                    """
                    The passions are natural movements of the human person. Pleasure, longing, fear, anger, and sadness are not automatically virtuous or sinful simply because they are felt. They become morally significant as reason and will receive, interpret, encourage, redirect, or act upon them. This distinction protects both responsibility and mercy. An unwanted impulse is not identical to consent; a strong appetite is not proof of bad character; feeling little pleasure is not proof of holiness.

                    Desire usually perceives some good. Hunger seeks nourishment, fatigue rest, loneliness communion, sexual desire embodied relationship, curiosity knowledge, and the wish for recognition belonging or confirmation. The perceived good may be real while the proposed object, timing, amount, or method is unfitting. A late-night purchase may promise security; endless scrolling may promise connection; overeating may promise comfort. Temperance asks what the desire is carrying without letting that explanation become permission.

                    Shame narrows attention and encourages secrecy. A person may condemn the entire self for an impulse, then seek relief through the same pattern. Truthful curiosity interrupts the cycle: What sensation or emotion is present? What happened before it? What good is sought? Which duty or relationship matters? What response could honor the need without surrendering freedom? This is not endless introspection. It gives desire a hearing without giving it the throne.
                    """
                ),
                (
                    "Lecture II — Repression and indulgence divide the person",
                    """
                    Repression says, “I must not feel this,” and may use busyness, severity, spiritual language, or denial to keep desire unexamined. The hidden desire can then return through resentment, secrecy, fantasy, or sudden excess. Indulgence says, “Because I feel this, I need or deserve to act.” It collapses the distance in which freedom can judge. Both responses let desire dominate: one through fear of its presence, the other through obedience to its urgency.

                    Integration names the desire, accepts the body as part of the person, judges the real good, and chooses within vocation and moral truth. The answer may be enjoyment, delay, substitution, sharing, a limit, or abstinence. Integration can also uncover a deeper need requiring a different good: call a friend instead of shopping for relief, eat a nourishing meal rather than punish hunger, sleep instead of seeking novelty, grieve rather than anesthetize, or obtain clinical care rather than intensify private rules.

                    Romans 6 tells believers not to let sin reign in the body and instead to present themselves to God. The body is not discarded; its members become instruments of righteousness. First Corinthians 6 similarly joins freedom, bodily dignity, resurrection, union with Christ, and glorifying God in the body. Self-mastery is therefore embodied offering. The person does not become free by ceasing to have appetite but by becoming able to direct bodily life toward communion and love.
                    """
                ),
                (
                    "Lecture III — Build the free pause",
                    """
                    Sirach counsels against following desires blindly and spending oneself on appetite. A practical free pause can be brief: stop, breathe, name the desire and emotion, remember the relevant good, then choose. The pause need not eliminate intensity. It creates enough space for the whole person to enter. For recurring patterns, the environment should support the pause through prepared alternatives, reduced cues, accountability, and limits decided before fatigue.

                    Not every delay is virtuous. Ignoring hunger, medication, sleep, or a legitimate relational need can become neglect. The pause is ordered to a responsible answer, not permanent postponement. Nor should someone with obsessive-compulsive patterns use the exercise for endless certainty checks. A stable plan made with a clinician or adviser may be more temperate than repeatedly reopening the decision.

                    After acting, review without contempt. Did the response serve the good? What trigger or need became clearer? Is repair required? Which environmental change would make future freedom more available? Failure does not prove desire cannot be integrated; it reveals the need for repentance, mercy, learning, and perhaps greater support. Repeated harmful loss of control, withdrawal, secrecy, medical risk, or severe distress should move the person toward qualified care rather than a harsher self-imposed discipline.
                    """
                ),
            ],
            misconception:
                "Integration does not mean approving every desire, analyzing every impulse, or waiting until appetite becomes calm before choosing. It also does not treat the body as a machine to control. Desire can be acknowledged without consent and redirected without shame. Where trauma, addiction, eating disorder, compulsion, or another clinical condition is present, professional treatment can be part of integration. Nor does integration guarantee that every conflict will disappear. Mature desire can remain costly: a person may still feel attraction, grief, hunger, anger, loneliness, or resistance while freely choosing the better good. Progress may first appear as earlier recognition, honest disclosure, prepared support, and a quicker return rather than effortless calm.",
            caseStudy:
                "After a lonely workday, a person repeatedly opens shopping apps and buys items that remain unopened. She alternates between telling herself she deserves comfort and calling herself shallow. Map the bodily state, emotion, perceived goods, financial duties, environmental cues, and freedom. What response addresses loneliness and fatigue directly? What purchasing boundary would help, and when would debt or compulsion warrant professional support?",
            practice:
                "Use a sixty-second pause before one recurring consumption choice. Name body, emotion, desire, perceived good, duty, and chosen response. Prepare one positive alternative before the vulnerable moment. Review the experiment after seven days without using a lapse as permission for shame or a more extreme rule.",
            prayer:
                "God who created me embodied, teach me to hear desire without fear and govern it without contempt. Unite my body, heart, reason, and freedom in the service of love.",
            scripture: [
                build.encounter(
                    "cardinal-temperance-desire-offer", "Primary reading — Present yourselves to God",
                    "Follow baptism, death and life with Christ, bodily desire, the reign of sin, freedom, and the offering of the person to righteousness.",
                    "ROM", 6, 1, 14),
                build.encounter(
                    "cardinal-temperance-desire-body", "Second reading — Freedom and bodily dignity",
                    "Read lawful things, mastery, bodily purpose, resurrection, union, flight from sin, belonging, and glory as one account of freedom.",
                    "1COR", 6, 12, 20),
                build.encounter(
                    "cardinal-temperance-desire-sirach", "Further reading — Do not follow every appetite",
                    "Attend to desire, resources, self-command, consequence, repentance, and timing in wisdom's compact practical counsel.",
                    "SIR", 18, 30, 33),
            ],
            remember: [
                "Why is feeling a desire different from consenting to an action?",
                "How do repression and indulgence each surrender freedom?",
                "What does integration bring together?",
                "How can a deeper need be honored without obeying the first proposed object?",
                "When does a recurring pattern require more than a private pause?",
            ],
            sourceIDs: [
                sources.catechismPassions.id, sources.catechismHumanVirtues.id,
                sources.catechismGrace.id,
            ]
        ),
        lecture(
            id: "cardinal-temperance-created-goods",
            title: "Good things are still good",
            summary:
                "Receive creation with gratitude while refusing to ask limited goods to become identity, salvation, or anesthesia.",
            opening:
                "Which created good do you either distrust as though enjoyment were dangerous or depend upon as though life could not be good without it?",
            goal:
                "By the end, you should be able to ground temperance in creation's goodness, explain gratitude and stewardship, distinguish enjoyment from idolatry, and receive an ordinary pleasure attentively and freely.",
            terms: [
                "Created good — a reality made or permitted within creation that can serve human flourishing under God's order and moral truth.",
                "Gratitude — truthful recognition of a received gift and its giver, disposing the person toward care, sharing, and praise.",
                "Idolatry — treating a created reality as ultimate, giving it trust, obedience, or identity that belongs to God.",
                "Stewardship — responsible use and care of received goods for personal, neighborly, and common flourishing.",
            ],
            chapters: [
                (
                    "Lecture I — Creation is good and the person is embodied",
                    """
                    Genesis declares bodily human life and creation very good. Christianity does not teach that matter, pleasure, food, rest, beauty, sexuality, possessions, or celebration are evil substances from which the spirit must escape. The Son assumes a body, participates in meals and wedding joy, heals bodies, and rises bodily. Temperance begins from this affirmation because only a real good can be rightly enjoyed or wrongly used.

                    First Timothy rejects teachings that forbid created gifts as though holiness required contempt. Food is received with thanksgiving and sanctified by God's word and prayer. Gratitude places enjoyment within relationship. The gift is not self-generated, unlimited, or detached from others. A prayer before a meal cannot excuse waste or indifference, but it can train attention toward giver, workers, land, companions, and people who lack enough.

                    Contempt for creation can imitate discipline while producing ingratitude, anxiety, or superiority. A person may reject celebration, beauty, rest, or ordinary pleasure because receiving feels unsafe or morally suspect. Temperance can require learning to enjoy without fear. This is especially important when shame or disordered patterns have damaged the relationship with body and food. Healing may require clinicians, dietitians, therapists, pastors, or recovery communities; a generic ascetical rule is not a substitute.
                    """
                ),
                (
                    "Lecture II — A gift is limited and relational",
                    """
                    Created goodness is limited goodness. A meal can nourish but cannot answer loneliness permanently. Money can secure real goods but cannot guarantee worth or love. Entertainment can restore but cannot provide a vocation. Technology can connect but cannot replace embodied communion. When a gift is asked to bear an ultimate need, use becomes increasingly anxious: more quantity, novelty, speed, or control is required because the object cannot deliver what was promised.

                    Gratitude corrects this demand. It lets a good be itself. The person can savor beauty without possessing it, enjoy company without controlling it, rest without making comfort the final end, and use tools without finding identity in them. Gratitude also moves outward. Gifts are cared for, shared, and used with respect for workers, poor neighbors, creation, and future persons. Temperance and justice meet because consumption always occurs within relationships.

                    Psalm 104 praises a creation of water, animals, work, food, wine, oil, bread, seasons, darkness, sea, creatures, and dependence upon God. Human use appears inside a world not made solely for human appetite. Wonder widens attention beyond consumption. The person becomes a participant and steward rather than predator. Pleasure deepens when connected to reality instead of consumed rapidly as a private product.
                    """
                ),
                (
                    "Lecture III — Enjoyment, detachment, and the freedom to stop",
                    """
                    Pope Francis says temperance does not make life gray; it allows better enjoyment of table fellowship, friendship, trust, and creation's beauty. Excess often dulls rather than enlarges pleasure. Endless novelty makes attention shallow, and hurried consumption loses taste. Measure restores presence. The person can say, “This is good,” enjoy it, and also say, “This is enough.”

                    Detachment is not indifference. It loves the gift without making possession necessary for identity. Loss can still hurt; giving can still cost. Freedom appears as the capacity to share, put away, choose another good, or abstain for love. Celebration can be generous because the person is not anxiously extracting maximum personal pleasure. Simplicity can be joyful because it is not a punishment.

                    Practice receptive attention. Before using one good, remember where it came from and whom it affects. During enjoyment, remove competing distraction and notice the actual experience. At the end, stop deliberately and give thanks. Then ask whether care, cleanup, sharing, or restitution follows. This small pattern—receive, savor, stop, thank, steward—trains a relationship with creation that is neither contemptuous nor possessive.
                    """
                ),
            ],
            misconception:
                "Affirming creation's goodness does not make every product, use, amount, or desire morally fitting. Created goods remain under truth, justice, health, vocation, and the common good. Detachment does not mean refusing affection or pretending loss is painless. It means receiving a limited good as a gift rather than demanding that it become God, identity, or escape from every sorrow. Gratitude is also more demanding than a pleasant feeling. It asks how a good was produced, who labored, what creation bore, whether another person was excluded, and what care follows reception. One may thank God for food while still needing to oppose exploitative conditions, reduce waste, pay fairly, or change a habit. Likewise, sacrifice is not automatically detached: refusing a gift can protect control, image, or fear. Christian detachment allows both reception and relinquishment to be governed by love, and it permits grief when a real good is lost. The creature's limits do not erase its goodness; they keep it from carrying the weight of salvation.",
            caseStudy:
                "A person declines family celebrations because desserts and leisure feel spiritually inferior, then privately consumes food in anxiety afterward. Relatives praise the visible discipline. Identify real health considerations, shame, desire, public identity, relationship, and the goodness of festivity. What would truthful participation look like? Which supports might be needed if food restriction or bingeing suggests an eating disorder?",
            practice:
                "Choose one ordinary created good and practice receive, savor, stop, thank, and steward. Use it slowly and without a second distraction. Note the people and creation involved, stop at the fitting point, and complete any care or sharing that follows. Do not use this as a food exposure exercise contrary to clinical guidance.",
            prayer:
                "Creator of every good gift, free me from contempt and possession. Teach me to receive with wonder, enjoy with presence, stop with freedom, share with justice, and return all praise to you.",
            scripture: [
                build.encounter(
                    "cardinal-temperance-goods-creation", "Primary reading — Creation entrusted and called very good",
                    "Attend to embodied humanity, image, relationship, fruitfulness, stewardship, provision, and God's judgment upon the whole created order.",
                    "GEN", 1, 26, 31),
                build.encounter(
                    "cardinal-temperance-goods-thanks", "Second reading — Received with thanksgiving",
                    "Read false severity, creation's goodness, reception, thanksgiving, God's word, and prayer as protection against contempt.",
                    "1TIM", 4, 1, 5),
                build.encounter(
                    "cardinal-temperance-goods-psalm", "Further reading — Wonder within a shared creation",
                    "Let the Psalm widen attention from human use to creatures, seasons, work, nourishment, dependence, life, death, renewal, and praise.",
                    "PS", 104, 1, 35),
            ],
            remember: [
                "Why must temperance begin from the goodness of creation?",
                "How does gratitude change enjoyment and use?",
                "What happens when a limited good is asked to meet an ultimate need?",
                "How does detachment differ from contempt or indifference?",
                "What five movements form grateful reception of an ordinary good?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.popeTemperance.id,
                sources.popeGluttony.id, sources.catechismGoodsAndProperty.id,
            ]
        ),
        lecture(
            id: "cardinal-temperance-domains",
            title: "Food, drink, and festivity",
            summary: "Practice freedom where nourishment, pleasure, health, hospitality, solidarity, and habit meet.",
            opening:
                "Does your way of eating and drinking help you receive nourishment and communion—or has it become hurried, secret, controlling, wasteful, or disconnected from need?",
            goal:
                "By the end, you should be able to distinguish nourishment, festivity, and misuse; evaluate alcohol and other health risks; reject body-size moralism; and practice attentive, grateful table fellowship.",
            terms: [
                "Gluttony — disordered relationship to consumption in which appetite, excess, manner, preoccupation, waste, or social indifference displaces the good.",
                "Festivity — shared celebration of a meaningful good through time, food, drink, beauty, ritual, and relationship.",
                "Sobriety — clear and responsible freedom from intoxication or mastery by substances; for some people it requires complete abstinence.",
                "Eating disorder — a serious health condition involving food, eating, body, or related behaviors that requires qualified clinical care rather than moral labeling.",
            ],
            chapters: [
                (
                    "Lecture I — Food serves life and communion",
                    """
                    Eating is a vital need, pleasure, cultural practice, labor, and place of relationship. Scripture speaks of daily bread, covenant meals, hospitality, fasting, wedding feasts, and the Eucharist. Jesus accepts invitations and eats with people others reject. Food is therefore more than fuel, but it is not less than nourishment. Temperance honors the body's need while allowing the table to serve gratitude, belonging, memory, and generosity.

                    Gluttony cannot be diagnosed by body size, appetite, one feast, or enjoyment. Pope Francis explicitly acknowledges eating disorders as painful illnesses connected to psychological and spiritual suffering. Moral formation must not stigmatize a body or substitute accusation for care. Disordered use can appear through haste, fixation, luxury, waste, secrecy, refusal to share, or consumption used repeatedly to escape. The object is to restore relationship with food and neighbor, not enforce an appearance.

                    Deuteronomy warns people entering abundance not to forget the giver, their history, or the source of power. Gratitude protects against entitlement. It also remembers workers, people facing hunger, and ecological cost. A meal prayer should lead toward responsible purchase, reduced waste, hospitality, and care for those without enough. These responsibilities vary by resources and role; they do not require anxious scrutiny of every bite.
                    """
                ),
                (
                    "Lecture II — Feast and ordinary measure differ",
                    """
                    A wedding, solemnity, family celebration, recovery milestone, and ordinary Tuesday do not require identical patterns. Festivity marks a good worth celebrating and often includes abundance, time, and special food. Temperance makes feasting possible because celebration remains connected to meaning and relationship rather than becoming constant stimulation. A feast has a beginning and end; gratitude allows return to ordinary life.

                    Jesus is criticized both for fasting associations and for eating with sinners. In Luke 7 he exposes critics who reject John and the Son of Man through opposite complaints. The issue is not a single approved style but response to God's work. Asceticism and table fellowship can each serve love. A person may abstain to protect recovery or health while still joining celebration through presence. A host should not pressure a guest to consume a substance or explain private medical reasons.

                    Plan meals around positive goods: nourishment, companionship, attention, and enough time. Remove one distraction where possible. Notice hunger and fullness without turning sensation into an infallible command. Share conversation, allow different needs, and complete cleanup and care. If eating is surrounded by panic, compensatory behaviors, severe restriction, bingeing, purging, or medical concern, seek qualified care rather than intensifying fasting or a self-designed diet.
                    """
                ),
                (
                    "Lecture III — Alcohol, substances, and responsibility",
                    """
                    The Catechism calls health a precious gift and teaches that temperance avoids excess in food, alcohol, tobacco, and medicine. Alcohol has particular implications because impairment affects judgment, consent, driving, caregiving, medication, work, and vulnerability. A moderate amount for one adult may be unsafe for another. No one owes alcohol use to hospitality, maturity, or celebration.

                    Complete abstinence can be prudent or necessary because of addiction, recovery, family history, medication, pregnancy, age, legal duty, past harm, or the need to protect others. Recovery support is not a temporary lack of virtue; it can be the structure through which truthful freedom is practiced. A person should not stop treatment, test recovery, or change medication based on a generic lesson. Qualified medical and recovery counsel governs those decisions.

                    Social responsibility includes refusing to drive impaired, never pressuring another person, arranging transport, protecting a vulnerable guest, and addressing dangerous conduct. Secrecy, increasing tolerance, withdrawal, blackouts, failed efforts to stop, or damage to duties and relationships are warning signs for professional assessment. Shame delays help. Temperance seeks reality, support, and repair. It wants the person alive, connected, and free—not merely appearing controlled.
                    """
                ),
            ],
            misconception:
                "Temperance cannot be inferred from body size, food preference, one celebration, or whether someone drinks alcohol. Eating disorders and addictions are serious conditions, not labels for weak character. Fasting, dieting, or exposure to a substance can be unsafe. Health, recovery, medication, age, pregnancy, duties, and the effects on others may make abstinence or clinical support necessary. Neither abstinence nor moderate use is a universal badge of maturity. A person may abstain because a substance is unsafe, because solidarity or vocation calls for it, or because freedom is strengthened by a chosen limit. Another may receive a lawful pleasure gratefully within fitting measure. Observers usually lack the bodily history, treatment plan, responsibility, and interior freedom required for comparison. The Christian task is to protect communion and the vulnerable, refuse pressure, and judge one's own concrete responsibility truthfully. Hospitality should always make refusal easy and belonging independent of consumption.",
            caseStudy:
                "At a wedding, a guest in early recovery is repeatedly offered alcohol and told one toast will prove he is no longer controlled by it. He feels ashamed to disclose recovery and fears offending the couple. Identify hospitality, privacy, social pressure, relapse risk, transport, allies, and the meaning of celebration. What can the guest, companion, host, and venue each do to support joyful abstinence without making him the center?",
            practice:
                "Plan one meal or celebration with a clear purpose, beginning, end, gratitude, attentive presence, and no pressure on another person's consumption. If alcohol is unsafe, decide abstinence, transport, and support beforehand. If food or substance use is causing medical, relational, or safety harm, make one appointment or recovery contact instead.",
            prayer:
                "Jesus who shared tables and gave yourself as bread, make my eating and drinking grateful, nourishing, responsible, and welcoming. Protect all who suffer in their relationship with food or substances and lead them to wise care.",
            scripture: [
                build.encounter(
                    "cardinal-temperance-table-abundance", "Primary reading — Remember God in abundance",
                    "Read land, food, satisfaction, gratitude, memory, pride, power, covenant, and the danger of forgetting within prosperity.",
                    "DEUT", 8, 7, 18),
                build.encounter(
                    "cardinal-temperance-table-jesus",
                    "Second reading — Asceticism and table fellowship judged unfairly",
                    "Notice how opposite practices become excuses to reject both John and Jesus, and how wisdom is known by its fruits.",
                    "LUKE", 7, 24, 35),
                build.encounter(
                    "cardinal-temperance-table-citizenship", "Further reading — Appetite and heavenly citizenship",
                    "Place appetite within Paul's larger contrast of imitation, the cross, earthly fixation, hope, bodily transformation, and Christ's rule.",
                    "PHIL", 3, 17, 21),
            ],
            remember: [
                "Why is food more than fuel while still serving bodily nourishment?",
                "Why can neither body size nor one feast diagnose gluttony?",
                "How do fasting and table fellowship each serve Christian life?",
                "Which factors can make alcohol abstinence necessary or prudent?",
                "What warning signs move a concern beyond private self-help?",
            ],
            sourceIDs: [
                sources.catechismHealth.id, sources.popeGluttony.id,
                sources.popeTemperance.id, sources.catechismHumanVirtues.id,
            ]
        ),
        lecture(
            id: "cardinal-temperance-digital",
            title: "Attention in a persuasive world",
            summary:
                "Apply temperance to digital tools designed to capture and prolong attention without treating technology itself as evil.",
            opening:
                "When you reach for a device automatically, what good are you seeking—and which person, duty, prayer, or form of rest may be disappearing from view?",
            goal:
                "By the end, you should be able to treat attention as a stewardship, identify persuasive cues, distinguish purposeful use from automatic consumption, and design a positive environmental boundary.",
            terms: [
                "Attention — the limited human capacity to remain present to a person, object, task, or reality; directing it is morally significant.",
                "Persuasive design — features intentionally shaped to increase engagement or action through cues, rewards, friction, social pressure, or personalization.",
                "Cue — an internal or external signal that initiates a habitual action, such as a notification, location, emotion, or moment of boredom.",
                "Replacement good — the person, practice, rest, task, or form of connection that a boundary is designed to make possible.",
            ],
            chapters: [
                (
                    "Lecture I — Digital tools are created instruments",
                    """
                    Phones, feeds, games, video, news, messaging, and artificial intelligence can teach, connect, create, organize, entertain, and extend access. Temperance does not begin by declaring technology corrupt. It asks whether the tool remains ordered to its purpose and the whole human good. The same device can support prayer, emergency communication, work, friendship, distraction, comparison, pornography, harassment, or endless novelty.

                    Attention is finite. Giving it to one object means not giving it elsewhere at that moment. This creates duties where a person, prayer, work, study, sleep, driving, or safety has a legitimate claim. The moral question is broader than screen minutes. Ten minutes of unsafe driving or dehumanizing content can matter more than an hour of deliberate learning. Examine content, intention, timing, context, effect, and freedom to stop.

                    Persuasive systems reduce the need for deliberate choice. Notifications, autoplay, infinite feeds, variable rewards, streaks, and social comparison keep the next action easy. Personal responsibility remains, but environment matters. Temperance need not fight every cue with willpower. Turn off nonessential notifications, move an app, schedule access, use a separate alarm clock, or keep the device outside a protected place. Wise friction makes the intended good easier to remember.
                    """
                ),
                (
                    "Lecture II — Watchfulness is availability to reality",
                    """
                    Ephesians tells believers to walk carefully, make good use of time, and understand the Lord's will. This is not a command for maximum productivity. Time includes worship, relationship, work, service, play, sleep, and receptive rest. Careful walking means days are not surrendered unknowingly to whatever most effectively solicits attention.

                    Jesus' seed among thorns is choked by worldly anxiety, the lure of riches, and other desires. Digital media can amplify all three through permanent alerts, comparison, advertising, and exposure to every crisis. Information may be true while the volume makes responsible response impossible. Temperance chooses sources and intervals so knowledge can become prayer, judgment, or action rather than agitation. A person does not owe continuous awareness of every event.

                    Psalm 101 links what is set before the eyes to integrity within the home. Today the home can receive distant influence instantly. Content affects imagination, desire, speech, and expectations even when no outward act follows immediately. A temperate examination asks whether material respects dignity, truth, privacy, and lawful ownership; whether it trains contempt or objectification; and whether secrecy is growing. Content involving exploitation or illegal material requires decisive refusal and, where relevant, appropriate reporting or help.
                    """
                ),
                (
                    "Lecture III — Boundaries should reveal a greater yes",
                    """
                    A digital boundary succeeds when it protects a named good. “No phone at dinner” protects conversation; “no feeds before prayer” protects receptive attention; “no device in bed” protects sleep or marital presence. Without a positive good, absence can feel like empty deprivation and the old habit returns. Prepare the alternative: a book, conversation question, prayer text, alarm clock, walk, or task list.

                    Boundaries must fit real responsibilities. Caregivers, workers, disabled users, and people separated from community may rely on devices differently. The goal is not aesthetic purity or competition over low screen time. It is truthful availability. Exceptions should be defined rather than improvised by every impulse. A family or team can agree on emergency contact and protected periods without demanding identical rules from everyone.

                    Review the pattern through fruits: sleep, prayer, focus, relationship, mood, duties, content, and ability to stop. If use repeatedly defeats serious commitments, involves pornography, gambling, spending, harassment, or intense distress, add accountability and specialized care. Filters and limits can support freedom but are not complete treatment. Mercy after a lapse returns to truth quickly, repairs harm, and adjusts the environment rather than declaring the person either cured or hopeless.
                    """
                ),
            ],
            misconception:
                "Digital temperance is not a contest for the lowest screen time, rejection of useful technology, or one universal rule. Necessary communication, accessibility, work, education, and community matter. The test is whether attention remains available for God, persons, duties, embodied rest, and truth. Severe compulsive or harmful use may require more than settings and willpower. High use can be proportionate for work, disability access, caregiving, study, or meaningful relationship, while a shorter use can still be disordered if it is secretive, exploitative, or deliberately replaces a serious duty. Content, context, purpose, timing, and aftereffects matter alongside duration. A boundary should not merely create empty space that the same anxiety quickly fills elsewhere; it should prepare a replacement good and an emergency path. Families and teams also need shared expectations so one person is not asked to carry the entire cost of institutional availability. Where technology involves pornography, gambling, harassment, dangerous spending, or significant impairment, filters and timers may support but cannot replace accountable and specialized care.",
            caseStudy:
                "A parent checks work messages and news throughout dinner, explaining that responsibility requires availability. The family has stopped sharing much because replies are interrupted, but the job sometimes includes real emergencies. Identify actual on-call duty, anxiety, cues, relational claims, employer expectations, and a workable emergency path. What boundary preserves both responsible work and presence without pretending the phone has no good use?",
            practice:
                "Choose one protected daily place or time and name the replacement good. Remove cues, prepare the alternative, define true exceptions, and tell affected people how to reach you for an emergency. Review after seven days through prayer, relationship, sleep, work, and freedom rather than minutes alone.",
            prayer:
                "Lord who calls me to watch and pray, gather my scattered attention. Make every tool a servant, restore my presence to the people before me, and teach me to choose what deserves my gaze.",
            scripture: [
                build.encounter(
                    "cardinal-temperance-digital-time", "Primary reading — Walk carefully and understand the time",
                    "Read light, truth, exposure, awakening, wisdom, time, understanding, sobriety, the Spirit, worship, and gratitude as one attentive life.",
                    "EPH", 5, 8, 20),
                build.encounter(
                    "cardinal-temperance-digital-eyes", "Second reading — Integrity within the home",
                    "Let praise, justice, the blameless way, what is set before the eyes, loyalty, speech, and household integrity examine attention.",
                    "PS", 101, 1, 8),
                build.encounter(
                    "cardinal-temperance-digital-thorns", "Further reading — Desires that choke the word",
                    "Notice hearing, worldly anxiety, the lure of wealth, other desires, unfruitfulness, receptive soil, and lasting fruit.",
                    "MARK", 4, 13, 20),
            ],
            remember: [
                "Why is the moral question larger than total screen minutes?",
                "How does persuasive design interact with personal responsibility?",
                "What does watchfulness protect besides productivity?",
                "Why should a boundary name and prepare a replacement good?",
                "Which patterns suggest the need for accountability or specialized care?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.popeTemperance.id,
                sources.catechismPassions.id,
            ]
        ),
    ]
}

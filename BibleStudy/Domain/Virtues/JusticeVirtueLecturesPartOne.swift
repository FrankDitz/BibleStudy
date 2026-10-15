import Foundation

extension JusticeVirtueLectures {
    static let partOne: [VirtueStudyLesson] = [
        lecture(
            id: "justice-due",
            title: "To each what is due",
            summary: "Learn to recognize justice in ordinary obligations before looking only toward courts and laws.",
            opening:
                "Which responsibility in your life feels optional only because the person who depends on you is unlikely to demand it?",
            goal:
                "By the end, you should be able to define justice as a stable virtue of the will, distinguish a due from a gift, connect rights with duties, and identify ordinary relationships in which justice must become dependable action.",
            terms: [
                "Justice — the constant and firm will to give God and neighbor their due.",
                "Due — a good another can rightly claim because of dignity, a promise, a role, a law, or another morally relevant relationship.",
                "Right — a morally grounded claim to a good that creates corresponding duties in other persons or institutions.",
                "Commutative justice — justice governing exchanges and agreements between persons or groups, including contracts, repayment, and restitution.",
            ],
            chapters: [
                (
                    "Lecture I — Justice forms a dependable will",
                    """
                    The Catechism defines justice as the moral virtue consisting in the constant and firm will to give God and neighbor their due. Each word matters. Justice is not only a correct opinion about fairness. It resides in the will: the capacity to choose and carry out what another is rightly owed. It is constant and firm because one fair gesture under favorable conditions does not yet make a person just. The virtue grows when truth, payment, care, worship, promises, and respect remain reliable even when fulfillment costs time, comfort, money, or approval.

                    This definition brings justice close to daily life. Courts, laws, and public institutions matter greatly, yet the first school of justice is often a kitchen, workplace, friendship, parish, or contract. A child needs care that cannot be replaced by occasional gifts. An employee is owed agreed compensation rather than praise instead of pay. A friend has a claim to truth when a lie would manipulate a serious decision. A lender has a claim to repayment under a legitimate agreement. The public has a claim to honest use of entrusted authority. God is owed worship, gratitude, and obedience because every creature receives being and every good from him.

                    Joseph Rickaby describes justice as giving stability to social life: people can cooperate because they may reasonably rely on one another. That insight must remain under the Catechism's fuller account, but it reveals why ordinary failures matter. When words, roles, and agreements cease to carry dependable obligations, the vulnerable bear the cost first. Justice therefore trains the heart to say, “This good is not mine to withhold merely because I possess the power to withhold it.” It converts a vague preference for fairness into habits that other people can safely trust.
                    """
                ),
                (
                    "Lecture II — A due is not an optional kindness",
                    """
                    A gift is freely offered beyond strict obligation. A due is already claimed by the relationship. Confusing the two permits injustice to borrow the language of generosity. A manager who pays wages is not being charitable; the employee has earned them. A parent providing ordinary care is not performing occasional benevolence. A borrower returning an item does not confer a favor on its owner. Gratitude may be appropriate whenever another fulfills a duty well, but gratitude does not change the duty into something optional.

                    What establishes a due? Some claims arise directly from human dignity: every person must be treated as a person rather than an object. Others arise from voluntary commitments such as promises and contracts. Roles create particular duties: spouses, parents, citizens, employers, employees, public officials, clergy, professionals, and friends do not owe identical things, yet each role contains real responsibilities. Just laws specify duties needed for common life. Harm can create a new due called restitution: the person responsible must seek to restore what was damaged as far as reasonably possible.

                    Rights and duties correspond. To speak about a right is not simply to state a strong desire; it identifies a human good that another person or community must respect, protect, or provide in the way appropriate to its responsibility. At the same time, rights language must not isolate the person from community. My claim ordinarily stands alongside the claims of others, limits of resources, prior commitments, and the common good. Prudence discerns how duties apply; justice supplies the firm intention not to erase a legitimate claim for convenience. Charity may later give more, but it must first refuse to call withheld obligations generosity.
                    """
                ),
                (
                    "Lecture III — Equality, proportion, and impartiality",
                    """
                    Justice is often pictured as equality, and equal human dignity is foundational. Yet equal treatment does not always mean identical distribution. A family gives medicine to the sick child, not to every child in equal quantity. A teacher may provide an accommodation so a student can participate on genuinely equal terms. A worker who performed more contracted hours may be owed more pay. Different treatment is just when the difference is morally relevant to the good being distributed, the promise made, or the responsibility held. It becomes favoritism when wealth, familiarity, prejudice, usefulness, or influence replaces the relevant reason.

                    Pope Francis portrays the just person as upright, grateful, truthful, respectful of law, and concerned for the common good. He also warns against slander, favoritism, and the mentality that bends rules for personal advantage. This portrait shows that justice is neither cold arithmetic nor permanent suspicion. The just person tries to understand what belongs to each relationship, refuses double standards, and accepts that personal preference cannot be the final measure. The familiar expression “to each his own” means what rightly belongs to the person, not whatever the powerful choose to grant.

                    Begin examining justice by mapping relationships rather than condemning your whole character. Who has entrusted something to you? What promises have you freely made? Which resources or powers can affect another's good? Who lacks the ability to press a legitimate claim? Which obligation has become invisible through routine? These questions reveal the places where a firm will must grow. They should not become a scrupulous search for infinite responsibility. Justice concerns actual relationships and reasonably knowable duties. When a matter is complex, counsel may be necessary; when a duty is clear, love makes it prompt rather than evasive.
                    """
                ),
            ],
            misconception:
                "Justice is not identical with getting an equal share, winning a dispute, or insisting on every personal preference. It also does not require treating affection as a debt: friendship, gratitude, and charity contain freedom that cannot be demanded like wages. Conversely, calling a duty an act of kindness does not remove the other person's claim. The task is to identify a real due from dignity, relationship, role, promise, law, or repair, then fulfill it through fitting means.",
            caseStudy:
                "A supervisor regularly asks the most agreeable employee to finish urgent work after clocking out. He says everyone must sometimes be generous, but he never records the time, rotates the burden, or explains that refusal is permitted. The employee fears losing future opportunities. Identify the observable facts, the supervisor's authority, the employee's claims, any legitimate emergency, and the difference between freely donated help and labor extracted through pressure. What would a just response require from the supervisor before asking for any sacrifice?",
            practice:
                "Draw four columns labeled person or community, relationship, legitimate claim, and next action. Add four real relationships without trying to inventory your entire life. Choose one clear obligation you have treated as optional, give the action a date, and fulfill it. If the claim is disputed or serious, write the question you need to bring to a competent adviser.",
            prayer:
                "Just and faithful God, steady my will to recognize what belongs to you and my neighbor. Free me from favoritism, excuses, and self-interest, and make my ordinary dealings truthful and dependable.",
            scripture: [
                build.encounter(
                    "justice-due-micah", "Primary reading — What the Lord requires",
                    "Notice how worship, justice, faithful love, and humble life before God belong together rather than competing.",
                    "MIC", 6, 6, 8),
                build.encounter(
                    "justice-due-beatitudes", "Second reading — Hunger and thirst for righteousness",
                    "Read the Beatitudes and the call to visible discipleship as formation in a life whose goodness serves others and honors the Father.",
                    "MATT", 5, 1, 16),
                build.encounter(
                    "justice-due-psalm", "Further reading — The trustworthy neighbor",
                    "Attend to the Psalm's concrete portrait: truth, speech, treatment of neighbor, promises, and money reveal who may dwell with God.",
                    "PS", 15, 1, 5),
            ],
            remember: [
                "Why does the Catechism locate justice in a constant and firm will rather than an isolated feeling?",
                "How does a due differ from an optional gift?",
                "What kinds of relationships can create legitimate claims?",
                "Why can identical treatment sometimes be unjust?",
                "Which ordinary obligation currently needs to become dependable action?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.popeJustice.id,
                sources.rickaby.id,
            ]
        ),
        lecture(
            id: "justice-god-neighbor",
            title: "Justice toward God and neighbor",
            summary: "Hold worship of God and responsibility for people within one coherent moral life.",
            opening:
                "Where are you tempted to separate prayer from responsibility—as though devotion could excuse neglect, or useful service could make worship unnecessary?",
            goal:
                "By the end, you should be able to explain the virtue of religion, distinguish worship from an attempt to earn grace, connect the two great commandments, and identify false separations between devotion and justice.",
            terms: [
                "Religion — the moral virtue by which a person renders God the worship, gratitude, and reverence that are due to him.",
                "Adoration — acknowledgment of God as Creator, Lord, and source of every good, expressed through the whole person.",
                "Grace — God's free and undeserved help and participation in divine life; it cannot be purchased by religious performance.",
                "Neighbor — the person whose good has become concrete before us, including the stranger and enemy rather than only the familiar or likable.",
            ],
            chapters: [
                (
                    "Lecture I — The virtue of religion",
                    """
                    Justice is first directed to God. The tradition calls this expression the virtue of religion: giving the Creator worship and honor. God does not need our praise as though divine happiness depended on human attention. We need to live truthfully within the relationship from which every created good proceeds. Adoration acknowledges that God is God and the self is a beloved creature, not the author of being or the final measure of good. Thanksgiving recognizes gifts rather than treating life, ability, forgiveness, and hope as possessions generated by the self.

                    Deuteronomy forms Israel to hear, love, remember, teach, and refuse rival gods. This worship reaches thought, body, home, memory, and action. Catholic worship likewise includes personal prayer but cannot be reduced to private feeling. The Eucharist, Sunday worship, the sacraments, prayer, vows, and reverence shape a people who receive rather than invent salvation. The virtue of religion belongs to justice because truth about God creates a fitting human response. Yet no quantity of religious practice puts God in our debt. Grace remains gift; obedience is a response made possible by grace, not a wage that purchases divine favor.

                    This distinction protects worship from bargaining. A person may unconsciously say, “I prayed, served, or sacrificed, so God owes me the outcome I want.” Lament and petition may speak boldly, but justice before God does not mean enforcing a contract upon providence. The creature offers worship because God is worthy. Christian prayer then receives every merit through Christ. Gratitude makes the heart available for service rather than anxious calculation, while adoration frees us from treating career, nation, success, pleasure, or another person as an absolute good.
                    """
                ),
                (
                    "Lecture II — The two great commandments belong together",
                    """
                    Jesus joins love of God with the whole heart, soul, mind, and strength to love of neighbor as oneself. He distinguishes the commandments without separating them. Neighbor-love does not replace worship, because the neighbor is not God. Worship does not cancel the neighbor, because the God adored creates, loves, and commands care for persons. The prophets therefore reject liturgy offered alongside oppression. The problem is not ritual itself but a divided life that speaks reverence toward God while using people unjustly.

                    Justice toward neighbor begins with dignity and becomes concrete through duties. The person before me is not raw material for my spiritual project. Service must respect freedom, privacy, safety, property, truth, and appropriate boundaries. A volunteer can still dominate those served. A donor can still humiliate a recipient. A parish leader can still misuse spiritual language to secure obedience that is not owed. Good intentions and a religious setting do not remove the need for accountability; they deepen it because sacred trust increases the possible harm of manipulation.

                    The reverse separation also distorts Christian life. Useful service is genuinely good, and people outside visible religious practice can act with admirable justice. But for a Christian, service cannot become a proof that communion with God is unnecessary. The neighbor is loved for the neighbor's own good and ultimately in God, not merely as a cause or achievement. Worship receives love before action, exposes idols hidden within activism, gives repentance a home, and keeps human success from becoming salvation. Prayer and responsibility correct and nourish each other.
                    """
                ),
                (
                    "Lecture III — Gratitude becomes a way of life",
                    """
                    Luke's ten lepers all receive healing, but one returns, glorifies God, and gives thanks. The episode does not imply that gratitude earned the cure; it reveals a person who recognizes the giver within the gift. Gratitude is closely related to justice because it answers a benefit truthfully. We cannot repay God as an equal creditor, and we should not convert every human kindness into a burden of repayment. Yet gratitude resists entitlement, remembers dependence, and disposes the will to honor both God and benefactors appropriately.

                    Romans 12 calls believers to offer their bodies as a living sacrifice, then immediately unfolds humble judgment, membership in one body, differentiated gifts, sincere love, generosity, patience, hospitality, peace, and refusal of vengeance. Worship becomes embodied life. This does not mean every practical task is automatically worship. It means the person offered to God must also let grace transform relationships, speech, work, and use of gifts. The altar cannot remain isolated from Monday's promises.

                    A coherent weekly pattern therefore places explicit worship and neighborly duties together. Sunday Mass should not be fitted around convenience as though it were merely another leisure option, while serious limits such as illness or care obligations require pastoral wisdom rather than accusation. Family, work, and civic duties should be scheduled honestly rather than treated as interruptions to a spiritual life. Examine both sides: where has devotion become performance without justice, and where has productivity crowded out receptive worship? The aim is not balance between competing gods but an ordered life in which worship of the true God makes faithful love possible.
                    """
                ),
            ],
            misconception:
                "Justice toward God does not mean that God lacks something we can supply, that religious observance earns grace, or that suffering proves insufficient devotion. Nor does love of neighbor permit coercion in religion or neglect of conscience and freedom. A Catholic account holds worship, grace, and moral duty together: God freely gives; the creature responds in truth; and that response must become recognizable in respect for persons.",
            caseStudy:
                "A parish volunteer is publicly generous and never misses a visible event, but repeatedly breaks a private commitment to care for an aging relative. He explains that parish work serves more people and calls the relative selfish for objecting. Another family member provides excellent care but treats prayer and Sunday worship as useless because only measurable service seems real. What authentic goods appear in each life? Which due has become invisible? How could each person reorder practice without using one commandment against the other?",
            practice:
                "Review the next seven days. Schedule one concrete act of worship and one existing duty toward another person before adding a new religious project. Write how each supports the other. If Sunday worship or a caregiving duty is genuinely difficult because of health, work, or safety, seek fitting pastoral or professional counsel rather than drawing a private verdict about guilt.",
            prayer:
                "God alone worthy of worship, receive my praise and order my whole life. Let gratitude for your gifts become faithful responsibility, and never let religious language hide neglect of a neighbor you love.",
            scripture: [
                build.encounter(
                    "justice-god-shema", "Primary reading — Love and remember the Lord",
                    "Trace the movement from hearing and loving God to teaching, remembering, resisting forgetfulness, and refusing rival worship.",
                    "DEUT", 6, 4, 15),
                build.encounter(
                    "justice-god-gratitude", "Second reading — The one who returned",
                    "Notice that healing is received before gratitude, then observe how recognition of the giver changes the healed person's response.",
                    "LUKE", 17, 11, 19),
                build.encounter(
                    "justice-god-living-sacrifice", "Further reading — Worship embodied in relationship",
                    "Follow Paul's movement from living sacrifice and renewed judgment into membership, gifts, love, generosity, patience, and hospitality.",
                    "ROM", 12, 1, 8),
            ],
            remember: [
                "What does the virtue of religion render to God?",
                "Why can worship never purchase grace or place God in our debt?",
                "How do the two great commandments remain distinct but inseparable?",
                "What dangers arise when religious service ignores another person's rights or freedom?",
                "How can your weekly worship become more coherent with an existing duty?",
            ],
            sourceIDs: [
                sources.catechismReligion.id, sources.catechismHumanVirtues.id,
                sources.deusCaritasEst.id,
            ]
        ),
        lecture(
            id: "justice-dignity",
            title: "Dignity, rights, and impartial regard",
            summary: "Learn to see the person before usefulness, status, similarity, health, or social approval.",
            opening:
                "Whose claim are you most likely to discount because the person has less power, status, familiarity, productivity, or ability to reward you?",
            goal:
                "By the end, you should be able to ground equal dignity in creation and vocation, relate rights to duties, distinguish relevant differences from favoritism, and explain why vulnerable people may need particular protection.",
            terms: [
                "Human dignity — the worth belonging to every person created in God's image and called to communion with him.",
                "Partiality — allowing irrelevant status, wealth, familiarity, prejudice, or advantage to decide whose claim counts.",
                "Discrimination — unjust differential treatment that denies or obstructs goods owed to a person or group.",
                "Solidarity — a firm commitment to the good of each and all because human beings are interdependent members of one family.",
            ],
            chapters: [
                (
                    "Lecture I — Dignity is received, not awarded",
                    """
                    Genesis presents humanity as created in the image and likeness of God. Catholic teaching therefore grounds dignity before achievement. Intelligence, independence, wealth, citizenship, health, age, beauty, popularity, productivity, criminal history, or social usefulness do not manufacture personhood. Abilities can change dramatically while the person remains a person. This conviction protects the unborn child, the disabled person, the migrant, the prisoner, the elderly person, the poor, the powerful, and the enemy under the same moral truth.

                    Equal dignity does not mean every person has the same responsibilities, competence, authority, or needs. It means no difference permits one human being to be reduced to an object. A surgeon and patient have unequal expertise; a judge and defendant occupy different roles; a parent holds authority a child does not. Justice tests how that difference is used. Authority should serve the person's good and the common good. Dependence calls for care, not contempt. Expertise creates responsibilities of honesty and competence rather than permission to manipulate.

                    The Catechism teaches that social justice can be attained only in respecting the transcendent dignity of the person. This order matters. Institutions do not grant fundamental dignity and therefore may not withdraw it when a life becomes inconvenient. Rights express protections and conditions necessary for persons to flourish according to that dignity. Duties correspond in individuals, communities, and public authority. The language can become abstract, so formation asks a concrete question: what does this person's dignity require from someone with my role, power, information, or resources here?
                    """
                ),
                (
                    "Lecture II — Relevant difference or favoritism?",
                    """
                    James condemns a Christian assembly that gives the rich guest honor and sends the poor person to an inferior place. Wealth is irrelevant to the dignity and belonging at stake, yet it governs treatment because the community expects advantage from one person and inconvenience from another. Partiality often works this way: a real difference becomes a pretext for assigning greater human worth. The remedy is not pretending differences do not exist but asking whether each difference truly relates to the decision.

                    Some differences are relevant. A job may require a specific competence. A dependent child is owed forms of care not owed to every stranger. Need may justify directing more resources to a person facing greater barriers. Disability accommodation is not favoritism when it removes an obstacle to meaningful participation. Equal dignity can require different support because an identical arrangement may preserve inequality in practice. Justice is proportionate and purposive, not mechanically uniform.

                    A useful impartiality test asks four questions. What good is being assigned: safety, opportunity, attention, punishment, praise, money, or authority? Which feature of the person is actually relevant to that good? Would I use the same rule if identities were reversed? Who helped define the rule, and who bears its burden? This test cannot resolve every policy dispute, but it exposes hidden convenience and double standards. It is especially important when the person affected cannot challenge the decision or when the decision-maker benefits from calling a difference relevant.
                    """
                ),
                (
                    "Lecture III — Particular protection serves equality",
                    """
                    Jesus' judgment scene in Matthew 25 identifies service to people who are hungry, thirsty, estranged, unclothed, sick, or imprisoned with service to him. The passage does not reduce persons to categories of need. It confronts the temptation to let vulnerability erase visibility. A person with little social leverage can be passed without consequence, so justice and charity must deliberately restore attention. The Christian sees not a problem to display but a brother or sister in whom Christ chooses to be encountered.

                    Solidarity is more than sympathy. It recognizes that goods, burdens, history, institutions, and choices connect lives. The Catechism speaks of differences among persons as capable of fostering mutual service, while condemning sinful inequalities that deny dignity. A just community therefore examines access and participation, not merely its stated intentions. Are buildings, information, schedules, procedures, and conversations arranged so affected people can genuinely participate? Have those people been heard, or only spoken about?

                    Particular protection must remain personal. Helping someone does not authorize control, exposure, sentimental storytelling, or assumptions about incapacity. Ask what the person says is needed, what your role can appropriately provide, and which professional or institutional responsibility exists. In cases involving discrimination, disability rights, immigration, abuse, employment, education, or medical care, moral concern may require competent legal or professional guidance. The app cannot determine a person's rights in a specific jurisdiction. It can form the habit of refusing to make lower power equivalent to lower worth.
                    """
                ),
            ],
            misconception:
                "Impartiality does not require indifference to history, need, relationship, or role, and equal dignity does not mean identical competence. It forbids assigning lesser human worth or ignoring a claim for an irrelevant reason. Particular assistance is not automatically unfair preference; it can make equal participation real. At the same time, benevolent intent cannot excuse paternalism, unsafe assumptions, or decisions made without listening to the person affected.",
            caseStudy:
                "Two candidates satisfy a role's essential requirements. One shares the decision-maker's background and social interests. The other has a disability and requests a reasonable adjustment for the interview. A colleague describes the adjustment as special treatment and says the familiar candidate will fit the culture better. Identify the actual job requirements, the irrelevant sources of comfort, the purpose of the adjustment, and who should help determine feasibility. How can the process protect dignity without pretending every difference is irrelevant?",
            practice:
                "Choose one recurring decision about attention, access, opportunity, burden, or recognition. Apply the four-question impartiality test in writing. Then ask one affected person a respectful question instead of assuming what is needed. Do not seek private medical or personal details beyond what your responsibility legitimately requires.",
            prayer:
                "Creator of every person, cleanse my judgment of favoritism and contempt. Teach me to honor the dignity you give, listen before deciding, and protect those whose claims are easiest to ignore.",
            scripture: [
                build.encounter(
                    "justice-dignity-image", "Primary reading — Created in God's image",
                    "Attend to the gift, vocation, bodily creatureliness, fruitfulness, stewardship, and goodness named in humanity's creation.",
                    "GEN", 1, 26, 31),
                build.encounter(
                    "justice-dignity-partiality", "Second reading — No partiality in the assembly",
                    "Trace how status corrupts judgment and how the royal law, mercy, and accountability answer the community's favoritism.",
                    "JAS", 2, 1, 13),
                build.encounter(
                    "justice-dignity-least", "Further reading — Christ among the vulnerable",
                    "Notice the concrete needs, the surprise of both groups, and Christ's identification with persons easily passed by.",
                    "MATT", 25, 31, 46),
            ],
            remember: [
                "Why is human dignity received rather than earned?",
                "How can real differences exist without differences in human worth?",
                "What question reveals whether a difference is relevant to a decision?",
                "Why can particular protection or accommodation serve equality?",
                "How does solidarity differ from sympathy or paternalism?",
            ],
            sourceIDs: [
                sources.catechismSocialJustice.id, sources.catechismHumanVirtues.id,
                sources.popeJustice.id,
            ]
        ),
        lecture(
            id: "justice-truth-repair",
            title: "Truth, promises, and reputation",
            summary:
                "Practice justice through speech that protects reality, trust, privacy, and the good name of others.",
            opening:
                "When you speak about someone who is absent, what gives the listener a genuine right to the information rather than mere interest in it?",
            goal:
                "By the end, you should be able to explain why truth is owed, distinguish lying from discretion, identify rash judgment, detraction, and calumny, understand promises as created claims, and plan proportionate repair for harmful speech.",
            terms: [
                "Lying — speaking falsehood with the intention of deceiving.",
                "Rash judgment — accepting another's moral fault as true without sufficient foundation.",
                "Detraction — disclosing another's real faults without an objectively valid reason to someone who did not know them.",
                "Calumny — harming another's reputation by false statements or judgments.",
            ],
            chapters: [
                (
                    "Lecture I — Truth is a good owed to persons",
                    """
                    Human beings make free choices in relation to reality. A deliberate lie tries to govern another person's judgment by placing false information where truth should stand. The liar does more than utter an inaccurate sentence: the intention is that another person rely on unreality. This violates justice because the listener's capacity to know and choose is treated as an instrument for the speaker's purpose. The harm may be material, relational, civic, or spiritual, even when the falsehood appears small.

                    Jesus' command that yes mean yes and no mean no forms a character whose ordinary speech can be trusted. Elaborate assurances become less necessary where words are habitually aligned with truth. Promises intensify this relationship. A legitimate promise freely made gives another person reason to arrange time, hope, resources, or responsibility around our word. It creates a claim. Circumstances can sometimes make fulfillment impossible or reveal that a promise was immoral and must not be kept, but inconvenience alone does not erase the person who relied upon it.

                    Truthfulness includes accuracy and honesty about uncertainty. “I do not know,” “I remember differently,” and “I need to verify that” may be more just than confident speech. It also includes correction. When we discover that we have given materially false information, the person affected may have a claim to timely clarification. The aim is not obsessive disclosure of every mistaken detail. It is to protect choices that reasonably depend on our words and to refuse the advantage obtained by letting a false impression stand.
                    """
                ),
                (
                    "Lecture II — Reputation and privacy are goods",
                    """
                    A good name affects whether a person can participate, work, form relationships, receive a fair hearing, and live without unjust suspicion. The Catechism therefore treats rash judgment, detraction, and calumny as offenses against truth and justice. Rash judgment completes a moral story without adequate evidence. Detraction reports a true fault to a person who has no right or need to know. Calumny adds falsehood. Digital communication magnifies all three because an accusation can be separated from context, repeated indefinitely, and delivered to an audience the speaker never sees.

                    Respect for reputation does not require silence about harm. A victim, witness, mandated reporter, parent, supervisor, safeguarding officer, or public authority may have a duty to share relevant information through the proper channel. The moral questions are who needs to know, what they need to know, why, how reliably the facts are known, and how unnecessary exposure can be limited. Gossip and responsible reporting can concern the same event while differing in audience, purpose, evidence, content, and process.

                    Privacy and confidentiality also protect goods, but they are not absolute shields for wrongdoing. Medical, pastoral, legal, professional, and personal relationships have different duties and exceptions. A friend should not invent a private disclosure process for suspected child abuse, danger, or crime. Established safeguards and qualified authorities matter. Nor should “I was only being honest” excuse humiliating speech. A true fact can be weaponized by the wrong audience or manner. Justice asks both whether the statement is true and whether this person has a right or responsibility to receive it.
                    """
                ),
                (
                    "Lecture III — Speech can require reparation",
                    """
                    Forgiveness and reparation answer different aspects of injury. Forgiveness releases vengeance and opens the offender to mercy; it does not make consequences unreal. The Catechism teaches that an offense against truth requires reparation when harm has been caused, even if forgiveness has been received. If a false accusation was public, a private apology alone may not restore the person's standing. If confidential information was spread, the disclosure cannot be retrieved, but the speaker can stop repetition, correct distortions, address the appropriate audience, accept consequences, and change the habit or system that enabled the harm.

                    Repair must itself be just. A dramatic confession can expose the injured person again or pressure that person to offer immediate reassurance. Ask who needs the correction, what information is necessary, what additional harm disclosure might cause, and whether a responsible intermediary should help. In workplace, legal, safeguarding, or abuse situations, direct contact may be inappropriate or unsafe. Repair is ordered to the neighbor's good, not to relieving the offender's feelings at any cost.

                    James compares the tongue to a bit, rudder, and fire. Speech appears small while directing bodies and communities. Ephesians places truth inside a larger conversion: anger is governed, theft gives way to work and generosity, corrupt speech becomes words that build, bitterness yields to kindness and forgiveness. Justice in speech is therefore not merely avoiding lies. It forms a trustworthy presence that verifies before accusing, protects what should remain private, speaks through responsible channels when another needs protection, keeps its word, and repairs foreseeable damage.
                    """
                ),
            ],
            misconception:
                "Truthfulness does not require telling every fact to every person, speaking every thought, or confronting someone directly when safety or proper procedure calls for another channel. Privacy is not dishonesty, and charity can govern timing and manner. But kindness cannot justify a lie that manipulates another's serious decision, and confidentiality cannot be used to conceal abuse or danger from a person or authority with a legitimate need to know.",
            caseStudy:
                "A friend confides that a household member sometimes frightens a child, then asks for absolute secrecy. You do not know the full facts, but one described event suggests possible danger. Another friend is curious and offers to help investigate informally. Separate rash conclusions, gossip, responsible documentation, immediate safety, and reporting obligations. Who may have a right or duty to know? Which details should not be circulated? Why might qualified safeguarding guidance be necessary before direct confrontation?",
            practice:
                "Review one unfinished promise, misleading statement, or disclosure. Write the exact claim another person gained through your word and the harm your action may have caused. Choose a proportionate fulfillment or correction through the right channel. If safety, employment, law, or professional confidentiality is involved, obtain competent guidance before contacting the affected person.",
            prayer:
                "God of truth and mercy, make my words worthy of trust. Guard me from deception, accusation, gossip, and careless exposure; give me courage to speak when protection and justice require it.",
            scripture: [
                build.encounter(
                    "justice-truth-yes", "Primary reading — Let your yes mean yes",
                    "Notice how Jesus moves beneath elaborate assurances toward speech made trustworthy by the speaker's ordinary integrity.",
                    "MATT", 5, 33, 37),
                build.encounter(
                    "justice-truth-tongue", "Second reading — The power of the tongue",
                    "Follow James's images of teaching, stumbling, bits, rudders, fire, creatures, blessing, and contradiction.",
                    "JAS", 3, 1, 12),
                build.encounter(
                    "justice-truth-new-life", "Further reading — Truth that builds the body",
                    "Read truth, anger, work, generosity, speech, forgiveness, and imitation of God as one relational conversion.",
                    "EPH", 4, 25, 32),
            ],
            remember: [
                "Why does a lie violate another person's freedom as well as factual truth?",
                "How do rash judgment, detraction, and calumny differ?",
                "What questions distinguish responsible reporting from gossip?",
                "Why can forgiveness leave a duty of reparation?",
                "How should repair protect the injured person rather than merely relieve the speaker?",
            ],
            sourceIDs: [
                sources.catechismTruth.id, sources.catechismHumanVirtues.id,
                sources.popeJustice.id,
            ]
        ),
        lecture(
            id: "justice-property",
            title: "Property, stewardship, and restitution",
            summary:
                "Respect legitimate ownership while remembering that created goods are destined for the good of all.",
            opening:
                "Which resource do you most easily call entirely mine—money, time, equipment, information, land, or influence—without noticing the duties attached to possessing it?",
            goal:
                "By the end, you should be able to relate private property to the universal destination of goods, recognize forms of theft beyond taking objects, distinguish restitution from punishment, and plan repair without creating further harm.",
            terms: [
                "Universal destination of goods — the principle that created goods are intended by God for the flourishing of the whole human family.",
                "Private property — legitimate possession that supports freedom, responsibility, family life, work, and social peace, while remaining morally ordered to the common good.",
                "Stewardship — responsible administration of goods received, possessed, or entrusted rather than absolute dominion without duties.",
                "Restitution — returning what was unjustly taken or providing proportionate repair for loss caused.",
            ],
            chapters: [
                (
                    "Lecture I — Ownership is legitimate and ordered",
                    """
                    Catholic teaching affirms the right to private property. Personal and family freedom need stable access to goods; work and responsibility become meaningful when persons can possess, develop, share, and hand on what they have lawfully acquired. Property can protect a family from arbitrary control and give a person room to serve. The commandment against theft assumes that goods can truly belong to another and that this belonging should be respected.

                    Yet private property is not absolute. The earth and its goods are created for all. The universal destination of goods means that possession remains under a prior moral purpose: human life, dignity, participation, and the common good. Owners are stewards before God. This does not authorize individuals simply to seize what they desire or abolish legitimate ownership by private judgment. It does mean that abundance, productive assets, land, knowledge, and power carry responsibilities toward dependents, workers, neighbors, the poor, future generations, and creation.

                    Holding these principles together prevents two errors. One treats ownership as unlimited permission: “Because it is mine, no one may ask how I obtained or use it.” The other treats another's property as available whenever one's intended use seems better. Justice asks whether acquisition was lawful, agreements were honored, use respects persons and creation, and those with legitimate claims receive what is due. Charity invites generosity beyond strict claims, while social and legal institutions help determine responsibilities that private preference cannot settle alone.
                    """
                ),
                (
                    "Lecture II — Theft includes dishonest advantage",
                    """
                    Theft is not confined to secretly carrying away an object. The Catechism identifies fraud, unjust retention, deliberate damage, business dishonesty, corruption, tax evasion, poorly performed contracted work, waste of entrusted resources, and other forms of taking or keeping what belongs to another. Digital goods and information also involve ownership, licensing, privacy, and labor. A practice can be common or technologically easy while still refusing the creator, employer, customer, public, or owner what is due.

                    The moral analysis must be concrete. Borrowing an item creates a duty of care and timely return. Managing another's money creates fiduciary responsibility beyond ordinary personal discretion. Using workplace resources may be permitted, tolerated, restricted, or materially costly depending on policy and scale. Intellectual property questions can involve complicated law and license terms. Need, emergency, consent, custom, contract, and the proportion of harm all matter. Prudence and competent advice apply justice's firm intention to the actual case.

                    Stewardship also examines waste. Damaging creation, consuming resources without regard for others, or neglecting maintenance can transfer costs to people who did not choose them. Not every inefficient choice is grave injustice, and the learner should resist anxious calculation over trivial use. Look instead for meaningful patterns: concealed personal benefit, disregard of an agreement, preventable damage, exploitation of unequal power, or refusal to acknowledge who pays. The decisive question is not “Can I get away with this?” but “Whose good has been entrusted or claimed here?”
                    """
                ),
                (
                    "Lecture III — Conversion seeks restitution",
                    """
                    Zacchaeus responds to Christ with both generosity and restitution. He gives to the poor and promises fourfold repayment where he has extorted. These actions are related but not interchangeable. A donation to a favored cause does not cancel a particular person's claim to return or repair. Restitution seeks to restore the good of the injured party as far as possible. It may include returning property, repaying money, replacing damaged goods, correcting records, compensating cost, or addressing a breach of trust.

                    Restitution is not a purchase of forgiveness and not self-imposed punishment. A person cannot force the injured party to meet, accept an apology, or declare the matter closed. Nor should a repair create a fresh injustice—for example, exposing a victim, violating another duty, or transferring loss to an innocent dependent. Serious theft, fraud, inheritance, employment, tax, or legal cases may require a confessor, lawyer, financial professional, employer process, or other qualified authority to determine what can rightly be returned and how.

                    When exact restoration is impossible, justice does not become meaningless. The offender can acknowledge the truth, stop the practice, preserve available evidence, repair what can be repaired, accept legitimate consequences, and seek a proportionate alternative directed toward the injured good. Grace makes conversion possible without pretending history can always be erased. A just examination avoids both minimization and endless self-punishment. It asks what belongs to the neighbor now, what help is required, and which changed practice will prevent repetition.
                    """
                ),
            ],
            misconception:
                "The universal destination of goods does not mean every desired taking is justified, and private property does not mean possession is free of social duties. Restitution is neither a dramatic display nor a fee paid to remove guilt. It is proportionate repair ordered to the injured person's good. Complex property and legal questions exceed a self-guided lesson and may require qualified advice before money, records, or admissions are transferred.",
            caseStudy:
                "An employee has used company equipment and licensed software for a private business without permission. Returning the equipment does not address wear, license violations, profit earned, or breach of trust. Immediate disclosure could also affect coworkers if handled recklessly. Identify what is known, what agreement governed the resources, who may have claims, what use must stop, and which professional or organizational process should guide restitution. Why would donating the profit elsewhere fail to answer the company's particular claim?",
            practice:
                "Inventory one borrowed, retained, damaged, copied, or misused good without expanding into a total audit of your life. Verify the agreement, stop any ongoing misuse, and begin return or repair. If the matter is financially, legally, or relationally serious, write the facts and seek confidential qualified counsel before improvising a settlement.",
            prayer:
                "God who gives the earth for all, make me a faithful steward of what I own and what others entrust. Give me courage to return, repay, repair, and share according to justice and love.",
            scripture: [
                build.encounter(
                    "justice-property-commandments", "Primary reading — Property within covenant",
                    "Read the commands against stealing and coveting within the covenant that also orders worship, family, life, marriage, and truth.",
                    "EXOD", 20, 1, 17),
                build.encounter(
                    "justice-property-neighbor", "Second reading — Harvest, wages, judgment, and love",
                    "Notice how property use, provision for the poor, timely wages, truthful judgment, speech, and love of neighbor form one holy life.",
                    "LEV", 19, 9, 18),
                build.encounter(
                    "justice-property-zacchaeus", "Further reading — Repentance that repairs",
                    "Observe how encounter with Christ changes Zacchaeus's relation to wealth, the poor, and identifiable people he has harmed.",
                    "LUKE", 19, 1, 10),
            ],
            remember: [
                "Why does Catholic teaching affirm private property?",
                "How does the universal destination of goods qualify ownership without erasing it?",
                "Which forms of dishonest advantage can violate property besides taking an object?",
                "How does restitution differ from generosity, punishment, and forgiveness?",
                "Why can serious repair require pastoral, financial, organizational, or legal counsel?",
            ],
            sourceIDs: [
                sources.catechismGoodsAndProperty.id, sources.catechismMercy.id,
                sources.rickaby.id,
            ]
        ),
    ]
}

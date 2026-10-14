import Foundation

enum JusticeVirtueCourse {
    private typealias Sources = VirtueCurriculumSources
    private typealias Build = VirtueCurriculumBuilder

    static let course = Build.course(
        id: "cardinal-justice",
        collection: .cardinal,
        virtueID: .justice,
        title: "Justice",
        subtitle: "Give God and neighbor what is due",
        overview:
            "Justice is the constant and firm will to give God and neighbor their due. It forms truthful relationships, honors dignity and rights, keeps promises, governs property and work, repairs wrong, serves the common good, and prepares charity to become trustworthy rather than sentimental.",
        whyItMatters:
            "Many obligations arrive disguised as optional kindness. Justice teaches that worship, truth, wages, promises, reputation, restitution, authority, property, and social participation concern real claims. Love may give beyond what is due, but it may never use generosity to excuse injustice.",
        systemImage: "scalemass",
        lessons: lessons,
        sources: [
            Sources.catechismHumanVirtues,
            Sources.catechismTheologicalVirtues,
            Sources.catechismGoodsAndProperty,
            Sources.catechismWork,
            Sources.catechismMercy,
            Sources.popeJustice,
            Sources.deusCaritasEst,
            Sources.gaudete,
            Sources.rickaby,
        ]
    )

    private static let lessons: [VirtueStudyLesson] = [
        Build.lesson(
            id: "justice-due",
            title: "To each what is due",
            summary: "Discover justice in ordinary obligations before looking only toward courts and laws.",
            terms: [
                "Justice - the constant and firm will to give God and neighbor their due.",
                "Due - a good another can rightly claim, not merely something it would be generous to offer.",
                "Right - a morally grounded claim that corresponds to duties in others and society.",
            ],
            teaching:
                "Justice lives in the will: a steady readiness to recognize and honor legitimate claims. Courts matter, but justice begins much closer to home. Truthful speech, wages, contracts, property, promises, reputation, care of dependents, responsible authority, and respect for bodily and spiritual dignity all concern what is due. Justice asks a bracing question: have I mislabeled an obligation as generosity so that fulfillment can remain optional? The reliable spouse, honest worker, fair manager, truthful friend, responsible citizen, and faithful worshiper all practice justice in different relationships.",
            distinction:
                "Equality and justice are related but not identical. Giving everyone the same can ignore different roles, needs, promises, or burdens. Justice seeks what is fittingly due without favoritism, contempt, or arbitrary preference.",
            witness:
                "Pope Francis describes the just person as upright, simple, truthful, grateful, responsible, respectful of law, and concerned for the common good. Rickaby's image of justice as the framework of social life is useful when read under the Catechism's definition.",
            caseStudy:
                "A supervisor regularly asks unpaid work from the most agreeable employee and calls it 'team generosity.' What makes the request a matter of justice rather than merely kindness? Which power difference matters?",
            practice:
                "List four people or communities with legitimate claims on your time, truth, property, or work. Circle one obligation you have treated as optional and name its next concrete fulfillment.",
            prayer:
                "Just and faithful God, steady my will to recognize what belongs to you and my neighbor. Make my ordinary dealings truthful and dependable.",
            scripture: [
                Build.encounter(
                    "justice-do-right", "Do justice, love goodness",
                    "Micah joins justice, faithful love, and humble life before God.", "MIC", 6, 8,
                    8)
            ],
            remember: [
                "Where does justice principally reside?",
                "How does a due differ from an optional gift?",
                "Which ordinary obligation most needs your attention?",
            ],
            sourceIDs: [
                Sources.catechismHumanVirtues.id, Sources.popeJustice.id, Sources.rickaby.id,
            ]
        ),
        Build.lesson(
            id: "justice-god-neighbor",
            title: "Justice toward God and neighbor",
            summary: "Hold worship of God and responsibility for people in one moral life.",
            terms: [
                "Religion - the moral virtue by which a person renders God the worship and honor that are due.",
                "Neighbor - the person whose good has become concrete before us, not only someone familiar or likable.",
            ],
            teaching:
                "Justice toward God is traditionally called the virtue of religion. The creature owes worship, gratitude, obedience, and reverence to the Creator, while every gift received remains grace rather than a wage earned from God. Justice toward neighbor respects each person's dignity and real claims. Jesus refuses to separate the two great commandments: love of God with the whole person and love of neighbor as oneself. Devotion that licenses exploitation is false, and service detached from God can lose the final source and end of human dignity.",
            distinction:
                "God is not one claimant competing with family, work, or neighbor. Right worship orders the entire life and therefore deepens rather than cancels responsibility. At the same time, religious language may never be used to excuse neglect, coercion, or injustice.",
            witness:
                "The prophets repeatedly reject worship offered alongside oppression. Jesus likewise identifies love of God and neighbor without collapsing one into the other. Catholic justice begins before God and becomes visible in relationship.",
            caseStudy:
                "A person volunteers publicly at parish events but repeatedly breaks a private caregiving commitment. Another serves generously but refuses every form of worship because usefulness seems sufficient. What disorder appears in each life?",
            practice:
                "Review the coming week for one concrete act of worship and one concrete obligation toward a neighbor. Schedule both so neither remains a vague intention.",
            prayer:
                "God alone worthy of worship, receive my praise and order my life. Let reverence for you become dependable respect and responsibility toward every neighbor.",
            scripture: [
                Build.encounter(
                    "justice-great-commandments", "Love of God and neighbor",
                    "Jesus names the two commandments on which the law and prophets depend.",
                    "MATT", 22, 34, 40)
            ],
            remember: [
                "What is the virtue of religion?",
                "Why can worship and neighbor-love not be separated?",
                "What one obligation will make your worship more coherent?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.rickaby.id]
        ),
        Build.lesson(
            id: "justice-dignity",
            title: "Dignity, rights, and impartial regard",
            summary: "Learn to see the person before usefulness, status, similarity, or social approval.",
            terms: [
                "Human dignity - the worth belonging to every person created in God's image and called to communion with him.",
                "Partiality - judging or treating persons by irrelevant status, wealth, familiarity, or advantage.",
            ],
            teaching:
                "Justice rests on the reality that every human person has a dignity not granted by productivity, wealth, intelligence, health, citizenship, popularity, or usefulness. Rights protect goods necessary for personal and common flourishing; they correspond to duties in other persons and institutions. Impartiality does not mean ignoring every difference. It means refusing to let irrelevant advantage or contempt decide whose truth, safety, opportunity, or claim counts. The vulnerable often need particular protection precisely so their equal dignity becomes effective rather than theoretical.",
            distinction:
                "Preference is not always favoritism: parents owe particular duties to children, and an employer owes employees obligations not owed to every stranger. Injustice begins when a relevant duty is ignored or an irrelevant status is allowed to erase another's claim.",
            witness:
                "James confronts a worshiping community that offers honor to the rich and humiliation to the poor. The problem is not courtesy; it is judgment corrupted by wealth and social advantage inside the assembly.",
            caseStudy:
                "Two applicants meet the same requirements. One shares the decision-maker's background and interests; the other has a disability requiring a reasonable adjustment. Which differences are relevant, and which tempt partiality?",
            practice:
                "Notice one person usually evaluated by usefulness, appearance, or status. Identify a concrete right, responsibility, story, or contribution that restores attention to the whole person.",
            prayer:
                "Creator of every person, cleanse my judgment of favoritism and contempt. Teach me to honor the dignity you give and to protect those whose claims are easily ignored.",
            scripture: [
                Build.encounter(
                    "justice-partiality", "No partiality in the assembly",
                    "James exposes treatment of rich and poor that contradicts faith in Christ.", "JAS", 2,
                    1, 9)
            ],
            remember: [
                "What grounds human dignity?",
                "When is different treatment just rather than partial?",
                "Whose claim is easiest for your community to overlook?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.popeJustice.id]
        ),
        Build.lesson(
            id: "justice-truth-repair",
            title: "Truth, promises, and reputation",
            summary: "Practice justice through speech that can be trusted and commitments that become real.",
            teaching:
                "Truth is owed because persons deserve to act in contact with reality rather than manipulation. Justice therefore rejects lying, deceptive omission, gossip, calumny, detraction, and reckless damage to reputation. Promises create claims when freely and legitimately made; keeping them makes relationship dependable. Confidentiality protects goods too, so truthfulness does not require telling every fact to every person. Prudence and justice together ask who has a right to know, what must be said, how privacy should be protected, and when silence would cooperate with harm.",
            distinction:
                "Candor is not permission for cruelty. A true statement can be shared with the wrong person, for the wrong reason, at the wrong time. Conversely, 'kindness' cannot justify a lie that denies another information needed for a responsible choice.",
            witness:
                "Jesus teaches speech whose yes and no can be trusted. The simplicity is demanding: it removes the need for dramatic assurances because ordinary words have been made reliable by character.",
            caseStudy:
                "A friend confides something private, then you learn a child may be in danger. What goods does confidentiality protect? Which person or authority may have a right to know? Why would gossip and responsible reporting be morally different?",
            practice:
                "Choose one unfinished promise, misleading statement, or damaged reputation. Identify the person with a claim and make one correction, fulfillment, or responsible disclosure through the proper channel.",
            prayer:
                "God of truth, make my words worthy of trust. Guard me from deception and careless disclosure, and give me courage to speak when justice requires it.",
            scripture: [
                Build.encounter(
                    "justice-yes", "Let your yes mean yes",
                    "Jesus calls disciples away from manipulative speech toward trustworthy simplicity.",
                    "MATT", 5, 33, 37)
            ],
            remember: [
                "Why is truth a matter of justice?",
                "Does truthfulness require revealing every fact to everyone?",
                "Which word or promise needs repair?",
            ],
            sourceIDs: [Sources.catechismHumanVirtues.id, Sources.popeJustice.id]
        ),
        Build.lesson(
            id: "justice-property",
            title: "Property, stewardship, and restitution",
            summary: "Respect legitimate ownership while remembering the universal destination of created goods.",
            terms: [
                "Universal destination of goods - creation is destined for the good of the whole human family.",
                "Restitution - returning what was unjustly taken or providing proportionate repair for loss caused.",
            ],
            teaching:
                "Catholic teaching recognizes legitimate private property because it supports responsibility, freedom, family life, work, and social peace. Ownership is not absolute. Created goods remain destined for all, and possession carries duties toward dependents, workers, neighbors, the poor, and creation. Theft includes more than physically taking an object: fraud, deliberate damage, withheld wages, misuse of entrusted property, piracy, and dishonest advantage can all violate another's goods. Repentance normally seeks restitution when possible because regret alone does not restore what the neighbor lost.",
            distinction:
                "Restitution is not self-punishment or a purchase of forgiveness. It is justice's effort to re-establish the neighbor's good. When direct return would create another harm or is impossible, wise pastoral or legal counsel may help determine proportionate repair.",
            witness:
                "Zacchaeus responds to Christ by naming concrete generosity and fourfold restitution. Salvation enters his house in a conversion that changes his relationship to money, power, and people he harmed.",
            caseStudy:
                "An employee has used company equipment for a private business without permission. Returning the equipment alone does not address wear, cost, or breach of trust. What forms of restitution and disclosure may be due?",
            practice:
                "Inventory one borrowed, withheld, damaged, or misused good. Begin return or repair today. If the case is serious or complicated, identify qualified counsel rather than inventing a private settlement.",
            prayer:
                "God who gives the earth for all, make me a faithful steward. Give me courage to return, repay, repair, and share according to justice and love.",
            scripture: [
                Build.encounter(
                    "justice-zacchaeus", "Repentance that repairs",
                    "Observe how encounter with Christ produces both generosity and restitution.", "LUKE", 19,
                    1, 10)
            ],
            remember: [
                "Why is private property legitimate but not absolute?",
                "How does restitution differ from regret?",
                "What good, cost, or trust may need repair?",
            ],
            sourceIDs: [Sources.catechismGoodsAndProperty.id, Sources.catechismMercy.id]
        ),
        Build.lesson(
            id: "justice-work",
            title: "Work, wages, and economic relationship",
            summary:
                "See labor, leadership, pay, conditions, and rest as relationships of persons rather than mere exchange.",
            teaching:
                "Work participates in care for creation and service to human need, but the worker is always more important than production. Justice asks whether wages, hours, safety, expectations, contracts, benefits, access, and use of power honor persons and the common good. Workers owe honest labor, care for entrusted resources, and fidelity to legitimate agreements. Employers and leaders owe fair treatment, clear expectations, safe conditions, and compensation. Consumers and investors also participate through the systems their choices support.",
            distinction:
                "Market agreement alone does not settle every moral question. Severe need, unequal power, misinformation, discrimination, or unsafe conditions can make an apparent agreement unjust. Likewise, dissatisfaction does not excuse theft, sabotage, or dishonest work.",
            witness:
                "James gives fierce language to wages withheld from laborers and presents their cry as reaching the Lord. Economic injustice is not morally distant from spiritual life; it concerns persons whose work and needs God sees.",
            caseStudy:
                "A small business is under pressure. Cutting safety measures could preserve profit and jobs for a quarter. What does justice require the owner to consider about workers, customers, transparency, and alternative sacrifices?",
            practice:
                "Examine one role you hold—worker, manager, customer, client, owner, or investor. Name one obligation of justice attached to that role and one action that makes it more concrete this week.",
            prayer:
                "Lord of every worker, purify my use of labor, money, and authority. Let no gain make another person's dignity invisible to me.",
            scripture: [
                Build.encounter(
                    "justice-withheld-wages", "The cry of withheld wages",
                    "James names economic exploitation as a grave matter before God.", "JAS", 5, 1,
                    6)
            ],
            remember: [
                "Why is work for the person rather than the person for work?",
                "Which obligations belong to workers and leaders?",
                "How can unequal power affect apparent consent?",
            ],
            sourceIDs: [Sources.catechismWork.id, Sources.popeJustice.id]
        ),
        Build.lesson(
            id: "justice-common-good",
            title: "Authority, law, and the common good",
            summary: "Move beyond private fairness toward participation in a just shared life.",
            terms: [
                "Common good - social conditions allowing persons and groups to reach fulfillment more fully and readily.",
                "Authority - legitimate responsibility to coordinate common life in service of persons and the good.",
            ],
            teaching:
                "Justice is personal and social. Laws, institutions, budgets, policies, and cultural habits distribute benefits and burdens, protect or expose the vulnerable, and make some forms of participation possible or difficult. Legitimate authority serves the common good; it does not possess people. Citizens owe lawful cooperation, taxes, truthful participation, and concern beyond private advantage. Authority loses moral legitimacy when it commands what is contrary to moral order, fundamental rights, or the Gospel.",
            distinction:
                "The common good is not whatever benefits the majority or state. It includes respect for persons, social well-being and development, peace, and special care that the weak are not sacrificed to aggregate convenience.",
            witness:
                "The prophets address rulers, courts, merchants, and communities because injustice can become structural. Isaiah joins ceasing evil with learning good, correcting oppression, and defending those whose claims are easily ignored.",
            caseStudy:
                "A policy is efficient for most residents but makes essential services inaccessible to people without cars or with disabilities. What would a common-good analysis notice that majority preference misses?",
            practice:
                "Choose one local issue. Identify the persons affected, the legitimate authorities, the relevant facts, and one proportionate form of participation: learning, voting, public comment, service, advocacy, or support.",
            prayer:
                "God of peoples and nations, make me a responsible participant in common life. Keep private comfort from blinding me to public duties and vulnerable neighbors.",
            scripture: [
                Build.encounter(
                    "justice-learn-good", "Learn to do good",
                    "Isaiah turns repentance toward the correction of oppression and defense of vulnerable people.",
                    "ISA", 1, 16, 17)
            ],
            remember: [
                "What is the common good?",
                "When does authority fail its purpose?",
                "Which form of participation is proportionate for you now?",
            ],
            sourceIDs: [Sources.popeJustice.id, Sources.catechismWork.id]
        ),
        Build.lesson(
            id: "justice-charity",
            title: "Justice and charity",
            summary: "Let love fulfill and exceed justice without allowing it to cancel what is due.",
            teaching:
                "Justice and charity are inseparable but not interchangeable. Justice gives what is due; charity loves God above all and neighbor for God's sake, often moving beyond strict obligation into mercy, generosity, sacrifice, and communion. A person cannot excuse withheld wages by making donations, conceal abuse in the name of forgiveness, or substitute warm feeling for restitution. At the same time, a life limited to enforceable claims remains incomplete. Charity humanizes justice, sees the person beyond the debt, and offers goods no law can compel.",
            distinction:
                "Forgiving a personal debt can be charitable when freely chosen, but no one may be pressured to abandon another person's rights or the common good. Mercy seeks the good of offender and victim; it does not rename harm or prevent protective action.",
            witness:
                "Benedict XVI teaches that charity will always be necessary even in the most just society, while also rejecting any use of charity to excuse the work of justice. Rickaby's image of justice as a skeleton and charity as living flesh conveys their relationship without making either disposable.",
            caseStudy:
                "A leader gives generous holiday gifts while employees work unpaid required hours. Which act is charity, which obligation is justice, and why can the first not compensate for the second?",
            practice:
                "Review one generous act and ask first whether any due obligation remains unpaid. Fulfill the obligation, then choose whether love invites a free gift beyond it.",
            prayer:
                "God of justice and mercy, keep me from generosity that hides injustice and from fairness without love. Teach me to give what is due and then to love freely beyond it.",
            scripture: [
                Build.encounter(
                    "justice-love-fulfills", "Love does no evil to the neighbor",
                    "Paul presents love as the fulfillment of the law rather than an escape from it.", "ROM",
                    13, 8, 10)
            ],
            remember: [
                "How do justice and charity differ?",
                "Why can generosity not compensate for injustice?",
                "When can mercy freely go beyond a claim?",
            ],
            sourceIDs: [
                Sources.catechismTheologicalVirtues.id, Sources.deusCaritasEst.id,
                Sources.rickaby.id,
            ]
        ),
        Build.lesson(
            id: "justice-mercy",
            title: "The poor and the works of mercy",
            summary: "Respond to immediate need while also asking what justice and participation require.",
            teaching:
                "The corporal and spiritual works of mercy make love concrete: feeding, sheltering, visiting, accompanying, instructing, counseling, comforting, forgiving, bearing wrongs patiently, and praying. Catholic teaching gives the poor a privileged claim on Christian love. Mercy meets the person and need before us; justice also examines why the need persists, who is excluded, which structures or choices contribute, and how agency can be respected. Good service listens rather than turning the recipient into a project or the giver into a hero.",
            distinction:
                "Emergency aid and structural action should not be set against each other. A hungry person needs food now; communities also need just access, work, housing, health, and participation. The fitting response may include both direct mercy and sustained reform.",
            witness:
                "In Matthew 25 Christ identifies himself with the hungry, thirsty, stranger, naked, sick, and imprisoned. The encounter is personal and concrete. Love offered or refused to a vulnerable neighbor concerns relationship with Christ.",
            caseStudy:
                "A food pantry has long lines because its hours conflict with low-wage work schedules. Volunteers can distribute more efficiently or ask recipients which hours and systems protect access and dignity. What do mercy and justice each contribute?",
            practice:
                "Choose one work of mercy in response to a real need. Before acting, ask what help is welcome and whether a recurring justice issue also deserves attention.",
            prayer:
                "Jesus hidden in the vulnerable neighbor, open my eyes and hands. Let mercy become concrete and justice make that mercy trustworthy.",
            scripture: [
                Build.encounter(
                    "justice-least", "Christ in the vulnerable neighbor",
                    "Read the works of mercy within Christ's final teaching on judgment and the kingdom.",
                    "MATT", 25, 31, 46)
            ],
            remember: [
                "How do mercy and justice answer different dimensions of need?",
                "Why should service respect agency?",
                "Which work of mercy can you undertake responsibly?",
            ],
            sourceIDs: [Sources.catechismMercy.id, Sources.deusCaritasEst.id]
        ),
        Build.lesson(
            id: "justice-practice",
            title: "Capstone: an examination of what is due",
            summary: "Integrate worship, dignity, truth, promise, property, work, common good, repair, and mercy.",
            teaching:
                "Justice becomes stable when a person learns to notice claims before convenience hides them. A complete examination considers God, family and promises, speech and reputation, property and money, work and authority, civic participation, vulnerable neighbors, and past wrongs needing repair. Not every problem can be resolved immediately or privately. Some need a payment plan, legal process, safeguarding report, pastoral counsel, institutional action, or cooperation with others. Justice asks for the next truthful step and perseverance beyond symbolic gestures.",
            distinction:
                "An examination of justice is not an invitation to assume responsibility for everything wrong in the world. Prudence identifies which roles, promises, powers, and opportunities are actually yours. Humility accepts both duty and limit.",
            witness:
                "Zacchaeus, the prophets, the early Christian community, and the works of mercy reveal a shared pattern: encounter with God changes material relationship, truthful speech, repair, and concern for neighbors.",
            caseStudy:
                "Choose one relationship or responsibility with a real unresolved claim. If direct action would be unsafe or legally complex, your just next step may be documenting, seeking counsel, or contacting proper authority rather than confronting alone.",
            practice:
                "Write four headings: truth to speak, promise to keep, good to protect, and wrong to repair. Add worship and common good. Choose one specific action, responsible channel, and review date.",
            prayer:
                "Just God, search my relationships and responsibilities. Give me humility to recognize what is mine, courage to repair, and perseverance to serve the common good.",
            scripture: [
                Build.encounter(
                    "justice-righteousness", "Justice like a mighty stream",
                    "Amos refuses worship detached from justice and righteousness in common life.", "AMOS",
                    5, 21, 24)
            ],
            remember: [
                "Which domains belong in an examination of justice?",
                "How can prudence keep responsibility truthful rather than limitless?",
                "What is your next just act, channel, and review date?",
            ],
            sourceIDs: [
                Sources.catechismHumanVirtues.id, Sources.popeJustice.id,
                Sources.catechismMercy.id,
            ]
        ),
    ]
}

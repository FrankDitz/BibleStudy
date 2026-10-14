import Foundation

enum OrientationVirtueCurriculum {
    private static let sources = VirtueCurriculumSources.self
    private static let build = VirtueCurriculumBuilder.self

    static let course = build.course(
        id: "virtue-foundations",
        collection: .foundations,
        virtueID: nil,
        title: "Becoming the Person God Calls You to Be",
        subtitle: "A ten-lesson Catholic introduction to virtue, freedom, grace, and holiness",
        overview:
            "Begin with the whole Catholic map. You will learn why every person seeks happiness, what a virtue is, how choices form character, how feelings and freedom relate, why the cardinal and theological virtues are different, and why growth always depends upon Christ and grace.",
        whyItMatters:
            "Without a foundation, virtue can sound like rule keeping, personality improvement, or a contest in self-control. Catholic formation is larger: God calls a free, embodied, social person into beatitude and teaches that person to love reliably through grace-supported habits.",
        systemImage: "building.columns",
        lessons: lessons,
        sources: [
            sources.catechismBeatitude,
            sources.catechismHumanVirtues,
            sources.catechismTheologicalVirtues,
            sources.catechismGiftsAndFruits,
            sources.catechismFreedom,
            sources.catechismPassions,
            sources.catechismGrace,
            sources.catechismCapitalSins,
            sources.lumenGentium,
            sources.gaudete,
            sources.deusCaritasEst,
            sources.popeGrace,
            sources.rickaby,
        ]
    )

    private static let lessons: [VirtueStudyLesson] = [
        build.lesson(
            id: "foundations-happiness",
            title: "The happiness beneath every choice",
            summary: "Begin moral formation with the good life for which you were created.",
            terms: [
                "Beatitude - complete happiness in communion with God, the final end of human life.",
                "Created good - a real but limited good, such as friendship, work, health, pleasure, or security.",
            ],
            teaching:
                "Every deliberate choice reaches toward something that appears good: relief, love, safety, recognition, pleasure, justice, belonging, or peace. Catholic moral teaching begins by taking that desire seriously. Human beings are not made merely to avoid mistakes; they are made for beatitude, the happiness of sharing God's life. Created goods are not enemies of that end. They are gifts that become life-giving when received in right order and destructive when treated as ultimate. A career can serve vocation, but it cannot bear the whole weight of identity. Pleasure can refresh, but it cannot promise lasting joy. Virtue educates desire so partial goods lead toward rather than away from the highest good.",
            distinction:
                "Christian happiness is not a promise of constant comfort or positive emotion. The Beatitudes call blessed people who mourn, hunger for righteousness, show mercy, and endure persecution. Their happiness rests in belonging to God and moving toward his kingdom, even through costly fidelity.",
            witness:
                "Jesus does not offer the disciples a technique for feeling successful. In the Beatitudes he reveals the shape of a life open to God: poor in spirit, merciful, pure of heart, peace-making, and faithful under pressure. The good life is received and lived before it is measured.",
            caseStudy:
                "A promotion would bring recognition and money, but it would also require neglecting promises already made to family and participating in conduct you believe unjust. Which goods are real? Which are only partial? What would it mean to judge the offer by your final end rather than by prestige alone?",
            practice:
                "List five things you currently pursue as sources of happiness. For each, write whether it is a final end, a real but limited good, or a means of serving love. Do not condemn the good; place it in order.",
            prayer:
                "God of every good gift, purify my desire for happiness. Teach me to receive created goods gratefully and to seek my lasting joy in you.",
            scripture: [
                build.encounter(
                    "foundations-beatitudes", "The shape of blessed life",
                    "Read the Beatitudes as Christ's portrait of life in God's kingdom, not as disconnected slogans.",
                    "MATT", 5, 1, 12)
            ],
            remember: [
                "What is beatitude?",
                "Why is a created good unable to serve as the final end of life?",
                "Which present pursuit most needs to be placed in a wiser order?",
            ],
            sourceIDs: [sources.catechismBeatitude.id, sources.gaudete.id]
        ),
        build.lesson(
            id: "foundations-meaning",
            title: "What virtue really is",
            summary: "Move beyond isolated good deeds to a stable readiness for the good.",
            terms: [
                "Virtue - a habitual and firm disposition to do the good.",
                "Disposition - a settled readiness that shapes how a person notices, chooses, and acts.",
            ],
            teaching:
                "Knowing the right answer is not yet virtue, and one impressive deed does not establish character. The Catechism describes human virtues as stable perfections of intellect and will that govern action, order the passions, and guide conduct according to reason and faith. A truthful person is not merely someone who once told the truth when it was easy; truthfulness has become a dependable readiness. Virtue therefore concerns the person one is becoming. It makes the good increasingly recognizable, possible, and even joyful without making action automatic or removing freedom.",
            distinction:
                "Virtue is not temperament, image, talent, or respectability. A naturally calm person may still avoid necessary courage; an energetic person may still lack diligence about actual duties. Virtue directs natural strengths toward the true good and trains weak places without turning personality differences into moral grades.",
            witness:
                "Rickaby compares virtue to a practiced skill. The analogy helps because musicians and craftspeople acquire readiness through repeated acts. Yet moral virtue is more personal than technique: it involves freedom, intention, responsibility, grace, repentance, and love. The book is a useful guide here, while the Catechism supplies the governing definition.",
            caseStudy:
                "A person makes a generous donation publicly but habitually withholds wages and breaks promises privately. Is the donation enough to call the person just or generous? What would stable character require across situations?",
            practice:
                "Name one good action that has become easier through practice and one good that still depends heavily on mood. Identify a small repeated act that could train readiness without pretending it proves mastery.",
            prayer:
                "Holy Spirit, form in me a steady love of the good. Let repeated faithful choices become freedom for service rather than a reason for pride.",
            scripture: [
                build.encounter(
                    "foundations-think-good", "Train attention toward the good",
                    "Paul joins attention to what is true and worthy with putting received teaching into practice.",
                    "PHIL", 4, 8, 9)
            ],
            remember: [
                "How does virtue differ from one good act?",
                "Why is temperament not the same as moral character?",
                "What does the skill analogy illuminate, and where does it fall short?",
            ],
            sourceIDs: [sources.catechismHumanVirtues.id, sources.rickaby.id]
        ),
        build.lesson(
            id: "foundations-freedom",
            title: "Freedom for the good",
            summary: "Understand why good habits enlarge rather than erase genuine freedom.",
            terms: [
                "Freedom - the power, rooted in reason and will, to act or not act and to take responsibility for deliberate choices.",
                "Responsibility - accountability for an act in proportion to knowledge and voluntary consent.",
            ],
            teaching:
                "Modern language can reduce freedom to having many options or resisting every limit. Catholic teaching sees freedom as ordered toward truth and goodness. A person becomes more free by repeatedly choosing the good, because selfish habits, fear, deception, and compulsion no longer command the same obedience. A practiced musician is freer at the instrument, not less free, because discipline has opened possibilities. Moral formation similarly makes truthful and loving action more available. Yet freedom remains real: habit influences action but does not turn the person into a machine.",
            distinction:
                "Constraint, ignorance, fear, habit, psychological pressure, and social conditions can diminish responsibility. They should be considered truthfully, neither used as blanket excuses nor ignored in harsh judgment. The app can teach principles, but it cannot read a conscience or calculate culpability.",
            witness:
                "Christ describes sin as slavery and discipleship to truth as freedom. He is not promising independence from God; he is revealing liberation from whatever makes love impossible. The more freely a person belongs to the good, the less every impulse or pressure can dictate the next act.",
            caseStudy:
                "Someone says, 'I am free, so no one may question how I use my time.' Yet the same person has freely made promises to a spouse, employer, parish, and friend. How do those promises become expressions of freedom rather than merely obstacles to it?",
            practice:
                "Rewrite one statement beginning 'I have no choice.' Name the real constraints, any diminished capacity, the promises involved, and the smallest meaningful freedom still available now.",
            prayer:
                "Jesus, you came to set captives free. Free me from false independence and train my freedom to recognize and choose what is true and loving.",
            scripture: [
                build.encounter(
                    "foundations-truth-free", "Truth and freedom",
                    "Jesus connects remaining in his word, knowing truth, and being set free.", "JOHN", 8,
                    31, 36)
            ],
            remember: [
                "Why is freedom more than the number of available options?",
                "Which factors can diminish responsibility?",
                "How can a promise become an act of freedom?",
            ],
            sourceIDs: [sources.catechismFreedom.id, sources.catechismHumanVirtues.id]
        ),
        build.lesson(
            id: "foundations-passions",
            title: "Feelings, temptation, and consent",
            summary: "Treat emotional life truthfully without confusing it with moral guilt.",
            terms: [
                "Passion - a movement of the sensitive appetite, such as love, fear, anger, joy, or sorrow.",
                "Temptation - an attraction or invitation toward sin; temptation itself is not consent.",
                "Consent - a sufficiently knowing and voluntary choice to embrace an act.",
            ],
            teaching:
                "Feelings are part of embodied human life. They carry energy and information: fear notices danger, anger reacts to perceived wrong, desire reaches for union or pleasure, sorrow registers loss. In themselves, passions are neither morally good nor evil. They take moral quality as reason and will engage them. An unwanted image, intrusive thought, spontaneous attraction, bodily reaction, or first movement of anger is not the same as a deliberate choice. Formation neither worships feeling nor treats feeling as contamination; it teaches the whole person to respond in truth.",
            distinction:
                "Repression denies or buries a feeling; indulgence treats it as a command; integration notices it and lets reason, faith, and love determine action. Scrupulosity collapses these distinctions and can turn involuntary experience into imagined guilt. Anyone suffering severe scrupulosity should seek a steady confessor and qualified mental-health care rather than multiply private rules.",
            witness:
                "In Gethsemane Jesus experiences anguish and honestly names his desire that the cup pass. His feeling is not rebellion. He brings it into prayer and freely aligns his human will with the Father's saving will. The scene reveals neither coldness nor emotional rule, but integrated obedience.",
            caseStudy:
                "A sharp criticism produces immediate anger and a fantasy of replying cruelly. The thought is noticed and rejected; the person pauses, asks a clarifying question, and answers later. Which parts were involuntary, and where did moral action begin?",
            practice:
                "Observe one strong feeling with four questions: What happened? What do I feel in body and imagination? What good or threat am I perceiving? What response is actually mine to choose?",
            prayer:
                "Lord Jesus, receive my whole emotional life. Give me honesty without shame and freedom to place every feeling at the service of truth and love.",
            scripture: [
                build.encounter(
                    "foundations-gethsemane", "A feeling brought into faithful prayer",
                    "Attend to Christ's anguish, honesty, companionship, and free obedience in Gethsemane.",
                    "MARK", 14, 32, 42)
            ],
            remember: [
                "Are passions automatically virtuous or sinful?",
                "How do temptation and consent differ?",
                "What distinguishes integration from repression and indulgence?",
            ],
            sourceIDs: [sources.catechismPassions.id, sources.catechismFreedom.id]
        ),
        build.lesson(
            id: "foundations-habit",
            title: "How acts become habits - for good or ill",
            summary: "See repeated choices as both the fruit and seed of character.",
            terms: [
                "Habit - a stable quality that makes a kind of action more ready.",
                "Vice - a habit inclined toward moral evil that clouds judgment and narrows freedom.",
                "Capital sin - a vice called capital because it gives rise to other sins and vices.",
            ],
            teaching:
                "A repeated act leaves a trace in the person. Each truthful choice strengthens readiness for truth; repeated evasion makes the next evasion easier to justify. That is why acts are both fruit and seed: they express present character and help form future character. The Catechism names seven capital sins not because every instance is automatically a mortal sin, but because pride, avarice, envy, wrath, lust, gluttony, and sloth or acedia can become generative patterns from which many harms grow. Virtue answers vice by patiently retraining perception, desire, decision, and action.",
            distinction:
                "A habit explains influence; it does not allow the app or another person to pronounce guilt. Neither does habit make change impossible. Grace, honest confession, restitution, environmental changes, community, treatment when needed, and repeated contrary action can interrupt even deeply learned patterns.",
            witness:
                "The prodigal son's return contains more than regret. He comes to himself, tells the truth, rises, returns, confesses, and receives a mercy greater than his plan. Conversion is a turn toward relationship and restored life, not self-punishment for having formed a bad pattern.",
            caseStudy:
                "A person checks a phone whenever work becomes uncomfortable. Over months, attention fragments and promises are missed. What are the cue, usual action, apparent reward, deeper cost, and a better response that is both small and real?",
            practice:
                "Draw one habit loop: cue, usual response, apparent reward, deeper cost, and a contrary response. Add one change to the environment and one person or sacramental support that would make the good easier to choose.",
            prayer:
                "Merciful Father, show me the patterns that narrow my freedom. Give me courage to return, repair what I can, and practice the good with hope.",
            scripture: [
                build.encounter(
                    "foundations-prodigal", "Conversion and merciful return",
                    "Read the younger son's pattern, awakening, return, confession, and reception by the father.",
                    "LUKE", 15, 11, 32)
            ],
            remember: [
                "Why are repeated acts both fruit and seed?",
                "Why are the seven capital sins called capital?",
                "Which supports can help interrupt a vice?",
            ],
            sourceIDs: [sources.catechismHumanVirtues.id, sources.catechismCapitalSins.id]
        ),
        build.lesson(
            id: "foundations-hinges",
            title: "The four hinges of moral life",
            summary: "Meet prudence, justice, fortitude, and temperance as one connected structure.",
            terms: [
                "Cardinal - pivotal or hinge-like; the other moral virtues are grouped around these four.",
                "Prudence - practical reason discerning the true good and fitting means.",
                "Justice - the firm will to give God and neighbor what is due.",
                "Fortitude and temperance - firmness in difficulty and right order in pleasure and created goods.",
            ],
            teaching:
                "The four cardinal virtues give moral life its basic architecture. Prudence sees a situation truthfully and directs action. Justice asks what is owed to God, neighbor, and the common good. Fortitude carries the good through fear, resistance, pain, or weariness. Temperance orders desire so pleasure and created goods do not seize command. They are distinct, yet a mature act often needs all four: a difficult conversation requires wise timing, respect for what is due, courage to speak, and restraint in tone.",
            distinction:
                "No cardinal virtue can safely become a private specialty detached from the others. Courage without prudence becomes rashness. Prudence without justice becomes clever self-interest. Temperance without charity can become rigid control. Justice without mercy can forget that persons are more than claims, while mercy without justice can abandon repair.",
            witness:
                "The image of hinges comes from the Latin root behind cardinal. Rickaby builds his book around these four, but the Catechism governs their definition and insists that grace purifies and elevates acquired moral strength.",
            caseStudy:
                "You discover a friend's harmful dishonesty. What does prudence need to know? What does justice require? What fear needs fortitude? What anger, desire for approval, or urge to expose the person needs temperance?",
            practice:
                "Analyze one real decision under four headings: the true good and fitting means; what is due; the difficulty to face; and the desire or reaction needing order.",
            prayer:
                "God of wisdom and strength, join sound judgment, justice, courage, and self-mastery in me so that my choices become faithful expressions of love.",
            scripture: [
                build.encounter(
                    "foundations-wisdom", "Wisdom names the four",
                    "Wisdom gathers moderation, prudence, justice, and courage as goods for human life.",
                    "WIS", 8, 7, 7)
            ],
            remember: [
                "What makes a virtue cardinal?",
                "What question does each of the four ask?",
                "How can one virtue become distorted when separated from the others?",
            ],
            sourceIDs: [
                sources.catechismHumanVirtues.id, sources.rickaby.id,
            ]
        ),
        build.lesson(
            id: "foundations-theological",
            title: "Faith, hope, and charity",
            summary: "Distinguish God's infused gifts from acquired human moral habits.",
            terms: [
                "Theological virtue - a virtue infused by God that relates the person directly to the Holy Trinity.",
                "Faith - believing God and what he reveals.",
                "Hope - desiring eternal life and trusting Christ's promises and help.",
                "Charity - loving God above all and neighbor for God's sake.",
            ],
            teaching:
                "The Christian moral life cannot be reduced to becoming a well-adjusted or admirable person. Faith, hope, and charity come from God and orient the believer directly to him. Faith receives truth and entrusts the self to God. Hope resists despair and presumption by relying on Christ rather than private strength. Charity shares in God's own love and gives Christian form to every moral virtue. A courageous act becomes fully Christian not only because it is difficult, but because grace can order it toward communion with God and loving service.",
            distinction:
                "Theological virtues are not moods. Faith can remain during intellectual struggle, hope during grief, and charity when affection is absent. Nor do they eliminate human virtues. Grace heals and elevates nature; it does not excuse dishonesty, imprudence, injustice, cowardice, or uncontrolled appetite.",
            witness:
                "Paul places faith, hope, and charity together and calls charity the greatest. Charity does not make truth or justice unnecessary. It animates them, purifies motive, and moves beyond minimum obligation toward self-giving communion.",
            caseStudy:
                "Two people perform the same work of mercy. One seeks admiration; the other responds gratefully to God's love and the neighbor's dignity. The outward act is similar. How do faith, hope, charity, intention, and humility change its moral and spiritual character?",
            practice:
                "Choose one present situation and complete three sentences: Faith asks me to receive... Hope asks me to trust... Charity asks me to love through...",
            prayer:
                "Holy Trinity, deepen faith, strengthen hope, and pour charity into my heart so that every human strength may serve communion with you and love of neighbor.",
            scripture: [
                build.encounter(
                    "foundations-faith-hope-love", "The greatest is love",
                    "Read the whole chapter as a correction to impressive action emptied of charity.",
                    "1COR", 13, 1, 13)
            ],
            remember: [
                "What makes a virtue theological?",
                "How do faith, hope, and charity differ?",
                "Why does grace not make human moral formation unnecessary?",
            ],
            sourceIDs: [sources.catechismTheologicalVirtues.id, sources.deusCaritasEst.id]
        ),
        build.lesson(
            id: "foundations-grace",
            title: "Grace, gifts, fruits, and cooperation",
            summary: "Hold human practice and complete dependence on God together.",
            terms: [
                "Grace - God's free and undeserved help and participation in divine life.",
                "Gift of the Holy Spirit - a stable disposition making the person docile to the Spirit's prompting.",
                "Fruit of the Spirit - a perfection formed in believers as the first fruits of eternal glory.",
            ],
            teaching:
                "Human effort matters: education, deliberate acts, discipline, counsel, restitution, and perseverance genuinely shape life. Yet none of them purchases divine life or saves by private achievement. Grace is God's initiative. It heals what sin has wounded, elevates human capacities, and makes friendship with God possible. Cooperation means a real response to a prior gift. The believer prays, acts, repents, practices, and receives the sacraments because God is already at work, not because holiness can be engineered.",
            distinction:
                "Two errors distort formation. Self-salvation treats spiritual life as a project of optimization and pride. Passivity invokes grace while refusing available responsibility. Catholic cooperation avoids both: apart from Christ we can do nothing, and in grace our free response truly matters.",
            witness:
                "Jesus' vine and branches image is not decorative. A branch bears fruit by abiding in living union. The fruit is real and appears through the branch, yet its life is received. This is the tone the app should preserve whenever it asks for practice.",
            caseStudy:
                "Someone prays repeatedly for patience but keeps rehearsing grievances, refuses counsel, and will not pause before speaking. Another builds elaborate habits but never prays or receives mercy. What truth does each need?",
            practice:
                "Pair one concrete effort with one prayer for grace and one human support. State all three: what you will do, what only God can give, and who can accompany or correct you.",
            prayer:
                "Holy Spirit, make me docile to your work. Save me from prideful self-reliance and passive excuse, and teach me to cooperate freely with grace.",
            scripture: [
                build.encounter(
                    "foundations-abide", "Fruit comes from abiding",
                    "Jesus joins fruitful action to living dependence upon him.", "JOHN", 15, 1,
                    17)
            ],
            remember: [
                "Why can human effort not save or manufacture grace?",
                "What does cooperation with grace mean?",
                "How do gifts and fruits of the Spirit differ?",
            ],
            sourceIDs: [
                sources.catechismGrace.id, sources.catechismGiftsAndFruits.id,
                sources.popeGrace.id,
            ]
        ),
        build.lesson(
            id: "foundations-church",
            title: "How Christ and the Church form virtue",
            summary: "Place Scripture, sacraments, worship, community, and service inside formation.",
            teaching:
                "Christian virtue is ecclesial, not a solitary character experiment. Scripture forms the imagination and reveals Christ. Baptism gives new life; the Eucharist joins worship to Christ's self-gift; Reconciliation names sin, receives mercy, and restores communion. Prayer disposes the heart to God. Community supplies examples, correction, encouragement, common worship, and real neighbors to love. Service and vocation turn ideas into responsibilities. These do not operate as magical shortcuts, but as ordinary means through which grace forms a people.",
            distinction:
                "A course can organize learning, but it cannot replace Mass, Confession, parish life, pastoral counsel, friendship, professional care, or concrete responsibility. Neither should religious activity become avoidance: devotion that consistently excuses injustice, broken promises, or refusal to repair has been separated from the moral life it should nourish.",
            witness:
                "The first Christians devoted themselves to apostolic teaching, fellowship, the breaking of bread, and prayers. Their shared worship overflowed into shared goods, table fellowship, praise, and care. Formation involved doctrine, sacrament, relationship, and material life together.",
            caseStudy:
                "A learner completes every lesson privately but remains isolated, avoids sacramental life, and refuses correction. Which necessary parts of Christian formation are missing? What could a realistic next step look like?",
            practice:
                "Sketch a weekly formation rhythm containing Scripture, personal prayer, Sunday worship, one honest relationship, one duty of service, and an appropriate place for Reconciliation or counsel.",
            prayer:
                "Christ, gather me into your Body. Through your word, sacraments, people, and mission, form what I could never form alone.",
            scripture: [
                build.encounter(
                    "foundations-church-life", "A formed people",
                    "Notice teaching, fellowship, Eucharistic life, prayer, generosity, and joy held together.",
                    "ACTS", 2, 42, 47)
            ],
            remember: [
                "Why is Christian virtue ecclesial rather than merely private?",
                "Which ordinary means of formation appear in Acts 2?",
                "What can this course never replace?",
            ],
            sourceIDs: [sources.lumenGentium.id, sources.gaudete.id]
        ),
        build.lesson(
            id: "foundations-christ",
            title: "A lifelong school of Christlike love",
            summary: "End the introduction with a person to follow, not an image to perform.",
            teaching:
                "Virtue education aims beyond possession of admirable traits. Jesus Christ is the living form of Christian life: prudent without calculation, just without coldness, courageous without violence, temperate without contempt for creation, humble without denying his mission, and charitable to the end. Christians do not merely extract principles from him. They abide in him, receive his grace, imitate his actions, share his prayer, and are conformed to his self-giving love over a lifetime.",
            distinction:
                "Finishing this course means that lessons were studied. It does not mean the learner has become virtuous, attained holiness, or earned a spiritual rank. Growth includes hidden seasons, changed circumstances, failure, mercy, repair, deeper surrender, and virtues practiced together. No app can score the soul.",
            witness:
                "Rickaby ends by moving from abstract virtue to the compelling person of Christ. That insight is valuable when governed by the wider Catholic sources: holiness is a universal call, grace is primary, and Christ forms each person within a people and vocation.",
            caseStudy:
                "A learner wants to choose the course that feels most shameful and rush through it. Another wants only the virtue already admired by friends. How might each choose a next course from vocation, present responsibility, prayer, and honest counsel instead?",
            practice:
                "Write a one-page formation map: the good you desire, your present responsibility, one virtue needing study, available supports, a likely counterfeit, and the first faithful step. Choose either the seven-sin track or cardinal track for a stated reason.",
            prayer:
                "Jesus, meek and humble of heart, draw me into your life. Teach me to receive grace, love the good, repair failure, and follow you in the ordinary duties of my vocation.",
            scripture: [
                build.encounter(
                    "foundations-follow", "Learn from Christ",
                    "Jesus invites burdened disciples to take his yoke and learn his meek and humble heart.",
                    "MATT", 11, 28, 30)
            ],
            remember: [
                "Who is the center and measure of Christian virtue?",
                "What does course completion truthfully record?",
                "How will you choose your next course without shame or vanity?",
            ],
            sourceIDs: [sources.gaudete.id, sources.lumenGentium.id, sources.rickaby.id]
        ),
    ]
}

import Foundation

enum CounterVirtueCurriculum {
    private typealias Sources = VirtueCurriculumSources
    private typealias Build = VirtueCurriculumBuilder

    static let courses: [VirtueStudyCourse] = profiles.map(makeCourse)

    private struct Profile {
        let virtueID: VirtueIdentifier
        let virtue: String
        let vice: String
        let subtitle: String
        let overview: String
        let whyItMatters: String
        let icon: String
        let sources: [VirtueContentSource]
        let lessonTitles: [String]
        let teachings: [String]
        let practices: [String]
        let scripture: [ScriptureSeed]
    }

    private struct ScriptureSeed {
        let id: String
        let title: String
        let context: String
        let book: String
        let chapter: Int
        let start: Int
        let end: Int
    }

    private static let suffixes = [
        "meaning", "vice", "distortions", "scripture", "interior", "relationships", "habits",
        "resistance", "grace", "practice",
    ]

    private static let profiles: [Profile] = [humility, charity, kindness, patience, chastity, temperance, diligence]

    private static func makeCourse(_ profile: Profile) -> VirtueStudyCourse {
        let commonSources = [
            Sources.catechismHumanVirtues,
            Sources.catechismCapitalSins,
            Sources.catechismGrace,
            Sources.gaudete,
        ]
        return Build.course(
            id: "christian-\(profile.virtueID.rawValue.replacingOccurrences(of: ".", with: "-"))",
            collection: .christian,
            virtueID: profile.virtueID,
            title: "\(profile.virtue) against \(profile.vice)",
            subtitle: profile.subtitle,
            overview: profile.overview,
            whyItMatters: profile.whyItMatters,
            systemImage: profile.icon,
            lessons: suffixes.indices.map { makeLesson(profile, index: $0) },
            sources: unique(commonSources + profile.sources)
        )
    }

    private static func makeLesson(_ profile: Profile, index: Int) -> VirtueStudyLesson {
        let scripture = profile.scripture[index % profile.scripture.count]
        let stageSummaries = [
            "Learn the virtue's Catholic meaning before trying to measure it in yourself.",
            "See how the opposing capital vice disorders a real desire and spreads into other choices.",
            "Protect formation from counterfeits, shame, passivity, and self-serving definitions.",
            "Let the whole movement of a biblical passage reshape the imagination.",
            "Bring thoughts, desires, emotions, and motives into truthful prayer.",
            "Practice the virtue where another person's dignity and good are at stake.",
            "Use small repeated acts to make the good more available in ordinary life.",
            "Meet temptation, failure, and discouragement without surrender or self-contempt.",
            "Receive growth as cooperation with grace rather than a private feat of willpower.",
            "Build a sustainable rule of life and continue after the course ends.",
        ]
        let distinctions = [
            "A virtue is a stable readiness for the good, not a mood, label, or single impressive act. Study its object and purpose before judging appearances.",
            "A capital vice is called capital because other sins can grow from it. It does not mean every temptation carries equal guilt, and the app cannot judge personal culpability.",
            "The true virtue preserves truth, freedom, dignity, and charity together. Any version that excuses harm, erases responsibility, or performs goodness for admiration is a counterfeit.",
            "Scripture should be read in context and within the Church's living faith. A verse illuminates formation; it is not a slogan used to silence complexity or another person.",
            "Feelings are morally important material but not automatic verdicts. Name them honestly, test the judgments attached to them, and offer the whole movement to God.",
            "Private intention matters, but virtue becomes visible in what is actually given, repaired, restrained, protected, or endured for another person's good.",
            "Practice is formative rather than performative. Small acts should be concrete enough to repeat and humble enough that they do not become a new source of pride.",
            "A fall does not prove that growth was false. Name the act without euphemism, seek forgiveness and repair, learn the occasion, and begin again with a wiser plan.",
            "Human effort matters, but grace comes first and accompanies every genuine response. Prayer, sacrament, community, and qualified care belong inside formation.",
            "Completion records lessons studied, not holiness achieved. The virtue remains a lifelong school whose tests arrive in changing circumstances.",
        ]
        let witness = [
            "The Catechism places acquired human virtues within the larger Christian life of faith, hope, charity, grace, and the gifts of the Holy Spirit.",
            "The Church's teaching on the capital sins offers a diagnostic map: it names recurring roots so repentance can reach deeper than isolated symptoms.",
            "Catholic moral teaching resists both rigorism and permissiveness. Truth and mercy meet in conversion that names harm while protecting the dignity of the person.",
            "The saints receive Scripture as a word to be obeyed in concrete love. Their lives differ widely, showing that holiness forms personality rather than erasing it.",
            "The tradition of examination of conscience turns attention inward without making the self its final object; honest self-knowledge returns the person to God and neighbor.",
            "Catholic social and moral teaching keeps virtue relational. Love of God becomes inseparable from truthful responsibility for the neighbor who can be helped or harmed.",
            "Ascetical practices train freedom when they are prudent, hidden, and ordered to love. Severity detached from charity is not maturity.",
            "Reconciliation is a school of hope: contrition names sin, confession rejects secrecy, absolution is received, and satisfaction begins repair.",
            "The universal call to holiness means ordinary people in ordinary duties are truly called, while no one grows alone or apart from Christ.",
            "Perseverance after a course is less dramatic than a beginning. The Church offers a durable rhythm of Sunday Eucharist, daily prayer, examination, service, and repeated return.",
        ]
        return Build.lesson(
            id: "\(profile.virtueID.rawValue)-\(suffixes[index])",
            title: profile.lessonTitles[index],
            summary: stageSummaries[index],
            teaching: profile.teachings[index],
            distinction: distinctions[index],
            witness: witness[index],
            caseStudy:
                "Picture this lesson in family life, work, parish life, and a private digital moment. Where would \(profile.vice.lowercased()) distort perception or choice? What would \(profile.virtue.lowercased()) notice, desire, and do differently without turning the other person into a project?",
            practice: profile.practices[index],
            prayer:
                "Jesus, heal in me the roots of \(profile.vice.lowercased()) and form the freedom of \(profile.virtue.lowercased()). Give me truth without harshness, mercy without evasion, and one faithful next step today.",
            scripture: [
                Build.encounter(
                    "\(profile.virtueID.rawValue)-\(scripture.id)-\(index)", scripture.title,
                    scripture.context, scripture.book, scripture.chapter, scripture.start, scripture.end)
            ],
            remember: [
                "How does Catholic teaching define \(profile.virtue.lowercased()) here?",
                "Which movement of \(profile.vice.lowercased()) does this lesson expose?",
                "What concrete response would join truth, freedom, and love?",
            ],
            sourceIDs: unique(
                [Sources.catechismHumanVirtues.id, Sources.catechismCapitalSins.id]
                    + profile.sources.map(\.id)
            )
        )
    }

    private static func unique<T: Identifiable>(_ values: [T]) -> [T] where T.ID: Hashable {
        var seen = Set<T.ID>()
        return values.filter { seen.insert($0.id).inserted }
    }

    private static func unique(_ values: [String]) -> [String] {
        var seen = Set<String>()
        return values.filter { seen.insert($0).inserted }
    }

    private static func scripture(
        _ id: String, _ title: String, _ context: String,
        _ book: String, _ chapter: Int, _ start: Int, _ end: Int
    ) -> ScriptureSeed {
        ScriptureSeed(
            id: id, title: title, context: context, book: book, chapter: chapter,
            start: start, end: end)
    }

    private static let humility = Profile(
        virtueID: .humility,
        virtue: "Humility",
        vice: "Pride",
        subtitle: "Truthful creatureliness, gratitude, teachability, and freedom from self-exaltation",
        overview:
            "Humility is living in truth before God: neither making oneself the center nor denying the gifts and responsibilities God has given. It receives life as gift, learns without humiliation, serves without performance, and makes room for God and neighbor.",
        whyItMatters:
            "Pride can bend every strength toward self-rule, superiority, image, or refusal of dependence. Humility heals perception so gifts become responsibilities, limits become occasions for trust, correction becomes possible, and greatness is measured by love.",
        icon: "leaf",
        sources: [Sources.catechismPrayerHumility, Sources.popeHumility, Sources.popePride],
        lessonTitles: [
            "Living in truth before God", "How pride becomes a root", "Humility is not self-contempt",
            "The downward way of Christ", "Receive gifts without possessing them", "Teachability and correction",
            "Hidden service and gratitude", "When pride returns", "Grace for the lowly",
            "A lifelong school of humility",
        ],
        teachings: [
            "Humility begins with reality: God is God, the person is a loved creature, every genuine gift is received, and every gift carries responsibility. Humility can therefore name strengths and limits without exaggeration. Its opposite is not confidence but the falsehood that the self is self-created, self-sufficient, or entitled to become the measure of everyone else.",
            "Pride is a capital vice because self-exaltation can recruit intelligence, work, religion, virtue, and even repentance into protection of the ego. It appears as superiority, but also as the refusal to need help, the demand to control how one is seen, and the inability to rejoice when another person is honored.",
            "Self-contempt keeps the gaze trapped on the self and contradicts the dignity God gives. Humility does not call evil good or good evil. It can accept a compliment, set a boundary, exercise authority, and speak clearly about injustice while refusing both domination and theatrical self-erasure.",
            "Christ's humility is active self-gift. The eternal Son does not cease to possess dignity; he freely takes the form of a servant and obeys in love. Christian humility is therefore not timid disappearance but participation in a love secure enough to descend, wash feet, tell truth, and bear cost.",
            "A gift can be acknowledged without becoming a claim to superiority. Gratitude asks where it came from, whom it should serve, and what stewardship it requires. False modesty denies the gift; pride treats it as private proof of greater worth; humility puts it to work for the common good.",
            "Correction tests whether truth matters more than image. Humility listens, asks what is valid, distinguishes content from poor delivery, repairs what is wrong, and remains free to reject false accusation without contempt. Authority also needs teachability, because office does not remove limitation.",
            "Hidden service loosens the appetite to be seen. Gratitude loosens the claim to be self-made. Together they train attention away from constant comparison and toward the actual good another person needs. Secrecy is not required when accountability matters, but applause need not be the fuel.",
            "Pride often returns through defensiveness, rehearsed comparison, spiritual vanity, or shame after failure. The response is neither denial nor self-punishment: name the false claim, apologize concretely, receive mercy, and perform the next duty without trying to recover an image immediately.",
            "Humility is impossible as a performance of being impressively humble. It grows through grace: prayer from need, sacraments received rather than achieved, dependence upon the Body of Christ, and trust that worth does not have to be manufactured. Grace makes honest smallness safe.",
            "The course ends, but humility continues wherever success, failure, authority, obscurity, praise, criticism, and dependence reveal the heart. A rule of humility keeps gratitude, counsel, service, confession, and worship in ordinary rhythm without scoring one's spiritual rank.",
        ],
        practices: [
            "Write three truths together: one gift, one limit, and one present responsibility. Thank God for all three.",
            "Notice one moment of comparison or defensiveness. Name what recognition or control you wanted and bless the other person's good.",
            "Replace one self-degrading statement with an exact statement of fact, responsibility, and hope.",
            "Read Philippians slowly and choose one ordinary act of service that costs convenience but does not seek notice.",
            "Accept one sincere compliment with 'thank you,' then name privately how that gift can serve someone.",
            "Ask a trustworthy person for one specific correction. Listen fully before explaining, and act on what is true.",
            "Do one needed service quietly and record one gift received from another person today.",
            "After a proud reaction, make one prompt repair without adding an excuse or a counteraccusation.",
            "Pray from need for five minutes and receive one form of help you would normally avoid to protect your image.",
            "Write a four-week rule containing gratitude, counsel, hidden service, and a weekly examination of pride.",
        ],
        scripture: [
            scripture(
                "magnificat", "The lowly lifted by God", "Mary's humility magnifies God and receives a real vocation.",
                "LUKE", 1, 46, 55),
            scripture(
                "pharisee", "Two kinds of prayer",
                "Jesus contrasts self-exalting comparison with truthful need before God.", "LUKE", 18, 9, 14),
            scripture(
                "feet", "The Lord who washes feet", "Jesus joins secure identity, authority, and humble service.",
                "JOHN", 13, 1, 15),
            scripture(
                "descent", "The mind of Christ",
                "Paul presents Christ's self-emptying obedience as the pattern of Christian life.", "PHIL", 2, 3, 11),
            scripture(
                "humble", "Clothed with humility",
                "Peter connects humility toward others, dependence on God, and freedom from anxiety.", "1PET", 5, 5, 7),
        ]
    )

    private static let charity = Profile(
        virtueID: .charity,
        virtue: "Charity and Generosity",
        vice: "Avarice",
        subtitle: "Love of God and neighbor made concrete through stewardship, mercy, and gift",
        overview:
            "Charity is the theological virtue by which we love God above all and our neighbor for God's sake. Generosity is one of its concrete expressions against avarice: goods are received as stewardship and made available for real human need.",
        whyItMatters:
            "Avarice promises safety through possession but can narrow the heart until people appear as costs, rivals, or tools. Charity restores communion, while generosity trains the hands to agree with the truth that every good is gift and every neighbor bears dignity.",
        icon: "heart.fill",
        sources: [
            Sources.catechismTheologicalVirtues, Sources.catechismGoodsAndProperty,
            Sources.catechismMercy, Sources.catechismCovetousness, Sources.deusCaritasEst,
            Sources.popeCharity, Sources.popeAvarice,
        ],
        lessonTitles: [
            "Charity: friendship with God", "How avarice closes the heart", "Generosity is not careless giving",
            "The rich love of Christ", "Enough, security, and trust", "See the person before the need",
            "Money, time, attention, and hospitality", "Repairing possessive habits",
            "Love received becomes love given",
            "A personal rule of generous charity",
        ],
        teachings: [
            "Charity is more than warmth or philanthropy. It is God's own love poured into human life, enabling love of God and neighbor for God's sake. Because charity gives every moral virtue its deepest form, generosity is not merely releasing objects; it seeks the true good of persons in truth, justice, wisdom, and mercy.",
            "Avarice treats accumulation as protection from creaturely dependence. It may appear in hoarding, exploitation, anxious control, refusal to share, or valuing people by usefulness. The vice can exist at many income levels because its center is not an amount but a heart increasingly possessed by possession.",
            "Generosity needs prudence and justice. Giving what belongs to another, neglecting dependents, enabling grave harm, or making gifts to control the recipient is not charity. Healthy generosity is free, proportionate, respectful, and attentive to both immediate need and long-term good.",
            "In Christ, divine love becomes self-gift: he becomes poor for our sake and gives himself, not merely surplus. This does not command identical material choices for every vocation. It reveals the form of love: the beloved's good becomes personal rather than remote.",
            "Money and possessions answer real needs, but they cannot eliminate mortality, dependence, or the need for God. A just plan for savings and responsibilities can coexist with generosity. The question is whether planning serves love or whether imagined control continually postpones it.",
            "Charity refuses to reduce a person to a problem, category, or occasion for the giver's virtue. It listens, protects agency, avoids spectacle, and learns from those close to the need. The poor are not instruments for spiritual self-improvement; they are neighbors and members of the human family.",
            "Generosity includes money but also time, attention, expertise, welcome, forgiveness, advocacy, and shared access. Different seasons change what can be offered. A faithful gift is not necessarily dramatic; it is concrete, responsible, and truly available to another person's good.",
            "Possessive habits weaken through truthful accounting, planned giving, simpler consumption, restitution where injustice occurred, and learning to part with useful goods before they become identity. Repair may require financial, legal, or pastoral counsel rather than private intention alone.",
            "Christian love begins in God's initiative. A person who knows himself received can give without pretending to be savior. Eucharist, prayer, and community continually expose the illusion of self-sufficiency and make generosity a response of gratitude rather than a purchase of moral worth.",
            "A durable rule joins ordinary giving, emergency mercy, hospitality, attention, and advocacy with actual responsibilities. It leaves room for discernment and review. The aim is not a total donated or badge earned, but a heart increasingly available to God and neighbor.",
        ],
        practices: [
            "Name one person whose good God is inviting you to seek. Choose a truthful act of love rather than a vague kind feeling.",
            "Review one anxious possession or spending pattern. Ask what safety it promises and what relationship or duty it may be displacing.",
            "Before giving, check ownership, dependents, likely impact, the recipient's agency, and whether the gift carries hidden control.",
            "Give one resource that costs something real—time, money, convenience, or attention—without making the recipient carry your need for praise.",
            "Set a prudent threshold for enough in one category and direct the next surplus toward a specific good.",
            "Listen to a person or reputable local ministry before deciding what help is needed. Let proximity correct assumption.",
            "Offer one nonfinancial gift that answers a real need and can be received without debt or embarrassment.",
            "Identify one unjust withholding, unpaid debt, or broken promise and begin concrete restitution with appropriate counsel.",
            "Receive one act of care without rushing to repay it. Thank God and let dependence enlarge solidarity.",
            "Write a four-week rule for planned giving, one work of mercy, attentive presence, and review of spending or hoarding triggers.",
        ],
        scripture: [
            scripture(
                "command", "Love God and neighbor",
                "Jesus joins the two great commandments without collapsing one into the other.", "MATT", 22, 34, 40),
            scripture(
                "fool", "The poverty of stored abundance",
                "Jesus exposes wealth that cannot make a person rich toward God.", "LUKE", 12, 13, 21),
            scripture(
                "widow", "A gift seen truthfully", "Jesus sees the costly trust hidden beneath a small offering.",
                "MARK", 12, 41, 44),
            scripture(
                "neighbor", "Mercy crosses the road",
                "The Samaritan makes compassion concrete through time, risk, care, and resources.", "LUKE", 10, 25, 37),
            scripture(
                "love", "Love in deed and truth",
                "John refuses a love that remains words while a neighbor's need is ignored.", "1JOHN", 3, 16, 18),
        ]
    )

    private static let kindness = Profile(
        virtueID: .kindness,
        virtue: "Kindness and Goodwill",
        vice: "Envy",
        subtitle: "Rejoicing in another's good and making charity tangible in speech and action",
        overview:
            "Kindness is charity's attentive expression: it wills and advances another person's good. Against envy, goodwill learns to rejoice in gifts one does not possess, grieve without resentment, and make room for another person to flourish.",
        whyItMatters:
            "Envy turns another person's good into a personal wound and can grow into detraction, sabotage, coldness, or secret delight at failure. Kindness restores the neighbor as someone to bless rather than compare, without denying one's own sorrow or legitimate desire.",
        icon: "hands.sparkles",
        sources: [Sources.deusCaritasEst, Sources.popeEnvy],
        lessonTitles: [
            "Goodwill that becomes action", "How envy sees another's good", "Kindness is not people-pleasing",
            "Rejoice with those who rejoice", "Comparison and gratitude", "Speech that protects another's good",
            "Small works of encouragement", "When envy has already harmed", "The kindness of God",
            "Practicing goodwill for life",
        ],
        teachings: [
            "Kindness is not merely a pleasant manner. It is a readiness to notice and serve another person's good through fitting words and deeds. As an expression of charity, it can be gentle or firm, quiet or public. Its center is goodwill: the other person's genuine flourishing is welcomed rather than treated as a threat.",
            "Envy is sorrow at another's good insofar as that good is perceived to diminish one's own standing. It distorts vision before it distorts action. A gift becomes an accusation; success becomes theft; praise becomes scarcity. From that root can grow gossip, mockery, exclusion, rivalry, and pleasure in another's fall.",
            "People-pleasing seeks approval and may avoid needed truth. Kindness seeks the person's true good and respects freedom. It can say no, name harm, allow consequences, or refuse manipulation. Pleasantness without truth is fragile; truth without goodwill becomes a weapon.",
            "Paul's command to rejoice and weep with others requires freedom from making every event about oneself. Shared joy does not deny personal disappointment, and shared grief does not demand identical emotion. Charity makes room for the other's reality while bringing one's own ache honestly to God.",
            "Comparison selects evidence to rank persons and then mistakes rank for worth. Gratitude receives one's own life without needing it to be another's. Admiration can become instruction: instead of resenting a gift, ask what it reveals, how to bless it, and what faithful work belongs to your own vocation.",
            "Envy often enters speech disguised as concern, humor, or necessary context. Kind speech refuses detraction, gives proportionate praise, protects confidences, and corrects falsehood without manufacturing a counter-image. Silence can also be unkind when another's good needs defense.",
            "Encouragement names a real good accurately and strengthens another person to continue. Practical kindness anticipates manageable needs, includes the overlooked, and lowers needless burdens. It is most formative when offered without demanding emotional repayment.",
            "Where envy has produced gossip, exclusion, or sabotage, interior regret is incomplete. Repair may require retracting a false statement, correcting an audience, restoring an opportunity, apologizing without excuses, and accepting that trust may return slowly.",
            "Divine kindness is not indulgence; it leads to repentance and gives good gifts before they can be earned. Receiving God's benevolence loosens the competition for worth. The person can bless because he first lives by blessing.",
            "Goodwill needs ongoing practices because comparison changes form with age, work, relationships, and digital life. A rule of blessing, gratitude, guarded speech, encouragement, and intercession turns attention repeatedly toward communion.",
        ],
        practices: [
            "Notice one person's real good and perform one action that supports it without inserting yourself into the result.",
            "When envy appears, name the precise good, the loss you fear, and one blessing you can sincerely ask for that person.",
            "Replace one automatic yes with a truthful, respectful response that serves the relationship rather than your image.",
            "Congratulate someone specifically, then bring your own disappointment to prayer without making them manage it.",
            "Limit one comparison trigger and write three concrete gifts and responsibilities belonging to your own vocation.",
            "Refuse one piece of unnecessary negative speech. If appropriate, add the missing good or context.",
            "Offer one exact encouragement and one practical kindness to someone whose work is usually unnoticed.",
            "Repair one envious word or action with the person and, where needed, with those who heard or were affected.",
            "Recall three undeserved kindnesses from God or others and let one of them become a gift passed forward.",
            "Write a four-week rule of gratitude, blessing a perceived rival, guarded speech, and one weekly work of kindness.",
        ],
        scripture: [
            scripture(
                "cain", "The warning before envy acts",
                "God addresses Cain's anger and responsibility before violence follows.", "GEN", 4, 1, 8),
            scripture(
                "rejoice", "Share another's joy and sorrow",
                "Paul calls Christians out of self-enclosure into genuine solidarity.", "ROM", 12, 9, 18),
            scripture(
                "speech", "Words that give grace",
                "Paul contrasts corrosive speech with words fitted to another's need.", "EPH", 4, 29, 32),
            scripture(
                "kind", "Clothe yourselves with kindness",
                "Kindness belongs with compassion, humility, patience, forgiveness, and love.", "COL", 3, 12, 14),
            scripture(
                "laborers", "The generosity that exposes envy",
                "Jesus' parable reveals resentment when generosity reaches another person.", "MATT", 20, 1, 16),
        ]
    )

    private static let patience = Profile(
        virtueID: .patience,
        virtue: "Patience and Meekness",
        vice: "Wrath",
        subtitle: "Strength that endures, governs anger, and seeks justice without hatred",
        overview:
            "Patience sustains the good through delay, suffering, and another person's limitations. Meekness governs anger so its energy serves truth and justice rather than retaliation, contempt, or loss of self-command.",
        whyItMatters:
            "Anger can reveal perceived injustice, but wrath lets anger dominate judgment and action. Patience and meekness create room for truthful response, proportionate boundaries, forgiveness, endurance, and repair without requiring passivity before harm.",
        icon: "hourglass",
        sources: [Sources.catechismAnger, Sources.popePatience, Sources.popeWrath],
        lessonTitles: [
            "Strong enough to remain", "When anger becomes wrath", "Patience is not passivity",
            "Jesus, gentle and truthful", "The pause before the act", "Conflict, boundaries, and forgiveness",
            "Practices of patient strength", "Repair after an angry fall", "Long-suffering and grace",
            "A rule for anger and endurance",
        ],
        teachings: [
            "Patience is steadfast love under difficulty, delay, or provocation. Meekness is strength under wise government, especially in anger. Neither virtue removes urgency or personality. They keep suffering and emotion from dictating actions opposed to truth, justice, and another person's dignity.",
            "Anger is a passion, not automatically a sin. It can register that something valuable is threatened. Wrath begins when the desire for response becomes disordered toward excessive punishment, revenge, hatred, dehumanization, or uncontrolled discharge. A just cause cannot sanctify unjust means.",
            "Passivity abandons a good that should be protected. Patience can report abuse, leave danger, enforce a consequence, confront injustice, and seek legal or professional help. Its restraint is purposeful: it refuses to add avoidable evil while doing what protection and justice require.",
            "Jesus names hypocrisy, overturns exploitative disorder, remains silent before some accusations, and forgives his executioners. No single emotional style defines meekness. His actions are united by obedience to the Father and love for persons, never by wounded ego seeking release.",
            "A pause is not avoidance when it prevents passion from becoming the sole judge. The body may need distance, breath, sleep, food, or safety before reason can act. The pause should lead back to a responsible response rather than become silent punishment or indefinite evasion.",
            "Healthy conflict names facts, harm, responsibility, and requested change. A boundary governs one's own participation and consequences; it is not a threat used to control another. Forgiveness rejects vengeance and entrusts judgment to God, but does not erase truth, restitution, prudence, or safety.",
            "Patience grows through waiting without complaint, listening before replying, tolerating ordinary imperfection, completing slow duties, and praying for those who provoke. These practices are not consent to grave harm; they train strength for ordinary friction.",
            "After wrath, repair should be prompt and specific: name the words or acts, acknowledge their effect, make restitution, accept proportionate consequences, and change the conditions that helped the fall. Shame that refuses repair remains self-focused.",
            "God's patience is ordered toward repentance and life. Human patience participates in that mercy but remains finite and creaturely. Grace, sacrament, community, trauma-informed care, and anger-management support may all be necessary means of growth.",
            "A mature rule identifies bodily warning signs, occasions, safe pauses, truthful scripts, boundaries, repair steps, and supports. It also includes patient endurance of one good that cannot be completed quickly.",
        ],
        practices: [
            "Choose one recurring delay and wait without rehearsing contempt. Use the time for a concrete act of attention or prayer.",
            "Map one angry episode from trigger to judgment, bodily signs, desire, act, and consequence. Identify where freedom was still available.",
            "Write one boundary that protects a good without insult, retaliation, or an attempt to control the other person's feelings.",
            "Read one Gospel conflict and note when Jesus speaks, questions, withdraws, remains silent, or acts firmly.",
            "Practice a ninety-second pause before one nonurgent reply. Name the fact, the good threatened, and the response you can own.",
            "Prepare one conflict statement: 'When this happened... the effect was... I am asking... If it continues, I will...'.",
            "Complete one slow duty without complaint and listen through one minor interruption before redirecting.",
            "Make a specific repair for one angry word, message, or withdrawal. Do not require immediate reassurance.",
            "Bring persistent anger to prayer and one trustworthy helper; seek qualified care where safety or control is at risk.",
            "Write a four-week rule including warning signs, a safe pause, a return time, a repair plan, and one endurance practice.",
        ],
        scripture: [
            scripture(
                "anger", "Slow to anger",
                "James distinguishes receptive listening from anger that cannot produce God's righteousness.", "JAS", 1,
                19, 21),
            scripture(
                "gentle", "Gentle and humble of heart",
                "Jesus joins meekness to a yoke that forms rather than crushes.", "MATT", 11, 28, 30),
            scripture(
                "forgive", "Truth, limits, and forgiveness",
                "Jesus places repeated forgiveness inside a community that also names fault.", "MATT", 18, 15, 22),
            scripture(
                "endure", "Patient like the farmer",
                "James compares endurance to faithful waiting for a harvest that cannot be forced.", "JAS", 5, 7, 11),
            scripture(
                "sun", "Do not let anger rule",
                "Paul calls for truthful speech, timely reconciliation, and an end to destructive language.", "EPH", 4,
                25, 32),
        ]
    )

    private static let chastity = Profile(
        virtueID: .chastity,
        virtue: "Chastity",
        vice: "Lust",
        subtitle: "Integrated sexuality, purity of heart, faithful love, and reverence for the person",
        overview:
            "Chastity integrates sexuality within the whole person and the truth of one's state of life. It teaches reverence for the body, freedom from using or consuming others, and a love capable of fidelity, tenderness, sacrifice, and appropriate boundaries.",
        whyItMatters:
            "Lust isolates sexual pleasure from the person's full dignity and from self-giving love. Chastity heals vision and desire so another person is encountered as someone to love, never as an object, while honoring the goodness of embodiment and sexuality.",
        icon: "heart.circle",
        sources: [Sources.catechismChastity, Sources.catechismPurity, Sources.popeLust],
        lessonTitles: [
            "The integration of sexuality", "How lust fragments the person", "Chastity is not shame",
            "Purity of heart and vision", "Desire, imagination, and freedom", "Vocation, consent, and boundaries",
            "Habits that protect communion", "Responding to failure without despair",
            "Grace, healing, and accompaniment",
            "A continuing rule of chastity",
        ],
        teachings: [
            "Chastity is the successful integration of sexuality within the person and therefore the inner unity of bodily and spiritual being. It belongs to every state of life, though its expression differs in marriage, celibacy, and unmarried life. Its goal is not mere avoidance but freedom for faithful self-gift.",
            "Lust seeks sexual pleasure apart from the integral good of the persons involved. It narrows vision to use, consumption, fantasy, or conquest. Because it fragments what belongs together—body, person, freedom, fidelity, responsibility—it can coexist with apparent affection while still refusing the other's full dignity.",
            "The body and sexual desire are not dirty. Shame can warn that intimacy or dignity has been exposed, but toxic shame says the person is ruined or unlovable. Chastity names sin and harm truthfully while defending the goodness of creation, the possibility of healing, and the person's enduring dignity.",
            "Purity of heart is an undivided desire to see God and love according to truth. It reforms the gaze: attention no longer scans a person for use but receives a neighbor with history, vocation, boundaries, and an eternal destiny. Custody of the eyes serves encounter rather than fear of bodies.",
            "Attraction may arise without consent. Freedom appears in what attention welcomes, elaborates, seeks, and does. Imagination can rehearse objectification or can be redirected toward the whole person and a chosen duty. Temptation is not identical with consent, and honest struggle should not become scrupulous self-surveillance.",
            "Chastity respects the truth of relationships and the freedom of persons. Consent must be real; coercion, manipulation, exploitation, and abuse contradict love. Fidelity keeps promises; boundaries protect conditions for truthful relationship; vocation gives sexuality a form larger than immediate desire.",
            "Helpful habits include avoiding predictable occasions, using technology transparently, protecting sleep and sobriety, cultivating nonsexual friendship, serving others, praying with the body, and seeking accountability. A rule should be prudent and personal, not punitive theater.",
            "Failure calls for repentance, confession where appropriate, repair, and a changed plan—not despair or concealment. Analyze triggers and access without turning the person into a diagnosis. Repeated or compulsive behavior may require specialized therapy, recovery support, and pastoral care.",
            "Christ meets persons as more than their sexual history or present struggle. Grace forgives, heals, strengthens freedom, and often works gradually through sacrament, trustworthy relationships, professional care, and patient practice. No course replaces individualized pastoral or clinical help.",
            "Chastity remains a lifelong integration because relationships, technology, health, and vocation change. A durable rule joins prayer, sacrament, friendship, boundaries, truthful accountability, meaningful work, rest, and immediate steps for moments of temptation.",
        ],
        practices: [
            "Write how chastity serves love in your present state of life. Name one freedom it protects rather than only one act it forbids.",
            "Notice one way media or fantasy fragments a person into an object. Redirect attention to the person's full dignity and your present duty.",
            "Replace one shaming statement with exact moral truth, responsibility, and hope. Seek help if shame is isolating you.",
            "Practice a respectful gaze in one ordinary encounter: notice the person, listen, and resist scanning for comparison or use.",
            "Map one temptation as cue, feeling, thought, opportunity, choice, and aftermath. Mark the earliest realistic point for a different response.",
            "Clarify one relationship or digital boundary in positive language: what good it protects, what you will do, and whom you will contact.",
            "Change one environmental condition today—access, timing, device location, isolation, sleep, or accountability.",
            "If a fall has occurred, make a concrete return: end concealment, seek Reconciliation or counsel, repair harm, and revise the plan.",
            "Choose one qualified support appropriate to your need: confessor, spiritual director, therapist, physician, recovery group, or trusted mentor.",
            "Write a four-week rule joining prayer, boundaries, friendship, service, rest, accountability, and a specific temptation response.",
        ],
        scripture: [
            scripture(
                "body", "The body for the Lord",
                "Paul grounds sexual ethics in belonging to Christ and the dignity of the body.", "1COR", 6, 12, 20),
            scripture(
                "heart", "Purity begins in the heart",
                "Jesus carries moral attention beneath external compliance to the gaze and intention.", "MATT", 5, 27,
                30),
            scripture(
                "woman", "A person seen beyond accusation",
                "Jesus refuses both condemnation and moral indifference in meeting a vulnerable woman.", "JOHN", 8, 1,
                11),
            scripture(
                "honor", "Holiness and honor",
                "Paul joins self-control, holiness, and refusal to exploit another person.", "1THESS", 4, 3, 8),
            scripture(
                "pure", "An undivided heart", "The Beatitude directs purity toward the vision of God.", "MATT", 5, 8, 8),
        ]
    )

    private static let temperance = Profile(
        virtueID: .temperance,
        virtue: "Temperance",
        vice: "Gluttony",
        subtitle: "Grateful and free enjoyment of nourishment, drink, comfort, and created goods",
        overview:
            "This course applies the cardinal virtue of temperance specifically against gluttony. It treats food, drink, comfort, health, feasting, fasting, and compulsive patterns with gratitude, prudence, and pastoral care.",
        whyItMatters:
            "Gluttony asks consumption to soothe, reward, distract, or define the person beyond its proper role. Temperance restores freedom to nourish the body, enjoy fellowship, stop, abstain when needed, feast gratefully, and seek help without shame.",
        icon: "scale.3d",
        sources: [Sources.catechismHealth, Sources.catechismSunday, Sources.popeTemperance, Sources.popeGluttony],
        lessonTitles: [
            "Freedom at the table", "How gluttony disorders appetite", "Temperance is not dieting or disgust",
            "Meals in the life of Jesus", "Hunger, emotion, and attention", "Hospitality and solidarity",
            "Fasting, feasting, and daily habits", "After excess", "Grace and help for compulsive patterns",
            "A sustainable rule of appetite",
        ],
        teachings: [
            "Temperance orders attraction to pleasure and brings appetite into the service of the whole person. Against gluttony, it makes eating and drinking grateful, attentive, proportionate, and free. The fitting measure respects health, circumstance, vocation, hospitality, and individual need rather than imposing one visible standard.",
            "Gluttony is not simply eating a large amount. It is a disordered relationship to consumption: preoccupation, haste, excess, fussiness, waste, impairment, refusal to share, or using food and drink as an automatic answer to every discomfort. Its moral shape requires context and cannot be diagnosed from body size.",
            "Temperance must never become contempt for the body, moral ranking by weight, or unauthorized medical advice. Restriction can itself be disordered. Nourishment is a good; pleasure in food can express gratitude and fellowship. Health conditions and eating disorders belong with qualified care.",
            "Jesus fasts, accepts invitations, feeds crowds, eats with sinners, and gives himself under signs of food and drink. These scenes prevent a narrow spirituality of appetite. Meals can reveal providence, communion, mercy, scandalous welcome, gratitude, and the kingdom's abundance.",
            "Physical hunger, habit, loneliness, fatigue, anxiety, celebration, and sensory pleasure can overlap. Attentive eating learns to name them without shame. The goal is not perfect internal certainty but enough awareness to choose nourishment or another fitting response rather than consuming automatically.",
            "Food is relational. Temperance considers whether others are welcomed, whether resources are wasted, whether someone is pressured to consume, and whether personal preferences dominate hospitality. Solidarity remembers people who lack reliable nourishment and connects restraint to generous action.",
            "Fasting trains freedom and prayer when medically safe and properly ordered; feasting receives abundance and communion; daily habits sustain the body between them. None should become performance. Catholic disciplines supply a communal form while prudence respects age, health, work, and legitimate exemptions.",
            "After excess, disgust and compensatory punishment can extend the disorder. A wiser response is calm truth: identify what occurred, protect immediate safety, return to ordinary nourishment and duties, repair any harm, and learn the occasion. Serious symptoms require clinical help.",
            "Repeated loss of control, substance dependence, purging, dangerous restriction, or major health effects are not solved by moral exhortation alone. Grace can work through physicians, therapists, dietitians, recovery groups, family support, pastoral care, and environments redesigned for safety.",
            "A rule of appetite includes ordinary meals, gratitude, sleep, movement appropriate to health, alcohol boundaries, fasting only when safe, hospitality, generosity, and an escalation plan. It remains flexible enough to serve people rather than making people serve the rule.",
        ],
        practices: [
            "At one meal, pause, give thanks, remove distraction, eat attentively, and notice the freedom to begin and finish.",
            "Record one episode without calories or body judgment: context, hunger, emotion, pace, company, freedom, and effect on duties.",
            "Identify one rule driven by shame or appearance and replace it with a health-appropriate principle of nourishment, gratitude, or freedom.",
            "Read one Gospel meal and note what Jesus reveals about welcome, need, gratitude, or communion.",
            "Before consuming automatically, ask whether you need nourishment, rest, comfort, conversation, movement, or help. Choose the fitting response.",
            "Share food, time, or money with a local work against hunger, respecting the dignity and expressed needs of those served.",
            "Choose one medically safe, modest fast and join it to prayer and generosity; honor exemptions without embarrassment.",
            "Respond to one excess without punishment: return to ordinary care, name the cue, and change one condition for next time.",
            "If a pattern affects safety, health, or control, contact an appropriate professional or recovery support rather than remaining alone.",
            "Write a four-week rule for meals, gratitude, alcohol or comfort boundaries, hospitality, fasting, and help thresholds.",
        ],
        scripture: [
            scripture(
                "wilderness", "Hunger and the word of God",
                "Jesus refuses to make bodily appetite the whole measure of life.", "MATT", 4, 1, 4),
            scripture(
                "feeding", "Need met with abundance",
                "Jesus receives limited food with thanksgiving and feeds a gathered people.", "MARK", 6, 34, 44),
            scripture(
                "table", "A table larger than status",
                "Jesus redirects hospitality from social repayment toward generous welcome.", "LUKE", 14, 7, 14),
            scripture(
                "mastered", "Not mastered by anything",
                "Paul refuses to let even lawful things become masters of Christian freedom.", "1COR", 6, 12, 13),
            scripture(
                "kingdom", "More than eating and drinking",
                "Paul places food questions beneath righteousness, peace, and joy in the Spirit.", "ROM", 14, 13, 21),
        ]
    )

    private static let diligence = Profile(
        virtueID: .diligence,
        virtue: "Diligence and Perseverance",
        vice: "Sloth and Acedia",
        subtitle: "Faithful attention to prayer, work, duty, and the difficult good",
        overview:
            "Diligence gives prompt, careful, persevering attention to goods entrusted to a person. Against sloth and spiritual acedia, it helps begin, remain, rest rightly, and return when resistance makes a worthy good feel empty or burdensome.",
        whyItMatters:
            "Acedia is deeper than ordinary tiredness. It can resist the demands and joy of communion with God, scattering attention or abandoning the good. Diligence restores faithful presence without idolizing productivity or condemning legitimate rest, illness, disability, or human limits.",
        icon: "checkmark.seal",
        sources: [Sources.catechismWork, Sources.catechismSunday, Sources.popeAcedia],
        lessonTitles: [
            "Faithful care for the entrusted good", "Sloth, acedia, and avoidance", "Diligence is not overwork",
            "Remain in Christ", "Beginning when desire is absent", "Work, vocation, and hidden duty",
            "Rhythm, focus, and perseverance", "Returning after neglect", "Grace in effort and rest",
            "A rule for faithful work and prayer",
        ],
        teachings: [
            "Diligence is love made attentive to a real duty or good. It begins at the fitting time, works with reasonable care, and perseveres according to one's state of life and limits. Its value comes from the good served, not from busyness, speed, visible output, or superiority over people with different capacities.",
            "Sloth can mean avoidable neglect, but acedia names a spiritual resistance to the good of relationship with God and the demands of charity. It may appear as boredom, restless distraction, cynical discouragement, constant task-switching, or sudden zeal for anything except the duty of the moment.",
            "Overwork can be another refusal of creaturely truth. Diligence includes sleep, Sabbath, worship, relationship, and limits because the person is not a machine. Illness, disability, grief, depression, caregiving, and exhaustion affect capacity and responsibility; they should receive care, not moralized productivity advice.",
            "Christian perseverance begins with abiding in Christ. Fruit grows from communion before it becomes achievement. Prayer can feel dry without becoming worthless; duty can feel ordinary without becoming meaningless. Remaining is an active consent to receive life and continue in love.",
            "Motivation often follows action rather than preceding it. Diligence lowers the threshold honestly: define the next physical step, begin for a limited period, remove one distraction, and allow small faithful work to rebuild momentum. A tiny act is not a trick when it truly serves the good.",
            "Work participates in human dignity and service, whether paid, domestic, intellectual, manual, relational, or hidden. Vocation orders tasks so urgent noise does not displace primary duties. Diligence also respects justice: neither exploiting another's labor nor accepting needless exploitation as holiness.",
            "Rhythm makes perseverance possible. Clear starts, focused intervals, breaks, review, prayer, and closure protect attention. Perseverance is not repeating a failed method forever; it includes learning, counsel, delegation, and prudent revision while remaining faithful to the underlying good.",
            "Neglect is repaired by naming what was left undone, assessing harm, communicating promptly, completing or renegotiating the duty, and changing the system that failed. Grand vows can distract from the next owed act. Return becomes credible through concrete responsibility.",
            "Grace does not eliminate effort; it heals, elevates, and accompanies it. Rest receives creaturely dependence, and work responds to gift. Prayer, Eucharist, wise community, clinical care, and practical structure can all become means through which God restores faithful action.",
            "A durable rule identifies primary duties, minimum faithful practices for difficult days, focused work, genuine rest, Sunday worship, weekly review, and a return protocol. Its purpose is availability to love, not a perfect streak.",
        ],
        practices: [
            "Name one entrusted good, why it matters in love, and the next visible action it requires today.",
            "When avoidance appears, write what good feels burdensome and what substitute activity promises. Begin the good for ten minutes.",
            "Schedule one period of genuine rest or worship and one bounded period of focused work. Protect both.",
            "Remain in silent prayer for five minutes beyond the first urge to leave, without judging the quality of the experience.",
            "Reduce one delayed duty to a physical first step, remove one cue of distraction, and start before waiting for enthusiasm.",
            "List your primary duties by vocation and identify one noisy task that should not displace them this week.",
            "Use one focused interval followed by a real break and a closing note that identifies the next step.",
            "Repair one neglected duty by contacting the affected person, stating reality, and completing or responsibly renegotiating it.",
            "Receive one support—prayer, rest, medical care, counsel, delegation, or companionship—that makes faithful effort more truthful.",
            "Write a four-week rule with daily minima, focused work, Sunday worship and rest, weekly review, and a return plan after missed days.",
        ],
        scripture: [
            scripture(
                "ant", "Learn from the ant",
                "Proverbs exposes avoidable neglect and the consequences of endlessly delayed beginnings.", "PROV", 6,
                6, 11),
            scripture(
                "abide", "Remain and bear fruit",
                "Jesus roots lasting fruit in communion with him rather than isolated effort.", "JOHN", 15, 1, 11),
            scripture(
                "work", "Work for the Lord", "Paul places ordinary work within wholehearted service to Christ.", "COL",
                3, 22, 24),
            scripture(
                "weary", "Do not grow weary",
                "Paul joins perseverance in good action to patience for its fitting harvest.", "GAL", 6, 7, 10),
            scripture(
                "talents", "Faithful stewardship",
                "Jesus' parable asks what servants do with goods entrusted during the master's absence.", "MATT", 25,
                14, 30),
        ]
    )
}

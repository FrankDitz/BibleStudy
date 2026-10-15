import Foundation

/// Authored supports for the foundation course. These are intentionally separate from
/// the lecture text so the reader can first think, then reveal guided reasoning.
enum OrientationLessonLearningSupport {
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
            selfExaminationSteps: [
                VirtueSelfExaminationStep(
                    id: "facts",
                    title: "Name the facts",
                    question: "What happened, in the order it happened?",
                    guidance:
                        "Write only what you directly observed, said, did, or reliably know. Set aside labels such as 'always,' 'selfish,' or 'they meant to' until you can distinguish fact from interpretation."
                ),
                VirtueSelfExaminationStep(
                    id: "desired-good",
                    title: "Name the good you wanted",
                    question: "What were you trying to gain, protect, avoid, or restore?",
                    guidance:
                        "Consider security, relief, approval, justice, pleasure, belonging, control, or another good. Naming a real desire makes the choice understandable; it does not automatically justify the means used."
                ),
                VirtueSelfExaminationStep(
                    id: "inner-movement",
                    title: "Notice what moved you",
                    question: "Which feeling, fear, desire, wound, pressure, or habit was active?",
                    guidance:
                        "A feeling is important information, not a verdict about guilt and not permission to act. Notice where a free response became possible without condemning an involuntary first reaction."
                ),
                VirtueSelfExaminationStep(
                    id: "interpretation",
                    title: "Test your interpretation",
                    question: "What story were you telling about God, yourself, or another person?",
                    guidance:
                        "Ask what evidence supports the story, what facts may be missing, and whether your interpretation is both truthful and charitable. Do not attempt to judge another person's conscience."
                ),
                VirtueSelfExaminationStep(
                    id: "choice",
                    title: "Name your choice",
                    question: "What concrete act did you freely choose, and what did you intend by it?",
                    guidance:
                        "Describe the act precisely, then consider your intention and the circumstances. Avoid vague conclusions about being a 'good' or 'bad' person; examine the particular choice."
                ),
                VirtueSelfExaminationStep(
                    id: "effects",
                    title: "Trace the effects and duties",
                    question: "What goods, people, promises, or responsibilities did the choice affect?",
                    guidance:
                        "Include effects you did not intend as well as obligations that existed before the moment. This keeps reflection connected to justice and relationship rather than private feeling alone."
                ),
                VirtueSelfExaminationStep(
                    id: "lesson-connection",
                    title: "Connect this lesson",
                    question: specificExamen,
                    guidance:
                        "Use the central distinction from this lesson to see the situation more clearly. The purpose is understanding and a truthful next step—not producing a perfect answer."
                ),
                VirtueSelfExaminationStep(
                    id: "next-step",
                    title: "Choose the next faithful step",
                    question: "Which virtue would strengthen the smallest honest action you can take next?",
                    guidance:
                        "Make the action specific enough to do: tell one truth, keep one promise, pause before replying, seek counsel, change an environment, pray, or perform another fitting act."
                ),
                VirtueSelfExaminationStep(
                    id: "repair-and-help",
                    title: "Repair and receive help",
                    question: "What repair, grace, or human help does this situation call for?",
                    guidance:
                        "Repair may include an apology, restitution, truth-telling, or a boundary. Help may include prayer, Confession, wise counsel, or qualified professional care. Not every situation requires every response."
                ),
            ],
            knowledgeChecks: checks
        )
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
        "foundations-happiness": make(
            analysis:
                "The promotion contains several real goods: useful work, provision, recognition, and the chance to develop gifts. Naming those goods keeps discernment honest. Yet the proposed means—routine deception—and the abandonment of genuine promises cannot be made good by the desirable salary or status. The final question is not simply which option feels costly, but which ordering of goods respects truth, justice, vocation, and communion with God. A prudent response would verify the facts, distinguish negotiable expectations from intrinsic wrongdoing, seek counsel, and explore lawful alternatives. If deception is truly required, refusing may involve sacrifice; that sacrifice does not make pain good in itself. It witnesses that career is a created good rather than the final end. The person should also consider responsibilities to dependents and seek a realistic transition instead of confusing recklessness with faith.",
            synthesis:
                "Matthew 5 portrays blessedness as communion with God's kingdom even amid grief, mercy, costly purity, and persecution. Psalm 16 identifies God—not possession or reputation—as the secure portion who teaches the path of life. Matthew 6 then places treasure, divided service, bodily needs, and anxiety beneath the Father's care and the priority of the kingdom. Together the readings do not condemn created goods. They expose what happens when a limited good becomes master and show why the virtues order ordinary desires toward a happiness only God can complete.",
            transfer:
                "Which good in your present life is easiest to receive as a gift but hardest to surrender as a master?",
            witnessTitle: "Saint Augustine and the restless heart",
            witnessBody:
                "Saint Augustine pursued learning, achievement, relationships, and public success before recognizing that no created good could bear the whole weight of his desire. Pope Benedict XVI describes Augustine's conversion not as flight from humanity but as a return to God and therefore to his deepest self. His witness does not make earthly goods worthless. It shows why the heart remains restless when it asks any finite success to become its final home.",
            sourceIDs: [VirtueCurriculumSources.saintAugustine.id],
            examenIntroduction:
                "Choose one current decision in which two genuine goods compete—for example, work and family, financial security and honesty, or rest and a promise. Use one specific moment rather than evaluating your whole life.",
            examenExample:
                "Example: A promotion offers useful work, income, and recognition, but seems to require misleading clients and repeatedly breaking a family commitment. The examination would name every real good, test whether the suspected requirement is factual, and ask which ordering of goods respects truth and one's actual duties.",
            specificExamen: "Where am I treating a gift as though losing it would make my life meaningless?"
        ),
        "foundations-meaning": make(
            analysis:
                "The donation may be a real good and may help real people. It still cannot by itself establish that the owner possesses justice or generosity. Delayed wages concern something already owed in justice; publicity does not cancel that debt. A stable virtue would alter perception first: workers would be seen as persons with claims, not costs to postpone. It would alter policy through timely pay and truthful promises, private conduct through consistency when nobody applauds, and correction through restitution rather than image management. The owner should not be reduced to one hypocrisy, but neither should a conspicuous gift be used to evade ordinary obligations. Growth begins by telling the whole truth, repairing harm, changing systems that repeat it, and allowing good actions to become coherent across public and hidden life.",
            synthesis:
                "Philippians 4 joins disciplined attention, received teaching, and repeated practice under the presence of the God of peace. Matthew 7 contrasts hearing with doing and shows that a life acquires structure through enacted obedience. Second Peter begins with divine gift and then calls believers to sustained effort so that good qualities become fruitful and stable. The three readings therefore resist both self-manufacture and passivity: virtue is a durable capacity formed through faithful acts, while every capacity remains dependent on God's prior gift and sustaining presence.",
            transfer:
                "Where is there a gap between a good action people can see and an ordinary obligation that receives little notice?",
            witnessTitle: "Saint Thérèse and the hidden weight of small acts",
            witnessBody:
                "Saint Thérèse of Lisieux taught a 'little way' of trust and love. Its smallness was not spiritual minimalism. It relocated holiness from impressive self-display to ordinary acts offered in dependence on God's mercy. Her witness helps distinguish stable virtue from a dramatic performance: repeated, hidden love can form the person more deeply than one admired gesture, precisely because it is not sustained by applause.",
            sourceIDs: [VirtueCurriculumSources.saintTherese.id],
            examenIntroduction:
                "Choose one recent contrast between the person you appeared to be and the person your quiet actions were forming. This is not an invitation to dismiss visible good deeds; it is a way to test whether public and hidden conduct are becoming coherent.",
            examenExample:
                "Example: Someone volunteers generously at a public event but has repeatedly delayed an ordinary promise at home. The examination would honor the service, name the neglected duty without excuses, and identify one act of repair and one repeated practice that could make generosity more stable.",
            specificExamen:
                "Which hidden obligation would reveal more about my character than the good deeds others notice?"
        ),
        "foundations-freedom": make(
            analysis:
                "The promises should be named and ranked rather than treated as one undifferentiated demand. Duties of justice and solemn commitments normally carry greater weight than preferences, convenience, or another person's attempt to control. Past promises are expressions of freedom, so honoring them can deepen freedom rather than erase it. At the same time, exhaustion, fear, compulsion, or psychological distress may reduce present capacity and call for support, changed expectations, or professional help. None of this authorizes the app—or a bystander—to pronounce on culpability. Prudence asks what is truly owed, which facts are missing, whether any demand is abusive or unjust, and what small truthful response remains possible. Freedom here may mean keeping a promise, renegotiating it honestly, setting a boundary, making repair, or asking for help.",
            synthesis:
                "John 8 roots freedom in remaining with Christ, receiving truth, and being liberated by the Son. Sirach 15 affirms genuine human agency while refusing to attribute wickedness to God. Romans 6 shows that repeated choices are never neutral: obedience takes a form and shapes the person either toward slavery or toward life. Christian freedom is therefore neither unlimited option nor coercion. It is the growing capacity, healed by grace and instructed by truth, to give oneself to the good and remain faithful to just commitments.",
            transfer:
                "Which present limit is imposed unjustly, and which limit is the shape of a good you once freely promised?",
            witnessTitle: "Saint Josephine Bakhita and freedom as gift",
            witnessBody:
                "Saint Josephine Bakhita endured kidnapping and enslavement, realities that gravely violated freedom and cannot be spiritualized away. Pope Francis presents her later forgiveness and service as fruits of the freedom she received in Christ, not as approval of what was done to her. Her witness distinguishes coerced servitude from a free gift of self and shows that Christian forgiveness can resist hatred without denying injustice or removing the need for protection.",
            sourceIDs: [VirtueCurriculumSources.saintBakhita.id],
            examenIntroduction:
                "Choose one commitment or limit that currently feels restrictive. Examine whether it protects a good you freely promised, should be honestly renegotiated, or is an unjust demand that calls for a boundary or help.",
            examenExample:
                "Example: You want to cancel a weekly responsibility because you are tired. The examination would distinguish ordinary reluctance from genuine incapacity, ask what was promised and to whom, and check whether the demand is safe and just before deciding to keep it, renegotiate it, or seek support.",
            specificExamen:
                "What commitment currently feels restrictive because it protects a good I genuinely want to love?"
        ),
        "foundations-conscience": make(
            analysis:
                "The hoped-for result—protecting jobs—is a serious good, and fear for coworkers is a morally relevant circumstance. But the first question concerns the chosen act itself: falsifying a safety report asserts as true what the employee believes is false and may expose others to harm. A good intention cannot transform that means into a good act. Circumstances can increase or diminish responsibility and urgency, but they do not make every means permissible. A formed response would verify the evidence, distinguish uncertainty from concealment, use appropriate reporting channels, seek counsel, document facts lawfully, and refuse direct falsehood. Duress or fear may reduce personal culpability, which outsiders should judge cautiously. It does not erase the need to protect people, repair false reporting, or obtain legal, pastoral, or professional help.",
            synthesis:
                "Romans 12 describes moral discernment as a renewed mind embodied in truthful, patient, peaceful, and courageous love. Hebrews 5 says mature perception is trained by practice to distinguish good from evil. First John 3 holds conscience before a God greater than the heart and joins confidence in prayer to concrete love and obedience. Together the passages show that conscience is neither a private feeling nor an external script. It is a judgment that must be formed by truth, practiced in love, corrected when mistaken, and entrusted to God's mercy.",
            transfer:
                "When your conscience feels certain, what practices help you test whether that certainty is formed by truth rather than fear, convenience, or group pressure?",
            witnessTitle: "Saint Thomas More and conscience formed by truth",
            witnessBody:
                "Saint Thomas More is remembered for fidelity to conscience under political pressure, but his example should not be reduced to 'follow whatever feels right.' Saint John Paul II emphasized More's disciplined search for truth, life of prayer, public service, and willingness to accept personal cost rather than make power the measure of good. His witness joins conscience to truth, responsibility, humility, and respect for others—not to stubborn self-assertion.",
            sourceIDs: [VirtueCurriculumSources.saintThomasMore.id],
            examenIntroduction:
                "Choose one decision in which you felt morally uncertain, pressured, or unusually certain. Reconstruct the decision so you can see what informed your conscience and what still needs verification or counsel.",
            examenExample:
                "Example: A supervisor asks you to omit an important fact to avoid conflict. The examination would identify exactly what would be stated or concealed, the good you hope to protect, the people affected, and which trustworthy sources or advisers can test your first judgment.",
            specificExamen:
                "Which source is forming my conscience most strongly right now: Scripture and Church teaching, prayer and wise counsel, fear, habit, convenience, or the approval of my group?",
            checks: [
                check(
                    "conscience-object-intention-circumstances",
                    "Which three elements must be considered when evaluating a human act?",
                    [
                        "Feeling, outcome, and reputation", "Object, intention, and circumstances",
                        "Rule, punishment, and success",
                    ],
                    correct: 1,
                    explanation:
                        "Catholic moral analysis considers what is chosen, why it is chosen, and the relevant circumstances. A good act requires goodness in all three, while circumstances cannot make an intrinsically wrong object good."
                ),
                check(
                    "conscience-good-end",
                    "Can a good goal make every means used to reach it morally good?",
                    [
                        "Yes, if the result helps enough people", "Yes, when the person feels certain",
                        "No; a good end does not justify an evil means",
                    ],
                    correct: 2,
                    explanation:
                        "Intention matters, but it cannot change an intrinsically disordered chosen act into a good one. Discernment must seek both a good end and morally good means."
                ),
                check(
                    "conscience-formation",
                    "What is the best description of a well-formed conscience?",
                    [
                        "An infallible feeling",
                        "A lifelong judgment educated by truth, prayer, practice, counsel, and Church teaching",
                        "Whatever removes uncertainty fastest",
                    ],
                    correct: 1,
                    explanation:
                        "Conscience must be obeyed and also formed. The Catechism describes formation as a lifelong task nourished by God's Word, prayer, practice, trustworthy witness, and the Church's teaching."
                ),
            ]
        ),
        "foundations-passions": make(
            analysis:
                "The first task is to separate what arose spontaneously from what was chosen. Anger, fear, bodily arousal, an intrusive image, or a first impulse may arrive without consent. They can still reveal a need, danger, wound, or disordered attachment that deserves attention. Moral responsibility concerns how the person receives, feeds, redirects, or acts upon the movement with available knowledge and freedom. A faithful response neither condemns the whole self for having a feeling nor treats intensity as permission. It names the feeling, checks the facts, protects anyone at risk, delays action if necessary, and chooses a fitting response. Persistent distress, compulsion, trauma, or danger may call for pastoral and clinical support; seeking that help is compatible with virtue.",
            synthesis:
                "The Gospel account of Gethsemane shows Christ experiencing anguish without allowing anguish to sever trust or obedience. The Psalms give strong emotion truthful speech before God rather than forcing pious denial. James distinguishes trial and temptation from the inward process by which desire is entertained and gives birth to sin. Read together, these passages protect both moral seriousness and mercy: feelings belong in prayer and discernment, while consent and chosen action remain distinct questions.",
            transfer:
                "What feeling do you most often either obey immediately or condemn immediately, instead of bringing it into truthful prayer and deliberate choice?",
            witnessTitle: "Christ in Gethsemane",
            witnessBody:
                "Jesus does not perform emotional numbness in Gethsemane. He names sorrow, asks his friends to remain near, prays honestly, and freely entrusts himself to the Father. His sinless humanity shows that intense feeling is not itself moral failure. The pattern is integration: emotion is neither denied nor enthroned, but carried within relationship, truth, prayer, and faithful action.",
            examenIntroduction:
                "Choose one recent moment when a strong emotion arrived before you had time to decide what to do. Focus on the movement from first reaction to consent and action, not on shaming yourself for having a feeling.",
            examenExample:
                "Example: An unfair email produces immediate anger and an urge to send a cutting reply. The examination would separate the involuntary surge from the decision to draft, pause, verify the facts, seek advice, or respond; it would also ask whether a real injustice needs a firm but fitting answer.",
            specificExamen:
                "Which part of my emotional response was involuntary, and at what point did a genuinely free next choice become available?"
        ),
        "foundations-habit": make(
            analysis:
                "One failure does not prove that every previous effort was false, and one success does not prove that a habit is secure. The lapse should be examined concretely: what cue, fatigue, environment, rationalization, or missing support made the old response easier? Repentance names any real wrong and makes repair; prudence redesigns the next situation; humility accepts that growth is uneven; hope returns without drama. The person should avoid two distortions: minimizing a pattern that harms others, and turning a setback into an identity sentence. Stable virtue grows through many free acts, but grace can meet the person in the very act of returning. The practical question is not 'Am I secretly hopeless?' but 'What truthful, supported choice will I practice next?'",
            synthesis:
                "Deuteronomy places God's words in repeated daily rhythms; Luke teaches faithfulness in small responsibilities; Galatians describes sowing and reaping without promising instant results. These readings show habit as embodied memory: attention, environment, repetition, and community make some responses more available. Yet biblical perseverance is not a mechanical law of self-improvement. The harvest remains God's gift, failure calls for repentance rather than fatalism, and small fidelity matters because love is lived in actual repeated choices.",
            transfer:
                "Which cue and environment make one repeated choice easier, and what change would make the good more available before willpower is tested?",
            witnessTitle: "Saint Thérèse and beginning again",
            witnessBody:
                "The little way of Saint Thérèse combines serious love with confidence in mercy. Small acts matter, yet they are not spiritual currency by which a person purchases God's love. Her witness offers a sane approach to habit: accept creaturely weakness, use the next ordinary opportunity, and begin again in trust. That posture resists both perfectionism and indifference.",
            sourceIDs: [VirtueCurriculumSources.saintTherese.id],
            examenIntroduction:
                "Choose one repeated pattern you want to understand, preferably a recent and ordinary instance. Study the cue, environment, response, and consequence so the next attempt depends on more than a vague promise to try harder.",
            examenExample:
                "Example: Late-night scrolling repeatedly displaces prayer and sleep. The examination would identify when the phone is picked up, what relief or stimulation is sought, which environmental cue keeps the loop available, and one realistic change—such as charging the phone elsewhere—paired with prayer and accountability.",
            specificExamen:
                "What cue begins the pattern I want to change, and what one environmental support could interrupt it earlier?"
        ),
        "foundations-hinges": make(
            analysis:
                "The courageous-looking response may still be imprudent, unjust, or intemperate. Prudence first seeks the relevant facts and fitting means. Justice asks what is owed to every person affected, including people without power. Fortitude supplies endurance to carry the right judgment through difficulty. Temperance keeps fear, anger, appetite, or desire for recognition from seizing control. The virtues are distinct, so a weakness in one cannot simply be covered by excess in another. A wise response may be firm and costly without being reckless; restrained without being passive; fair without pretending every claim is identical. The 'hinges' work together because a human act is one act of a whole person.",
            synthesis:
                "Wisdom 8 names temperance, prudence, justice, and courage together as goods useful throughout life. The wise and foolish builders in Matthew connect sound judgment to action that endures pressure. Philippians 4 places disciplined attention and practice within prayer and God's peace. The readings portray the cardinal virtues not as four personality types but as interdependent powers by which reason, desire, relationship, and endurance become coordinated for faithful action. No one virtue can excuse neglect of the others.",
            transfer:
                "In a decision you face, which cardinal virtue is most visible—and which quieter virtue is needed to keep it truthful?",
            witnessTitle: "Solomon's request for a listening heart",
            witnessBody:
                "Solomon's early prayer asks not first for dominance or long life but for an understanding heart able to discern and govern justly. His later failures also warn that an initial gift does not remove the need for continued fidelity. The biblical witness holds two truths together: practical wisdom is a gift worth seeking, and no past insight excuses present disorder.",
            examenIntroduction:
                "Choose one decision in which a response looks courageous, fair, restrained, or clever at first glance. Then test whether all four cardinal virtues are needed to keep that response ordered to the good.",
            examenExample:
                "Example: Confronting a coworker about harmful conduct may require justice for those affected and fortitude to speak. Prudence still asks when, where, and with what evidence to act, while temperance keeps anger or the desire to look heroic from taking control.",
            specificExamen:
                "Which of prudence, justice, fortitude, or temperance is missing from the way I am framing this situation?"
        ),
        "foundations-theological": make(
            analysis:
                "The person's service may involve real generosity and disciplined human virtue, but the theological virtues cannot be inferred from visible usefulness alone. Faith, hope, and charity are gifts by which God draws the person into relationship with himself. They can animate ordinary service, purify motives, and direct even hidden acts toward divine communion. The right response is neither to dismiss natural goodness nor to canonize appearances. Encourage the concrete good, invite deeper trust and prayer, and remember that only God sees the heart fully. Human virtue prepares and disposes action; theological virtue gives a specifically Godward life that no personality trait or public record can manufacture.",
            synthesis:
                "Hebrews 11 presents faith as lived trust in God's promise. Romans 5 shows hope arising through grace even in suffering, rather than through optimism about circumstances. First Corinthians 13 identifies charity as the form without which extraordinary gifts lose their spiritual substance. Together the readings show why these virtues are called theological: God is their origin, motive, and object, and they order the whole moral life toward communion with him.",
            transfer:
                "Which good act in your life most needs to be re-rooted in trust in God, hope in his promise, or love for God and neighbor?",
            witnessTitle: "Mary's receiving faith",
            witnessBody:
                "At the Annunciation, Mary asks a real question, receives God's word, and consents to a future she cannot control. Her faith is neither credulity nor possession of a full plan. Her hope rests in God's fidelity, and her charity becomes embodied service. Mary shows the theological virtues as relationship and gift before they become heroic-looking action.",
            examenIntroduction:
                "Choose one good action that has become anxious, resentful, self-reliant, or dependent on recognition. Ask how faith, hope, and charity would change its source and direction rather than merely adding more effort.",
            examenExample:
                "Example: Regular service begins with love but gradually becomes a search for praise, and disappointment turns into resentment. The examination would preserve the real good being done while asking how trust in God, hope beyond visible results, and love for the actual people served could purify the action.",
            specificExamen:
                "Am I trying to produce faith, hope, or charity as a performance, or am I asking God to deepen his gift and responding to it?"
        ),
        "foundations-grace": make(
            analysis:
                "The person should neither claim sole credit for growth nor deny real cooperation. Grace is God's free initiative and gift; human response is itself enabled by grace, yet it remains genuinely human and free. Concrete disciplines, therapy, friendship, sacramental life, and repeated decisions may all become means through which healing and formation unfold. A setback does not prove grace absent, and success does not establish spiritual superiority. The right posture is gratitude, responsibility, and dependence: thank God, name the help received, make repair where needed, continue the practice, and reject comparison. If the struggle involves serious harm or illness, divine help is not a reason to avoid competent human care.",
            synthesis:
                "John 15 places fruitfulness in abiding union with Christ. Ephesians 2 names salvation as grace and gift while immediately describing a life created for good works. Galatians 5 contrasts disordered works with the Spirit's fruit and calls believers to walk by the Spirit. Together the passages refuse a contest between grace and effort: grace precedes, heals, elevates, and sustains; the person truly receives, cooperates, practices, and bears fruit without treating holiness as self-authorship.",
            transfer:
                "Where are you tempted either to take total credit for growth or to use dependence on grace as a reason not to take the next concrete step?",
            witnessTitle: "Peter: received, restored, and sent",
            witnessBody:
                "Peter's story includes sincere love, proud confidence, fear, denial, tears, forgiveness, and renewed mission. Christ does not treat Peter's failure as the final truth about him, nor does restoration erase responsibility. Peter becomes a witness that grace is not denial of weakness: it meets a real sinner, restores communion, and entrusts concrete love and service again.",
            examenIntroduction:
                "Choose one area of genuine growth or one setback after growth. Look for both God's prior gifts and your real response so that gratitude does not become passivity and effort does not become self-congratulation.",
            examenExample:
                "Example: A harmful pattern improves through prayer, the sacraments, therapy, a friend's support, environmental changes, and repeated choices. The examination would name every form of help with gratitude, accept responsibility for the choices made, and plan the next act without claiming sole credit or denying progress.",
            specificExamen:
                "What gift, person, sacrament, or circumstance has helped me grow that I have been treating as though it were my achievement alone?",
            checks: [
                check(
                    "grace-passivity",
                    "Which statement best expresses Catholic cooperation with grace?",
                    [
                        "God acts, so practice is unnecessary", "Growth is entirely self-produced",
                        "God's grace comes first and enables a genuinely free human response",
                    ],
                    correct: 2,
                    explanation:
                        "Grace is gratuitous and prior; it does not turn the person into a passive object. Enabled by grace, the person truly responds, practices, repents, and loves."
                ),
                check(
                    "grace-virtue-types",
                    "How do acquired human virtues and the theological virtues differ?",
                    [
                        "They are identical",
                        "Human virtues grow through repeated acts; faith, hope, and charity are infused gifts ordered directly to God",
                        "Only human virtues affect conduct",
                    ],
                    correct: 1,
                    explanation:
                        "The distinction prevents both self-reliance and passivity. Grace purifies and elevates human virtue while faith, hope, and charity give the moral life its Godward form."
                ),
                check(
                    "grace-fruit",
                    "What does completing a lesson or practice establish?",
                    [
                        "That the person has mastered the virtue", "That God now owes a reward",
                        "Only that the person completed that study or practice",
                    ],
                    correct: 2,
                    explanation:
                        "Participation is factual evidence of participation, not a measurement of holiness, culpability, or the hidden work of grace."
                ),
            ]
        ),
        "foundations-church": make(
            analysis:
                "Private study is a real good, but Christian formation is not designed as an isolated self-project. Scripture is received in the Church; worship directs the person toward God; sacraments communicate grace; community supplies witness, correction, service, and belonging. This does not mean every parish relationship is safe or every human minister acts well. Harm should be named and appropriate boundaries or reporting may be necessary. Nor does community remove personal responsibility. A mature next step distinguishes the Church's gifts from the failures of members, seeks trustworthy participation, and refuses both consumer passivity and solitary self-sufficiency.",
            synthesis:
                "Acts 2 joins apostolic teaching, fellowship, the breaking of bread, prayer, generosity, and common life. First Corinthians 12 insists that different members and gifts belong to one body and cannot declare one another unnecessary. Ephesians 4 describes ministry as equipping the whole body to mature in truth and love. These readings make formation ecclesial: Christ forms distinct persons through shared worship, doctrine, gifts, service, correction, and communion. Personal responsibility remains, but it is never meant to mature in isolation.",
            transfer:
                "Which part of formation are you trying to carry alone that properly needs sacrament, community, wise accompaniment, or service?",
            witnessTitle: "The first Christian community",
            witnessBody:
                "Acts does not present the first believers as a flawless society. It presents a community gathered around apostolic teaching, prayer, shared life, the breaking of bread, and care for need. Later conflicts in Acts reveal that communion requires truth and repair. Their witness is not nostalgia; it is a pattern showing that doctrine, worship, material responsibility, and relationship belong together.",
            examenIntroduction:
                "Choose one part of Catholic formation you are attempting alone or one painful community experience that now shapes your participation. Examine what can rightly remain personal, what requires the Church, and what safety or repair may be needed.",
            examenExample:
                "Example: After one hurtful parish interaction, a person avoids every form of parish life while still longing for sacramental and communal formation. The examination would not excuse the harm or demand unsafe contact; it would distinguish that event from the Church's gifts and identify one trustworthy, bounded way to seek support or participate.",
            specificExamen:
                "Where do I need to receive from the Church, and where am I being called to contribute rather than remain a spectator?"
        ),
        "foundations-christ": make(
            analysis:
                "The desire for an ideal image can quietly replace discipleship. The person should ask whether the plan makes Christ more visible or merely makes the self more controllable and admirable. A Christ-centered rule includes prayer, sacramental life, truth, duties of justice, mercy, rest, relationship, and concrete service; it can be revised when circumstances change. Failure calls for repentance and return, not self-contempt. Success calls for gratitude, not superiority. Practices are servants of love. If they damage health, neglect vocation, conceal sin, or produce contempt for weaker people, the plan needs correction rather than stricter performance.",
            synthesis:
                "Philippians 2 reveals Christ's self-emptying obedience and God's exaltation, making his pattern the center of Christian character. John 13 shows the Lord giving humble service a bodily form and commanding disciples to love as he has loved. Colossians 3 describes the communal habits of compassion, forgiveness, peace, gratitude, and love that clothe a life in Christ. The course therefore ends not with a perfected self-image but with continuing apprenticeship to a living person whose grace gives the virtues their unity and end.",
            transfer:
                "Which practice would make your life resemble Christ more in love, and which impressive practice might only make your preferred self-image stronger?",
            witnessTitle: "Jesus Christ, measure and teacher of every virtue",
            witnessBody:
                "Christ does not merely deliver a catalogue of traits. In him truth, justice, courage, self-command, mercy, humility, faithfulness, and charity form one life of love for the Father and self-gift for others. The saints matter because they receive and refract this life in different circumstances. Christian formation remains personal: learn Christ, receive his grace, imitate his love, repent when you fail, and remain with him.",
            examenIntroduction:
                "Choose one spiritual practice, discipline, or virtue goal that matters to you. Examine whether it is making love of God and neighbor more concrete or mainly strengthening an ideal image of yourself.",
            examenExample:
                "Example: A strict prayer and study schedule looks impressive but regularly produces impatience toward family interruptions. The examination would honor the desire for discipline while asking whether the schedule serves communion with Christ, duties of love, health, and vocation—or needs to be revised so the practice remains a servant of love.",
            specificExamen:
                "If someone saw only my ordinary treatment of inconvenient people, what would they learn about the Christ I claim to follow?",
            checks: [
                check(
                    "christ-final-end",
                    "What is the final end of Catholic virtue formation?",
                    ["A flawless public image", "Communion with God and Christlike love", "Maximum self-control"],
                    correct: 1,
                    explanation:
                        "Virtues order the person toward beatitude—communion with God—and make freedom capable of steadfast love. Performance and control are not the final end."
                ),
                check(
                    "christ-passions",
                    "Which statement about strong feelings is most accurate?",
                    [
                        "The feeling itself always proves guilt", "Authenticity requires acting on it",
                        "It is real information whose moral meaning also depends on consent and response",
                    ],
                    correct: 2,
                    explanation:
                        "Passions belong to embodied life and are not evil in themselves. Formation neither represses them nor lets them rule; it integrates them under reason, freedom, faith, and love."
                ),
                check(
                    "christ-cardinal",
                    "Why are prudence, justice, fortitude, and temperance called cardinal virtues?",
                    [
                        "They coordinate central powers of moral life", "They replace faith, hope, and charity",
                        "Each belongs to a different personality type",
                    ],
                    correct: 0,
                    explanation:
                        "They are 'hinges' of human moral life: right judgment, what is owed, firmness in difficulty, and ordered desire work together rather than define personality categories."
                ),
                check(
                    "christ-return",
                    "What is the fitting response after failure?",
                    [
                        "Erase all prior progress", "Repent, repair, receive mercy, learn, and begin again",
                        "Hide the failure until the habit is stronger",
                    ],
                    correct: 1,
                    explanation:
                        "Christian perseverance tells the truth about wrong, seeks needed repair and sacramental help, learns from the conditions of failure, and returns in hope."
                ),
            ]
        ),
    ]
}

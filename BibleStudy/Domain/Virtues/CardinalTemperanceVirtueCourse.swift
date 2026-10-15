import Foundation

enum CardinalTemperanceVirtueCourse {
    private static let sources = VirtueCurriculumSources.self
    private static let build = VirtueCurriculumBuilder.self

    static let course = build.course(
        id: "cardinal-temperance",
        collection: .cardinal,
        virtueID: .cardinalTemperance,
        title: "Temperance: Freedom in the Use of Good Things",
        subtitle: "Order desire, receive gifts, and remain free to love",
        overview:
            "Temperance moderates the attraction of pleasures and provides balance in the use of created goods. This ten-lesson course studies fitting measure, integrated desire, gratitude for creation, food and drink, digital attention, possessions, speech and anger, fasting and feasting, compulsive patterns, grace, and a humane rule of enough. It rejects both indulgence and contempt for the body.",
        whyItMatters:
            "Created goods can nourish life, relationship, beauty, celebration, and service. They become poor masters when immediate pleasure obscures health, vocation, worship, justice, or another person. Temperance forms self-mastery not so life becomes gray, but so enjoyment remains grateful, proportionate, shareable, and free enough to stop.",
        systemImage: "dial.medium",
        contentVersion: 3,
        lessons: CardinalTemperanceVirtueLectures.lessons,
        sources: [
            sources.catechismHumanVirtues,
            sources.catechismPassions,
            sources.catechismHealth,
            sources.catechismSunday,
            sources.catechismGoodsAndProperty,
            sources.catechismGrace,
            sources.catechismPenance,
            sources.popeTemperance,
            sources.popeGluttony,
            sources.rickaby,
        ]
    )
}

enum CardinalTemperanceVirtueLectures {
    static let sources = VirtueCurriculumSources.self
    static let build = VirtueCurriculumBuilder.self
    static let lessons = partOne + partTwo

    static func lecture(
        id: String,
        title: String,
        summary: String,
        opening: String,
        goal: String,
        terms: [String],
        chapters: [(String, String)],
        misconception: String,
        caseStudy: String,
        practice: String,
        prayer: String,
        scripture: [VirtueScriptureEncounter],
        remember: [String],
        sourceIDs: [String]
    ) -> VirtueStudyLesson {
        var sections = [
            build.section("Opening question", opening),
            build.section("Learning goal", goal),
            build.section("Terms to know", terms.joined(separator: "\n\n")),
        ]
        sections.append(contentsOf: chapters.map { build.section($0.0, $0.1) })
        sections.append(contentsOf: [
            build.section("Misconception check", misconception),
            build.section("A case to consider", caseStudy),
            build.section("Practice before the next lesson", practice),
            build.section("Prayer", prayer),
        ])

        let formationSupport = CardinalTemperanceLessonLearningSupport.support(for: id)
        let completeSourceIDs = Array(
            Set(sourceIDs + (formationSupport?.supportingSourceIDs ?? []))
        ).sorted()

        return build.lectureLesson(
            id: id,
            title: title,
            summary: summary,
            sections: sections,
            scripture: scripture,
            remember: remember,
            sourceIDs: completeSourceIDs,
            formationSupport: formationSupport
        )
    }
}

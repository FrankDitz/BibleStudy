import Foundation

enum FortitudeVirtueCourse {
    private static let sources = VirtueCurriculumSources.self
    private static let build = VirtueCurriculumBuilder.self

    static let course = build.course(
        id: "cardinal-fortitude",
        collection: .cardinal,
        virtueID: .fortitude,
        title: "Fortitude: Courage for the Difficult Good",
        subtitle: "Face fear, act with love, endure with hope",
        overview:
            "Fortitude ensures firmness in difficulty and constancy in pursuing the good. This ten-lesson course studies fear, motive, rashness, ordinary moral courage, endurance, Christ's Passion, resistance to evil, receiving help, grace, and a sustainable rule of courageous fidelity. It teaches courage without romanticizing danger, pain, isolation, or aggression.",
        whyItMatters:
            "Knowing what is good does not remove cost, opposition, weariness, temptation, or fear. Fortitude helps a person act and remain faithful without confusing bold feeling with virtue. Christian courage is governed by prudence and justice, perfected by charity, sustained by hope and grace, and humble enough to seek protection and help.",
        systemImage: "shield.lefthalf.filled",
        contentVersion: 3,
        lessons: FortitudeVirtueLectures.lessons,
        sources: [
            sources.catechismHumanVirtues,
            sources.catechismFreedom,
            sources.catechismPassions,
            sources.catechismGrace,
            sources.catechismHope,
            sources.catechismGiftsAndFruits,
            sources.catechismHumanLife,
            sources.popeFortitude,
            sources.popePatience,
            sources.gaudete,
            sources.veritatisSplendor,
            sources.rickaby,
        ]
    )
}

enum FortitudeVirtueLectures {
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

        let formationSupport = FortitudeLessonLearningSupport.support(for: id)
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

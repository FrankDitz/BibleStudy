import Foundation

enum OrientationVirtueCurriculum {
    private static let sources = VirtueCurriculumSources.self
    private static let build = VirtueCurriculumBuilder.self

    static let course = build.course(
        id: "virtue-foundations",
        collection: .foundations,
        virtueID: nil,
        title: "Becoming the Person God Calls You to Be",
        subtitle: "An eleven-lesson Catholic introduction to virtue, conscience, grace, and holiness",
        overview:
            "Begin with the whole Catholic map. These are full mini-lectures rather than short devotionals: each lesson develops one major idea, assigns several connected Scripture readings, tests common misunderstandings, and ends with review and practice.",
        whyItMatters:
            "Without a foundation, virtue can sound like rule keeping, personality improvement, or a contest in self-control. Catholic formation is larger: God calls a free, embodied, social person into beatitude and teaches that person to love reliably through grace-supported habits.",
        systemImage: "building.columns",
        contentVersion: 4,
        lessons: OrientationVirtueLectures.lessons,
        sources: [
            sources.catechismBeatitude,
            sources.catechismHumanVirtues,
            sources.catechismTheologicalVirtues,
            sources.catechismGiftsAndFruits,
            sources.catechismFreedom,
            sources.catechismMoralActs,
            sources.catechismConscience,
            sources.catechismPassions,
            sources.catechismGrace,
            sources.catechismCapitalSins,
            sources.lumenGentium,
            sources.gaudete,
            sources.deusCaritasEst,
            sources.popeGrace,
            sources.saintAugustine,
            sources.saintThomasMore,
            sources.saintTherese,
            sources.saintBakhita,
            sources.rickaby,
        ]
    )
}

enum OrientationVirtueLectures {
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

        let formationSupport = OrientationLessonLearningSupport.support(for: id)
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

import Foundation

enum PrudenceVirtueCourse {
    private static let sources = VirtueCurriculumSources.self
    private static let build = VirtueCurriculumBuilder.self

    static let course = build.course(
        id: "cardinal-prudence",
        collection: .cardinal,
        virtueID: .prudence,
        title: "Prudence",
        subtitle: "See the true good and choose the fitting way toward it",
        overview:
            "Prudence is practical wisdom: reason attentive to truth, moral principle, persons, circumstances, counsel, consequences, prayer, and timely action. This ten-lesson course moves from first principles through a complete Catholic process of discernment, with worked cases, substantial Scripture study, guided self-examination, and concrete practice.",
        whyItMatters:
            "Good intentions do not automatically produce good choices. We can pursue a partial good, use an unjust means, ignore reality, wait too long, or call fear prudence. This virtue helps every other moral virtue find its fitting expression in real life, where duties, people, limits, and consequences must be judged together.",
        systemImage: "eye.circle",
        contentVersion: 3,
        lessons: PrudenceVirtueLectures.lessons,
        sources: [
            sources.catechismHumanVirtues,
            sources.catechismFreedom,
            sources.catechismMoralActs,
            sources.catechismConscience,
            sources.popePrudence,
            sources.popeGrace,
            sources.gaudete,
            sources.rickaby,
        ]
    )
}

enum PrudenceVirtueLectures {
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

        let formationSupport = PrudenceLessonLearningSupport.support(for: id)
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

import Foundation

enum JusticeVirtueCourse {
    private static let sources = VirtueCurriculumSources.self
    private static let build = VirtueCurriculumBuilder.self

    static let course = build.course(
        id: "cardinal-justice",
        collection: .cardinal,
        virtueID: .justice,
        title: "Justice",
        subtitle: "Give God and neighbor what is due",
        overview:
            "Justice is the constant and firm will to give God and neighbor their due. This ten-lesson course begins with ordinary obligations, then studies worship, dignity, truth, property, work, authority, the common good, charity, mercy, and repair. Its purpose is not to turn every relationship into a transaction, but to form a dependable person whose love rests on truth.",
        whyItMatters:
            "Many duties arrive disguised as optional kindness. Justice teaches us to recognize legitimate claims, use power for service, protect dignity, keep promises, repair injuries, and participate in a shared life. Charity gives beyond what is due, but it cannot make unpaid wages, deception, favoritism, or neglected responsibilities acceptable.",
        systemImage: "scalemass",
        contentVersion: 3,
        lessons: JusticeVirtueLectures.lessons,
        sources: [
            sources.catechismHumanVirtues,
            sources.catechismTheologicalVirtues,
            sources.catechismSocialJustice,
            sources.catechismCommonGood,
            sources.catechismReligion,
            sources.catechismTruth,
            sources.catechismGoodsAndProperty,
            sources.catechismWork,
            sources.catechismMercy,
            sources.popeJustice,
            sources.deusCaritasEst,
            sources.gaudete,
            sources.rickaby,
        ]
    )
}

enum JusticeVirtueLectures {
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

        let formationSupport = JusticeLessonLearningSupport.support(for: id)
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

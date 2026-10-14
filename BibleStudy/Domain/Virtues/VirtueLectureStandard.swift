import Foundation

enum VirtueLectureIssue: String, Equatable, Sendable {
    case insufficientTeaching
    case insufficientTotalContent
    case insufficientSections
    case insufficientScripture
    case insufficientScriptureBreadth
    case insufficientReview
    case inaccurateTimeEstimate
    case missingWorkedReasoning
    case missingScriptureSynthesis
    case missingSelfExamination
    case missingWitness
    case missingSourceTraceability
}

struct VirtueLectureMetrics: Equatable, Sendable {
    let instructionalWords: Int
    let totalSectionWords: Int
    let scripturePassages: Int
    let scriptureVerses: Int
    let reviewPrompts: Int
    let estimatedMinutes: Int
}

/// A content acceptance gate for lessons advertised as full mini-lectures.
///
/// The thresholds intentionally measure authored instruction separately from prayers,
/// exercises, definitions, and Scripture. This prevents a lesson from appearing deep
/// because it has a long reading assignment or repeated boilerplate.
enum VirtueLectureStandard {
    static let minimumInstructionalWords = 800
    static let minimumTotalSectionWords = 1_000
    static let minimumSections = 8
    static let minimumScripturePassages = 3
    static let minimumScriptureVerses = 24
    static let minimumReviewPrompts = 5

    private static let nonInstructionalTitles: Set<String> = [
        "Opening question",
        "Learning goal",
        "Terms to know",
        "Practice before the next lesson",
        "Prayer",
    ]

    static func metrics(for lesson: VirtueStudyLesson) -> VirtueLectureMetrics {
        let totalSectionWords = lesson.sections.reduce(0) { $0 + wordCount(in: $1.body) }
        let instructionalWords = lesson.sections
            .filter { nonInstructionalTitles.contains($0.title) == false }
            .reduce(0) { $0 + wordCount(in: $1.body) }
        let scriptureVerses = lesson.scriptureEncounters.reduce(0) {
            guard let verseStart = $1.reference.verseStart else { return $0 + 1 }
            let verseEnd = $1.reference.verseEnd ?? verseStart
            return $0 + max(0, verseEnd - verseStart + 1)
        }

        return VirtueLectureMetrics(
            instructionalWords: instructionalWords,
            totalSectionWords: totalSectionWords,
            scripturePassages: lesson.scriptureEncounters.count,
            scriptureVerses: scriptureVerses,
            reviewPrompts: lesson.reflectionPrompts.count,
            estimatedMinutes: estimatedMinutes(
                sectionWords: totalSectionWords,
                scriptureVerses: scriptureVerses,
                reviewPrompts: lesson.reflectionPrompts.count,
                formationSupport: lesson.formationSupport
            )
        )
    }

    static func issues(for lesson: VirtueStudyLesson) -> Set<VirtueLectureIssue> {
        let metrics = metrics(for: lesson)
        var issues: Set<VirtueLectureIssue> = []

        if metrics.instructionalWords < minimumInstructionalWords {
            issues.insert(.insufficientTeaching)
        }
        if metrics.totalSectionWords < minimumTotalSectionWords {
            issues.insert(.insufficientTotalContent)
        }
        if lesson.sections.count < minimumSections {
            issues.insert(.insufficientSections)
        }
        if metrics.scripturePassages < minimumScripturePassages {
            issues.insert(.insufficientScripture)
        }
        if metrics.scriptureVerses < minimumScriptureVerses {
            issues.insert(.insufficientScriptureBreadth)
        }
        if metrics.reviewPrompts < minimumReviewPrompts {
            issues.insert(.insufficientReview)
        }
        if lesson.estimatedMinutes != metrics.estimatedMinutes {
            issues.insert(.inaccurateTimeEstimate)
        }
        guard let support = lesson.formationSupport else {
            issues.formUnion([
                .missingWorkedReasoning,
                .missingScriptureSynthesis,
                .missingSelfExamination,
                .missingWitness,
                .missingSourceTraceability,
            ])
            return issues
        }
        if wordCount(in: support.workedCaseAnalysis) < 80 {
            issues.insert(.missingWorkedReasoning)
        }
        if wordCount(in: support.scriptureSynthesis) < 70
            || support.scriptureTransferQuestion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            issues.insert(.missingScriptureSynthesis)
        }
        if wordCount(in: support.selfExaminationIntroduction) < 20
            || wordCount(in: support.selfExaminationExample) < 25
            || support.selfExaminationSteps.count < 9
            || support.selfExaminationSteps.contains(where: {
                $0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    || wordCount(in: $0.question) < 5
                    || wordCount(in: $0.guidance) < 12
            })
        {
            issues.insert(.missingSelfExamination)
        }
        if wordCount(in: support.witnessBody) < 55
            || support.witnessTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            issues.insert(.missingWitness)
        }
        if lesson.sourceIDs.isEmpty
            || Set(support.supportingSourceIDs).isSubset(of: Set(lesson.sourceIDs)) == false
        {
            issues.insert(.missingSourceTraceability)
        }

        return issues
    }

    static func estimatedMinutes(
        sections: [VirtueLessonSection],
        scripture: [VirtueScriptureEncounter],
        reviewPrompts: [String],
        formationSupport: VirtueLessonFormationSupport? = nil
    ) -> Int {
        estimatedMinutes(
            sectionWords: sections.reduce(0) { $0 + wordCount(in: $1.body) },
            scriptureVerses: scripture.reduce(0) {
                guard let verseStart = $1.reference.verseStart else { return $0 + 1 }
                let verseEnd = $1.reference.verseEnd ?? verseStart
                return $0 + max(0, verseEnd - verseStart + 1)
            },
            reviewPrompts: reviewPrompts.count,
            formationSupport: formationSupport
        )
    }

    private static func estimatedMinutes(
        sectionWords: Int,
        scriptureVerses: Int,
        reviewPrompts: Int,
        formationSupport: VirtueLessonFormationSupport?
    ) -> Int {
        // Teaching is read slowly; Scripture is read more slowly still. Review time is
        // deliberately modest because learners may choose to journal for much longer.
        let teachingMinutes = Int(ceil(Double(sectionWords) / 165.0))
        let scriptureMinutes = Int(ceil(Double(scriptureVerses) / 10.0))
        let reviewMinutes = max(3, Int(ceil(Double(reviewPrompts) * 0.75)))
        let supportWords: Int
        if let formationSupport {
            let teachingSupportWords =
                wordCount(in: formationSupport.workedCaseAnalysis)
                + wordCount(in: formationSupport.scriptureSynthesis)
                + wordCount(in: formationSupport.scriptureTransferQuestion)
                + wordCount(in: formationSupport.witnessBody)
            let examinationWords =
                wordCount(in: formationSupport.selfExaminationIntroduction)
                + wordCount(in: formationSupport.selfExaminationExample)
                + formationSupport.selfExaminationSteps.reduce(0) {
                    $0 + wordCount(in: $1.title) + wordCount(in: $1.question)
                        + wordCount(in: $1.guidance)
                }
            let checkWords = formationSupport.knowledgeChecks.reduce(0) {
                $0 + wordCount(in: $1.prompt) + wordCount(in: $1.explanation)
            }
            supportWords = teachingSupportWords + examinationWords + checkWords
        } else {
            supportWords = 0
        }
        let formationMinutes = Int(ceil(Double(supportWords) / 145.0))
        return max(1, teachingMinutes + scriptureMinutes + reviewMinutes + formationMinutes)
    }

    private static func wordCount(in text: String) -> Int {
        text.split { $0.isWhitespace || $0.isNewline }.count
    }
}

enum VirtueCourseLearningIssue: String, Equatable, Sendable {
    case insufficientCheckpointCoverage
    case missingFinalCheckpoint
}

/// Course-level checks cover cumulative learning patterns that cannot be judged one lesson at a time.
enum VirtueCourseLearningStandard {
    static func issues(for course: VirtueStudyCourse) -> Set<VirtueCourseLearningIssue> {
        var issues: Set<VirtueCourseLearningIssue> = []
        let checkpointLessons = course.lessons.filter {
            $0.formationSupport?.knowledgeChecks.isEmpty == false
        }
        let checkpointCount = checkpointLessons.reduce(0) {
            $0 + ($1.formationSupport?.knowledgeChecks.count ?? 0)
        }
        if checkpointLessons.count < 3 || checkpointCount < 9 {
            issues.insert(.insufficientCheckpointCoverage)
        }
        if course.lessons.last?.formationSupport?.knowledgeChecks.isEmpty != false {
            issues.insert(.missingFinalCheckpoint)
        }
        return issues
    }
}

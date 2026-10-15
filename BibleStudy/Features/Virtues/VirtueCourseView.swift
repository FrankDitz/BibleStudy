import SwiftData
import SwiftUI

struct VirtueCourseView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let course: VirtueStudyCourse
    let openReading: (CanonicalScriptureReference) -> Void

    @State private var errorMessage: String?
    @State private var beginningReflection = ""
    @State private var endingReflection = ""

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                header
                courseProgress
                reviewNotice
                overview
                courseReflection
                action
                lessonOutline
                sources
            }
            .padding(AppSpacing.screen)
            .frame(maxWidth: 840)
            .frame(maxWidth: .infinity)
        }
        .background(AppScreenBackground())
        .navigationTitle(course.title)
        .onAppear(perform: loadReflections)
        .accessibilityIdentifier("virtue-course-\(course.id)")
        .alert("Course could not be updated", isPresented: errorBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Please try again.")
        }
    }

    private var state: VirtueFormationState {
        _ = formationRecords.count
        return (try? VirtueFormationRepository(modelContext: modelContext).state()) ?? .empty
    }

    private var progress: VirtueCourseProgress? {
        state.courseProgress.first { $0.courseID == course.id }
    }

    private var nextLesson: VirtueStudyLesson? {
        if let lastID = progress?.lastOpenedLessonID,
            let lastIndex = course.lessons.firstIndex(where: { $0.id == lastID }),
            progress?.completedLessonIDs.contains(lastID) == false
        {
            return course.lessons[lastIndex]
        }
        return course.lessons.first { progress?.completedLessonIDs.contains($0.id) != true }
            ?? course.lessons.first
    }

    private var completedLessonCount: Int {
        progress?.completedLessonCount(in: course) ?? 0
    }

    private var courseProgressTitle: String {
        guard let progress else { return "Not started" }
        return progress.isComplete(course) ? "Course complete" : "In progress"
    }

    private var courseProgressSymbol: String {
        guard let progress else { return "circle" }
        return progress.isComplete(course) ? "checkmark.seal.fill" : "circle.dotted"
    }

    private var courseProgressColor: Color {
        guard let progress else { return AppTheme.supportingText }
        return progress.isComplete(course) ? AppTheme.success : AppTheme.accent
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [AppTheme.accent, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: course.systemImage)
                .font(.system(size: 180, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.08))
                .offset(x: 180, y: -35)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 12) {
                EditorialEyebrow(course.collection.title, inverse: true)
                Text(course.title)
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                Text(course.subtitle)
                    .font(AppTypography.screenIntroduction)
                    .foregroundStyle(.white.opacity(0.84))
                HStack(spacing: 16) {
                    Label("\(course.lessons.count) lessons", systemImage: "list.number")
                    Label("About \(course.estimatedMinutes) min", systemImage: "clock")
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.84))
            }
            .foregroundStyle(.white)
            .padding(AppSpacing.spacious)
        }
        .frame(minHeight: 280)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
    }

    private var courseProgress: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("COURSE PROGRESS")
                            .font(.caption.bold())
                            .foregroundStyle(AppTheme.supportingText)
                        Text("\(completedLessonCount) of \(course.lessons.count) lessons completed")
                            .font(.headline)
                    }
                    Spacer(minLength: 12)
                    Label(courseProgressTitle, systemImage: courseProgressSymbol)
                        .font(.subheadline.bold())
                        .foregroundStyle(courseProgressColor)
                }

                EmeraldProgressBar(
                    value: course.lessons.isEmpty
                        ? 0 : Double(completedLessonCount) / Double(course.lessons.count)
                )

                Text(
                    progress?.isComplete(course) == true
                        ? "Every lesson is checked off. You can revisit any lesson without losing completion."
                        : "Completed lessons are checked and highlighted in the course outline below."
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityIdentifier("virtue-course-progress")
    }

    private var reviewNotice: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 6) {
                Label("Source-checked course · Catholic review pending", systemImage: "checkmark.shield")
                    .font(.headline)
                    .foregroundStyle(AppTheme.warning)
                Text(
                    "This course synthesizes Scripture, the Catechism, and current universal-Church teaching. Historical sources appear only where relevant and never govern doctrine. It remains visibly marked as a draft until a qualified Catholic reviewer signs and dates it."
                )
                .font(.subheadline)
                .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityIdentifier("virtue-course-review-status")
    }

    private var overview: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Course overview", systemImage: "doc.text.magnifyingglass")
                    .font(AppTypography.sectionTitle)
                Text(course.overview)
                Text("Why it matters")
                    .font(.headline)
                Text(course.whyItMatters)
                    .foregroundStyle(AppTheme.supportingText)
                Text(
                    "Lesson completion records what you have studied. It does not measure holiness, mastery, or moral worth."
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityIdentifier("virtue-course-overview")
    }

    private var courseReflection: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Private Then / Now", systemImage: "lock")
                    .font(AppTypography.sectionTitle)

                Text("Then — before or early in the course")
                    .font(.headline)
                TextField(
                    "What do you currently believe virtue is, and where do you most want clarity or growth?",
                    text: $beginningReflection,
                    axis: .vertical
                )
                .lineLimit(3...7)

                if let progress, progress.isComplete(course) {
                    Divider()
                    Text("Now — after studying")
                        .font(.headline)
                    TextField(
                        "What changed in your understanding, and what faithful next step will you carry forward?",
                        text: $endingReflection,
                        axis: .vertical
                    )
                    .lineLimit(3...7)
                } else if progress != nil {
                    Text("Your “Now” reflection will appear after the course is complete.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.supportingText)
                }

                if progress != nil {
                    Button("Save Private Reflection", action: saveReflections)
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("virtue-course-save-reflection")
                }

                Text(
                    "These notes remain in the private virtue store. They are not graded, interpreted, or included in provider requests or hub events."
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityIdentifier("virtue-course-then-now")
    }

    @ViewBuilder
    private var action: some View {
        if let nextLesson {
            NavigationLink {
                VirtueLessonView(course: course, lesson: nextLesson, openReading: openReading)
            } label: {
                Label(actionTitle, systemImage: progress == nil ? "play.fill" : "arrow.right")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(EmeraldActionButtonStyle())
            .simultaneousGesture(TapGesture().onEnded(beginCourse))
            .accessibilityIdentifier("virtue-course-primary-action")
        }
    }

    private var actionTitle: String {
        guard let progress else { return "Begin Course" }
        return progress.isComplete(course) ? "Review Course" : "Continue Course"
    }

    private var lessonOutline: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Course outline")
                    .font(AppTypography.sectionTitle)
                Spacer()
                if let progress {
                    Text("\(progress.completedLessonCount(in: course)) of \(course.lessons.count)")
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.accent)
                }
            }

            ForEach(Array(course.lessons.enumerated()), id: \.element.id) { index, lesson in
                NavigationLink {
                    VirtueLessonView(course: course, lesson: lesson, openReading: openReading)
                } label: {
                    FeatureCard {
                        HStack(alignment: .top, spacing: 14) {
                            lessonStatus(lesson, number: index + 1)
                            VStack(alignment: .leading, spacing: 5) {
                                Text(lesson.title)
                                    .font(.headline)
                                Text(lesson.summary)
                                    .foregroundStyle(AppTheme.supportingText)
                                    .multilineTextAlignment(.leading)
                                Label("\(lesson.estimatedMinutes) min", systemImage: "clock")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.supportingText)
                                if lessonIsCompleted(lesson) {
                                    Label("Completed", systemImage: "checkmark.circle.fill")
                                        .font(.caption.bold())
                                        .foregroundStyle(AppTheme.success)
                                }
                            }
                            Spacer(minLength: 8)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .accessibilityHidden(true)
                        }
                    }
                    .overlay {
                        if lessonIsCompleted(lesson) {
                            RoundedRectangle(cornerRadius: AppCornerRadius.card)
                                .stroke(AppTheme.success.opacity(0.65), lineWidth: 2)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("virtue-lesson-row-\(lesson.id)")
                .accessibilityValue(lessonIsCompleted(lesson) ? "Completed" : "Not completed")
            }
        }
        .accessibilityIdentifier("virtue-course-outline")
    }

    private func lessonStatus(_ lesson: VirtueStudyLesson, number: Int) -> some View {
        Group {
            if lessonIsCompleted(lesson) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.success)
                    .accessibilityLabel("Completed")
            } else {
                Text("\(number)")
                    .foregroundStyle(.white)
                    .accessibilityLabel("Lesson \(number)")
            }
        }
        .font(.headline)
        .frame(width: 34, height: 34)
        .background(
            lessonIsCompleted(lesson)
                ? AppTheme.success.opacity(0.12) : AppTheme.accent,
            in: Circle()
        )
    }

    private func lessonIsCompleted(_ lesson: VirtueStudyLesson) -> Bool {
        progress?.completedLessonIDs.contains(lesson.id) == true
    }

    private var sources: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Sources", systemImage: "link")
                    .font(AppTypography.sectionTitle)
                ForEach(course.sources) { source in
                    Link(destination: source.url) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(source.title)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                Text(source.locator)
                                    .font(.subheadline)
                            }
                            Spacer(minLength: 8)
                            Image(systemName: "arrow.up.right")
                        }
                    }
                }
            }
        }
        .accessibilityIdentifier("virtue-course-sources")
    }

    private func beginCourse() {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                try VirtueStudyEngine.begin(courseID: course.id, in: &state)
                if !beginningReflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    try VirtueStudyEngine.saveCourseReflection(
                        courseID: course.id,
                        stage: .beginning,
                        text: beginningReflection,
                        in: &state
                    )
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadReflections() {
        guard let progress else { return }
        beginningReflection = progress.beginningReflection ?? ""
        endingReflection = progress.endingReflection ?? ""
    }

    private func saveReflections() {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                try VirtueStudyEngine.saveCourseReflection(
                    courseID: course.id,
                    stage: .beginning,
                    text: beginningReflection,
                    in: &state
                )
                if progress?.isComplete(course) == true {
                    try VirtueStudyEngine.saveCourseReflection(
                        courseID: course.id,
                        stage: .ending,
                        text: endingReflection,
                        in: &state
                    )
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )
    }
}

struct VirtueLessonView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let course: VirtueStudyCourse
    let lesson: VirtueStudyLesson
    let openReading: (CanonicalScriptureReference) -> Void

    @State private var errorMessage: String?
    @State private var privateExamen = ""
    @State private var selectedAnswers: [String: Int] = [:]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                lessonHeader
                ForEach(lesson.sections) { section in
                    lessonSection(section)
                }
                witness
                scripture
                reflection
                selfExamination
                knowledgeChecks
                lessonSources
                completion
            }
            .padding(AppSpacing.screen)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .background(AppScreenBackground())
        .navigationTitle("Lesson \(lessonNumber) of \(course.lessons.count)")
        .onAppear(perform: recordOpened)
        .accessibilityIdentifier("virtue-lesson-\(lesson.id)")
        .alert("Lesson could not be updated", isPresented: errorBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Please try again.")
        }
    }

    private var state: VirtueFormationState {
        _ = formationRecords.count
        return (try? VirtueFormationRepository(modelContext: modelContext).state()) ?? .empty
    }

    private var isCompleted: Bool {
        state.courseProgress.first(where: { $0.courseID == course.id })?
            .completedLessonIDs.contains(lesson.id) == true
    }

    private var nextLesson: VirtueStudyLesson? {
        guard let index = course.lessons.firstIndex(where: { $0.id == lesson.id }),
            course.lessons.indices.contains(index + 1)
        else { return nil }
        return course.lessons[index + 1]
    }

    private var lessonNumber: Int {
        (course.lessons.firstIndex(where: { $0.id == lesson.id }) ?? 0) + 1
    }

    private var lessonHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(course.title.uppercased())
                .font(.caption.bold())
                .foregroundStyle(AppTheme.accent)
            Text(lesson.title)
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text(lesson.summary)
                .font(AppTypography.screenIntroduction)
                .foregroundStyle(AppTheme.supportingText)
            Label("About \(lesson.estimatedMinutes) minutes", systemImage: "clock")
                .font(.subheadline)
                .foregroundStyle(AppTheme.supportingText)
            HStack(spacing: 16) {
                Label("Lesson \(lessonNumber) of \(course.lessons.count)", systemImage: "list.number")
                Label(
                    isCompleted ? "Completed" : "In progress",
                    systemImage: isCompleted ? "checkmark.circle.fill" : "circle.dotted"
                )
                .foregroundStyle(isCompleted ? AppTheme.success : AppTheme.accent)
                .accessibilityIdentifier("virtue-lesson-status")
            }
            .font(.subheadline.bold())
        }
    }

    private func lessonSection(_ section: VirtueLessonSection) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(section.title)
                    .font(AppTypography.sectionTitle)
                Text(section.body)
                    .font(.system(.body, design: .serif))
                    .lineSpacing(5)
                if section.title == "A case to consider",
                    let analysis = lesson.formationSupport?.workedCaseAnalysis
                {
                    Divider()
                    DisclosureGroup("Walk through the reasoning") {
                        Text(analysis)
                            .font(.system(.body, design: .serif))
                            .lineSpacing(5)
                            .padding(.top, 8)
                    }
                    .font(.headline)
                    .tint(AppTheme.accent)
                    .accessibilityIdentifier("virtue-worked-case")
                }
            }
        }
    }

    @ViewBuilder
    private var witness: some View {
        if let support = lesson.formationSupport {
            FeatureCard {
                VStack(alignment: .leading, spacing: 10) {
                    Label("A lived witness", systemImage: "person.crop.circle.badge.checkmark")
                        .font(AppTypography.sectionTitle)
                    Text(support.witnessTitle)
                        .font(.headline)
                    Text(support.witnessBody)
                        .font(.system(.body, design: .serif))
                        .lineSpacing(5)
                }
            }
            .accessibilityIdentifier("virtue-lived-witness")
        }
    }

    @ViewBuilder
    private var scripture: some View {
        if !lesson.scriptureEncounters.isEmpty {
            FeatureCard {
                VStack(alignment: .leading, spacing: 14) {
                    Label("Read in Scripture", systemImage: "text.book.closed")
                        .font(AppTypography.sectionTitle)
                    Text(
                        "Open each passage in your selected Bible edition so the words remain in their full context."
                    )
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.supportingText)
                    ForEach(lesson.scriptureEncounters) { encounter in
                        Button {
                            openReading(encounter.reference)
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "book.pages")
                                    .foregroundStyle(AppTheme.accent)
                                    .frame(width: 28)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(encounter.title)
                                        .font(.headline)
                                    Text(displayName(encounter.reference))
                                        .font(.subheadline.bold())
                                        .foregroundStyle(AppTheme.accent)
                                    Text(encounter.context)
                                        .foregroundStyle(AppTheme.supportingText)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer(minLength: 8)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("virtue-lesson-scripture-\(encounter.id)")
                    }
                    if let support = lesson.formationSupport {
                        Divider()
                        Text("After reading")
                            .font(.headline)
                        Text(support.scriptureSynthesis)
                            .font(.system(.body, design: .serif))
                            .lineSpacing(5)
                        Label(support.scriptureTransferQuestion, systemImage: "arrow.triangle.branch")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.accent)
                    }
                }
            }
        }
    }

    private var reflection: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Consider", systemImage: "sparkles")
                    .font(AppTypography.sectionTitle)
                ForEach(lesson.reflectionPrompts, id: \.self) { prompt in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(AppTheme.accent)
                        Text(prompt)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var selfExamination: some View {
        if let support = lesson.formationSupport {
            FeatureCard {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Examine one real situation", systemImage: "heart.text.square")
                        .font(AppTypography.sectionTitle)
                    Text(support.selfExaminationIntroduction)
                        .font(.system(.body, design: .serif))
                        .lineSpacing(4)

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Illustrative example", systemImage: "lightbulb")
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.accent)
                        Text(support.selfExaminationExample)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.supportingText)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.elevatedSurface, in: RoundedRectangle(cornerRadius: 12))

                    Text(
                        "Now apply the steps to your own situation. Move slowly; this is an aid to honest prayer and practical judgment, not a diagnosis, a judgment of another person's soul, or a substitute for Confession or qualified help."
                    )
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.supportingText)

                    ForEach(Array(support.selfExaminationSteps.enumerated()), id: \.element.id) {
                        index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .frame(width: 26, height: 26)
                                .background(AppTheme.accent, in: Circle())
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(step.title)
                                    .font(.headline)
                                Text(step.question)
                                    .font(.body)
                                Text(step.guidance)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.supportingText)
                            }
                        }
                        .accessibilityElement(children: .combine)
                    }

                    TextField(
                        "Private notes (optional)",
                        text: $privateExamen,
                        axis: .vertical
                    )
                    .lineLimit(4...10)

                    Button("Save Private Notes", action: saveLessonReflection)
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("virtue-save-private-examen")
                    Text("Saved only in the private virtue store. The app does not interpret or score this text.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.supportingText)
                }
            }
            .accessibilityIdentifier("virtue-self-examination")
        }
    }

    @ViewBuilder
    private var knowledgeChecks: some View {
        if let checks = lesson.formationSupport?.knowledgeChecks, !checks.isEmpty {
            FeatureCard {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Check your understanding", systemImage: "checkmark.bubble")
                        .font(AppTypography.sectionTitle)
                    Text("Ungraded. Choose again as often as you need; the explanation matters more than the result.")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.supportingText)

                    ForEach(checks) { check in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(check.prompt)
                                .font(.headline)
                            ForEach(Array(check.options.enumerated()), id: \.offset) { index, option in
                                Button {
                                    selectedAnswers[check.id] = index
                                } label: {
                                    HStack(alignment: .top) {
                                        Image(
                                            systemName: selectedAnswers[check.id] == index
                                                ? "largecircle.fill.circle" : "circle"
                                        )
                                        Text(option)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(
                                    selectedAnswers[check.id] == index
                                        ? AppTheme.accent : .primary
                                )
                            }

                            if let selection = selectedAnswers[check.id] {
                                Label(
                                    selection == check.correctOptionIndex ? "That's it" : "Not quite—try again",
                                    systemImage: selection == check.correctOptionIndex
                                        ? "checkmark.circle.fill" : "arrow.counterclockwise.circle"
                                )
                                .font(.subheadline.bold())
                                .foregroundStyle(
                                    selection == check.correctOptionIndex
                                        ? AppTheme.success : AppTheme.warning
                                )
                                Text(check.explanation)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.supportingText)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .accessibilityIdentifier("virtue-knowledge-check")
        }
    }

    private var lessonSources: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 10) {
                Label("Sources for this lesson", systemImage: "link")
                    .font(.headline)
                ForEach(lesson.sourceIDs.compactMap(course.source), id: \.id) { source in
                    Link("\(source.title) · \(source.locator)", destination: source.url)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }

    private var completion: some View {
        VStack(spacing: 12) {
            Button(isCompleted ? "Mark Lesson Incomplete" : "Mark Lesson Complete") {
                setCompleted(!isCompleted)
            }
            .buttonStyle(.borderedProminent)
            .tint(isCompleted ? AppTheme.success : AppTheme.accent)
            .frame(maxWidth: .infinity)
            .accessibilityIdentifier("virtue-lesson-complete")

            if isCompleted, let nextLesson {
                NavigationLink {
                    VirtueLessonView(course: course, lesson: nextLesson, openReading: openReading)
                } label: {
                    Label("Next Lesson", systemImage: "arrow.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("virtue-next-lesson")
            } else if isCompleted {
                Label(
                    "Course lessons complete. Return whenever you want to review; completion is not a claim of mastery.",
                    systemImage: "checkmark.seal"
                )
                .font(.subheadline)
                .foregroundStyle(AppTheme.success)
                practiceBridge
            }
        }
    }

    @ViewBuilder
    private var practiceBridge: some View {
        if let virtueID = course.virtueID {
            FeatureCard {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Live what you learned", systemImage: "figure.walk")
                        .font(AppTypography.sectionTitle)
                    Text(
                        "Choose one source-checked practice. A Focus Cycle records participation and reflection, never holiness or mastery."
                    )
                    .foregroundStyle(AppTheme.supportingText)

                    ForEach(transferPractices(for: virtueID)) { practice in
                        if let context = preferredContext(for: practice) {
                            NavigationLink {
                                VirtueFocusCycleSetupView(
                                    virtueID: virtueID,
                                    context: context,
                                    practiceID: practice.id,
                                    origin: .foundation
                                )
                            } label: {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(practice.commitment.title)
                                            .font(.caption.bold())
                                            .foregroundStyle(AppTheme.accent)
                                        Text(practice.title)
                                            .font(.headline)
                                        Text(practice.instruction)
                                            .font(.subheadline)
                                            .foregroundStyle(AppTheme.supportingText)
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        } else {
            FeatureCard {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Choose what to study and practice next", systemImage: "arrow.right.circle")
                        .font(.headline)
                    Text(
                        "Return to the Virtues library and choose one of the seven counter-virtue or four cardinal courses. Practice remains optional and follows understanding."
                    )
                    .foregroundStyle(AppTheme.supportingText)
                }
            }
        }
    }

    private func recordOpened() {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                try VirtueStudyEngine.openLesson(
                    courseID: course.id,
                    lessonID: lesson.id,
                    in: &state
                )
            }
            privateExamen =
                state.lessonReflections.first {
                    $0.courseID == course.id && $0.lessonID == lesson.id
                }?.response ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func saveLessonReflection() {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                try VirtueStudyEngine.saveLessonReflection(
                    courseID: course.id,
                    lessonID: lesson.id,
                    text: privateExamen,
                    in: &state
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func transferPractices(for virtueID: VirtueIdentifier) -> [VirtuePracticeDefinition] {
        let practices = VirtueFoundationLibrary.pathway(for: virtueID)?.practices ?? []
        return VirtuePracticeCommitment.allCases.compactMap { commitment in
            practices.first { $0.commitment == commitment }
        }
    }

    private func preferredContext(
        for practice: VirtuePracticeDefinition
    ) -> VirtuePracticeContext? {
        practice.contexts.sorted { $0.rawValue < $1.rawValue }.first
    }

    private func setCompleted(_ completed: Bool) {
        do {
            try VirtueFormationRepository(modelContext: modelContext).update { state in
                try VirtueStudyEngine.setLessonCompleted(
                    courseID: course.id,
                    lessonID: lesson.id,
                    completed: completed,
                    in: &state
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func displayName(_ reference: CanonicalScriptureReference) -> String {
        let book = CatholicCanon.book(osisID: reference.bookID)?.displayName ?? reference.bookID
        guard let verseStart = reference.verseStart else { return "\(book) \(reference.chapter)" }
        guard let verseEnd = reference.verseEnd, verseEnd != verseStart else {
            return "\(book) \(reference.chapter):\(verseStart)"
        }
        return "\(book) \(reference.chapter):\(verseStart)–\(verseEnd)"
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )
    }
}

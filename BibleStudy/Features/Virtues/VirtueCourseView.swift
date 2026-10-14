import SwiftData
import SwiftUI

struct VirtueCourseView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let course: VirtueStudyCourse
    let openReading: (CanonicalScriptureReference) -> Void

    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                header
                reviewNotice
                overview
                action
                lessonOutline
                sources
            }
            .padding()
            .frame(maxWidth: 840)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.warmSurface.opacity(0.35))
        .navigationTitle(course.title)
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

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: course.systemImage)
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 68, height: 68)
                .background(AppTheme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
                .accessibilityHidden(true)
            Text(course.collection.title.uppercased())
                .font(.caption.bold())
                .foregroundStyle(AppTheme.accent)
            Text(course.title)
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text(course.subtitle)
                .font(AppTypography.screenIntroduction)
                .foregroundStyle(AppTheme.supportingText)
            HStack(spacing: 16) {
                Label("\(course.lessons.count) lessons", systemImage: "list.number")
                Label("About \(course.estimatedMinutes) min", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(AppTheme.supportingText)
        }
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
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
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
                            }
                            Spacer(minLength: 8)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("virtue-lesson-row-\(lesson.id)")
            }
        }
        .accessibilityIdentifier("virtue-course-outline")
    }

    private func lessonStatus(_ lesson: VirtueStudyLesson, number: Int) -> some View {
        Group {
            if progress?.completedLessonIDs.contains(lesson.id) == true {
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
            progress?.completedLessonIDs.contains(lesson.id) == true
                ? AppTheme.success.opacity(0.12) : AppTheme.accent,
            in: Circle()
        )
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

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                lessonHeader
                ForEach(lesson.sections) { section in
                    lessonSection(section)
                }
                scripture
                reflection
                lessonSources
                completion
            }
            .padding()
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.warmSurface.opacity(0.35))
        .navigationTitle(lesson.title)
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
            }
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
        } catch {
            errorMessage = error.localizedDescription
        }
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

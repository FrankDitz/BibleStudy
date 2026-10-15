import SwiftData
import SwiftUI

struct VirtuesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BibleStudySchemaV3.VirtueFormationRecord.modifiedAt, order: .reverse)
    private var formationRecords: [BibleStudySchemaV3.VirtueFormationRecord]

    let openReading: (CanonicalScriptureReference) -> Void

    init(openReading: @escaping (CanonicalScriptureReference) -> Void = { _ in }) {
        self.openReading = openReading
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    featuredFormation
                    if featuredCourse.id != VirtueStudyCatalog.foundationCourse.id {
                        foundationCourse
                    }
                    formationJourney
                    privacyNote
                    courseCollection(
                        title: "Seven virtues against the capital sins",
                        detail:
                            "Learn how pride, avarice, envy, wrath, lust, gluttony, and sloth distort good desires—and how Catholic virtue heals and redirects them.",
                        courses: VirtueStudyCatalog.christianCourses,
                        identifier: "virtues-christian-courses"
                    )
                    courseCollection(
                        title: "The four cardinal virtues",
                        detail:
                            "Study the four hinges of moral life: prudent judgment, justice in relationship, courageous steadfastness, and temperate freedom.",
                        courses: VirtueStudyCatalog.cardinalCourses,
                        identifier: "virtues-cardinal-courses"
                    )
                    doctrinalMap
                    practiceCompanion
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.bottom, AppSpacing.section)
                .frame(maxWidth: 1120)
                .frame(maxWidth: .infinity)
            }
            .background(AppScreenBackground())
            .navigationTitle("Virtues")
        }
        .accessibilityIdentifier("virtues-root")
    }

    private var state: VirtueFormationState {
        _ = formationRecords.count
        return (try? VirtueFormationRepository(modelContext: modelContext).state()) ?? .empty
    }

    private var latestProgress: VirtueCourseProgress? {
        state.courseProgress
            .filter { VirtueStudyCatalog.lectureReadyCourseIDs.contains($0.courseID) }
            .max { $0.updatedAt < $1.updatedAt }
    }

    private var currentCycle: VirtueFocusCycle? {
        state.currentCycle
    }

    private var featuredCourse: VirtueStudyCourse {
        guard let latestProgress,
            let course = VirtueStudyCatalog.course(id: latestProgress.courseID)
        else {
            return VirtueStudyCatalog.foundationCourse
        }
        return course
    }

    private var featuredProgress: VirtueCourseProgress? {
        state.courseProgress.first { $0.courseID == featuredCourse.id }
    }

    private var featuredLesson: VirtueStudyLesson? {
        if let lastOpenedLessonID = featuredProgress?.lastOpenedLessonID,
            featuredProgress?.completedLessonIDs.contains(lastOpenedLessonID) == false,
            let lesson = featuredCourse.lessons.first(where: { $0.id == lastOpenedLessonID })
        {
            return lesson
        }
        return featuredCourse.lessons.first {
            featuredProgress?.completedLessonIDs.contains($0.id) != true
        } ?? featuredCourse.lessons.first
    }

    private var featuredFormation: some View {
        NavigationLink {
            VirtueCourseView(course: featuredCourse, openReading: openReading)
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    AppHeroArtwork()
                        .frame(height: 380)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .overlay {
                            LinearGradient(
                                colors: [.black.opacity(0.05), .black.opacity(0.20), .black.opacity(0.90)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }

                    VStack(alignment: .leading, spacing: 9) {
                        EditorialEyebrow("Virtue formation", inverse: true)
                        Text(featuredCourse.title)
                            .font(.system(size: 46, weight: .black, design: .serif))
                            .minimumScaleFactor(0.62)
                            .lineLimit(2)
                        Text(featuredCourse.subtitle.uppercased())
                            .font(.caption.weight(.bold))
                            .tracking(2.2)
                            .foregroundStyle(.white.opacity(0.82))
                            .lineLimit(3)
                    }
                    .foregroundStyle(.white)
                    .padding(AppSpacing.spacious)
                }

                VStack(alignment: .leading, spacing: AppSpacing.standard) {
                    HStack(spacing: 7) {
                        ForEach(featuredCourse.lessons.indices, id: \.self) { index in
                            Rectangle()
                                .fill(
                                    featuredProgress?.completedLessonIDs.contains(
                                        featuredCourse.lessons[index].id
                                    ) == true
                                        ? AppTheme.accent : AppTheme.elevatedSurface
                                )
                                .frame(height: 9)
                        }
                        Text(
                            "\(featuredProgress?.completedLessonCount(in: featuredCourse) ?? 0) / \(featuredCourse.lessons.count)"
                        )
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.supportingText)
                        .fixedSize()
                    }

                    if let featuredLesson {
                        EditorialEyebrow(featuredProgress == nil ? "Begin here" : "Continue learning")
                        Text(featuredLesson.title)
                            .font(.system(.title, design: .serif, weight: .bold))
                            .foregroundStyle(AppTheme.ink)
                        Text(featuredLesson.summary)
                            .foregroundStyle(AppTheme.supportingText)
                            .multilineTextAlignment(.leading)

                        HStack {
                            Label(
                                "Lesson \((featuredCourse.lessons.firstIndex(where: { $0.id == featuredLesson.id }) ?? 0) + 1)",
                                systemImage: "book.closed"
                            )
                            Spacer()
                            Label("Open course", systemImage: "arrow.right")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(AppTheme.accent)
                    }
                }
                .padding(AppSpacing.spacious)
                .background(AppTheme.surface)
                .overlay {
                    Rectangle().stroke(AppTheme.hairline, lineWidth: 1)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(
            featuredCourse.id == VirtueStudyCatalog.foundationCourse.id
                ? "virtue-foundation-course" : "virtue-featured-course"
        )
    }

    private var introduction: some View {
        ZStack(alignment: .bottomLeading) {
            AppHeroArtwork()
                .frame(height: 390)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [AppTheme.accent.opacity(0.10), AppTheme.accent.opacity(0.86)],
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                }

            VStack(alignment: .leading, spacing: 10) {
                EditorialEyebrow("Virtue formation", inverse: true)
                Text("BECOME\nMORE LIKE\nJESUS.")
                    .font(.system(size: 42, weight: .black, design: .serif))
                    .minimumScaleFactor(0.72)
                Text("Learn the good. Practice it with grace. Return to Christ when growth is difficult.")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.86))
                    .frame(maxWidth: 520, alignment: .leading)
            }
            .foregroundStyle(.white)
            .padding(AppSpacing.spacious)
        }
        .frame(minHeight: 390)
        .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var continueLearning: some View {
        if let latestProgress,
            let course = VirtueStudyCatalog.course(id: latestProgress.courseID)
        {
            NavigationLink {
                VirtueCourseView(course: course, openReading: openReading)
            } label: {
                FeatureCard {
                    HStack(spacing: 16) {
                        Image(systemName: "bookmark.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .background(AppTheme.accent, in: RoundedRectangle(cornerRadius: AppCornerRadius.control))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(latestProgress.isComplete(course) ? "Review your course" : "Continue learning")
                                .font(.caption.bold())
                                .foregroundStyle(AppTheme.accent)
                            Text(course.title)
                                .font(.title2.bold())
                            Text(
                                "\(latestProgress.completedLessonCount(in: course)) of \(course.lessons.count) lessons complete"
                            )
                            .foregroundStyle(AppTheme.supportingText)
                        }
                        Spacer(minLength: 8)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary)
                            .accessibilityHidden(true)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("virtue-continue-course")
        }
    }

    private var foundationCourse: some View {
        NavigationLink {
            VirtueCourseView(
                course: VirtueStudyCatalog.foundationCourse,
                openReading: openReading
            )
        } label: {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: AppCornerRadius.card)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.accent, .black],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                VStack(alignment: .leading, spacing: 10) {
                    Label("START HERE · FULL LECTURE COURSE", systemImage: "building.columns")
                        .font(.caption.bold())
                    Text(VirtueStudyCatalog.foundationCourse.title)
                        .font(.system(.title, design: .serif, weight: .bold))
                    Text(VirtueStudyCatalog.foundationCourse.overview)
                        .font(.body)
                    Label(
                        "\(VirtueStudyCatalog.foundationCourse.lessons.count) lessons · About \(VirtueStudyCatalog.foundationCourse.estimatedMinutes) min",
                        systemImage: "book.closed"
                    )
                    .font(.subheadline.bold())
                }
                .foregroundStyle(.white)
                .padding(AppSpacing.spacious)
            }
            .frame(minHeight: 250)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("virtue-foundation-course")
    }

    private var formationJourney: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("How this library works", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
                    .font(.headline)
                journeyRow(
                    number: 1,
                    title: "Begin with the foundation",
                    detail:
                        "Learn how freedom, habit, the cardinal virtues, grace, and imitation of Christ fit together."
                )
                journeyRow(
                    number: 2,
                    title: "Choose a learning track",
                    detail:
                        "Study a virtue against a capital sin, or deepen the cardinal virtues that guide every moral choice. Preview all ten lessons before beginning."
                )
                journeyRow(
                    number: 3,
                    title: "Carry it into life",
                    detail:
                        "Open Scripture and use an optional Focus Cycle only after the teaching gives the practice meaning."
                )
                Label(
                    "The Catechism and current universal-Church teaching govern the courses. Joseph Rickaby's 1908 work is used only as a historical guide to the cardinal virtues.",
                    systemImage: "checkmark.shield"
                )
                .font(.footnote)
                .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityIdentifier("virtues-formation-journey")
    }

    private var doctrinalMap: some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 10) {
                Label("One virtue, two ways of studying it", systemImage: "arrow.triangle.branch")
                    .font(.headline)
                Text(
                    "Temperance appears in both tracks because it is the same cardinal virtue viewed at two levels. “Temperance against Gluttony” applies it closely to appetite and consumption; the cardinal course studies its wider work across created goods and pleasure. It is not counted as a twelfth virtue."
                )
                .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityIdentifier("virtues-doctrinal-map")
    }

    private func courseCollection(
        title: String,
        detail: String,
        courses: [VirtueStudyCourse],
        identifier: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            EditorialSectionHeader(title, eyebrow: "Course library", detail: detail)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 260), spacing: AppSpacing.standard)],
                spacing: AppSpacing.standard
            ) {
                ForEach(courses) { course in
                    if VirtueStudyCatalog.isLectureReady(course) {
                        NavigationLink {
                            VirtueCourseView(course: course, openReading: openReading)
                        } label: {
                            courseCard(course, isReady: true)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier(courseIdentifier(course))
                    } else {
                        courseCard(course, isReady: false)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(course.title). Full lecture course in development.")
                            .accessibilityIdentifier("\(courseIdentifier(course))-in-development")
                    }
                }
            }
        }
        .accessibilityIdentifier(identifier)
    }

    private func courseCard(_ course: VirtueStudyCourse, isReady: Bool) -> some View {
        FeatureCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: course.systemImage)
                        .font(.title2)
                        .foregroundStyle(AppTheme.accent)
                        .frame(width: 46, height: 46)
                        .background(
                            AppTheme.elevatedSurface, in: RoundedRectangle(cornerRadius: AppCornerRadius.control))
                    Spacer()
                    courseStatus(course)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                Text(course.title)
                    .font(.title2.bold())
                Text(course.subtitle)
                    .foregroundStyle(AppTheme.supportingText)
                    .multilineTextAlignment(.leading)
                Label(
                    isReady
                        ? "\(course.lessons.count) full lessons"
                        : "Full lecture course in development",
                    systemImage: isReady ? "book.closed" : "hammer"
                )
                .font(.caption.bold())
                .foregroundStyle(isReady ? AppTheme.accent : AppTheme.warning)
            }
        }
        .opacity(isReady ? 1 : 0.76)
    }

    @ViewBuilder
    private func courseStatus(_ course: VirtueStudyCourse) -> some View {
        if let progress = state.courseProgress.first(where: { $0.courseID == course.id }) {
            if progress.isComplete(course) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.success)
                    .accessibilityLabel("Course lessons complete")
            } else {
                Text("\(progress.completedLessonCount(in: course))/\(course.lessons.count)")
                    .font(.caption.bold())
                    .foregroundStyle(AppTheme.accent)
                    .accessibilityLabel(
                        "\(progress.completedLessonCount(in: course)) of \(course.lessons.count) lessons complete"
                    )
            }
        }
    }

    private var practiceCompanion: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live what you learn")
                .font(AppTypography.sectionTitle)
            Text(
                "Study comes first. When you are ready, use these optional tools to repeat one concrete practice and reflect without scores or shame."
            )
            .foregroundStyle(AppTheme.supportingText)
            focusCycle
            continuingFormation
        }
        .accessibilityIdentifier("virtues-practice-companion")
    }

    private var focusCycle: some View {
        Group {
            if let cycle = currentCycle {
                NavigationLink {
                    VirtueActiveCycleView(cycleID: cycle.id)
                } label: {
                    FeatureCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Current Focus Cycle", systemImage: "scope")
                                .font(.headline)
                            Text(VirtueFoundationLibrary.pathway(for: cycle.virtueID)?.title ?? "Virtue")
                                .font(.title2.bold())
                            Text(cycle.practice.title)
                                .foregroundStyle(AppTheme.supportingText)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("virtue-current-cycle")
            } else {
                NavigationLink {
                    VirtueFocusCycleSetupView()
                } label: {
                    formationLink(
                        title: "Begin a Focus Cycle",
                        detail: "Repeat one owner-selected practice for one, two, or four weeks.",
                        systemImage: "scope"
                    )
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("virtue-start-cycle")
            }
        }
    }

    private var continuingFormation: some View {
        VStack(alignment: .leading, spacing: 10) {
            NavigationLink {
                VirtuePracticeLibraryView()
            } label: {
                formationLink(
                    title: "Practice Library",
                    detail: "Find a practice by life context and commitment.",
                    systemImage: "books.vertical"
                )
            }
            NavigationLink {
                VirtueThematicJourneysView()
            } label: {
                formationLink(
                    title: "Thematic Journeys",
                    detail: "Apply several virtues to work, relationships, digital life, service, or difficulty.",
                    systemImage: "map"
                )
            }
            NavigationLink {
                VirtueRuleOfLifeView()
            } label: {
                formationLink(
                    title: "My Rule of Life",
                    detail: "Keep and revise practices you deliberately choose.",
                    systemImage: "text.book.closed"
                )
            }
            NavigationLink {
                VirtueFormationRecordView()
            } label: {
                formationLink(
                    title: "Formation Record",
                    detail: "Review participation and reflections without a virtue score.",
                    systemImage: "clock.arrow.circlepath"
                )
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("virtues-continuing-formation")
    }

    private func formationLink(title: String, detail: String, systemImage: String) -> some View {
        FeatureCard {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(detail)
                        .foregroundStyle(AppTheme.supportingText)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
        }
    }

    private var privacyNote: some View {
        Label(
            "Lesson progress and formation records remain private. The app records what you studied and practiced; it never calculates holiness or infers a moral weakness.",
            systemImage: "lock.shield"
        )
        .font(.footnote)
        .foregroundStyle(AppTheme.supportingText)
        .accessibilityIdentifier("virtues-privacy-note")
    }

    private func courseIdentifier(_ course: VirtueStudyCourse) -> String {
        if let virtueID = course.virtueID, course.collection == .christian {
            return "virtue-pathway-\(virtueID.rawValue)"
        }
        return "virtue-course-card-\(course.id)"
    }

    private func journeyRow(number: Int, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(AppTheme.accent, in: Circle())
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .foregroundStyle(AppTheme.supportingText)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

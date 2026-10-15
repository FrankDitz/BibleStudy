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
                        trackNumber: "01",
                        detail:
                            "Learn how pride, avarice, envy, wrath, lust, gluttony, and sloth distort good desires—and how Catholic virtue heals and redirects them.",
                        courses: VirtueStudyCatalog.christianCourses,
                        identifier: "virtues-christian-courses"
                    )
                    courseCollection(
                        title: "The four cardinal virtues",
                        trackNumber: "02",
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
                    EditorialHeroArtwork(assetName: "VirtuesHero")
                        .frame(height: EditorialImageMetrics.virtueHeroHeight)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .overlay {
                            LinearGradient(
                                colors: [.black.opacity(0.05), .black.opacity(0.20), .black.opacity(0.90)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                        .overlay(alignment: .topTrailing) {
                            Label("Private progress", systemImage: "lock.fill")
                                .font(.caption2.weight(.bold))
                                .textCase(.uppercase)
                                .tracking(1.2)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                                .background(.black.opacity(0.72))
                                .padding(AppSpacing.standard)
                                .accessibilityIdentifier("virtues-privacy-note")
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
        VStack(alignment: .leading, spacing: AppSpacing.spacious) {
            VStack(alignment: .leading, spacing: 7) {
                EditorialEyebrow("Your formation path", inverse: true)
                Text("LEARN IT.\nPRACTICE IT.\nLIVE IT.")
                    .font(.system(size: 36, weight: .black, design: .serif))
                    .foregroundStyle(.white)
            }

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: AppSpacing.spacious) {
                    journeyRow(
                        number: 1,
                        title: "Build the foundation",
                        detail: "Understand freedom, habit, grace, and why virtue makes a person more free."
                    )
                    journeyRow(
                        number: 2,
                        title: "Choose a course",
                        detail: "Study a counter-virtue or deepen one of the four hinges of moral life."
                    )
                    journeyRow(
                        number: 3,
                        title: "Carry it into life",
                        detail: "Open Scripture, practice deliberately, and return for continued formation."
                    )
                }
                VStack(alignment: .leading, spacing: AppSpacing.spacious) {
                    journeyRow(
                        number: 1,
                        title: "Build the foundation",
                        detail: "Understand freedom, habit, grace, and why virtue makes a person more free."
                    )
                    journeyRow(
                        number: 2,
                        title: "Choose a course",
                        detail: "Study a counter-virtue or deepen one of the four hinges of moral life."
                    )
                    journeyRow(
                        number: 3,
                        title: "Carry it into life",
                        detail: "Open Scripture, practice deliberately, and return for continued formation."
                    )
                }
            }

            Rectangle().fill(.white.opacity(0.22)).frame(height: 1)
            Label(
                "The Catechism and current universal-Church teaching govern every course. Joseph Rickaby is used only as a historical guide to the cardinal virtues.",
                systemImage: "checkmark.shield"
            )
            .font(.footnote)
            .foregroundStyle(.white.opacity(0.72))
        }
        .padding(AppSpacing.spacious)
        .background(.black)
        .overlay(alignment: .leading) {
            Rectangle().fill(AppTheme.accent).frame(width: 5)
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
        trackNumber: String,
        detail: String,
        courses: [VirtueStudyCourse],
        identifier: String
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.standard) {
            HStack(alignment: .top, spacing: AppSpacing.standard) {
                Text(trackNumber)
                    .font(.system(size: 42, weight: .black, design: .serif))
                    .foregroundStyle(AppTheme.accent)
                    .accessibilityHidden(true)
                EditorialSectionHeader(title, eyebrow: "Course library", detail: detail)
            }

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 260), spacing: AppSpacing.standard)],
                spacing: AppSpacing.standard
            ) {
                ForEach(Array(courses.enumerated()), id: \.element.id) { index, course in
                    if VirtueStudyCatalog.isLectureReady(course) {
                        NavigationLink {
                            VirtueCourseView(course: course, openReading: openReading)
                        } label: {
                            courseCard(course, number: index + 1, isReady: true)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier(courseIdentifier(course))
                    } else {
                        courseCard(course, number: index + 1, isReady: false)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(course.title). Full lecture course in development.")
                            .accessibilityIdentifier("\(courseIdentifier(course))-in-development")
                    }
                }
            }
        }
        .accessibilityIdentifier(identifier)
    }

    private func courseCard(_ course: VirtueStudyCourse, number: Int, isReady: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(String(format: "%02d", number))
                    .font(.system(size: 38, weight: .black, design: .serif))
                    .foregroundStyle(AppTheme.accent)
                Spacer()
                courseStatus(course)
                Image(systemName: "arrow.up.right")
                    .foregroundStyle(AppTheme.accent)
                    .accessibilityHidden(true)
            }
            .padding(AppSpacing.standard)
            .background(AppTheme.elevatedSurface)

            VStack(alignment: .leading, spacing: 10) {
                EditorialEyebrow(isReady ? "Full lecture course" : "In development")
                Text(course.title)
                    .font(.system(.title2, design: .serif, weight: .bold))
                Text(course.subtitle)
                    .foregroundStyle(AppTheme.supportingText)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 4)
                HStack {
                    Label(
                        isReady
                            ? "\(course.lessons.count) lessons"
                            : "Course in development",
                        systemImage: isReady ? "book.closed" : "hammer"
                    )
                    Spacer()
                    Image(systemName: course.systemImage)
                }
                .font(.caption.bold())
                .foregroundStyle(isReady ? AppTheme.accent : AppTheme.warning)
            }
            .padding(AppSpacing.standard)
            .frame(maxWidth: .infinity, minHeight: 170, alignment: .topLeading)
            .background(AppTheme.surface)
        }
        .overlay { Rectangle().stroke(AppTheme.hairline, lineWidth: 1) }
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
    }

    private func courseIdentifier(_ course: VirtueStudyCourse) -> String {
        if let virtueID = course.virtueID, course.collection == .christian {
            return "virtue-pathway-\(virtueID.rawValue)"
        }
        return "virtue-course-card-\(course.id)"
    }

    private func journeyRow(number: Int, title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(format: "%02d", number))
                .font(.system(.title2, design: .serif, weight: .black))
                .foregroundStyle(AppTheme.accent)
                .accessibilityHidden(true)
            Rectangle().fill(.white.opacity(0.35)).frame(width: 36, height: 1)
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.68))
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .accessibilityElement(children: .combine)
    }
}

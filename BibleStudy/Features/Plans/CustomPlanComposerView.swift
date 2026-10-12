import SwiftUI

struct CustomPlanComposerView: View {
    @Environment(\.dismiss) private var dismiss

    let onActivate: (CustomReadingPlanPreview) -> Void

    @State private var title = "My reading plan"
    @State private var scopeChoice = ScopeChoice.catholicBible
    @State private var selectedBookIDs: Set<String> = []
    @State private var passageBookID = "JOHN"
    @State private var passageChapter = 1
    @State private var usesVerseRange = false
    @State private var passageVerseStart = 1
    @State private var passageVerseEnd = 1
    @State private var paceChoice = PaceChoice.finishBy
    @State private var chaptersPerReadingDay = 4
    @State private var startDate = Date()
    @State private var finishDate = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
    @State private var eligibleWeekdays = PlanWeekday.everyDay
    @State private var ordering = CustomPlanOrdering.canonical
    @State private var recoveryPreference = CustomPlanRecoveryPreference.keepDates
    @State private var reminderEnabled = false
    @State private var reminderDate =
        Calendar.current.date(
            bySettingHour: 7,
            minute: 0,
            second: 0,
            of: Date()
        ) ?? Date()

    private let calendar = Calendar.current

    init(onActivate: @escaping (CustomReadingPlanPreview) -> Void = { _ in }) {
        self.onActivate = onActivate
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    TextField("Plan name", text: $title)
                        .accessibilityIdentifier("custom-plan-title")
                    Picker("Reading scope", selection: $scopeChoice) {
                        ForEach(ScopeChoice.allCases) { choice in
                            Text(choice.title).tag(choice)
                        }
                    }
                    .accessibilityIdentifier("custom-plan-scope")

                    scopeControls
                }

                Section("Pace") {
                    Picker("Plan by", selection: $paceChoice) {
                        ForEach(PaceChoice.allCases) { choice in
                            Text(choice.title).tag(choice)
                        }
                    }
                    .pickerStyle(.segmented)

                    DatePicker("Start", selection: $startDate, displayedComponents: .date)
                    if paceChoice == .finishBy {
                        DatePicker(
                            "Finish",
                            selection: $finishDate,
                            in: startDate...,
                            displayedComponents: .date
                        )
                    } else {
                        Stepper(
                            "\(chaptersPerReadingDay) chapter\(chaptersPerReadingDay == 1 ? "" : "s") per reading day",
                            value: $chaptersPerReadingDay,
                            in: 1...50
                        )
                    }
                }

                Section("Reading days") {
                    WeekdaySelector(selection: $eligibleWeekdays)
                    if eligibleWeekdays.isEmpty {
                        Label("Choose at least one reading day.", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(AppTheme.danger)
                    } else if eligibleWeekdays.count < PlanWeekday.allCases.count {
                        Text("Unselected weekdays become rest days.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.supportingText)
                    }
                }

                Section("Reading order") {
                    Picker("Order", selection: $ordering) {
                        ForEach(CustomPlanOrdering.allCases, id: \.self) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    if ordering == .interleaveTestaments && !scopeIncludesBothTestaments {
                        Text("Interleaving requires a scope with both Testaments.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.danger)
                    }
                }

                Section("If I fall behind") {
                    Picker("Recovery", selection: $recoveryPreference) {
                        ForEach(CustomPlanRecoveryPreference.allCases, id: \.self) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    Text(recoveryPreference.explanation)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.supportingText)
                }

                Section("Reminder") {
                    Toggle("Daily reminder", isOn: $reminderEnabled)
                    if reminderEnabled {
                        DatePicker("Time", selection: $reminderDate, displayedComponents: .hourAndMinute)
                    }
                }

                Section("Workload preview") {
                    PreviewSummary(result: previewResult)
                        .accessibilityIdentifier("custom-plan-preview")
                }

                Section {
                    Button {
                        guard case .success(let preview) = previewResult else { return }
                        onActivate(preview)
                        dismiss()
                    } label: {
                        Label("Start This Plan", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.accent)
                    .disabled(!previewResult.isSuccess)
                    .accessibilityIdentifier("activate-custom-plan")
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Create a Plan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onChange(of: startDate) { _, newStartDate in
                if finishDate < newStartDate {
                    finishDate = newStartDate
                }
            }
            .onChange(of: passageBookID) { _, _ in
                passageChapter = min(passageChapter, passageChapterLimit)
            }
        }
        .frame(minWidth: 380, idealWidth: 620, minHeight: 600, idealHeight: 780)
    }

    @ViewBuilder
    private var scopeControls: some View {
        switch scopeChoice {
        case .selectedBooks:
            NavigationLink {
                BookSelectionView(selection: $selectedBookIDs)
            } label: {
                LabeledContent("Books", value: selectedBooksSummary)
            }
        case .passage:
            Picker("Book", selection: $passageBookID) {
                ForEach(CatholicCanon.books) { book in
                    Text(book.displayName).tag(book.osisID)
                }
            }
            Stepper("Chapter \(passageChapter)", value: $passageChapter, in: 1...passageChapterLimit)
            Toggle("Limit to verses", isOn: $usesVerseRange)
            if usesVerseRange {
                Stepper("First verse: \(passageVerseStart)", value: $passageVerseStart, in: 1...200)
                Stepper(
                    "Last verse: \(passageVerseEnd)",
                    value: $passageVerseEnd,
                    in: passageVerseStart...200
                )
            }
        case .catholicBible, .oldTestament, .newTestament:
            EmptyView()
        }
    }

    private var previewResult: Result<CustomReadingPlanPreview, ReadingPlanComposerError> {
        do {
            let scope = try makeScope()
            let reminder: PlanReminderTime?
            if reminderEnabled {
                let components = calendar.dateComponents([.hour, .minute], from: reminderDate)
                reminder = PlanReminderTime(
                    hour: components.hour ?? 7,
                    minute: components.minute ?? 0
                )
            } else {
                reminder = nil
            }
            let pace: CustomPlanPace =
                paceChoice == .finishBy
                ? .finishBy(PlanLocalDate(finishDate, calendar: calendar))
                : .chaptersPerReadingDay(chaptersPerReadingDay)
            let draft = CustomReadingPlanDraft(
                title: title,
                scope: scope,
                pace: pace,
                startDate: PlanLocalDate(startDate, calendar: calendar),
                eligibleWeekdays: eligibleWeekdays,
                ordering: ordering,
                recoveryPreference: recoveryPreference,
                reminderTime: reminder
            )
            return .success(try ReadingPlanComposer(calendar: calendar).preview(draft))
        } catch let error as ReadingPlanComposerError {
            return .failure(error)
        } catch {
            return .failure(.invalidSchedule)
        }
    }

    private func makeScope() throws -> CustomReadingPlanScope {
        switch scopeChoice {
        case .catholicBible:
            return .catholicBible
        case .oldTestament:
            return .testament(.old)
        case .newTestament:
            return .testament(.new)
        case .selectedBooks:
            return .books(selectedBookIDs)
        case .passage:
            let passage = try CustomPlanPassage(
                bookID: passageBookID,
                chapter: passageChapter,
                verseStart: usesVerseRange ? passageVerseStart : nil,
                verseEnd: usesVerseRange ? passageVerseEnd : nil
            )
            return .passage(passage)
        }
    }

    private var passageChapterLimit: Int {
        CatholicChapterManifest.cpdvV1.chapterCountByBookID[passageBookID] ?? 1
    }

    private var selectedBooksSummary: String {
        switch selectedBookIDs.count {
        case 0: return "Choose"
        case 1: return "1 selected"
        default: return "\(selectedBookIDs.count) selected"
        }
    }

    private var scopeIncludesBothTestaments: Bool {
        switch scopeChoice {
        case .catholicBible:
            return true
        case .selectedBooks:
            let testaments = Set(
                selectedBookIDs.compactMap { CatholicCanon.book(osisID: $0)?.testament }
            )
            return testaments == Set(BiblicalTestament.allCases)
        case .oldTestament, .newTestament, .passage:
            return false
        }
    }
}

private struct PreviewSummary: View {
    let result: Result<CustomReadingPlanPreview, ReadingPlanComposerError>

    var body: some View {
        switch result {
        case .success(let preview):
            VStack(alignment: .leading, spacing: 12) {
                Label("Schedule ready", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(AppTheme.success)
                HStack(alignment: .top, spacing: 24) {
                    metric("Reading days", "\(preview.readingDayCount)")
                    metric("Chapters", "\(preview.totalChapterCount)")
                    metric(
                        "Daily load",
                        chapterRange(preview)
                    )
                }
                HStack(alignment: .top, spacing: 24) {
                    metric("Finish", preview.scheduledFinishDate?.formatted ?? "—")
                    metric(
                        "Time",
                        "\(preview.estimatedDailyMinutes.lowerBound)–\(preview.estimatedDailyMinutes.upperBound) min"
                    )
                    metric("Rest days", "\(preview.restDayCount)")
                }
                if let warning = preview.warnings.first {
                    Label(warning.message, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(AppTheme.warning)
                }
            }
        case .failure(let error):
            Label(error.message, systemImage: "exclamationmark.circle.fill")
                .foregroundStyle(AppTheme.danger)
        }
    }

    private func metric(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.supportingText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func chapterRange(_ preview: CustomReadingPlanPreview) -> String {
        if preview.minimumDailyChapters == preview.maximumDailyChapters {
            return "\(preview.maximumDailyChapters)/day"
        }
        return "\(preview.minimumDailyChapters)–\(preview.maximumDailyChapters)/day"
    }
}

struct WeekdaySelector: View {
    @Binding var selection: Set<PlanWeekday>

    var body: some View {
        HStack(spacing: 8) {
            ForEach(PlanWeekday.allCases, id: \.self) { weekday in
                Button {
                    if selection.contains(weekday) {
                        selection.remove(weekday)
                    } else {
                        selection.insert(weekday)
                    }
                } label: {
                    Text(weekday.shortTitle)
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .foregroundStyle(selection.contains(weekday) ? Color.white : Color.primary)
                        .background(
                            selection.contains(weekday) ? AppTheme.accent : Color.secondary.opacity(0.14),
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(weekday.fullTitle)
                .accessibilityValue(selection.contains(weekday) ? "Selected" : "Not selected")
            }
        }
    }
}

private struct BookSelectionView: View {
    @Binding var selection: Set<String>

    var body: some View {
        List {
            bookSection("Old Testament", testament: .old)
            bookSection("New Testament", testament: .new)
        }
        .navigationTitle("Choose Books")
        .toolbar {
            Button(selection.count == CatholicCanon.books.count ? "Clear All" : "Select All") {
                if selection.count == CatholicCanon.books.count {
                    selection.removeAll()
                } else {
                    selection = Set(CatholicCanon.books.map(\.osisID))
                }
            }
        }
    }

    private func bookSection(_ title: String, testament: BiblicalTestament) -> some View {
        Section(title) {
            ForEach(CatholicCanon.books.filter { $0.testament == testament }) { book in
                Button {
                    if selection.contains(book.osisID) {
                        selection.remove(book.osisID)
                    } else {
                        selection.insert(book.osisID)
                    }
                } label: {
                    HStack {
                        Text(book.displayName)
                            .foregroundStyle(.primary)
                        Spacer()
                        if selection.contains(book.osisID) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(AppTheme.accent)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private enum ScopeChoice: String, CaseIterable, Identifiable {
    case catholicBible
    case oldTestament
    case newTestament
    case selectedBooks
    case passage

    var id: Self { self }

    var title: String {
        switch self {
        case .catholicBible: return "Catholic Bible"
        case .oldTestament: return "Old Testament"
        case .newTestament: return "New Testament"
        case .selectedBooks: return "Selected books"
        case .passage: return "Single passage"
        }
    }
}

private enum PaceChoice: String, CaseIterable, Identifiable {
    case finishBy
    case chaptersPerDay

    var id: Self { self }

    var title: String {
        switch self {
        case .finishBy: return "Finish by"
        case .chaptersPerDay: return "Chapters/day"
        }
    }
}

extension PlanLocalDate {
    fileprivate var formatted: String {
        String(format: "%d/%d/%d", month, day, year)
    }
}

extension PlanWeekday {
    var shortTitle: String {
        switch self {
        case .sunday: return "S"
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "T"
        case .friday: return "F"
        case .saturday: return "S"
        }
    }

    var fullTitle: String {
        Calendar.current.weekdaySymbols[rawValue - 1]
    }
}

extension CustomPlanOrdering {
    fileprivate var title: String {
        switch self {
        case .canonical: return "Canonical order"
        case .interleaveTestaments: return "Interleave Testaments"
        }
    }
}

extension CustomPlanRecoveryPreference {
    fileprivate var title: String {
        switch self {
        case .keepDates: return "Keep dates"
        case .shiftForward: return "Shift forward"
        case .redistribute: return "Redistribute"
        case .chooseNewFinishDate: return "Choose a new finish date"
        }
    }

    fileprivate var explanation: String {
        switch self {
        case .keepDates:
            return "Keep the original schedule and show overdue readings."
        case .shiftForward:
            return "Move unfinished readings forward without changing their order."
        case .redistribute:
            return "Rebalance unfinished readings across the remaining schedule."
        case .chooseNewFinishDate:
            return "Ask for a new goal date before rebuilding the remaining schedule."
        }
    }
}

extension CustomPlanPreviewWarning {
    fileprivate var message: String {
        switch self {
        case .demandingDailyLoad(let maximumChapters):
            return "This schedule reaches \(maximumChapters) chapters on its busiest reading day."
        }
    }
}

extension ReadingPlanComposerError {
    fileprivate var message: String {
        switch self {
        case .blankTitle: return "Give the plan a name."
        case .titleTooLong: return "Keep the plan name to 80 characters or fewer."
        case .emptyScope: return "Choose at least one book."
        case .invalidScopeBook: return "One of the selected books is not in the Catholic canon."
        case .passageOutsideManifest: return "That passage is not available in the supported Catholic edition."
        case .emptyEligibleWeekdays: return "Choose at least one reading day."
        case .invalidChapterPace: return "Choose between 1 and 50 chapters per reading day."
        case .finishDateBeforeStartDate: return "The finish date must be on or after the start date."
        case .invalidReminderTime: return "Choose a valid reminder time."
        case .interleavingRequiresBothTestaments:
            return "Interleaving requires readings from both the Old and New Testaments."
        case .noEligibleDates: return "No selected reading day occurs in this date range."
        case .invalidSchedule: return "This schedule could not be created. Try adjusting the dates or pace."
        }
    }
}

extension Result where Success == CustomReadingPlanPreview, Failure == ReadingPlanComposerError {
    fileprivate var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}

import SwiftData
import SwiftUI
import YouVersionPlatform

struct YouVersionBibleReaderView: View {
    let navigation: ScriptureNavigationController
    let approvedVersionIDs: Set<Int>

    @State private var editions: [Int: YouVersionReaderEdition] = [:]
    @State private var location: YouVersionReaderLocation?
    @State private var loadError: String?
    @State private var isBookPickerPresented = false
    @State private var isControlsPresented = false
    @State private var selectedVerse: SelectedVerse?
    @State private var footnotes: [BibleFootnote] = []
    @AppStorage("reader-theme") private var readerTheme = ReaderTheme.light
    @AppStorage("reader-text-scale") private var readerTextScale = 1.0
    @ScaledMetric(relativeTo: .body) private var baseTextSize = 18.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if approvedVersionIDs.isEmpty {
                AppStateView(
                    AppStateDescriptor(
                        kind: .rightsLocked,
                        title: "No approved Bible edition",
                        message: "The reader will remain closed until a licensed Catholic edition passes its audit.",
                        icon: "book.closed"
                    )
                )
            } else if let loadError {
                AppStateView(
                    AppStateDescriptor(
                        kind: .error,
                        title: "Reader unavailable",
                        message: loadError,
                        icon: "wifi.exclamationmark"
                    ),
                    actionTitle: "Try again"
                ) {
                    Task { await loadReader(force: true) }
                }
            } else if let location, let edition = editions[location.versionID] {
                reader(location: location, edition: edition)
            } else {
                AppStateView(
                    AppStateDescriptor(
                        kind: .loading,
                        title: "Opening Scripture",
                        message: "Loading the approved Catholic edition and your last reading position.",
                        icon: "book"
                    )
                )
            }
        }
        .task {
            synchronizeHighlights()
            await loadReader()
        }
        .task(id: navigation.request?.id) {
            guard let reference = navigation.request?.reference else { return }
            open(reference)
        }
        .sheet(isPresented: $isBookPickerPresented) {
            if let location, let edition = editions[location.versionID] {
                YouVersionBookChapterPicker(
                    edition: edition,
                    currentLocation: location
                ) { selectedLocation in
                    move(to: selectedLocation)
                }
            }
        }
        .sheet(isPresented: $isControlsPresented) {
            ReaderControlsView(theme: $readerTheme, textScale: $readerTextScale)
        }
        .sheet(item: $selectedVerse) { selection in
            VerseActionsView(
                selection: selection,
                onHighlightChanged: synchronizeHighlights
            )
        }
        .sheet(isPresented: footnotesPresented) {
            NavigationStack {
                List(footnotes) { footnote in
                    Text(footnote.text.asAttributedString)
                }
                .navigationTitle("Footnotes")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { footnotes = [] }
                    }
                }
            }
            .frame(minWidth: 340, minHeight: 260)
        }
    }

    private func reader(
        location: YouVersionReaderLocation,
        edition: YouVersionReaderEdition
    ) -> some View {
        VStack(spacing: 0) {
            readerHeader(location: location, edition: edition)
            Divider()

            ScrollViewReader { proxy in
                ScrollView {
                    BibleTextView(
                        location.providerReference,
                        textOptions: textOptions,
                        onVerseTap: handleVerseTap
                    )
                    .id(location.id)
                    .frame(maxWidth: 760, alignment: .leading)
                    .padding(.horizontal, AppSpacing.standard)
                    .padding(.vertical, AppSpacing.compact)
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: location.id) {
                    proxy.scrollTo(location.id, anchor: .top)
                }
            }

            Divider()
            readerFooter(location: location, edition: edition)
        }
        .background(readerTheme.backgroundColor)
        .foregroundStyle(readerTheme.textColor)
        .preferredColorScheme(readerTheme.preferredColorScheme)
    }

    private func readerHeader(
        location: YouVersionReaderLocation,
        edition: YouVersionReaderEdition
    ) -> some View {
        HStack(spacing: AppSpacing.compact) {
            Button {
                isBookPickerPresented = true
            } label: {
                Label(locationTitle(location, in: edition), systemImage: "book")
            }
            .buttonStyle(.bordered)
            .accessibilityHint("Choose a book and chapter")

            if editions.count > 1 {
                Menu(edition.abbreviation) {
                    ForEach(editions.values.sorted(by: { $0.id < $1.id })) { option in
                        Button(option.title) {
                            switchEdition(to: option)
                        }
                    }
                }
                .accessibilityLabel("Bible edition, \(edition.title)")
            } else {
                Text(edition.abbreviation)
                    .font(.subheadline.weight(.semibold))
                    .accessibilityLabel("Bible edition, \(edition.title)")
            }

            Spacer()

            Button("Reader settings", systemImage: "textformat.size") {
                isControlsPresented = true
            }
            .labelStyle(.iconOnly)
            .accessibilityHint("Change text size and reader theme")
        }
        .padding(.horizontal, AppSpacing.compact)
        .padding(.vertical, 8)
    }

    private func readerFooter(
        location: YouVersionReaderLocation,
        edition: YouVersionReaderEdition
    ) -> some View {
        HStack {
            Button("Previous chapter", systemImage: "chevron.left") {
                move(direction: -1, from: location, in: edition)
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.bordered)
            .disabled(
                YouVersionReaderNavigator.adjacentLocation(
                    to: location,
                    direction: -1,
                    in: edition
                ) == nil
            )
            .keyboardShortcut("[", modifiers: .command)

            Spacer()
            Text(chapterProgress(location, in: edition))
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityLabel(chapterProgressAccessibilityLabel(location, in: edition))
            Spacer()

            Button("Next chapter", systemImage: "chevron.right") {
                move(direction: 1, from: location, in: edition)
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.bordered)
            .disabled(
                YouVersionReaderNavigator.adjacentLocation(
                    to: location,
                    direction: 1,
                    in: edition
                ) == nil
            )
            .keyboardShortcut("]", modifiers: .command)
        }
        .padding(.horizontal, AppSpacing.standard)
        .padding(.vertical, 8)
        .background(.bar)
    }

    private var textOptions: BibleTextOptions {
        BibleTextOptions(
            fontFamily: "Georgia",
            fontSize: baseTextSize * readerTextScale,
            lineSpacing: 0.4,
            paragraphSpacing: 4,
            textColor: readerTheme.textColor,
            verseNumberColor: readerTheme.textColor.opacity(0.65),
            wordsOfChristColor: readerTheme == .dark
                ? Color(red: 1, green: 0.42, blue: 0.46) : Color(red: 0.78, green: 0.12, blue: 0.18),
            footnoteMode: .image,
            verseSelectionStyle: .solid
        )
    }

    private var footnotesPresented: Binding<Bool> {
        Binding(
            get: { !footnotes.isEmpty },
            set: { if !$0 { footnotes = [] } }
        )
    }

    @MainActor
    private func loadReader(force: Bool = false) async {
        guard editions.isEmpty || force else { return }
        loadError = nil

        do {
            var loaded: [Int: YouVersionReaderEdition] = [:]
            for versionID in approvedVersionIDs.sorted() {
                let version = try await BibleVersionRepository.shared.version(withId: versionID)
                if let edition = YouVersionReaderEdition(version: version) {
                    loaded[versionID] = edition
                }
            }
            guard !loaded.isEmpty else {
                loadError = "No approved edition returned readable book and chapter metadata."
                return
            }
            editions = loaded

            let requested = navigation.request?.reference
            let restored = try ReadingPositionRepository(modelContext: modelContext)
                .restoredReference(
                    provider: .youVersion,
                    approvedVersionIDs: approvedVersionIDs
                )
            let fallback = Self.approvedReference(
                YouVersionCatalogPolicy.developmentStart,
                approvedVersionIDs: approvedVersionIDs
            )

            for candidate in [requested, restored, fallback].compactMap({ $0 }) {
                if let candidateLocation = location(for: candidate, in: loaded) {
                    move(to: candidateLocation)
                    return
                }
            }

            if let firstEdition = preferredEdition(in: loaded),
                let firstLocation = firstEdition.firstLocation
            {
                move(to: firstLocation)
            } else {
                loadError = "The approved edition does not contain a readable Catholic canon."
            }
        } catch {
            loadError = "Bible Study could not load the approved edition. Check your connection and try again."
        }
    }

    private func open(_ reference: ScriptureReference) {
        guard !editions.isEmpty else { return }
        let approved = Self.approvedReference(reference, approvedVersionIDs: approvedVersionIDs)
        guard let approved, let newLocation = location(for: approved, in: editions) else {
            return
        }
        move(to: newLocation)
    }

    private func move(
        direction: Int,
        from location: YouVersionReaderLocation,
        in edition: YouVersionReaderEdition
    ) {
        guard
            let adjacent = YouVersionReaderNavigator.adjacentLocation(
                to: location,
                direction: direction,
                in: edition
            )
        else {
            return
        }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
            move(to: adjacent)
        }
    }

    private func move(to newLocation: YouVersionReaderLocation) {
        location = newLocation
        guard let reference = newLocation.canonicalReference else { return }
        do {
            try ReadingPositionRepository(modelContext: modelContext).save(
                reference,
                provider: .youVersion
            )
        } catch {
            assertionFailure("Unable to save reading position: \(error)")
        }
    }

    private func switchEdition(to edition: YouVersionReaderEdition) {
        guard let current = location else { return }
        let reference = try? ScriptureReference(
            versionID: edition.id,
            bookID: current.canonicalBookID,
            chapter: current.chapter,
            verseStart: current.verse
        )
        if let reference, let matched = edition.location(matching: reference) {
            move(to: matched)
        } else if let first = edition.firstLocation {
            move(to: first)
        }
    }

    private func location(
        for reference: ScriptureReference,
        in editions: [Int: YouVersionReaderEdition]
    ) -> YouVersionReaderLocation? {
        editions[reference.versionID]?.location(matching: reference)
    }

    private func preferredEdition(
        in editions: [Int: YouVersionReaderEdition]
    ) -> YouVersionReaderEdition? {
        guard
            let versionID = YouVersionCatalogPolicy.preferredApprovedVersionID(
                in: Set(editions.keys)
            )
        else {
            return nil
        }
        return editions[versionID]
    }

    private func locationTitle(
        _ location: YouVersionReaderLocation,
        in edition: YouVersionReaderEdition
    ) -> String {
        let book = edition.books.first { $0.providerID == location.providerBookID }
        return "\(book?.title ?? location.providerBookID) \(location.chapter)"
    }

    private func chapterProgress(
        _ location: YouVersionReaderLocation,
        in edition: YouVersionReaderEdition
    ) -> String {
        guard
            let bookIndex = edition.books.firstIndex(where: {
                $0.providerID == location.providerBookID
            }),
            let chapterIndex = edition.books[bookIndex].chapters.firstIndex(of: location.chapter)
        else {
            return locationTitle(location, in: edition)
        }
        return
            "Book \(bookIndex + 1) of \(edition.books.count) · Chapter \(chapterIndex + 1) of \(edition.books[bookIndex].chapters.count)"
    }

    private func chapterProgressAccessibilityLabel(
        _ location: YouVersionReaderLocation,
        in edition: YouVersionReaderEdition
    ) -> String {
        "\(locationTitle(location, in: edition)). \(chapterProgress(location, in: edition))"
    }

    private func handleVerseTap(
        _ reference: BibleReference,
        actionType: String,
        footnotes: [BibleFootnote],
        footnoteID: String?
    ) {
        if actionType == BibleVersionRendering.LinkSchemes.footnote.rawValue {
            if let footnoteID,
                let selectedFootnote = footnotes.first(where: { $0.id == footnoteID })
            {
                self.footnotes = [selectedFootnote]
            } else {
                self.footnotes = footnotes
            }
            return
        }

        guard let canonicalReference = reference.canonicalReference else { return }
        selectedVerse = SelectedVerse(
            providerReference: reference,
            canonicalReference: canonicalReference
        )
    }

    static func approvedReference(
        _ reference: ScriptureReference,
        approvedVersionIDs: Set<Int>
    ) -> ScriptureReference? {
        if approvedVersionIDs.contains(reference.versionID) {
            return reference
        }
        guard
            let fallbackVersionID = YouVersionCatalogPolicy.preferredApprovedVersionID(
                in: approvedVersionIDs
            )
        else {
            return nil
        }
        return try? ScriptureReference(
            versionID: fallbackVersionID,
            bookID: reference.bookID,
            chapter: reference.chapter,
            verseStart: reference.verseStart,
            verseEnd: reference.verseEnd
        )
    }

    private func synchronizeHighlights() {
        do {
            let repository = ScriptureAnnotationRepository(modelContext: modelContext)
            let snapshots = try repository.activeHighlights()
            YouVersionLocalHighlightBridge().replaceCachedHighlights(with: snapshots)
        } catch {
            assertionFailure("Unable to render locally stored highlights: \(error)")
        }
    }
}

private struct YouVersionBookChapterPicker: View {
    let edition: YouVersionReaderEdition
    let currentLocation: YouVersionReaderLocation
    let onSelection: (YouVersionReaderLocation) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(edition.books) { book in
                NavigationLink {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 52), spacing: 8)],
                            spacing: 8
                        ) {
                            ForEach(book.chapters, id: \.self) { chapter in
                                Button(String(chapter)) {
                                    onSelection(
                                        YouVersionReaderNavigator.location(
                                            editionID: edition.id,
                                            book: book,
                                            chapter: chapter
                                        )
                                    )
                                    dismiss()
                                }
                                .buttonStyle(.bordered)
                                .accessibilityLabel("\(book.title), chapter \(chapter)")
                                .accessibilityAddTraits(
                                    currentLocation.providerBookID == book.providerID
                                        && currentLocation.chapter == chapter ? .isSelected : []
                                )
                            }
                        }
                        .padding()
                    }
                    .navigationTitle(book.title)
                } label: {
                    HStack {
                        Text(book.title)
                        Spacer()
                        if currentLocation.providerBookID == book.providerID {
                            Text("Chapter \(currentLocation.chapter)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Choose a passage")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .frame(minWidth: 420, minHeight: 560)
    }
}

private struct ReaderControlsView: View {
    @Binding var theme: ReaderTheme
    @Binding var textScale: Double

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Text size") {
                    Slider(value: $textScale, in: 0.85...1.7, step: 0.05) {
                        Text("Reader text size")
                    } minimumValueLabel: {
                        Image(systemName: "textformat.size.smaller")
                    } maximumValueLabel: {
                        Image(systemName: "textformat.size.larger")
                    }
                    .accessibilityLabel("Reader text size")
                    .accessibilityValue("\(Int(textScale * 100)) percent")
                    Text("In the beginning was the Word")
                        .font(.system(size: 18 * textScale, design: .serif))
                }

                Section("Theme") {
                    Picker("Reader theme", selection: $theme) {
                        ForEach(ReaderTheme.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Reader settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .frame(minWidth: 340, minHeight: 280)
    }
}

private struct SelectedVerse: Identifiable {
    let providerReference: BibleReference
    let canonicalReference: ScriptureReference

    var id: String { providerReference.debugDescription }
}

private struct VerseActionsView: View {
    let selection: SelectedVerse
    let onHighlightChanged: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var annotationState = ScriptureAnnotationState.empty
    @State private var noteDraft = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Highlight") {
                    HStack(spacing: 16) {
                        ForEach(ScriptureHighlightColor.allCases) { color in
                            Button {
                                updateHighlight(color)
                            } label: {
                                Image(
                                    systemName: annotationState.highlightColor == color
                                        ? "circle.inset.filled" : "circle.fill"
                                )
                                .font(.title2)
                                .foregroundStyle(swiftUIColor(for: color))
                                .accessibilityLabel("\(color.displayName) highlight")
                                .accessibilityAddTraits(annotationState.highlightColor == color ? .isSelected : [])
                            }
                            .buttonStyle(.plain)
                        }

                        if annotationState.highlightColor != nil {
                            Button("Remove", role: .destructive) {
                                updateHighlight(nil)
                            }
                        }
                    }
                }

                Section("Private note") {
                    TextEditor(text: $noteDraft)
                        .frame(minHeight: 96)
                        .accessibilityIdentifier("reader-note-editor")

                    Button("Save note") {
                        saveNote()
                    }
                    .disabled(
                        noteDraft.trimmingCharacters(in: .whitespacesAndNewlines)
                            == annotationState.noteText
                    )
                }

                Section {
                    Button {
                        toggleBookmark()
                    } label: {
                        Label(
                            annotationState.isBookmarked ? "Remove bookmark" : "Bookmark verse",
                            systemImage: annotationState.isBookmarked ? "bookmark.fill" : "bookmark"
                        )
                    }
                } footer: {
                    Text("These actions will be stored privately by Bible Study, not in a YouVersion account.")
                }
            }
            .navigationTitle(selection.providerReference.passageId)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .frame(minWidth: 340, minHeight: 300)
        .task {
            loadState()
        }
        .alert("Couldn’t save annotation", isPresented: errorIsPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Please try again.")
        }
    }

    private var repository: ScriptureAnnotationRepository {
        ScriptureAnnotationRepository(modelContext: modelContext)
    }

    private var errorIsPresented: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    errorMessage = nil
                }
            }
        )
    }

    private func loadState() {
        performRepositoryAction {
            annotationState = try repository.state(for: selection.canonicalReference)
            noteDraft = annotationState.noteText
        }
    }

    private func updateHighlight(_ color: ScriptureHighlightColor?) {
        performRepositoryAction {
            try repository.setHighlight(color, for: selection.canonicalReference)
            annotationState = try repository.state(for: selection.canonicalReference)
            onHighlightChanged()
        }
    }

    private func saveNote() {
        performRepositoryAction {
            try repository.saveNote(noteDraft, for: selection.canonicalReference)
            annotationState = try repository.state(for: selection.canonicalReference)
            noteDraft = annotationState.noteText
        }
    }

    private func toggleBookmark() {
        performRepositoryAction {
            annotationState.isBookmarked = try repository.toggleBookmark(
                for: selection.canonicalReference
            )
        }
    }

    private func performRepositoryAction(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            errorMessage = String(describing: error)
        }
    }

    private func swiftUIColor(for color: ScriptureHighlightColor) -> Color {
        switch color {
        case .gold: .yellow
        case .blue: .blue
        case .green: .green
        case .rose: .pink
        }
    }
}

extension BibleReference {
    var canonicalReference: ScriptureReference? {
        guard let canonicalBookID = YouVersionCatholicBookMapping.canonicalID(forProviderID: bookId) else {
            return nil
        }

        return try? ScriptureReference(
            versionID: versionId,
            bookID: canonicalBookID,
            chapter: chapter,
            verseStart: verseStart,
            verseEnd: verseEnd
        )
    }
}

extension ScriptureReference {
    var youVersionReference: BibleReference {
        let providerBookID =
            YouVersionCatholicBookMapping
            .primaryProviderID(forCanonicalID: bookID) ?? bookID

        if let verseStart, let verseEnd, verseStart != verseEnd {
            return BibleReference(
                versionId: versionID,
                bookId: providerBookID,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd
            )
        }

        return BibleReference(
            versionId: versionID,
            bookId: providerBookID,
            chapter: chapter,
            verse: verseStart
        )
    }
}

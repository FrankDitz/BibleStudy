import SwiftData
import SwiftUI
import YouVersionPlatform

struct YouVersionBibleReaderView: View {
    let navigation: ScriptureNavigationController
    let approvedVersionIDs: Set<Int>

    @State private var readerNavigation = BibleReaderNavigation()
    @State private var selectedVerse: SelectedVerse?
    @Environment(\.modelContext) private var modelContext

    @ViewBuilder
    var body: some View {
        if let initialReference {
            BibleReaderView(
                reference: initialReference.youVersionReference,
                verseSelectionStyle: .solid,
                onVerseTap: { reference in
                    if let canonicalReference = reference.canonicalReference {
                        selectedVerse = SelectedVerse(
                            providerReference: reference,
                            canonicalReference: canonicalReference
                        )
                    }
                },
                showsFullChapter: true,
                readerNavigation: readerNavigation
            )
            .task(id: navigation.request?.id) {
                synchronizeHighlights()
                guard let reference = navigation.request?.reference else { return }
                guard let approvedReference = approvedReference(for: reference) else { return }
                readerNavigation.request(
                    approvedReference.youVersionReference,
                    showsFullChapter: true
                )
            }
            .sheet(item: $selectedVerse) { selection in
                VerseActionsView(
                    selection: selection,
                    onHighlightChanged: synchronizeHighlights
                )
            }
        } else {
            AppStateView(
                AppStateDescriptor(
                    kind: .rightsLocked,
                    title: "No approved Bible edition",
                    message: "The reader will remain closed until a licensed Catholic edition passes its audit.",
                    icon: "book.closed"
                )
            )
        }
    }

    private var initialReference: ScriptureReference? {
        Self.approvedReference(
            navigation.request?.reference ?? YouVersionCatalogPolicy.developmentStart,
            approvedVersionIDs: approvedVersionIDs
        )
    }

    private func approvedReference(for reference: ScriptureReference) -> ScriptureReference? {
        Self.approvedReference(reference, approvedVersionIDs: approvedVersionIDs)
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

import SwiftUI
import YouVersionPlatform

struct YouVersionBibleReaderView: View {
    let navigation: ScriptureNavigationController

    @State private var readerNavigation = BibleReaderNavigation()
    @State private var selectedVerse: SelectedVerse?

    var body: some View {
        BibleReaderView.restoringLastPassage(
            verseSelectionStyle: .solid,
            onVerseTap: { reference in
                selectedVerse = SelectedVerse(reference: reference)
            },
            readerNavigation: readerNavigation
        )
        .task(id: navigation.request?.id) {
            guard let reference = navigation.request?.reference else { return }
            readerNavigation.request(reference.youVersionReference, showsFullChapter: true)
        }
        .sheet(item: $selectedVerse) { selection in
            VerseActionsView(selection: selection)
        }
    }
}

private struct SelectedVerse: Identifiable {
    let reference: BibleReference

    var id: String { reference.debugDescription }
}

private struct VerseActionsView: View {
    let selection: SelectedVerse

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("Highlight", systemImage: "highlighter")
                    Label("Add a note", systemImage: "note.text.badge.plus")
                    Label("Bookmark", systemImage: "bookmark")
                } footer: {
                    Text("These actions will be stored privately by Bible Study, not in a YouVersion account.")
                }
            }
            .navigationTitle(selection.reference.passageId)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .frame(minWidth: 340, minHeight: 300)
    }
}

private extension ScriptureReference {
    var youVersionReference: BibleReference {
        let providerBookID = YouVersionCatholicBookMapping
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

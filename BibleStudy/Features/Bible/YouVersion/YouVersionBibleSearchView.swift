import SwiftUI
import YouVersionPlatform

struct YouVersionBibleSearchView: View {
    let provider: any ScriptureSearchProvider
    let versionID: Int
    let navigation: ScriptureNavigationController

    @Environment(\.dismiss) private var dismiss

    @State private var query = ""
    @State private var intent = ScriptureSearchIntent.text
    @State private var references: [ScriptureReference] = []
    @State private var suggestions: [String] = []
    @State private var searchedInsteadFor: String?
    @State private var nextPageToken: String?
    @State private var isSearching = false
    @State private var hasSearched = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchControls
                Divider()

                Group {
                    if isSearching && references.isEmpty {
                        ProgressView("Searching Scripture…")
                    } else if let errorMessage, references.isEmpty {
                        ContentUnavailableView(
                            "Search unavailable",
                            systemImage: "exclamationmark.magnifyingglass",
                            description: Text(errorMessage)
                        )
                    } else if hasSearched && references.isEmpty {
                        ContentUnavailableView {
                            Label("No results", systemImage: "magnifyingglass")
                        } description: {
                            Text("Try another phrase, reference, or search type.")
                        } actions: {
                            ForEach(suggestions.prefix(3), id: \.self) { suggestion in
                                Button("Search for “\(suggestion)”") {
                                    query = suggestion
                                    runSearch(reset: true)
                                }
                            }
                        }
                    } else if references.isEmpty {
                        ContentUnavailableView(
                            "Search Scripture",
                            systemImage: "text.magnifyingglass",
                            description: Text("Find a reference, words from a verse, or a topic.")
                        )
                    } else {
                        resultsList
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Bible Search")
            .searchable(text: $query, prompt: "Reference, text, or topic")
            .searchSuggestions {
                ForEach(suggestions, id: \.self) { suggestion in
                    Text(suggestion).searchCompletion(suggestion)
                }
            }
            .onSubmit(of: .search) {
                runSearch(reset: true)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        #if os(macOS)
            .frame(minWidth: 640, minHeight: 720)
        #endif
    }

    private var searchControls: some View {
        HStack {
            Picker("Search type", selection: $intent) {
                ForEach(ScriptureSearchIntent.allCases) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .pickerStyle(.segmented)

            Button("Search", systemImage: "magnifyingglass") {
                runSearch(reset: true)
            }
            .buttonStyle(EmeraldActionButtonStyle())
            .disabled(
                query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    || isSearching
            )
        }
        .padding(AppSpacing.compact)
    }

    private var resultsList: some View {
        List {
            if let searchedInsteadFor {
                Section {
                    Text("Results were corrected to “\(searchedInsteadFor)”.")
                } header: {
                    Text("Showing corrected results")
                }
            }

            if !suggestions.isEmpty {
                Section("Did you mean?") {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button(suggestion) {
                            query = suggestion
                            runSearch(reset: true)
                        }
                    }
                }
            }

            Section("Results") {
                ForEach(references, id: \.self) { reference in
                    VStack(spacing: AppSpacing.compact) {
                        BibleCardView(
                            reference: reference.youVersionReference,
                            fontSize: 18
                        )
                        .accessibilityIdentifier("scripture-search-result-card")

                        Button("Open in reader") {
                            navigation.open(reference)
                            dismiss()
                        }
                        .buttonStyle(EmeraldActionButtonStyle())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, AppSpacing.compact)
                }

                if nextPageToken != nil {
                    Button {
                        runSearch(reset: false)
                    } label: {
                        if isSearching {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Load more")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(isSearching)
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.secondary)
                    Button("Try again") {
                        runSearch(reset: nextPageToken == nil)
                    }
                } header: {
                    Text("Couldn’t load results")
                }
            }

            if let notice = YouVersionCatalogPolicy.approvedEditionNotice(for: [versionID]) {
                Section("Edition") {
                    Text(notice)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func runSearch(reset: Bool) {
        guard !isSearching else { return }
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }

        isSearching = true
        errorMessage = nil
        let pageToken = reset ? nil : nextPageToken
        if reset {
            references = []
            suggestions = []
            searchedInsteadFor = nil
            nextPageToken = nil
            hasSearched = false
        }

        Task {
            do {
                let page = try await provider.search(
                    ScriptureSearchRequest(
                        query: trimmedQuery,
                        versionID: versionID,
                        intent: intent,
                        pageToken: pageToken
                    )
                )
                references.append(contentsOf: page.references)
                suggestions = page.spellingSuggestions
                searchedInsteadFor = page.searchedInsteadFor
                nextPageToken = page.nextPageToken
            } catch {
                errorMessage = message(for: error)
            }
            hasSearched = true
            isSearching = false
        }
    }

    private func message(for error: Error) -> String {
        guard let failure = error as? ScriptureProviderFailure else {
            return "Search couldn’t complete. Please try again."
        }

        switch failure {
        case .invalidRequest:
            return "Enter between 1 and 100 characters."
        case .offline:
            return "Check your internet connection and try again."
        case .rateLimited(let retryAfter):
            if let retryAfter {
                return "Search is busy. Try again in about \(Int(retryAfter)) seconds."
            }
            return "Search is busy. Please try again shortly."
        case .unauthorized, .notConfigured, .unlicensed:
            return "This Bible edition is not available to the configured App Key."
        case .invalidResponse, .unavailable:
            return "Search couldn’t complete. Please try again."
        }
    }
}

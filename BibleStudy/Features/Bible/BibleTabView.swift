import SwiftUI

struct BibleTabView: View {
    let configuration: AppConfiguration
    let navigation: ScriptureNavigationController
    let catalogApproval: YouVersionCatalogApproval
    let returnTitle: String?
    let onReturn: (() -> Void)?

    @State private var isSearchPresented = false

    init(
        configuration: AppConfiguration,
        navigation: ScriptureNavigationController,
        catalogApproval: YouVersionCatalogApproval,
        returnTitle: String? = nil,
        onReturn: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.navigation = navigation
        self.catalogApproval = catalogApproval
        self.returnTitle = returnTitle
        self.onReturn = onReturn
    }

    var body: some View {
        NavigationStack {
            Group {
                if !configuration.isYouVersionConfigured {
                    AppStateView(
                        AppStateDescriptor(
                            kind: .rightsLocked,
                            title: "Bible provider setup required",
                            message:
                                "Add your private YouVersion Platform App Key to Config/Secrets.xcconfig to enable the licensed reader.",
                            icon: "book.closed"
                        )
                    )
                } else {
                    configuredContent
                }
            }
            .navigationTitle("Bible")
            .toolbar {
                if let returnTitle, let onReturn {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(returnTitle, systemImage: "chevron.backward", action: onReturn)
                            .accessibilityIdentifier("bible-return-to-virtues")
                    }
                }
                if approvedVersionID != nil {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Search", systemImage: "magnifyingglass") {
                            isSearchPresented = true
                        }
                        .accessibilityIdentifier("bible-search-button")
                    }
                }
            }
        }
        .task {
            await catalogApproval.audit(using: configuration)
        }
        .sheet(isPresented: $isSearchPresented) {
            if let appKey = configuration.youVersionAppKey,
                let versionID = approvedVersionID
            {
                YouVersionBibleSearchView(
                    provider: YouVersionScriptureSearchAdapter(
                        appKey: appKey,
                        approvedVersionIDs: approvedVersionIDs
                    ),
                    versionID: versionID,
                    navigation: navigation
                )
            }
        }
    }

    @ViewBuilder
    private var configuredContent: some View {
        switch catalogApproval.state {
        case .notStarted, .auditing:
            AppStateView(
                AppStateDescriptor(
                    kind: .loading,
                    title: "Checking licensed editions",
                    message: "Confirming Catholic canon coverage and required attribution before opening the reader.",
                    icon: "checkmark.shield"
                )
            )
        case .ready(let approvedVersionIDs):
            VStack(spacing: 0) {
                YouVersionBibleReaderView(
                    navigation: navigation,
                    approvedVersionIDs: approvedVersionIDs
                )

                if let notice = YouVersionCatalogPolicy.approvedEditionNotice(
                    for: approvedVersionIDs
                ) {
                    Text(notice)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, AppSpacing.compact)
                        .padding(.vertical, 6)
                        .background(.bar)
                        .accessibilityLabel("Bible edition notice. \(notice)")
                }
            }
        case .rejected:
            AppStateView(
                AppStateDescriptor(
                    kind: .rightsLocked,
                    title: "No approved Catholic edition",
                    message:
                        "The editions available to this App Key did not pass the Catholic canon and attribution audit.",
                    icon: "book.closed"
                ),
                actionTitle: "Check again"
            ) {
                catalogApproval.retry(using: configuration)
            }
        case .unavailable:
            AppStateView(
                AppStateDescriptor(
                    kind: .error,
                    title: "Edition check unavailable",
                    message:
                        "Bible Study could not verify the licensed catalog. Check your connection and App Key, then try again.",
                    icon: "wifi.exclamationmark"
                ),
                actionTitle: "Try again"
            ) {
                catalogApproval.retry(using: configuration)
            }
        }
    }

    private var approvedVersionIDs: Set<Int> {
        guard case .ready(let approvedVersionIDs) = catalogApproval.state else { return [] }
        return approvedVersionIDs
    }

    private var approvedVersionID: Int? {
        YouVersionCatalogPolicy.preferredApprovedVersionID(in: approvedVersionIDs)
    }
}

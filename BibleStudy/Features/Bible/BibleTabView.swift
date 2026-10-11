import SwiftUI

struct BibleTabView: View {
    let configuration: AppConfiguration
    let navigation: ScriptureNavigationController
    let catalogApproval: YouVersionCatalogApproval

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
        }
        .task {
            await catalogApproval.audit(using: configuration)
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
        case .ready:
            YouVersionBibleReaderView(navigation: navigation)
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
}

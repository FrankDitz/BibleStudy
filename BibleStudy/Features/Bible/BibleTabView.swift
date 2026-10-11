import SwiftUI

struct BibleTabView: View {
    let isPlatformConfigured: Bool
    let navigation: ScriptureNavigationController

    var body: some View {
        NavigationStack {
            Group {
                if isPlatformConfigured {
                    YouVersionBibleReaderView(navigation: navigation)
                } else {
                    AppStateView(
                        AppStateDescriptor(
                            kind: .rightsLocked,
                            title: "Bible provider setup required",
                            message: "Add your private YouVersion Platform App Key to Config/Secrets.xcconfig to enable the licensed reader.",
                            icon: "book.closed"
                        )
                    )
                }
            }
            .navigationTitle("Bible")
        }
    }
}

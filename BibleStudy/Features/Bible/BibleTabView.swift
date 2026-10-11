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
                    ContentUnavailableView {
                        Label("YouVersion setup required", systemImage: "book.closed")
                    } description: {
                        Text("Add your private YouVersion Platform App Key to Config/Secrets.xcconfig to enable the Bible reader.")
                    }
                }
            }
            .navigationTitle("Bible")
        }
    }
}

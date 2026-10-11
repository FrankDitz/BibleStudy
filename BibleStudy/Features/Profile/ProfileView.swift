import SwiftUI

struct ProfileView: View {
    let isYouVersionConfigured: Bool

    var body: some View {
        NavigationStack {
            List {
                Section("Journey") {
                    LabeledContent("Reading days", value: "0")
                    LabeledContent("Current streak", value: "0 days")
                    LabeledContent("Plans completed", value: "0")
                }

                Section("Integrations") {
                    LabeledContent("YouVersion Platform") {
                        Label(
                            isYouVersionConfigured ? "Configured" : "Needs App Key",
                            systemImage: isYouVersionConfigured ? "checkmark.circle.fill" : "exclamationmark.circle"
                        )
                        .foregroundStyle(isYouVersionConfigured ? AppTheme.success : .secondary)
                    }
                    LabeledContent("YouVersion sign-in", value: "Off")
                    LabeledContent("iCloud sync", value: "Planned")
                }

                Section("Privacy") {
                    Text("Your plans, completion history, notes, highlights, bookmarks, and reflections are designed to remain private app data.")
                    Text("This build is scoped for one-person use. Any public release requires a new content-license, privacy, attribution, and distribution review.")
                }
            }
            .navigationTitle("You")
        }
    }
}

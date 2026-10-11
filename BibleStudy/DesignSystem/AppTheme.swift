import SwiftUI

enum AppTheme {
    static let accent = Color(red: 0.48, green: 0.20, blue: 0.16)
    static let warmSurface = Color(red: 0.96, green: 0.93, blue: 0.87)
    static let success = Color(red: 0.20, green: 0.46, blue: 0.30)
}

struct FeatureCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

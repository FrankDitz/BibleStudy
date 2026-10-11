import Foundation

struct AppConfiguration: Sendable {
    static let current = AppConfiguration(bundle: .main)

    let youVersionAppKey: String?

    init(bundle: Bundle) {
        self.init(infoDictionary: bundle.infoDictionary ?? [:])
    }

    init(infoDictionary: [String: Any]) {
        let rawValue = infoDictionary["YVPAppKey"] as? String
        let candidate = rawValue?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let candidate,
           !candidate.isEmpty,
           !candidate.contains("replace-with"),
           !candidate.hasPrefix("$(") {
            youVersionAppKey = candidate
        } else {
            youVersionAppKey = nil
        }
    }

    var isYouVersionConfigured: Bool {
        youVersionAppKey != nil
    }
}

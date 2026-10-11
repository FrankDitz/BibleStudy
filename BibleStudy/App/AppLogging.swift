import Foundation
import OSLog

enum AppLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.frankditz.biblestudy"

    static let app = Logger(subsystem: subsystem, category: "app")
    static let scripture = Logger(subsystem: subsystem, category: "scripture")
    static let persistence = Logger(subsystem: subsystem, category: "persistence")
    static let plans = Logger(subsystem: subsystem, category: "plans")
    static let learning = Logger(subsystem: subsystem, category: "learning")
    static let integration = Logger(subsystem: subsystem, category: "integration")
}

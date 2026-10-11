import Foundation
import Observation

@MainActor
@Observable
final class ScriptureNavigationController {
    struct Request: Equatable, Identifiable {
        let id = UUID()
        let reference: ScriptureReference
    }

    private(set) var request: Request?

    func open(_ reference: ScriptureReference) {
        request = Request(reference: reference)
    }
}

import Observation

@MainActor
@Observable
final class YouVersionCatalogApproval {
    enum State: Equatable {
        case notStarted
        case auditing
        case ready(approvedVersionIDs: Set<Int>)
        case rejected
        case unavailable
    }

    private(set) var state: State = .notStarted

    func audit(using configuration: AppConfiguration) async {
        guard configuration.isYouVersionConfigured else {
            state = .notStarted
            return
        }
        guard state == .notStarted else { return }

        state = .auditing
        let result = await YouVersionCapabilityProbe.run()

        switch YouVersionCatalogGateDecision.evaluate(result) {
        case .approved(let approvedVersionIDs):
            YouVersionBootstrap.configureIfAvailable(
                using: configuration,
                permittedVersionIDs: approvedVersionIDs
            )
            state = .ready(approvedVersionIDs: approvedVersionIDs)
        case .rejected:
            state = .rejected
        case .unavailable:
            state = .unavailable
        }
    }

    func retry(using configuration: AppConfiguration) {
        state = .notStarted
        Task {
            await audit(using: configuration)
        }
    }
}

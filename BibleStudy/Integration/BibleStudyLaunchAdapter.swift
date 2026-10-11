import Foundation

enum BibleStudyLaunchContext: Equatable, Sendable {
    case standalone
    case hub(BibleStudyHubLaunchRequest)

    var initialRoute: BibleStudyRoute? {
        switch self {
        case .standalone:
            nil
        case let .hub(request):
            request.initialRoute
        }
    }
}

struct BibleStudyHubLaunchRequest: Equatable, Sendable {
    let profile: BibleStudyProfileContext?
    let initialRoute: BibleStudyRoute?
}

enum BibleStudyLaunchAdapter {
    static func hubRequest(
        profile: BibleStudyProfileContext?,
        destination: AppDestination
    ) -> BibleStudyHubLaunchRequest {
        BibleStudyHubLaunchRequest(
            profile: profile,
            initialRoute: .destination(destination)
        )
    }

    static func hubRequest(
        profile: BibleStudyProfileContext?,
        reference: CanonicalScriptureReference,
        preferredVersionID: Int
    ) throws -> BibleStudyHubLaunchRequest {
        let scriptureReference = try ScriptureReference(
            versionID: preferredVersionID,
            bookID: reference.bookID,
            chapter: reference.chapter,
            verseStart: reference.verseStart,
            verseEnd: reference.verseEnd
        )
        return BibleStudyHubLaunchRequest(
            profile: profile,
            initialRoute: .scripture(scriptureReference)
        )
    }

}

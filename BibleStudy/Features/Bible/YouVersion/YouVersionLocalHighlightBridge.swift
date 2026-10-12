import YouVersionPlatform

@MainActor
struct YouVersionLocalHighlightBridge {
    private let cache: BibleHighlightsCache

    init(cache: BibleHighlightsCache = .shared) {
        self.cache = cache
    }

    func replaceCachedHighlights(with snapshots: [ScriptureHighlightSnapshot]) {
        guard !YouVersionPlatformConfiguration.isSignInEnabled else { return }

        cache.reset()
        cache.addHighlights(
            snapshots.map { snapshot in
                BibleHighlight(
                    snapshot.reference.youVersionReference,
                    color: snapshot.color.youVersionHexValue
                )
            }
        )
    }
}

extension ScriptureHighlightColor {
    fileprivate var youVersionHexValue: String {
        switch self {
        case .gold: "#FFDE59"
        case .blue: "#72C7FF"
        case .green: "#79DC8B"
        case .rose: "#FF95D6"
        }
    }
}

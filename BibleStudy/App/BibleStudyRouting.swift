import Foundation

enum BibleStudyRoute: Codable, Equatable, Sendable {
    case destination(AppDestination)
    case scripture(ScriptureReference)
}

enum BibleStudyDeepLink {
    static let scheme = "biblestudy"

    static func parse(_ url: URL) -> BibleStudyRoute? {
        guard url.scheme?.lowercased() == scheme else { return nil }
        let pathComponents = url.pathComponents.filter { $0 != "/" }

        switch url.host?.lowercased() {
        case "destination":
            guard
                let rawDestination = pathComponents.first?.lowercased(),
                let destination = AppDestination(rawValue: rawDestination)
            else {
                return nil
            }
            return .destination(destination)

        case "scripture":
            guard
                pathComponents.count == 2,
                let chapter = Int(pathComponents[1]),
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let versionID = components.integerQueryValue(named: "version")
            else {
                return nil
            }

            let verseStart = components.integerQueryValue(named: "verse")
            let verseEnd = components.integerQueryValue(named: "end")
            guard
                let reference = try? ScriptureReference(
                    versionID: versionID,
                    bookID: pathComponents[0],
                    chapter: chapter,
                    verseStart: verseStart,
                    verseEnd: verseEnd
                )
            else {
                return nil
            }
            return .scripture(reference)

        default:
            return nil
        }
    }

    static func url(for route: BibleStudyRoute) -> URL? {
        var components = URLComponents()
        components.scheme = scheme

        switch route {
        case .destination(let destination):
            components.host = "destination"
            components.path = "/\(destination.rawValue)"
        case .scripture(let reference):
            components.host = "scripture"
            components.path = "/\(reference.bookID)/\(reference.chapter)"
            var queryItems = [URLQueryItem(name: "version", value: String(reference.versionID))]
            if let verseStart = reference.verseStart {
                queryItems.append(URLQueryItem(name: "verse", value: String(verseStart)))
            }
            if let verseEnd = reference.verseEnd, verseEnd != reference.verseStart {
                queryItems.append(URLQueryItem(name: "end", value: String(verseEnd)))
            }
            components.queryItems = queryItems
        }

        return components.url
    }
}

extension URLComponents {
    fileprivate func integerQueryValue(named name: String) -> Int? {
        guard let value = queryItems?.first(where: { $0.name == name })?.value else {
            return nil
        }
        return Int(value)
    }
}

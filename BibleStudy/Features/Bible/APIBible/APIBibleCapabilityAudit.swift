import Foundation

enum APIBibleEndpoint: Equatable, Sendable {
    case textBibles
    case audioBibles
    case textBooks(bibleID: String)
    case audioBooks(bibleID: String)
    case audioChapter(bibleID: String, chapterID: String)

    func url(baseURL: URL = URL(string: "https://rest.api.bible/v1")!) -> URL {
        let components: [String]
        switch self {
        case .textBibles:
            components = ["bibles"]
        case .audioBibles:
            components = ["audio-bibles"]
        case .textBooks(let bibleID):
            components = ["bibles", bibleID, "books"]
        case .audioBooks(let bibleID):
            components = ["audio-bibles", bibleID, "books"]
        case .audioChapter(let bibleID, let chapterID):
            components = ["audio-bibles", bibleID, "chapters", chapterID]
        }

        return components.reduce(baseURL) { partialURL, component in
            partialURL.appendingPathComponent(component)
        }
    }
}

struct APIBibleAudioChapterEnvelope: Decodable, Equatable, Sendable {
    let data: APIBibleAudioChapter
    let meta: APIBibleResponseMetadata?
}

struct APIBibleAudioChapter: Decodable, Equatable, Sendable {
    let id: String
    let bibleID: String
    let number: String
    let bookID: String
    let resourceURL: String
    let timecodes: [Timecode]?
    let expiresAt: Int64
    let reference: String
    let copyright: String

    struct Timecode: Decodable, Equatable, Sendable {
        let start: String
        let end: String
        let verseID: String

        enum CodingKeys: String, CodingKey {
            case start
            case end
            case verseID = "verseId"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case bibleID = "bibleId"
        case number
        case bookID = "bookId"
        case resourceURL = "resourceUrl"
        case timecodes
        case expiresAt
        case reference
        case copyright
    }
}

struct APIBibleResponseMetadata: Decodable, Equatable, Sendable {
    let fums: String?
    let fumsID: String?

    enum CodingKeys: String, CodingKey {
        case fums
        case fumsID = "fumsId"
    }
}

struct APIBibleAudioAuditReport: Equatable, Sendable {
    let supportsChapterPlayback: Bool
    let supportsVerseFollowAlong: Bool
    let hasSecureResourceURL: Bool
    let hasUnexpiredResourceURL: Bool
    let hasAttribution: Bool
    let invalidTimecodeVerseIDs: [String]

    var isEligibleForTierAPrototype: Bool {
        supportsChapterPlayback
            && hasSecureResourceURL
            && hasUnexpiredResourceURL
            && hasAttribution
    }
}

enum APIBibleAudioAuditor {
    static func audit(
        _ chapter: APIBibleAudioChapter,
        now: Date = .now
    ) -> APIBibleAudioAuditReport {
        let resourceURL = URL(string: chapter.resourceURL)
        let hasSecureResourceURL = resourceURL?.scheme?.lowercased() == "https"
        let expiration = Date(timeIntervalSince1970: TimeInterval(chapter.expiresAt))
        let timecodes = chapter.timecodes ?? []
        let invalidTimecodes = timecodes.filter { timecode in
            guard
                let start = parseTime(timecode.start),
                let end = parseTime(timecode.end)
            else {
                return true
            }
            return start < 0 || end <= start
        }

        return APIBibleAudioAuditReport(
            supportsChapterPlayback: !chapter.resourceURL.isEmpty,
            supportsVerseFollowAlong: !timecodes.isEmpty && invalidTimecodes.isEmpty,
            hasSecureResourceURL: hasSecureResourceURL,
            hasUnexpiredResourceURL: expiration > now,
            hasAttribution: !chapter.copyright.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            invalidTimecodeVerseIDs: invalidTimecodes.map(\.verseID)
        )
    }

    private static func parseTime(_ value: String) -> TimeInterval? {
        if let seconds = TimeInterval(value) {
            return seconds
        }

        let parts = value.split(separator: ":").compactMap { TimeInterval($0) }
        guard !parts.isEmpty, parts.count <= 3 else { return nil }

        return parts.reversed().enumerated().reduce(0) { total, item in
            total + item.element * pow(60, Double(item.offset))
        }
    }
}

enum APIBibleCachePolicy {
    static let recommendedRefreshInterval: TimeInterval = 14 * 24 * 60 * 60
    static let maximumRefreshInterval: TimeInterval = 30 * 24 * 60 * 60

    static func isRefreshRequired(cachedAt: Date, now: Date = .now) -> Bool {
        now.timeIntervalSince(cachedAt) >= maximumRefreshInterval
    }
}

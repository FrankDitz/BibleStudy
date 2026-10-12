import Foundation

struct YouVersionScriptureSearchAdapter: ScriptureSearchProvider {
    typealias Loader = @Sendable (URLRequest) async throws -> (Data, HTTPURLResponse)

    private let appKey: String
    private let approvedVersionIDs: Set<Int>
    private let endpoint: URL
    private let load: Loader

    init(
        appKey: String,
        approvedVersionIDs: Set<Int>,
        endpoint: URL = URL(string: "https://api.youversion.com/v1/search-verses")!,
        session: URLSession = .shared
    ) {
        self.appKey = appKey
        self.approvedVersionIDs = approvedVersionIDs
        self.endpoint = endpoint
        load = { request in
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw ScriptureProviderFailure.invalidResponse
            }
            return (data, response)
        }
    }

    init(
        appKey: String,
        approvedVersionIDs: Set<Int>,
        endpoint: URL,
        load: @escaping Loader
    ) {
        self.appKey = appKey
        self.approvedVersionIDs = approvedVersionIDs
        self.endpoint = endpoint
        self.load = load
    }

    func search(_ request: ScriptureSearchRequest) async throws -> ScriptureSearchPage {
        let query = request.query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard query.count >= 1, query.count <= 100, (1...99).contains(request.pageSize) else {
            throw ScriptureProviderFailure.invalidRequest
        }
        guard approvedVersionIDs.contains(request.versionID) else {
            throw ScriptureProviderFailure.unlicensed
        }

        let urlRequest = try makeURLRequest(for: request, trimmedQuery: query)

        do {
            let (data, response) = try await load(urlRequest)
            try validate(response)
            return try decode(data, versionID: request.versionID)
        } catch let failure as ScriptureProviderFailure {
            throw failure
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost,
                .cannotConnectToHost, .dnsLookupFailed:
                throw ScriptureProviderFailure.offline
            default:
                throw ScriptureProviderFailure.unavailable
            }
        } catch is DecodingError {
            throw ScriptureProviderFailure.invalidResponse
        } catch {
            throw ScriptureProviderFailure.unavailable
        }
    }

    private func makeURLRequest(
        for request: ScriptureSearchRequest,
        trimmedQuery: String
    ) throws -> URLRequest {
        guard var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false) else {
            throw ScriptureProviderFailure.invalidRequest
        }

        var queryItems = [
            URLQueryItem(name: "query", value: trimmedQuery),
            URLQueryItem(name: "bible_id", value: String(request.versionID)),
            URLQueryItem(name: "user_intent", value: request.intent.rawValue),
            URLQueryItem(name: "page_size", value: String(request.pageSize)),
        ]
        if let pageToken = request.pageToken {
            queryItems.append(URLQueryItem(name: "page_token", value: pageToken))
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            throw ScriptureProviderFailure.invalidRequest
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(appKey, forHTTPHeaderField: "X-YVP-App-Key")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }

    private func validate(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200:
            return
        case 401:
            throw ScriptureProviderFailure.unauthorized
        case 403:
            throw ScriptureProviderFailure.unlicensed
        case 429:
            let retryAfter = response.value(forHTTPHeaderField: "Retry-After")
                .flatMap(TimeInterval.init)
            throw ScriptureProviderFailure.rateLimited(retryAfter: retryAfter)
        default:
            throw ScriptureProviderFailure.unavailable
        }
    }

    private func decode(_ data: Data, versionID: Int) throws -> ScriptureSearchPage {
        let response = try JSONDecoder().decode(SearchResponse.self, from: data)
        let references = try response.verses.map { result in
            try parse(reference: result.reference, versionID: versionID)
        }

        return ScriptureSearchPage(
            references: references,
            resolvedIntent: response.userIntent,
            spellingSuggestions: response.didYouMean,
            searchedInsteadFor: response.searchInsteadFor,
            nextPageToken: response.nextPageToken
        )
    }

    private func parse(reference: String, versionID: Int) throws -> ScriptureReference {
        let components = reference.split(separator: ".", omittingEmptySubsequences: false)
        guard
            components.count == 3,
            let canonicalBookID = YouVersionCatholicBookMapping.canonicalID(
                forProviderID: String(components[0])
            ),
            let chapter = Int(components[1]),
            let verse = Int(components[2])
        else {
            throw ScriptureProviderFailure.invalidResponse
        }

        do {
            return try ScriptureReference(
                versionID: versionID,
                bookID: canonicalBookID,
                chapter: chapter,
                verseStart: verse
            )
        } catch {
            throw ScriptureProviderFailure.invalidResponse
        }
    }
}

private struct SearchResponse: Decodable {
    let verses: [SearchVerse]
    let userIntent: String?
    let didYouMean: [String]
    let searchInsteadFor: String?
    let nextPageToken: String?

    enum CodingKeys: String, CodingKey {
        case verses
        case userIntent = "user_intent"
        case didYouMean = "did_you_mean"
        case searchInsteadFor = "search_instead_for"
        case nextPageToken = "next_page_token"
    }
}

private struct SearchVerse: Decodable {
    let reference: String
}

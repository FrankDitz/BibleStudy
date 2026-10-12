import Foundation
import XCTest

@testable import BibleStudy

final class YouVersionScriptureSearchAdapterTests: XCTestCase, @unchecked Sendable {
    func testSearchBuildsLicensedRequestAndMapsCatholicReference() async throws {
        let endpoint = try XCTUnwrap(URL(string: "https://example.test/v1/search-verses"))
        let responseURL = endpoint
        let adapter = YouVersionScriptureSearchAdapter(
            appKey: "test-key",
            approvedVersionIDs: [42],
            endpoint: endpoint
        ) { request in
            let components = try XCTUnwrap(
                URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false)
            )
            let query = Dictionary(
                uniqueKeysWithValues: (components.queryItems ?? []).compactMap { item in
                    item.value.map { (item.name, $0) }
                }
            )
            XCTAssertEqual(request.value(forHTTPHeaderField: "X-YVP-App-Key"), "test-key")
            XCTAssertEqual(query["query"], "love")
            XCTAssertEqual(query["bible_id"], "42")
            XCTAssertEqual(query["user_intent"], "text")
            XCTAssertEqual(query["page_size"], "10")

            return (
                Data(
                    #"{"verses":[{"reference":"JHN.3.16"}],"user_intent":"text","did_you_mean":[],"search_instead_for":null,"next_page_token":"next"}"#
                        .utf8
                ),
                try XCTUnwrap(
                    HTTPURLResponse(
                        url: responseURL,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                )
            )
        }

        let page = try await adapter.search(
            ScriptureSearchRequest(query: " love ", versionID: 42)
        )

        XCTAssertEqual(page.references.count, 1)
        XCTAssertEqual(page.references.first?.bookID, "JOHN")
        XCTAssertEqual(page.references.first?.chapter, 3)
        XCTAssertEqual(page.references.first?.verseStart, 16)
        XCTAssertEqual(page.resolvedIntent, "text")
        XCTAssertEqual(page.nextPageToken, "next")
    }

    func testSearchSendsPageTokenAndReturnsCorrections() async throws {
        let endpoint = try XCTUnwrap(URL(string: "https://example.test/v1/search-verses"))
        let adapter = YouVersionScriptureSearchAdapter(
            appKey: "test-key",
            approvedVersionIDs: [42],
            endpoint: endpoint
        ) { request in
            let components = try XCTUnwrap(
                URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false)
            )
            XCTAssertTrue(
                components.queryItems?.contains(
                    URLQueryItem(name: "page_token", value: "page-two")
                ) == true
            )
            return (
                Data(
                    #"{"verses":[],"user_intent":"topical","did_you_mean":["faith"],"search_instead_for":"faith","next_page_token":null}"#
                        .utf8
                ),
                try XCTUnwrap(
                    HTTPURLResponse(
                        url: endpoint,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                )
            )
        }

        let page = try await adapter.search(
            ScriptureSearchRequest(
                query: "fath",
                versionID: 42,
                intent: .topical,
                pageToken: "page-two"
            )
        )

        XCTAssertEqual(page.spellingSuggestions, ["faith"])
        XCTAssertEqual(page.searchedInsteadFor, "faith")
    }

    func testSearchRejectsUnapprovedVersionBeforeNetworkRequest() async {
        let adapter = YouVersionScriptureSearchAdapter(
            appKey: "test-key",
            approvedVersionIDs: [42],
            endpoint: URL(string: "https://example.test/v1/search-verses")!
        ) { _ in
            XCTFail("Unapproved versions must fail before a request is sent")
            throw ScriptureProviderFailure.unavailable
        }

        do {
            _ = try await adapter.search(
                ScriptureSearchRequest(query: "love", versionID: 2015)
            )
            XCTFail("Expected an unlicensed failure")
        } catch {
            XCTAssertEqual(error as? ScriptureProviderFailure, .unlicensed)
        }
    }

    func testSearchMapsRateLimitRetryAfter() async {
        let endpoint = URL(string: "https://example.test/v1/search-verses")!
        let adapter = YouVersionScriptureSearchAdapter(
            appKey: "test-key",
            approvedVersionIDs: [42],
            endpoint: endpoint
        ) { _ in
            (
                Data(),
                HTTPURLResponse(
                    url: endpoint,
                    statusCode: 429,
                    httpVersion: nil,
                    headerFields: ["Retry-After": "30"]
                )!
            )
        }

        do {
            _ = try await adapter.search(
                ScriptureSearchRequest(query: "love", versionID: 42)
            )
            XCTFail("Expected a rate limit failure")
        } catch {
            XCTAssertEqual(
                error as? ScriptureProviderFailure,
                .rateLimited(retryAfter: 30)
            )
        }
    }
}

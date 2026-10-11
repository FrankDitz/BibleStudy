import Foundation

struct ScriptureProviderIdentifier: RawRepresentable, Codable, Hashable, Sendable {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue.lowercased()
    }

    static let fixture = Self(rawValue: "fixture")
    static let youVersion = Self(rawValue: "youversion")
    static let apiBible = Self(rawValue: "api-bible")
}

struct ScriptureEditionIdentifier: Codable, Hashable, Sendable {
    let provider: ScriptureProviderIdentifier
    let value: String

    init(provider: ScriptureProviderIdentifier, value: String) {
        self.provider = provider
        self.value = value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum ScriptureCapability: String, Codable, CaseIterable, Hashable, Sendable {
    case catalog
    case chapterReading
    case search
    case providerManagedCache
    case persistentOfflineStorage
    case excerptSharing
    case chapterAudio
    case verseTimecodes
}

enum ScriptureApprovalStatus: String, Codable, Sendable {
    case fixtureOnly
    case pendingLiveAudit
    case approved
    case blocked
}

struct ScriptureRights: Codable, Equatable, Sendable {
    enum OfflineStorage: String, Codable, Sendable {
        case unavailable
        case providerManaged
        case appManaged
    }

    let status: ScriptureApprovalStatus
    let capabilities: Set<ScriptureCapability>
    let requiresAttribution: Bool
    let offlineStorage: OfflineStorage
    let maximumCacheAge: TimeInterval?
    let confirmationDate: Date?

    func allows(_ capability: ScriptureCapability) -> Bool {
        capabilities.contains(capability)
    }
}

struct ScriptureEdition: Identifiable, Codable, Equatable, Sendable {
    let id: ScriptureEditionIdentifier
    let title: String
    let abbreviation: String
    let languageTag: String
    let providerBookIDs: Set<String>
    let attribution: String?
    let rights: ScriptureRights

    var isEligibleForProduction: Bool {
        rights.status == .approved
            && rights.allows(.chapterReading)
            && (!rights.requiresAttribution || hasAttribution)
    }

    private var hasAttribution: Bool {
        attribution?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }
}

protocol ScriptureProvider: Sendable {
    var identifier: ScriptureProviderIdentifier { get }

    func editions() async throws -> [ScriptureEdition]
}

enum ScriptureProviderFailure: Error, Equatable, Sendable {
    case notConfigured
    case unauthorized
    case unlicensed
    case rateLimited(retryAfter: TimeInterval?)
    case offline
    case invalidResponse
    case unavailable
}

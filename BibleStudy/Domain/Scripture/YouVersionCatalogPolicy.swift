import Foundation

enum YouVersionCatalogPolicy {
    static let catholicPublicDomainVersionID = 42
    static let nabreVersionID = 463
    static let nrsvCIVersionID = 2015
    static let douayRheimsVersionID = 55

    static let preferredVersionIDs = [
        nabreVersionID,
        nrsvCIVersionID,
        douayRheimsVersionID,
        catholicPublicDomainVersionID,
    ]

    static let developmentDefaultVersionID = catholicPublicDomainVersionID
    static let permittedLanguageTags: Set<String> = ["en"]
    static let permittedVersionIDs = Set(preferredVersionIDs)

    static func preferredApprovedVersionID(in approvedVersionIDs: Set<Int>) -> Int? {
        preferredVersionIDs.first { approvedVersionIDs.contains($0) }
    }

    static func attribution(
        for versionID: Int,
        providerAttribution: String?
    ) -> String? {
        let trimmedAttribution = providerAttribution?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if let trimmedAttribution, !trimmedAttribution.isEmpty {
            return trimmedAttribution
        }

        if versionID == catholicPublicDomainVersionID {
            return "Catholic Public Domain Version · Scripture supplied by YouVersion"
        }
        return nil
    }

    static func approvedEditionNotice(for approvedVersionIDs: Set<Int>) -> String? {
        guard approvedVersionIDs.contains(catholicPublicDomainVersionID) else { return nil }
        return "CPDV · Catholic Public Domain Version · Scripture supplied by YouVersion"
    }

    static let developmentStart = try! ScriptureReference(
        versionID: developmentDefaultVersionID,
        bookID: "JOHN",
        chapter: 1
    )
}

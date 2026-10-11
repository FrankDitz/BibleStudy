import Foundation

enum YouVersionCatalogPolicy {
    static let nabreVersionID = 463
    static let nrsvCIVersionID = 2015
    static let douayRheimsVersionID = 55

    static let preferredVersionIDs = [
        nabreVersionID,
        nrsvCIVersionID,
        douayRheimsVersionID,
    ]

    static let developmentDefaultVersionID = douayRheimsVersionID
    static let permittedLanguageTags: Set<String> = ["en"]
    static let permittedVersionIDs = Set(preferredVersionIDs)

    static let developmentStart = try! ScriptureReference(
        versionID: developmentDefaultVersionID,
        bookID: "JOHN",
        chapter: 1
    )
}

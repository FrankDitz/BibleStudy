import Foundation
import YouVersionPlatform

enum YouVersionCatholicBookMapping {
    /// YouVersion uses three-character USFM-style book codes. Catholic Esther is split
    /// across `EST` and `ESG`, so 73 conceptual books require 74 provider resources.
    static let providerIDsByCanonicalID: [String: Set<String>] = [
        "GEN": ["GEN"], "EXOD": ["EXO"], "LEV": ["LEV"], "NUM": ["NUM"],
        "DEUT": ["DEU"], "JOSH": ["JOS"], "JUDG": ["JDG"], "RUTH": ["RUT"],
        "1SAM": ["1SA"], "2SAM": ["2SA"], "1KGS": ["1KI"], "2KGS": ["2KI"],
        "1CHR": ["1CH"], "2CHR": ["2CH"], "EZRA": ["EZR"], "NEH": ["NEH"],
        "TOB": ["TOB"], "JDT": ["JDT"], "ESTH": ["EST", "ESG"],
        "1MACC": ["1MA"], "2MACC": ["2MA"], "JOB": ["JOB"], "PS": ["PSA"],
        "PROV": ["PRO"], "ECCL": ["ECC"], "SONG": ["SNG"], "WIS": ["WIS"],
        "SIR": ["SIR"], "ISA": ["ISA"], "JER": ["JER"], "LAM": ["LAM"],
        "BAR": ["BAR"], "EZEK": ["EZK"], "DAN": ["DAN"], "HOS": ["HOS"],
        "JOEL": ["JOL"], "AMOS": ["AMO"], "OBAD": ["OBA"], "JONAH": ["JON"],
        "MIC": ["MIC"], "NAH": ["NAM"], "HAB": ["HAB"], "ZEPH": ["ZEP"],
        "HAG": ["HAG"], "ZECH": ["ZEC"], "MAL": ["MAL"], "MATT": ["MAT"],
        "MARK": ["MRK"], "LUKE": ["LUK"], "JOHN": ["JHN"], "ACTS": ["ACT"],
        "ROM": ["ROM"], "1COR": ["1CO"], "2COR": ["2CO"], "GAL": ["GAL"],
        "EPH": ["EPH"], "PHIL": ["PHP"], "COL": ["COL"], "1THESS": ["1TH"],
        "2THESS": ["2TH"], "1TIM": ["1TI"], "2TIM": ["2TI"], "TITUS": ["TIT"],
        "PHLM": ["PHM"], "HEB": ["HEB"], "JAS": ["JAS"], "1PET": ["1PE"],
        "2PET": ["2PE"], "1JOHN": ["1JN"], "2JOHN": ["2JN"],
        "3JOHN": ["3JN"], "JUDE": ["JUD"], "REV": ["REV"],
    ]

    static let expectedProviderBookIDs: Set<String> = {
        providerIDsByCanonicalID.values.reduce(into: Set<String>()) { result, identifiers in
            result.formUnion(identifiers)
        }
    }()

    static func canonicalID(forProviderID providerID: String) -> String? {
        let normalized = providerID.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        return providerIDsByCanonicalID.first { $0.value.contains(normalized) }?.key
    }

    /// Returns the normal reading resource. Catholic Esther additions remain a
    /// separate `ESG` resource and are handled by the Catholic navigator.
    static func primaryProviderID(forCanonicalID canonicalID: String) -> String? {
        let normalized = canonicalID.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if normalized == "ESTH" {
            return "EST"
        }
        guard let identifiers = providerIDsByCanonicalID[normalized], identifiers.count == 1 else {
            return nil
        }
        return identifiers.first
    }
}

struct YouVersionEditionSnapshot: Equatable, Sendable {
    let versionID: Int
    let title: String
    let abbreviation: String
    let attribution: String?
    let providerBookIDs: Set<String>
    let chapterIDsByBook: [String: Set<String>]

    init(
        versionID: Int,
        title: String,
        abbreviation: String,
        attribution: String?,
        providerBookIDs: Set<String>,
        chapterIDsByBook: [String: Set<String>]
    ) {
        self.versionID = versionID
        self.title = title
        self.abbreviation = abbreviation
        self.attribution = attribution
        self.providerBookIDs = Set(providerBookIDs.map { $0.uppercased() })
        self.chapterIDsByBook = Dictionary(
            uniqueKeysWithValues: chapterIDsByBook.map {
                ($0.key.uppercased(), Set($0.value.map { $0.uppercased() }))
            })
    }

    init(version: BibleVersion) {
        let books = version.books ?? []
        let chapterPairs: [(String, Set<String>)] = books.compactMap { book -> (String, Set<String>)? in
            guard let id = book.id else { return nil }
            return (id, Set((book.chapters ?? []).compactMap(\.id)))
        }
        let chapterIDs = Dictionary(uniqueKeysWithValues: chapterPairs)

        self.init(
            versionID: version.id,
            title: version.localizedTitle ?? version.title ?? "Bible \(version.id)",
            abbreviation: version.localizedAbbreviation ?? version.abbreviation ?? String(version.id),
            attribution: version.copyright ?? version.promotionalContent,
            providerBookIDs: Set(version.bookIds),
            chapterIDsByBook: chapterIDs
        )
    }
}

struct YouVersionEditionAuditReport: Identifiable, Equatable, Sendable {
    let versionID: Int
    let title: String
    let abbreviation: String
    let providerBookCount: Int
    let missingProviderBookIDs: [String]
    let missingCanonicalBookIDs: [String]
    let hasEstherAdditions: Bool
    let hasDanielAdditions: Bool
    let hasAttribution: Bool

    var id: Int { versionID }

    var isApprovedStructure: Bool {
        missingProviderBookIDs.isEmpty
            && missingCanonicalBookIDs.isEmpty
            && hasEstherAdditions
            && hasDanielAdditions
            && hasAttribution
    }
}

enum YouVersionEditionAuditor {
    static func audit(_ snapshot: YouVersionEditionSnapshot) -> YouVersionEditionAuditReport {
        let expectedProviderIDs = YouVersionCatholicBookMapping.expectedProviderBookIDs
        let missingProviderIDs = expectedProviderIDs.subtracting(snapshot.providerBookIDs).sorted()

        let coveredCanonicalIDs = Set(
            snapshot.providerBookIDs.compactMap {
                YouVersionCatholicBookMapping.canonicalID(forProviderID: $0)
            })
        let canonicalIDs = Set(CatholicCanon.books.map(\.osisID))
        let missingCanonicalIDs = canonicalIDs.subtracting(coveredCanonicalIDs).sorted()
        let danielChapterIDs = snapshot.chapterIDsByBook["DAN"] ?? []
        let attribution = snapshot.attribution?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return YouVersionEditionAuditReport(
            versionID: snapshot.versionID,
            title: snapshot.title,
            abbreviation: snapshot.abbreviation,
            providerBookCount: snapshot.providerBookIDs.count,
            missingProviderBookIDs: missingProviderIDs,
            missingCanonicalBookIDs: missingCanonicalIDs,
            hasEstherAdditions: snapshot.providerBookIDs.contains("ESG"),
            hasDanielAdditions: danielChapterIDs.contains("13") && danielChapterIDs.contains("14"),
            hasAttribution: attribution?.isEmpty == false
        )
    }
}

enum YouVersionCapabilityProbe {
    struct Failure: Identifiable, Equatable, Sendable {
        let versionID: Int
        let message: String

        var id: Int { versionID }
    }

    struct Result: Equatable, Sendable {
        let reports: [YouVersionEditionAuditReport]
        let failures: [Failure]
    }

    static func run() async -> Result {
        var reports: [YouVersionEditionAuditReport] = []
        var failures: [Failure] = []

        for versionID in YouVersionCatalogPolicy.preferredVersionIDs {
            do {
                let version = try await YouVersionAPI.Bible.version(withId: versionID)
                reports.append(YouVersionEditionAuditor.audit(.init(version: version)))
            } catch {
                failures.append(Failure(versionID: versionID, message: String(describing: error)))
            }
        }

        return Result(reports: reports, failures: failures)
    }
}

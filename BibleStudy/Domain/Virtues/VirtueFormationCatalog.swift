import Foundation

struct VirtuePathwayDescriptor: Identifiable, Equatable, Sendable {
    let id: VirtueIdentifier
    let title: String
    let emphasis: String
    let systemImage: String
}

enum VirtueFormationCatalog {
    static let descriptors: [VirtuePathwayDescriptor] = [
        VirtuePathwayDescriptor(
            id: .chastity,
            title: "Chastity",
            emphasis: "Integrity, purity of heart, and the dignity of every person",
            systemImage: "heart.circle"
        ),
        VirtuePathwayDescriptor(
            id: .temperance,
            title: "Temperance",
            emphasis: "Freedom through moderation and rightly ordered desire",
            systemImage: "scale.3d"
        ),
        VirtuePathwayDescriptor(
            id: .charity,
            title: "Charity",
            emphasis: "Love of God and neighbor made concrete",
            systemImage: "heart.fill"
        ),
        VirtuePathwayDescriptor(
            id: .diligence,
            title: "Diligence",
            emphasis: "Faithful attention to duties and worthy commitments",
            systemImage: "checkmark.seal"
        ),
        VirtuePathwayDescriptor(
            id: .patience,
            title: "Patience",
            emphasis: "Peaceful endurance in delay and difficulty",
            systemImage: "hourglass"
        ),
        VirtuePathwayDescriptor(
            id: .kindness,
            title: "Kindness",
            emphasis: "Gentle and generous action that makes charity tangible",
            systemImage: "hands.sparkles"
        ),
        VirtuePathwayDescriptor(
            id: .humility,
            title: "Humility",
            emphasis: "Living truthfully before God without pride or self-contempt",
            systemImage: "leaf"
        ),
    ]

    static let supportedIdentifiers = Set(descriptors.map(\.id))
}

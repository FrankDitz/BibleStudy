import Foundation
import SwiftData

@MainActor
struct VirtueFormationRepository {
    private let modelContext: ModelContext
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        encoder.dateEncodingStrategy = .millisecondsSince1970
        encoder.outputFormatting = [.sortedKeys]
        decoder.dateDecodingStrategy = .millisecondsSince1970
    }

    func state() throws -> VirtueFormationState {
        guard let record = try activeRecord() else { return .empty }
        return try decoder.decode(VirtueFormationState.self, from: record.payload)
    }

    @discardableResult
    func update(
        at date: Date = .now,
        _ change: (inout VirtueFormationState) throws -> Void
    ) throws -> VirtueFormationState {
        var state = try state()
        try change(&state)
        let payload = try encoder.encode(state)
        if let record = try activeRecord() {
            record.payload = payload
            record.modifiedAt = date
        } else {
            modelContext.insert(
                BibleStudySchemaV3.VirtueFormationRecord(payload: payload, modifiedAt: date)
            )
        }
        try modelContext.save()
        return state
    }

    private func activeRecord() throws -> BibleStudySchemaV3.VirtueFormationRecord? {
        try modelContext.fetch(
            FetchDescriptor<BibleStudySchemaV3.VirtueFormationRecord>(
                sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)]
            )
        ).first { $0.deletedAt == nil }
    }
}

import Foundation
import SwiftData

enum PersistenceController {
    static func createContainer() -> ModelContainer {
        let schema = Schema([EntradaDiario.self, Meta.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            migrateFromUserDefaultsIfNeeded(context: container.mainContext)
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private static func migrateFromUserDefaultsIfNeeded(context: ModelContext) {
        let defaults = UserDefaults.standard
        let migrationKey = "didMigrateToSwiftData_v1"
        guard !defaults.bool(forKey: migrationKey) else { return }

        // Migrate diary entries
        if let data = defaults.data(forKey: "diario_teddy_v2_ultra") {
            struct LegacyEntry: Codable {
                let id: UUID
                let fecha: Date
                let texto: String
                let audioURL: URL?
                let transcribedText: String?
            }
            if let entries = try? JSONDecoder().decode([LegacyEntry].self, from: data) {
                for entry in entries {
                    let audioPath: String? = entry.audioURL.map { $0.lastPathComponent }
                    let newEntry = EntradaDiario(
                        id: entry.id,
                        fecha: entry.fecha,
                        texto: entry.texto,
                        audioRelativePath: audioPath,
                        transcribedText: entry.transcribedText
                    )
                    context.insert(newEntry)
                }
            }
        }

        // Migrate goals
        if let data = defaults.data(forKey: "metas_teddy_v2_full") {
            struct LegacyMeta: Codable {
                var id: UUID
                var titulo: String
                var esCompletada: Bool
            }
            if let metas = try? JSONDecoder().decode([LegacyMeta].self, from: data) {
                for meta in metas {
                    let newMeta = Meta(id: meta.id, titulo: meta.titulo, esCompletada: meta.esCompletada)
                    context.insert(newMeta)
                }
            }
        }

        try? context.save()
        defaults.set(true, forKey: migrationKey)

        // Clean up old keys
        defaults.removeObject(forKey: "diario_teddy_v2_ultra")
        defaults.removeObject(forKey: "metas_teddy_v2_full")
    }
}

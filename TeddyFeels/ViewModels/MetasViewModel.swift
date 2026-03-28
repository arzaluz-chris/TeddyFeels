import Foundation
import SwiftData

@Observable
final class MetasViewModel {
    var showConfetti = false

    func addMeta(context: ModelContext, titulo: String) {
        let meta = Meta(titulo: titulo)
        context.insert(meta)
        try? context.save()
    }

    func toggleMeta(_ meta: Meta) {
        meta.esCompletada.toggle()
        if meta.esCompletada {
            showConfetti = true
        }
    }

    func removeMeta(_ meta: Meta, context: ModelContext) {
        context.delete(meta)
    }
}

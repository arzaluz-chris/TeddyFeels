import Foundation
import SwiftData

@Model
final class Meta {
    var id: UUID
    var titulo: String
    var esCompletada: Bool
    var fechaCreacion: Date

    init(id: UUID = UUID(), titulo: String, esCompletada: Bool = false, fechaCreacion: Date = Date()) {
        self.id = id
        self.titulo = titulo
        self.esCompletada = esCompletada
        self.fechaCreacion = fechaCreacion
    }
}

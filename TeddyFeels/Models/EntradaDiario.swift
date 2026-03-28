import Foundation
import SwiftData

@Model
final class EntradaDiario {
    var id: UUID
    var fecha: Date
    var texto: String
    var audioRelativePath: String?
    var transcribedText: String?

    init(id: UUID = UUID(), fecha: Date = Date(), texto: String = "", audioRelativePath: String? = nil, transcribedText: String? = nil) {
        self.id = id
        self.fecha = fecha
        self.texto = texto
        self.audioRelativePath = audioRelativePath
        self.transcribedText = transcribedText
    }

    var audioURL: URL? {
        guard let path = audioRelativePath else { return nil }
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent(path)
    }
}

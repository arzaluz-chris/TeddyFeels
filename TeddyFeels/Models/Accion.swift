import Foundation

struct Accion: Identifiable, Codable {
    var id: UUID = UUID()
    let texto: String
    let icono: String
    let comoHacerlo: String
}

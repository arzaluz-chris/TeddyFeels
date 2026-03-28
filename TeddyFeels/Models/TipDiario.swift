import Foundation

struct TipDiario: Identifiable {
    let id = UUID()
    let titulo: String
    let descripcion: String
    let icono: String
    let categoria: String
    let detalleLargo: String
}

import Foundation

@Observable
final class PositividadViewModel {
    var positiveCount: Int = 0
    var negativeCount: Int = 0
    var message: String = "¡Agrega emociones para balancear!"

    var ratio: Double {
        negativeCount == 0 ? 0 : Double(positiveCount) / Double(negativeCount)
    }

    func addNegative() {
        negativeCount += 1
        updateMessage()
    }

    func addPositive() {
        positiveCount += 1
        updateMessage()
    }

    func reset() {
        positiveCount = 0
        negativeCount = 0
        message = "¡Agrega emociones para balancear!"
    }

    private func updateMessage() {
        if negativeCount == 0 {
            message = "¡Todo positivo! Sigue así."
        } else if ratio >= 3 {
            message = "¡Bien hecho! Ratio \(String(format: "%.1f", ratio)):1. El oso está feliz 🐻😊"
        } else {
            message = "Ratio actual: \(String(format: "%.1f", ratio)):1. ¡Agrega más positivas!"
        }
    }
}

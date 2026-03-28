import Foundation

@Observable
final class RiskDetectionService {
    var pantallaBloqueadaPorRiesgo = false

    func analyzeText(_ texto: String) -> Double {
        let t = texto.lowercased()

        // Check danger phrases
        for phrase in RiskWordsData.palabrasPeligro {
            if t.contains(phrase) {
                pantallaBloqueadaPorRiesgo = true
                return 0
            }
        }

        // Sentiment scoring
        var score = 0.0
        for word in RiskWordsData.palabrasPositivas where t.contains(word) {
            score += RiskWordsData.scorePositivo
        }
        for word in RiskWordsData.palabrasNegativas where t.contains(word) {
            score += RiskWordsData.scoreNegativo
        }
        return score
    }

    func dismissRiskScreen() {
        pantallaBloqueadaPorRiesgo = false
    }
}

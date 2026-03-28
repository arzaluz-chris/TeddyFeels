import Foundation
import SwiftUI

@Observable
final class EmotionViewModel {
    var emocionActual: Emocion = .feliz
    var puntajeBienestar: Double {
        get { UserDefaults.standard.double(forKey: "score_v2_full") }
        set { UserDefaults.standard.set(newValue, forKey: "score_v2_full") }
    }

    func selectEmotion(_ emocion: Emocion) {
        emocionActual = emocion
        let value = emocion.valorBienestar
        puntajeBienestar = min(100, puntajeBienestar + value)
        DailyScoreService.record(scoreChange: value)
        print("📊 [Emotion] \(emocion.rawValue) → +\(value) pts — total: \(Int(puntajeBienestar))%")
    }

    func resetBienestar() {
        puntajeBienestar = 0.0
        DailyScoreService.resetAll()
    }
}

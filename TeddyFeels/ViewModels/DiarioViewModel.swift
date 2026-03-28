import Foundation
import SwiftData
import SwiftUI

@Observable
final class DiarioViewModel {
    var puntajeBienestar: Double {
        get { UserDefaults.standard.double(forKey: "score_v2_full") }
        set { UserDefaults.standard.set(newValue, forKey: "score_v2_full") }
    }

    private let riskService: RiskDetectionService

    init(riskService: RiskDetectionService) {
        self.riskService = riskService
    }

    func addEntry(context: ModelContext, texto: String, audioRelativePath: String? = nil, transcribedText: String? = nil) {
        let entry = EntradaDiario(
            texto: texto,
            audioRelativePath: audioRelativePath,
            transcribedText: transcribedText
        )
        context.insert(entry)

        let contentToAnalyze = transcribedText ?? texto
        if !contentToAnalyze.isEmpty {
            let scoreChange = riskService.analyzeText(contentToAnalyze)
            puntajeBienestar = max(0, min(100, puntajeBienestar + scoreChange))
            DailyScoreService.record(scoreChange: scoreChange)
            print("📊 [Diario] Análisis de texto → cambio: \(String(format: "%+.1f", scoreChange)) pts — total: \(Int(puntajeBienestar))%")
        }
    }

    func removeEntry(_ entry: EntradaDiario, context: ModelContext) {
        if let url = entry.audioURL {
            try? FileManager.default.removeItem(at: url)
        }
        context.delete(entry)
    }
}

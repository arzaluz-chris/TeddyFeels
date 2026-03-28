import Foundation
import Speech

@Observable
final class TranscriptionService {
    var isTranscribing = false
    var transcribedText = ""
    var error: String?

    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { _ in }
    }

    func transcribe(url: URL, completion: @escaping (String?) -> Void) {
        isTranscribing = true
        error = nil
        transcribedText = ""

        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))
        guard let recognizer, recognizer.isAvailable else {
            DispatchQueue.main.async {
                self.error = "Reconocedor no disponible"
                self.isTranscribing = false
                completion(nil)
            }
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = true

        recognizer.recognitionTask(with: request) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error {
                    self?.isTranscribing = false
                    self?.error = "Error en transcripción: \(error.localizedDescription)"
                    completion(nil)
                    return
                }
                if let result {
                    self?.transcribedText = result.bestTranscription.formattedString
                    if result.isFinal {
                        self?.isTranscribing = false
                        completion(result.bestTranscription.formattedString)
                    }
                }
            }
        }
    }
}

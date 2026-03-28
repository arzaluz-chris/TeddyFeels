import Foundation
import SwiftUI

@Observable
final class PINService {
    // MARK: - State
    private(set) var isSetup: Bool

    // MARK: - Keys
    private enum Keys {
        static let pin = "teddy_pin"
        static let rescueQuestion1Index = "teddy_rescue_q1_index"
        static let rescueQuestion2Index = "teddy_rescue_q2_index"
        static let rescueAnswer1 = "teddy_rescue_a1"
        static let rescueAnswer2 = "teddy_rescue_a2"
        static let failedAttempts = "teddy_pin_failed_attempts"
    }

    // MARK: - Rescue Questions
    /// Questions designed so only the child would know the answer, not parents
    static let rescueQuestions: [String] = [
        "¿Cómo se llama tu peluche favorito?",
        "¿Cuál es tu animal favorito?",
        "¿Cuál es tu comida favorita?",
        "¿Cuál es tu color favorito?",
        "¿Cómo se llama tu mejor amigo o amiga?",
        "¿Cuál es tu caricatura favorita?",
        "¿Cuál es tu juego favorito?",
        "¿Qué superhéroe te gusta más?",
    ]

    // MARK: - Failed Attempts
    var failedAttempts: Int {
        get { UserDefaults.standard.integer(forKey: Keys.failedAttempts) }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.failedAttempts)
            print("🔐 [PIN] Intentos fallidos persistidos: \(newValue)")
        }
    }

    func resetFailedAttempts() {
        failedAttempts = 0
    }

    // MARK: - Init
    init() {
        self.isSetup = UserDefaults.standard.string(forKey: Keys.pin) != nil
        let attempts = UserDefaults.standard.integer(forKey: Keys.failedAttempts)
        print("🔐 [PIN] Inicializado — PIN configurado: \(isSetup) — intentos fallidos previos: \(attempts)")
    }

    // MARK: - PIN Management

    func setupPIN(_ pin: String, question1Index: Int, answer1: String, question2Index: Int, answer2: String) {
        let defaults = UserDefaults.standard
        defaults.set(pin, forKey: Keys.pin)
        defaults.set(question1Index, forKey: Keys.rescueQuestion1Index)
        defaults.set(question2Index, forKey: Keys.rescueQuestion2Index)
        defaults.set(answer1.lowercased().trimmingCharacters(in: .whitespaces), forKey: Keys.rescueAnswer1)
        defaults.set(answer2.lowercased().trimmingCharacters(in: .whitespaces), forKey: Keys.rescueAnswer2)
        isSetup = true
        print("🔐 [PIN] PIN configurado exitosamente con preguntas de rescate")
    }

    func validatePIN(_ pin: String) -> Bool {
        let result = UserDefaults.standard.string(forKey: Keys.pin) == pin
        if result {
            resetFailedAttempts()
        }
        print("🔐 [PIN] Validación de PIN: \(result ? "✅ correcto" : "❌ incorrecto")")
        return result
    }

    // MARK: - Rescue Questions

    func getRescueQuestions() -> (String, String)? {
        let defaults = UserDefaults.standard
        let q1 = defaults.integer(forKey: Keys.rescueQuestion1Index)
        let q2 = defaults.integer(forKey: Keys.rescueQuestion2Index)
        guard q1 < Self.rescueQuestions.count, q2 < Self.rescueQuestions.count else { return nil }
        return (Self.rescueQuestions[q1], Self.rescueQuestions[q2])
    }

    func validateRescueAnswers(answer1: String, answer2: String) -> Bool {
        let defaults = UserDefaults.standard
        let stored1 = defaults.string(forKey: Keys.rescueAnswer1) ?? ""
        let stored2 = defaults.string(forKey: Keys.rescueAnswer2) ?? ""
        let clean1 = answer1.lowercased().trimmingCharacters(in: .whitespaces)
        let clean2 = answer2.lowercased().trimmingCharacters(in: .whitespaces)
        return clean1 == stored1 && clean2 == stored2
    }

    func resetPIN() {
        print("🔐 [PIN] Reseteando PIN y preguntas de rescate")
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Keys.pin)
        defaults.removeObject(forKey: Keys.rescueQuestion1Index)
        defaults.removeObject(forKey: Keys.rescueQuestion2Index)
        defaults.removeObject(forKey: Keys.rescueAnswer1)
        defaults.removeObject(forKey: Keys.rescueAnswer2)
        defaults.removeObject(forKey: Keys.failedAttempts)
        isSetup = false
    }
}

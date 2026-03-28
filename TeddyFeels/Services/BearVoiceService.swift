import Foundation
import AVFoundation
import SwiftUI

@Observable
final class BearVoiceService {
    enum Character: String, CaseIterable, Identifiable {
        case dan = "Dan"
        case dani = "Dani"
        var id: String { rawValue }
    }

    var selectedCharacter: Character {
        get {
            Character(rawValue: UserDefaults.standard.string(forKey: "bearVoiceCharacter") ?? "Dan") ?? .dan
        }
        set {
            print("🔊 [BearVoice] Personaje cambiado a: \(newValue.rawValue)")
            UserDefaults.standard.set(newValue.rawValue, forKey: "bearVoiceCharacter")
            stop()
        }
    }

    var hasSelectedCharacter: Bool = UserDefaults.standard.bool(forKey: "hasSelectedBearCharacter")

    var isPlaying = false

    private var player: AVAudioPlayer?
    private var playedTabs: [String: Date] = [:]
    private let cooldownSeconds: TimeInterval = 300 // 5 minutes

    func markCharacterSelected() {
        UserDefaults.standard.set(true, forKey: "hasSelectedBearCharacter")
        hasSelectedCharacter = true
        print("🔊 [BearVoice] Personaje marcado como seleccionado: \(selectedCharacter.rawValue)")
    }

    // MARK: - Playback

    func play(for tab: String) {
        print("🔊 [BearVoice] play(for: \"\(tab)\") — personaje: \(selectedCharacter.rawValue)")

        // Cooldown check per tab
        if let lastTime = playedTabs[tab], Date().timeIntervalSince(lastTime) < cooldownSeconds {
            let remaining = Int(cooldownSeconds - Date().timeIntervalSince(lastTime))
            print("🔊 [BearVoice] ⏳ Cooldown activo para \"\(tab)\" — faltan \(remaining)s")
            return
        }

        guard let audioName = audioFileName(for: tab) else {
            print("🔊 [BearVoice] ⚠️ No hay audio configurado para tab: \"\(tab)\"")
            return
        }

        print("🔊 [BearVoice] Buscando archivo: \(audioName).m4a")

        guard let url = findAudioURL(named: audioName) else {
            print("🔊 [BearVoice] ❌ No se encontró el archivo: \(audioName).m4a en el bundle")
            logBundleContents()
            return
        }

        print("🔊 [BearVoice] ✅ Archivo encontrado: \(url.path)")
        playURL(url, tab: tab)
    }

    func replay(for tab: String) {
        print("🔊 [BearVoice] replay(for: \"\(tab)\") — ignorando cooldown")
        playedTabs.removeValue(forKey: tab)
        play(for: tab)
    }

    func stop() {
        if isPlaying {
            print("🔊 [BearVoice] ⏹ Deteniendo reproducción")
        }
        player?.stop()
        isPlaying = false
    }

    func playWelcome() {
        let prefix = selectedCharacter == .dan ? "dan" : "dani"
        let name = "\(prefix)_bienvenida"
        print("🔊 [BearVoice] playWelcome() — buscando: \(name).m4a")

        guard let url = findAudioURL(named: name) else {
            print("🔊 [BearVoice] ❌ No se encontró bienvenida: \(name).m4a")
            logBundleContents()
            return
        }

        print("🔊 [BearVoice] ✅ Bienvenida encontrada: \(url.path)")
        playURL(url, tab: "welcome")
    }

    // MARK: - Audio File Resolution

    private func audioFileName(for tab: String) -> String? {
        let prefix = selectedCharacter == .dan ? "dan" : "dani"
        switch tab {
        case "Inicio": return "\(prefix)_emociones_tab1"
        case "Diario": return "\(prefix)_diario"
        case "Explorar": return "dani_tips_bienestar"
        case "Metas": return "\(prefix)_metas"
        case "Progreso": return "\(prefix)_analisis"
        default: return nil
        }
    }

    /// Tries multiple path strategies to find the audio file in the bundle
    private func findAudioURL(named name: String) -> URL? {
        let characterFolder = selectedCharacter.rawValue // "Dan" or "Dani"
        let otherFolder = selectedCharacter == .dan ? "Dani" : "Dan"

        // Strategy 1: subdirectory with Resources prefix
        let subdirs = [
            "Resources/Audio/\(characterFolder)",
            "Resources/Audio/\(otherFolder)",
            "Audio/\(characterFolder)",
            "Audio/\(otherFolder)",
        ]

        for subdir in subdirs {
            if let url = Bundle.main.url(forResource: name, withExtension: "m4a", subdirectory: subdir) {
                print("🔊 [BearVoice] 📂 Encontrado en subdirectory: \(subdir)")
                return url
            }
        }

        // Strategy 2: flat lookup (no subdirectory)
        if let url = Bundle.main.url(forResource: name, withExtension: "m4a") {
            print("🔊 [BearVoice] 📂 Encontrado sin subdirectory (flat)")
            return url
        }

        // Strategy 3: search entire bundle
        if let url = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil)?.first(where: { $0.lastPathComponent == "\(name).m4a" }) {
            print("🔊 [BearVoice] 📂 Encontrado con búsqueda amplia: \(url.path)")
            return url
        }

        print("🔊 [BearVoice] ❌ Todas las estrategias fallaron para: \(name).m4a")
        return nil
    }

    // MARK: - Playback Engine

    private func playURL(_ url: URL, tab: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)

            guard let player else {
                print("🔊 [BearVoice] ❌ AVAudioPlayer es nil después de init")
                return
            }

            let started = player.play()
            print("🔊 [BearVoice] ▶️ play() returned: \(started) — duración: \(String(format: "%.1f", player.duration))s — tab: \"\(tab)\"")

            isPlaying = true
            playedTabs[tab] = Date()
        } catch {
            print("🔊 [BearVoice] ❌ Error de reproducción: \(error)")
        }
    }

    // MARK: - Debug

    private func logBundleContents() {
        print("🔊 [BearVoice] === BUNDLE DEBUG ===")
        print("🔊 [BearVoice] Bundle path: \(Bundle.main.bundlePath)")

        // List all m4a files in bundle
        if let allM4A = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil) {
            print("🔊 [BearVoice] Archivos .m4a encontrados (flat): \(allM4A.count)")
            for url in allM4A {
                print("🔊 [BearVoice]   - \(url.lastPathComponent) @ \(url.path)")
            }
        } else {
            print("🔊 [BearVoice] ⚠️ No se encontraron archivos .m4a en el bundle (flat)")
        }

        // Try common subdirectories
        for subdir in ["Audio", "Resources/Audio", "Audio/Dan", "Audio/Dani", "Resources/Audio/Dan", "Resources/Audio/Dani"] {
            if let urls = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: subdir) {
                print("🔊 [BearVoice] Archivos en \(subdir)/: \(urls.map { $0.lastPathComponent })")
            }
        }

        print("🔊 [BearVoice] === FIN BUNDLE DEBUG ===")
    }
}

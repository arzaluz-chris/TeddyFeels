import SwiftUI
import AVFoundation
import ConfettiSwiftUI

struct CharacterPickerView: View {
    @Environment(BearVoiceService.self) private var bearVoice
    @State private var selectedCharacter: BearVoiceService.Character = .dan
    @State private var showContent = false
    @State private var confettiCounter = 0
    @State private var previewPlayer: AVAudioPlayer?
    @State private var isPreviewPlaying = false

    var body: some View {
        ZStack {
            TeddyAnimatedBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: TeddyTheme.spacingLG) {
                    Spacer(minLength: TeddyTheme.spacingXL)

                    Image("oso_Bienvenida")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .scaleEffect(showContent ? 1.0 : 0.5)
                        .opacity(showContent ? 1.0 : 0)

                    VStack(spacing: TeddyTheme.spacingSM) {
                        Text("¡Hola! Soy Teddy")
                            .font(TeddyTheme.screenTitle())
                            .foregroundColor(TeddyTheme.textPrimary)

                        Text("¿Con qué voz quieres que te hable?")
                            .font(TeddyTheme.body())
                            .foregroundColor(TeddyTheme.textSecondary)
                    }
                    .opacity(showContent ? 1.0 : 0)

                    HStack(spacing: TeddyTheme.spacingLG) {
                        characterCard(character: .dan, imageName: "osito_feliz", label: "Dan")
                        characterCard(character: .dani, imageName: "osita_feliz", label: "Dani")
                    }
                    .opacity(showContent ? 1.0 : 0)

                    // Preview button
                    Button {
                        playPreview(for: selectedCharacter)
                    } label: {
                        HStack(spacing: TeddyTheme.spacingSM) {
                            Image(systemName: isPreviewPlaying ? "speaker.wave.2.fill" : "play.circle.fill")
                                .font(.system(size: 20))
                            Text(isPreviewPlaying ? "Escuchando..." : "Escuchar voz")
                                .font(TeddyTheme.bodyBold())
                        }
                        .foregroundColor(TeddyTheme.primary)
                        .padding(.vertical, TeddyTheme.spacingSM)
                        .padding(.horizontal, TeddyTheme.spacingLG)
                        .background(TeddyTheme.primary.opacity(0.1))
                        .clipShape(Capsule())
                    }
                    .disabled(isPreviewPlaying)
                    .opacity(showContent ? 1.0 : 0)

                    TeddyButton(title: "¡Empezar!", icon: "play.fill") {
                        stopPreview()
                        confettiCounter += 1
                        bearVoice.selectedCharacter = selectedCharacter
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            bearVoice.markCharacterSelected()
                        }
                    }
                    .padding(.horizontal, TeddyTheme.spacingXL)
                    .opacity(showContent ? 1.0 : 0)

                    Spacer(minLength: TeddyTheme.spacingLG)
                }
                .frame(maxWidth: .infinity)
                .padding(TeddyTheme.screenPadding)
            }
            .scrollIndicators(.hidden)
            .teddyCelebration(counter: $confettiCounter)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) {
                showContent = true
            }
        }
        .onDisappear {
            stopPreview()
        }
    }

    private func characterCard(character: BearVoiceService.Character, imageName: String, label: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedCharacter = character
            }
            stopPreview()
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } label: {
            VStack(spacing: TeddyTheme.spacingSM) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                Text(label)
                    .font(TeddyTheme.screenTitle())
                    .foregroundColor(TeddyTheme.textPrimary)
            }
            .frame(width: 180, height: 180)
            .background(selectedCharacter == character ? TeddyTheme.primary.opacity(0.1) : TeddyTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: TeddyTheme.cardRadius)
                    .stroke(selectedCharacter == character ? TeddyTheme.primary : TeddyTheme.border, lineWidth: selectedCharacter == character ? 3 : 1)
            )
            .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
            .scaleEffect(selectedCharacter == character ? 1.05 : 1.0)
        }
    }

    // MARK: - Preview Audio

    private func playPreview(for character: BearVoiceService.Character) {
        stopPreview()
        let prefix = character == .dan ? "dan" : "dani"
        let fileName = "\(prefix)_bienvenida"
        let folder = character == .dan ? "Dan" : "Dani"

        print("🔊 [Preview] Buscando: \(fileName).m4a para \(character.rawValue)")

        // Try multiple subdirectory strategies
        let subdirs = ["Resources/Audio/\(folder)", "Audio/\(folder)"]
        var foundURL: URL?
        for subdir in subdirs {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "m4a", subdirectory: subdir) {
                print("🔊 [Preview] ✅ Encontrado en: \(subdir)")
                foundURL = url
                break
            }
        }
        // Flat fallback
        if foundURL == nil {
            foundURL = Bundle.main.url(forResource: fileName, withExtension: "m4a")
            if foundURL != nil {
                print("🔊 [Preview] ✅ Encontrado sin subdirectory")
            }
        }

        guard let url = foundURL else {
            print("🔊 [Preview] ❌ No se encontró: \(fileName).m4a")
            // Log all m4a in bundle
            if let all = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil) {
                print("🔊 [Preview] Archivos .m4a en bundle: \(all.map { $0.lastPathComponent })")
            } else {
                print("🔊 [Preview] ⚠️ No hay archivos .m4a en el bundle")
            }
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            previewPlayer = try AVAudioPlayer(contentsOf: url)
            previewPlayer?.delegate = PreviewDelegate.shared
            PreviewDelegate.shared.onFinish = {
                self.isPreviewPlaying = false
                print("🔊 [Preview] ⏹ Preview terminado")
            }
            let started = previewPlayer?.play() ?? false
            isPreviewPlaying = true
            print("🔊 [Preview] ▶️ play() returned: \(started) — duración: \(String(format: "%.1f", previewPlayer?.duration ?? 0))s")
        } catch {
            print("🔊 [Preview] ❌ Error: \(error)")
        }
    }

    private func stopPreview() {
        previewPlayer?.stop()
        previewPlayer = nil
        isPreviewPlaying = false
    }
}

// MARK: - AVAudioPlayerDelegate helper

private class PreviewDelegate: NSObject, AVAudioPlayerDelegate {
    static let shared = PreviewDelegate()
    var onFinish: (() -> Void)?

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.onFinish?()
        }
    }
}

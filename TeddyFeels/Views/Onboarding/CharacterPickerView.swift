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

    // Staggered entrance
    @State private var titleProgress: Int = 0
    @State private var danAppeared = false
    @State private var daniAppeared = false
    @State private var controlsAppeared = false

    private let titleText = Array("Elige tu compañero")

    var body: some View {
        ZStack {
            TeddyAnimatedBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: TeddyTheme.spacingLG) {
                    Spacer(minLength: TeddyTheme.spacingHuge)

                    // Title with typewriter effect
                    VStack(spacing: TeddyTheme.spacingSM) {
                        HStack(spacing: 1) {
                            ForEach(Array(titleText.enumerated()), id: \.offset) { index, char in
                                Text(String(char))
                                    .font(TeddyTheme.screenTitle())
                                    .foregroundColor(TeddyTheme.textPrimary)
                                    .opacity(index < titleProgress ? 1 : 0)
                                    .animation(
                                        .spring(response: 0.3, dampingFraction: 0.7)
                                            .delay(Double(index) * 0.03),
                                        value: titleProgress
                                    )
                            }
                        }

                        Text("¿Con qué voz quieres que te hable?")
                            .font(TeddyTheme.body())
                            .foregroundColor(TeddyTheme.textSecondary)
                            .opacity(controlsAppeared ? 1 : 0)
                    }

                    // Character cards — slide in from sides
                    HStack(spacing: TeddyTheme.spacingLG) {
                        characterCard(
                            character: .dan,
                            imageName: "osito_feliz",
                            label: "Dan",
                            subtitle: "Aventurero"
                        )
                        .offset(x: danAppeared ? 0 : -100)
                        .opacity(danAppeared ? 1 : 0)

                        characterCard(
                            character: .dani,
                            imageName: "osita_feliz",
                            label: "Dani",
                            subtitle: "Curiosa"
                        )
                        .offset(x: daniAppeared ? 0 : 100)
                        .opacity(daniAppeared ? 1 : 0)
                    }

                    // Preview button
                    Button {
                        playPreview(for: selectedCharacter)
                    } label: {
                        HStack(spacing: TeddyTheme.spacingSM) {
                            Image(systemName: isPreviewPlaying ? "speaker.wave.2.fill" : "play.circle.fill")
                                .font(.system(size: 22, weight: .semibold))
                            Text(isPreviewPlaying ? "Escuchando..." : "Escuchar voz")
                                .font(TeddyTheme.bodyBold())
                        }
                        .foregroundColor(TeddyTheme.primary)
                        .padding(.vertical, TeddyTheme.spacingSM + 2)
                        .padding(.horizontal, TeddyTheme.spacingLG)
                        .background(TeddyTheme.primary.opacity(0.1))
                        .clipShape(Capsule())
                    }
                    .disabled(isPreviewPlaying)
                    .opacity(controlsAppeared ? 1 : 0)
                    .scaleEffect(controlsAppeared ? 1 : 0.8)

                    TeddyButton(title: "¡Empezar!", icon: "play.fill") {
                        stopPreview()
                        confettiCounter += 1
                        bearVoice.selectedCharacter = selectedCharacter
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            bearVoice.markCharacterSelected()
                        }
                    }
                    .padding(.horizontal, TeddyTheme.spacingXL)
                    .opacity(controlsAppeared ? 1 : 0)
                    .scaleEffect(controlsAppeared ? 1 : 0.8)

                    Spacer(minLength: TeddyTheme.spacingLG)
                }
                .frame(maxWidth: .infinity)
                .padding(TeddyTheme.screenPadding)
            }
            .scrollIndicators(.hidden)
            .teddyCelebration(counter: $confettiCounter)
        }
        .onAppear {
            startEntranceSequence()
        }
        .onDisappear {
            stopPreview()
        }
    }

    // MARK: - Entrance Sequence

    private func startEntranceSequence() {
        // Title typewriter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            titleProgress = titleText.count
        }

        // Dan slides in from left
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(TeddyTheme.bounceSpring) {
                danAppeared = true
            }
        }

        // Dani slides in from right (staggered)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(TeddyTheme.bounceSpring) {
                daniAppeared = true
            }
        }

        // Controls fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(TeddyTheme.gentleSpring) {
                controlsAppeared = true
            }
        }
    }

    // MARK: - Character Card

    private func characterCard(character: BearVoiceService.Character, imageName: String, label: String, subtitle: String) -> some View {
        Button {
            withAnimation(TeddyTheme.bounceSpring) {
                selectedCharacter = character
            }
            stopPreview()
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        } label: {
            VStack(spacing: TeddyTheme.spacingSM) {
                TeddyAnimatedBear(
                    imageName: imageName,
                    size: 120,
                    style: selectedCharacter == character ? .breathing : .none
                )
                .frame(height: 120)
                .saturation(selectedCharacter == character ? 1.0 : 0.6)
                .scaleEffect(selectedCharacter == character ? 1.0 : 0.9)

                VStack(spacing: 2) {
                    Text(label)
                        .font(TeddyTheme.screenTitle())
                        .foregroundColor(TeddyTheme.textPrimary)

                    Text(subtitle)
                        .font(TeddyTheme.caption())
                        .foregroundColor(TeddyTheme.textSecondary)
                }
            }
            .frame(width: 170, height: 210)
            .background(
                selectedCharacter == character
                    ? TeddyTheme.primary.opacity(0.08)
                    : TeddyTheme.surface
            )
            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: TeddyTheme.cardRadius, style: .continuous)
                    .stroke(
                        selectedCharacter == character ? TeddyTheme.primary : TeddyTheme.border,
                        lineWidth: selectedCharacter == character ? 2.5 : 1
                    )
            )
            .shadow(
                color: selectedCharacter == character ? TeddyTheme.primary.opacity(0.2) : TeddyTheme.cardShadow.color,
                radius: selectedCharacter == character ? 16 : TeddyTheme.cardShadow.radius,
                x: 0,
                y: TeddyTheme.cardShadow.y
            )
        }
        .animation(TeddyTheme.gentleSpring, value: selectedCharacter)
    }

    // MARK: - Preview Audio

    private func playPreview(for character: BearVoiceService.Character) {
        stopPreview()
        let prefix = character == .dan ? "dan" : "dani"
        let fileName = "\(prefix)_bienvenida"
        let folder = character == .dan ? "Dan" : "Dani"

        let subdirs = ["Resources/Audio/\(folder)", "Audio/\(folder)"]
        var foundURL: URL?
        for subdir in subdirs {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "m4a", subdirectory: subdir) {
                foundURL = url
                break
            }
        }
        if foundURL == nil {
            foundURL = Bundle.main.url(forResource: fileName, withExtension: "m4a")
        }

        guard let url = foundURL else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            previewPlayer = try AVAudioPlayer(contentsOf: url)
            previewPlayer?.delegate = PreviewDelegate.shared
            PreviewDelegate.shared.onFinish = {
                self.isPreviewPlaying = false
            }
            previewPlayer?.play()
            isPreviewPlaying = true
        } catch {
            print("🔊 [Preview] Error: \(error)")
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

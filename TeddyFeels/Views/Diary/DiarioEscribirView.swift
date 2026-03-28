import SwiftUI
import SwiftData
import ConfettiSwiftUI

struct DiarioEscribirView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BearVoiceService.self) private var bearVoice
    @Environment(RiskDetectionService.self) private var riskService
    @Query(sort: \EntradaDiario.fecha, order: .reverse) private var entradas: [EntradaDiario]

    @State private var diarioVM: DiarioViewModel?
    @State private var recorder = AudioRecorderService()
    @State private var playerService = AudioPlayerService()
    @State private var transcription = TranscriptionService()

    @State private var texto = ""
    @State private var showSaved = false
    @State private var confettiCounter = 0

    var body: some View {
        ScrollView {
            VStack(spacing: TeddyTheme.spacingMD) {
                TeddyBearBanner(
                    imageName: "oso_Diario",
                    message: "Aquí puedes escribir o grabar notas de voz. Nadie más las verá.",
                    imageSize: 100,
                    onTap: { bearVoice.replay(for: "Diario") }
                )

                TeddyCard {
                    VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                        Text("Cuéntale a Teddy...")
                            .font(TeddyTheme.caption())
                            .foregroundColor(TeddyTheme.textTertiary)

                        TextEditor(text: $texto)
                            .frame(height: 150)
                            .scrollContentBackground(.hidden)
                            .font(TeddyTheme.body())
                            .foregroundColor(TeddyTheme.textPrimary)
                    }
                }

                HStack(spacing: TeddyTheme.spacingSM) {
                    TeddyButton(title: "Guardar", icon: "checkmark.circle.fill") {
                        if !texto.isEmpty {
                            print("📱 [Diario] Guardando entrada de texto (\(texto.count) chars)")
                            getVM().addEntry(context: modelContext, texto: texto)
                            texto = ""
                            confettiCounter += 1
                            showSaved = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showSaved = false }
                        }
                    }

                    Button {
                        if recorder.isRecording {
                            print("📱 [Diario] Deteniendo grabación")
                            recorder.stopRecording()
                            if let url = recorder.recordingURL {
                                print("📱 [Diario] Auto-transcribiendo: \(url.lastPathComponent)")
                                transcription.transcribe(url: url) { _ in }
                            }
                        } else {
                            print("📱 [Diario] Iniciando grabación")
                            transcription.transcribedText = ""
                            recorder.startRecording()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(recorder.isRecording ? TeddyTheme.secondary : TeddyTheme.primary)
                                .frame(width: 56, height: 56)
                            Image(systemName: recorder.isRecording ? "stop.fill" : "mic.fill")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .shadow(color: (recorder.isRecording ? TeddyTheme.secondary : TeddyTheme.primary).opacity(0.3), radius: 8, y: 4)
                    }
                }

                if recorder.isRecording {
                    HStack(spacing: TeddyTheme.spacingSM) {
                        Circle()
                            .fill(TeddyTheme.secondary)
                            .frame(width: 10, height: 10)
                        Text("Grabando...")
                            .font(TeddyTheme.caption())
                            .foregroundColor(TeddyTheme.secondary)
                    }
                    .transition(.opacity)
                }

                if transcription.isTranscribing || !transcription.transcribedText.isEmpty {
                    TeddyCard {
                        VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                            HStack {
                                Image(systemName: "text.bubble.fill")
                                    .foregroundColor(TeddyTheme.primary)
                                Text("Transcripción")
                                    .font(TeddyTheme.cardTitle())
                                    .foregroundColor(TeddyTheme.textPrimary)
                                Spacer()
                                if transcription.isTranscribing {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                }
                            }
                            Text(transcription.transcribedText.isEmpty ? "Escuchando..." : transcription.transcribedText)
                                .font(TeddyTheme.body())
                                .foregroundColor(transcription.transcribedText.isEmpty ? TeddyTheme.textTertiary : TeddyTheme.textPrimary)
                        }
                    }
                }

                if !transcription.isTranscribing && !transcription.transcribedText.isEmpty {
                    TeddyButton(title: "Guardar nota de voz", icon: "checkmark.circle.fill") {
                        if let url = recorder.recordingURL {
                            getVM().addEntry(
                                context: modelContext,
                                texto: "",
                                audioRelativePath: url.lastPathComponent,
                                transcribedText: transcription.transcribedText
                            )
                            recorder.clearRecording()
                            transcription.transcribedText = ""
                            confettiCounter += 1
                            showSaved = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showSaved = false }
                        }
                    }
                }

                if showSaved {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(TeddyTheme.success)
                        Text("¡Teddy guardó tu secreto!")
                            .font(TeddyTheme.bodyBold())
                            .foregroundColor(TeddyTheme.success)
                    }
                    .transition(.scale.combined(with: .opacity))
                }

                if !entradas.isEmpty {
                    TeddySectionHeader(title: "Mis Notas")
                    ForEach(entradas) { entry in
                        DiaryEntryRow(entry: entry, playerService: playerService)
                    }
                }
            }
            .padding(.horizontal, TeddyTheme.screenPadding)
            .padding(.top, TeddyTheme.spacingMD)
            .padding(.bottom, 100)
        }
        .scrollDismissesKeyboard(.interactively)
        .teddyCelebration(counter: $confettiCounter)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Listo") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .font(TeddyTheme.bodyBold())
                .foregroundColor(TeddyTheme.primary)
            }
        }
        .onAppear {
            recorder.requestPermissions()
            transcription.requestPermission()
            bearVoice.play(for: "Diario")
        }
        .onDisappear {
            if recorder.isRecording { recorder.stopRecording() }
            playerService.stopAll()
        }
    }

    private func getVM() -> DiarioViewModel {
        if let vm = diarioVM { return vm }
        let vm = DiarioViewModel(riskService: riskService)
        diarioVM = vm
        return vm
    }
}

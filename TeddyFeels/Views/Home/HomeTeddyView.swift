import SwiftUI
import ConfettiSwiftUI

struct HomeTeddyView: View {
    @Environment(BearVoiceService.self) private var bearVoice
    @State private var emotionVM = EmotionViewModel()
    @State private var selectedEmocion: Emocion?
    @State private var showSOS = false
    @State private var showPrivacy = false
    @State private var confettiCounter = 0

    @Environment(\.horizontalSizeClass) private var sizeClass

    private var gridColumns: [GridItem] {
        let count = sizeClass == .regular ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: TeddyTheme.spacingSM), count: count)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "¡Buenos días! ¿Cómo amaneciste hoy?"
        case 12..<18: return "¡Buenas tardes! ¿Cómo te sientes?"
        default: return "¡Buenas noches! ¿Cómo estuvo tu día?"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: TeddyTheme.spacingLG) {
                    // Bear greeting banner - bear changes based on current emotion
                    TeddyBearBanner(
                        imageName: emotionVM.emocionActual.bearImageName,
                        message: greeting,
                        onTap: { bearVoice.replay(for: "Inicio") }
                    )

                    // Energy score widget
                    TeddyScoreWidget(score: emotionVM.puntajeBienestar)

                    // Emotion section
                    VStack(alignment: .leading, spacing: TeddyTheme.spacingMD) {
                        TeddySectionHeader(title: "¿Cómo te sientes?")

                        LazyVGrid(columns: gridColumns, spacing: TeddyTheme.spacingSM) {
                            ForEach(Emocion.allCases) { emocion in
                                TeddyEmotionCard(
                                    emocion: emocion,
                                    isSelected: emotionVM.emocionActual == emocion
                                ) {
                                    print("📱 [Home] Emoción seleccionada: \(emocion.rawValue)")
                                    emotionVM.selectEmotion(emocion)
                                    confettiCounter += 1
                                    selectedEmocion = emocion
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, TeddyTheme.screenPadding)
                .iPadReadableWidth()
                .padding(.top, TeddyTheme.spacingMD)
                .padding(.bottom, 100)
            }
            .background { TeddyAnimatedBackground().ignoresSafeArea() }
            .navigationTitle("Teddy Feels")
            .navigationBarTitleDisplayMode(.large)
            .teddyCelebration(counter: $confettiCounter)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPrivacy = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(TeddyTheme.primary)
                    }
                }
            }
        }
        .sheet(item: $selectedEmocion) { emocion in
            DetalleSheet(emocion: emocion)
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyPolicyView()
        }
        .onAppear {
            print("📱 [Home] Vista apareció — personaje: \(bearVoice.selectedCharacter.rawValue)")
            bearVoice.play(for: "Inicio")
        }
    }
}

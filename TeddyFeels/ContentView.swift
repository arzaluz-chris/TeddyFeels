import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(BearVoiceService.self) private var bearVoice
    @Environment(RiskDetectionService.self) private var riskService
    @State private var welcome = false
    @State private var isColdStart = true
    @State private var selectedTab = 0
    @State private var showSOS = false

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            if !welcome {
                IntroLoadingView(welcome: $welcome, isColdStart: isColdStart)
                    .onAppear { print("📱 [Nav] Mostrando IntroLoadingView (coldStart: \(isColdStart))") }
            } else if !bearVoice.hasSelectedCharacter {
                CharacterPickerView()
                    .onAppear { print("📱 [Nav] Mostrando CharacterPickerView") }
            } else {
                mainApp
                    .onAppear { print("📱 [Nav] Mostrando mainApp — personaje: \(bearVoice.selectedCharacter.rawValue)") }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && welcome && bearVoice.hasSelectedCharacter {
                isColdStart = false
                welcome = false
                print("📱 [Nav] App activada — mostrando splash rápida")
            }
        }
    }

    private var mainApp: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                HomeTeddyView()
                    .tabItem {
                        Label("Inicio", systemImage: "house.fill")
                    }
                    .tag(0)

                DiarioTabView()
                    .tabItem {
                        Label("Diario", systemImage: "book.fill")
                    }
                    .tag(1)

                ExplorarView()
                    .tabItem {
                        Label("Explorar", systemImage: "sparkles")
                    }
                    .tag(2)

                IAAnalisisDashboard()
                    .tabItem {
                        Label("Progreso", systemImage: "chart.bar.fill")
                    }
                    .tag(3)
            }
            .tint(TeddyTheme.primary)

            // Floating SOS button
            TeddyFloatingSOSButton {
                showSOS = true
            }
            .padding(.trailing, 20)
            .padding(.bottom, 80)

            // Risk detection overlay
            if riskService.pantallaBloqueadaPorRiesgo {
                LockScreenHelpView()
            }
        }
        .fullScreenCover(isPresented: $showSOS) {
            SOSIAView()
        }
    }
}

#Preview {
    ContentView()
        .environment(BearVoiceService())
        .environment(RiskDetectionService())
        .modelContainer(for: [EntradaDiario.self, Meta.self], inMemory: true)
}

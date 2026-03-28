import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(BearVoiceService.self) private var bearVoice
    @Environment(RiskDetectionService.self) private var riskService
    @State private var welcome = false
    @State private var selectedTab = 0
    @State private var showSOS = false

    var body: some View {
        ZStack {
            if !welcome {
                IntroLoadingView(welcome: $welcome)
                    .onAppear { print("📱 [Nav] Mostrando IntroLoadingView") }
            } else if !bearVoice.hasSelectedCharacter {
                CharacterPickerView()
                    .onAppear { print("📱 [Nav] Mostrando CharacterPickerView") }
            } else {
                mainApp
                    .onAppear { print("📱 [Nav] Mostrando mainApp — personaje: \(bearVoice.selectedCharacter.rawValue)") }
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

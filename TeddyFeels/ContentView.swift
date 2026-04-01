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
            } else if !bearVoice.hasSelectedCharacter {
                CharacterPickerView()
            } else {
                mainApp
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && welcome && bearVoice.hasSelectedCharacter {
                isColdStart = false
                welcome = false
            }
        }
    }

    private var mainApp: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            Group {
                switch selectedTab {
                case 0: HomeTeddyView()
                case 1: DiarioTabView()
                case 2: ExplorarView()
                case 3: IAAnalisisDashboard()
                default: HomeTeddyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom floating tab bar
            floatingTabBar

            // Risk detection overlay
            if riskService.pantallaBloqueadaPorRiesgo {
                LockScreenHelpView()
            }
        }
        .fullScreenCover(isPresented: $showSOS) {
            SOSIAView()
        }
    }

    // MARK: - Floating Tab Bar

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            tabBarItem(icon: "house.fill", label: "Inicio", tab: 0)
            tabBarItem(icon: "book.fill", label: "Diario", tab: 1)

            // SOS button — center, prominent
            sosButton

            tabBarItem(icon: "sparkles", label: "Explorar", tab: 2)
            tabBarItem(icon: "chart.bar.fill", label: "Progreso", tab: 3)
        }
        .padding(.horizontal, TeddyTheme.spacingMD)
        .padding(.vertical, TeddyTheme.spacingSM)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.12), radius: 20, y: 8)
        )
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, TeddyTheme.spacingLG)
        .padding(.bottom, TeddyTheme.spacingSM)
    }

    private func tabBarItem(icon: String, label: String, tab: Int) -> some View {
        Button {
            withAnimation(TeddyTheme.snappySpring) {
                selectedTab = tab
            }
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: selectedTab == tab ? 22 : 20, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? TeddyTheme.primary : TeddyTheme.textTertiary)
                    .scaleEffect(selectedTab == tab ? 1.1 : 1.0)

                Text(label)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(selectedTab == tab ? TeddyTheme.primary : TeddyTheme.textTertiary)

                // Active indicator dot
                Circle()
                    .fill(selectedTab == tab ? TeddyTheme.primary : .clear)
                    .frame(width: 5, height: 5)
            }
            .frame(maxWidth: .infinity)
            .animation(TeddyTheme.snappySpring, value: selectedTab)
        }
    }

    private var sosButton: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
            showSOS = true
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [TeddyTheme.secondary, TeddyTheme.secondary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: TeddyTheme.secondary.opacity(0.4), radius: 8, y: 2)

                Image(systemName: "bolt.shield.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .offset(y: -8) // Float above tab bar
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
        .environment(BearVoiceService())
        .environment(RiskDetectionService())
        .modelContainer(for: [EntradaDiario.self, Meta.self], inMemory: true)
}

import SwiftUI
import SwiftData

@main
struct TeddyFeelsApp: App {
    let container: ModelContainer
    @State private var bearVoice = BearVoiceService()
    @State private var riskService = RiskDetectionService()
    @State private var pinService = PINService()

    init() {
        container = PersistenceController.createContainer()
        print("📱 [App] TeddyFeels iniciado")
        print("📱 [App] Bundle path: \(Bundle.main.bundlePath)")
        // Log all m4a files at startup
        if let m4aFiles = Bundle.main.urls(forResourcesWithExtension: "m4a", subdirectory: nil) {
            print("📱 [App] Archivos .m4a en bundle (flat): \(m4aFiles.count)")
            for f in m4aFiles { print("📱 [App]   \(f.lastPathComponent)") }
        } else {
            print("📱 [App] ⚠️ No se encontraron archivos .m4a en el bundle")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bearVoice)
                .environment(riskService)
                .environment(pinService)
        }
        .modelContainer(container)
    }
}

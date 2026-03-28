import SwiftUI

struct LockScreenHelpView: View {
    @Environment(RiskDetectionService.self) private var riskService

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 30) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)

                Text("TEDDY ESTÁ PREOCUPADO")
                    .font(.title.bold())
                    .foregroundColor(.white)

                Text("He leído algo que me asusta. No estás solo. Por favor, habla con mamá, papá o un maestro ahora mismo. Ellos te quieren ayudar.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Líneas de ayuda inmediata:")
                        .font(.headline)
                        .foregroundColor(.yellow)

                    Text("• Emergencias: \(AppConstants.EmergencyNumbers.emergencias) (México)")
                        .foregroundColor(.white)
                    Text("• SAPTEL para niños: \(AppConstants.EmergencyNumbers.saptel)")
                        .foregroundColor(.white)
                    Text("• Línea de la Vida: \(AppConstants.EmergencyNumbers.lineaVida)")
                        .foregroundColor(.white)
                    Text("• UNICEF México: Busca ayuda en tu escuela o familiar de confianza")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button {
                    riskService.dismissRiskScreen()
                } label: {
                    Text("VOY A BUSCAR AYUDA, OK")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}

import SwiftUI

struct DiarioTabView: View {
    @State private var selectedSegment = 0
    @State private var accesoConcedido = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !accesoConcedido {
                    SecretPasswordView(
                        title: "Mi Espacio Secreto",
                        subtitle: "Escribe tu PIN secreto para entrar",
                        bearImage: "oso_Diario"
                    ) {
                        accesoConcedido = true
                    }
                } else {
                    // Segment picker
                    Picker("", selection: $selectedSegment) {
                        Text("Mi Diario").tag(0)
                        Text("Mis Metas").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, TeddyTheme.screenPadding)
                    .padding(.top, TeddyTheme.spacingMD)

                    // Content
                    if selectedSegment == 0 {
                        DiarioEscribirView()
                    } else {
                        MetasControlView()
                    }
                }
            }
            .navigationTitle("Diario")
            .navigationBarTitleDisplayMode(.large)
        }
        .background { TeddyAnimatedBackground().ignoresSafeArea() }
    }
}

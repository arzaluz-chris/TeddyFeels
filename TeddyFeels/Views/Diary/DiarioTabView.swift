import SwiftUI

struct DiarioTabView: View {
    @State private var selectedSegment = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
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
            .background(TeddyTheme.background)
            .navigationTitle("Diario")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

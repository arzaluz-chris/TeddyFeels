import SwiftUI

struct TipsGlobalesView: View {
    @State private var searchText = ""

    var filteredTips: [TipDiario] {
        if searchText.isEmpty { return TipsData.allTips }
        return TipsData.allTips.filter {
            $0.titulo.localizedCaseInsensitiveContains(searchText) ||
            $0.categoria.localizedCaseInsensitiveContains(searchText) ||
            $0.detalleLargo.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: TeddyTheme.spacingMD) {
                // Search bar
                HStack(spacing: TeddyTheme.spacingSM) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(TeddyTheme.textTertiary)
                    TextField("Buscar tips...", text: $searchText)
                        .font(TeddyTheme.body())
                }
                .padding(TeddyTheme.spacingMD)
                .background(TeddyTheme.glassFill)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)

                // Tips list
                ForEach(filteredTips) { tip in
                    TeddyCard {
                        VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(TeddyTheme.primary.opacity(0.1))
                                        .frame(width: 36, height: 36)
                                    Image(systemName: tip.icono)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(TeddyTheme.primary)
                                }

                                Text(tip.titulo)
                                    .font(TeddyTheme.cardTitle())
                                    .foregroundColor(TeddyTheme.textPrimary)

                                Spacer()

                                Text(tip.categoria)
                                    .font(TeddyTheme.badge())
                                    .foregroundColor(TeddyTheme.primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(TeddyTheme.primary.opacity(0.1))
                                    .clipShape(Capsule())
                            }

                            Text(tip.detalleLargo)
                                .font(TeddyTheme.body())
                                .foregroundColor(TeddyTheme.textSecondary)
                                .lineLimit(3)
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
        .navigationTitle("Tips de Bienestar")
    }
}

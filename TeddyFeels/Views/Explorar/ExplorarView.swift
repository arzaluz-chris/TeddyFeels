import SwiftUI

struct ExplorarView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: TeddyTheme.spacingMD) {
                    // Bear banner
                    TeddyBearBanner(
                        imageName: "oso_Walden",
                        message: "Descubre tips, juegos y todo sobre cómo funcionan tus emociones"
                    )
                    .padding(.horizontal, TeddyTheme.screenPadding)
                .iPadReadableWidth()

                    // Section cards
                    VStack(spacing: TeddyTheme.spacingMD) {
                        NavigationLink {
                            TipsGlobalesView()
                        } label: {
                            explorarCard(
                                icon: "lightbulb.fill",
                                iconColor: .orange,
                                title: "Tips de Bienestar",
                                subtitle: "Más de 80 consejos para sentirte mejor",
                                bgColor: Color(hex: "FFF7ED")
                            )
                        }

                        NavigationLink {
                            PositividadView()
                        } label: {
                            explorarCard(
                                icon: "heart.fill",
                                iconColor: .pink,
                                title: "La Regla 3:1",
                                subtitle: "Aprende a balancear tus emociones con un juego",
                                bgColor: Color(hex: "FDF2F8")
                            )
                        }

                        NavigationLink {
                            InvestigacionExtensaView()
                        } label: {
                            explorarCard(
                                icon: "doc.text.fill",
                                iconColor: TeddyTheme.primary,
                                title: "Sobre Teddy",
                                subtitle: "La ciencia detrás de tu amigo inteligente",
                                bgColor: Color(hex: "EEF2FF")
                            )
                        }
                    }
                    .padding(.horizontal, TeddyTheme.screenPadding)
                .iPadReadableWidth()
                }
                .padding(.top, TeddyTheme.spacingMD)
                .padding(.bottom, 100)
            }
            .navigationTitle("Explorar")
            .navigationBarTitleDisplayMode(.large)
        }
        .background { TeddyAnimatedBackground().ignoresSafeArea() }
    }

    private func explorarCard(icon: String, iconColor: Color, title: String, subtitle: String, bgColor: Color) -> some View {
        HStack(spacing: TeddyTheme.spacingMD) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(bgColor)
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: TeddyTheme.spacingXS) {
                Text(title)
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.textPrimary)

                Text(subtitle)
                    .font(TeddyTheme.caption())
                    .foregroundColor(TeddyTheme.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(TeddyTheme.textTertiary)
        }
        .padding(TeddyTheme.cardPadding)
        .background(TeddyTheme.glassFill)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
        .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
    }
}

import SwiftUI

struct ExplorarView: View {
    @State private var cardsAppeared = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: TeddyTheme.spacingMD) {
                    // Bear banner with animated bear
                    TeddyBearBanner(
                        imageName: "oso_Walden",
                        message: "Descubre tips, juegos y todo sobre cómo funcionan tus emociones"
                    )
                    .padding(.horizontal, TeddyTheme.screenPadding)
                    .iPadReadableWidth()

                    // Section cards — staggered entrance
                    VStack(spacing: TeddyTheme.spacingMD) {
                        NavigationLink {
                            TipsGlobalesView()
                        } label: {
                            explorarCard(
                                icon: "lightbulb.fill",
                                iconColor: .orange,
                                title: "Tips de Bienestar",
                                subtitle: "Más de 80 consejos para sentirte mejor",
                                bgColor: Color(hex: "FFF7ED"),
                                index: 0
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
                                bgColor: Color(hex: "FDF2F8"),
                                index: 1
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
                                bgColor: Color(hex: "EEF2FF"),
                                index: 2
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
        .onAppear {
            withAnimation(TeddyTheme.gentleSpring.delay(0.2)) {
                cardsAppeared = true
            }
        }
    }

    private func explorarCard(icon: String, iconColor: Color, title: String, subtitle: String, bgColor: Color, index: Int) -> some View {
        HStack(spacing: TeddyTheme.spacingMD) {
            // Large icon area with color background
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(bgColor)
                    .frame(width: 64, height: 64)

                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
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
        .elevatedCard()
        .opacity(cardsAppeared ? 1 : 0)
        .offset(y: cardsAppeared ? 0 : 30)
        .animation(TeddyTheme.gentleSpring.delay(Double(index) * 0.1), value: cardsAppeared)
    }
}

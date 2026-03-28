import SwiftUI

struct InvestigacionExtensaView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: TeddyTheme.spacingMD) {
                TeddyBearBanner(
                    imageName: "oso_Escuela",
                    message: "Conoce la ciencia detrás de tu amigo inteligente",
                    imageSize: 100
                )

                TeddyCard(accentColor: TeddyTheme.primary) {
                    VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                        Text("EXPEDIENTE TÉCNICO V.2.0")
                            .font(TeddyTheme.badge())
                            .foregroundColor(TeddyTheme.primary)
                        Text("Teddy Feels: Tu amigo inteligente")
                            .font(TeddyTheme.sectionTitle())
                            .foregroundColor(TeddyTheme.textPrimary)
                    }
                }

                researchCard(title: "1. ¿Por qué existe Teddy?", content: InvestigacionData.porQueExiste)
                researchCard(title: "2. Cómo se hizo Teddy", content: InvestigacionData.comoSeHizo)

                TeddyCard {
                    VStack(alignment: .leading, spacing: TeddyTheme.spacingMD) {
                        Text("3. Libros y doctores que nos ayudaron")
                            .font(TeddyTheme.cardTitle())
                            .foregroundColor(TeddyTheme.primary)

                        ForEach(InvestigacionData.fuentes, id: \.self) { fuente in
                            HStack(alignment: .top, spacing: TeddyTheme.spacingSM) {
                                Circle()
                                    .fill(TeddyTheme.primary)
                                    .frame(width: 6, height: 6)
                                    .padding(.top, 6)
                                Text(fuente)
                                    .font(TeddyTheme.body())
                                    .foregroundColor(TeddyTheme.textSecondary)
                            }
                        }
                    }
                }

                // Credits
                TeddyCard {
                    VStack(spacing: TeddyTheme.spacingSM) {
                        Text("CREADORES")
                            .font(TeddyTheme.badge())
                            .foregroundColor(TeddyTheme.textTertiary)
                        ForEach(InvestigacionData.creadores, id: \.self) { creador in
                            Text(creador)
                                .font(TeddyTheme.cardTitle())
                                .foregroundColor(TeddyTheme.textPrimary)
                        }
                        Text(InvestigacionData.copyright)
                            .font(TeddyTheme.caption())
                            .foregroundColor(TeddyTheme.textTertiary)
                            .padding(.top, TeddyTheme.spacingXS)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, TeddyTheme.screenPadding)
                .iPadReadableWidth()
            .padding(.top, TeddyTheme.spacingMD)
            .padding(.bottom, 100)
        }
        .background { TeddyAnimatedBackground().ignoresSafeArea() }
        .navigationTitle("Sobre Teddy")
    }

    private func researchCard(title: String, content: String) -> some View {
        TeddyCard {
            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                Text(title)
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.primary)
                Text(content)
                    .font(TeddyTheme.body())
                    .foregroundColor(TeddyTheme.textSecondary)
                    .lineSpacing(4)
            }
        }
    }
}

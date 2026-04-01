import SwiftUI
import ConfettiSwiftUI

struct DetalleSheet: View {
    let emocion: Emocion
    @Environment(BearVoiceService.self) private var bearVoice
    @Environment(\.dismiss) var dismiss
    @State private var confettiCounter = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: TeddyTheme.spacingLG) {
                    // Header with solid emotion color
                    VStack(spacing: TeddyTheme.spacingMD) {
                        TeddyAnimatedBear(
                            imageName: emocion.imageName(for: bearVoice.selectedCharacter),
                            size: 180,
                            style: .breathing
                        )

                        Text("Cuando me siento \(emocion.displayName(for: bearVoice.selectedCharacter).lowercased())")
                            .font(TeddyTheme.sectionTitle())
                            .foregroundColor(TeddyTheme.textPrimary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, TeddyTheme.spacingLG)
                    .padding(.horizontal, TeddyTheme.screenPadding)
                    .background(
                        LinearGradient(
                            colors: [emocion.backgroundColor.opacity(0.6), emocion.backgroundColor],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    // Recommendations carousel
                    VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                        Text("¿Qué puedes hacer?")
                            .font(TeddyTheme.sectionTitle())
                            .foregroundColor(TeddyTheme.textPrimary)
                            .padding(.horizontal, TeddyTheme.screenPadding)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: TeddyTheme.spacingMD) {
                                ForEach(emocion.recomendaciones) { rec in
                                    recommendationCard(rec)
                                }
                            }
                            .padding(.horizontal, TeddyTheme.screenPadding)
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                    }
                    .iPadReadableWidth()
                }
                .padding(.bottom, TeddyTheme.spacingXXL)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        confettiCounter += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss()
                        }
                    }
                    .font(TeddyTheme.bodyBold())
                    .foregroundColor(TeddyTheme.primary)
                }
            }
            .teddyCelebration(counter: $confettiCounter, colors: [emocion.color, .white, emocion.color.opacity(0.5)])
        }
        .background {
            TeddyAnimatedBackground(emotion: emocion)
                .ignoresSafeArea()
        }
    }

    // MARK: - Recommendation Card

    private func recommendationCard(_ rec: Accion) -> some View {
        VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
            // Color strip top
            RoundedRectangle(cornerRadius: 2)
                .fill(emocion.color)
                .frame(height: 4)

            HStack(spacing: TeddyTheme.spacingSM) {
                ZStack {
                    Circle()
                        .fill(emocion.backgroundColor)
                        .frame(width: 40, height: 40)

                    Image(systemName: rec.icono)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(emocion.color)
                }

                Text(rec.texto)
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.textPrimary)
                    .lineLimit(2)
            }

            Text(rec.comoHacerlo)
                .font(TeddyTheme.body())
                .foregroundColor(TeddyTheme.textSecondary)
                .lineLimit(4)

            Spacer(minLength: 0)
        }
        .padding(TeddyTheme.cardPadding)
        .frame(width: 280)
        .frame(minHeight: 160)
        .elevatedCard()
    }
}

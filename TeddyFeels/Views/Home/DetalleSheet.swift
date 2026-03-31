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
                    // Header with bear
                    VStack(spacing: TeddyTheme.spacingMD) {
                        Image(emocion.imageName(for: bearVoice.selectedCharacter))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 160)

                        Text("Cuando me siento \(emocion.displayName(for: bearVoice.selectedCharacter).lowercased())")
                            .font(TeddyTheme.sectionTitle())
                            .foregroundColor(TeddyTheme.textPrimary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, TeddyTheme.spacingMD)

                    // Recommendations
                    VStack(spacing: TeddyTheme.spacingSM) {
                        ForEach(emocion.recomendaciones) { rec in
                            HStack(spacing: TeddyTheme.spacingMD) {
                                ZStack {
                                    Circle()
                                        .fill(emocion.backgroundColor)
                                        .frame(width: 44, height: 44)

                                    Image(systemName: rec.icono)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(emocion.color)
                                }

                                VStack(alignment: .leading, spacing: TeddyTheme.spacingXS) {
                                    Text(rec.texto)
                                        .font(TeddyTheme.cardTitle())
                                        .foregroundColor(TeddyTheme.textPrimary)

                                    Text(rec.comoHacerlo)
                                        .font(TeddyTheme.body())
                                        .foregroundColor(TeddyTheme.textSecondary)
                                }

                                Spacer()
                            }
                            .padding(TeddyTheme.cardPadding)
                            .background(TeddyTheme.glassFill)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
                            .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
                        }
                    }
                    .padding(.horizontal, TeddyTheme.screenPadding)
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
        .background { TeddyAnimatedBackground().ignoresSafeArea() }
    }
}

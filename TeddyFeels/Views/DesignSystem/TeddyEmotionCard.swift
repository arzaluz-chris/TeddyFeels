import SwiftUI

struct TeddyEmotionCard: View {
    let emocion: Emocion
    let isSelected: Bool
    let character: BearVoiceService.Character
    let action: () -> Void

    @State private var isPressed = false
    @State private var appeared = false
    @State private var glowPulse = false
    @Environment(\.colorScheme) private var colorScheme

    private var cardBackground: Color {
        if colorScheme == .dark {
            return emocion.color.opacity(isSelected ? 0.25 : 0.15)
        } else {
            return emocion.backgroundColor
        }
    }

    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        } label: {
            VStack(spacing: TeddyTheme.spacingSM) {
                Image(emocion.imageName(for: character))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68, height: 68)

                Text(emocion.displayName(for: character))
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.textPrimary)
            }
            .padding(.vertical, TeddyTheme.spacingSM)
            .frame(maxWidth: .infinity)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: TeddyTheme.cardRadius, style: .continuous)
                    .stroke(emocion.color.opacity(isSelected ? 0.7 : 0.3), lineWidth: isSelected ? 2.5 : 1)
            )
            // Radial glow behind the card when selected
            .background(
                RoundedRectangle(cornerRadius: TeddyTheme.cardRadius + 4, style: .continuous)
                    .fill(emocion.color.opacity(glowPulse ? 0.35 : 0.2))
                    .blur(radius: 12)
                    .scaleEffect(1.05)
                    .opacity(isSelected ? 1 : 0)
            )
            .shadow(
                color: isSelected ? emocion.color.opacity(0.4) : TeddyTheme.cardShadow.color,
                radius: isSelected ? 16 : TeddyTheme.cardShadow.radius,
                x: 0,
                y: isSelected ? 2 : TeddyTheme.cardShadow.y
            )
            .offset(y: isSelected ? -3 : 0)
        }
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(TeddyTheme.bounceSpring, value: isPressed)
        .animation(TeddyTheme.gentleSpring, value: isSelected)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .onAppear {
            withAnimation(TeddyTheme.gentleSpring) {
                appeared = true
            }
        }
        .onChange(of: isSelected) { _, selected in
            if selected {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    glowPulse = true
                }
            } else {
                glowPulse = false
            }
        }
    }
}

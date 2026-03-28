import SwiftUI

struct TeddyEmotionCard: View {
    let emocion: Emocion
    let isSelected: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        } label: {
            VStack(spacing: TeddyTheme.spacingSM) {
                Image(emocion.emotionImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)

                Text(emocion.rawValue)
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 145)
            .glassCard(tint: emocion.color, tintOpacity: isSelected ? 0.25 : 0.12)
            .shadow(
                color: isSelected ? emocion.color.opacity(0.4) : .clear,
                radius: isSelected ? 12 : 0,
                x: 0, y: 0
            )
            .overlay(
                RoundedRectangle(cornerRadius: TeddyTheme.cardRadius)
                    .stroke(isSelected ? emocion.color.opacity(0.6) : .clear, lineWidth: 2)
            )
        }
        .scaleEffect(isPressed ? 0.93 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.3), value: isSelected)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

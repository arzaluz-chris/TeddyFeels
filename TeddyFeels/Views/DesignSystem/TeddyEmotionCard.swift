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
                    .frame(width: 60, height: 60)

                Text(emocion.rawValue)
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(emocion.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: TeddyTheme.cardRadius)
                    .stroke(isSelected ? emocion.color : Color.clear, lineWidth: 3)
            )
            .shadow(color: emocion.color.opacity(0.15), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(isPressed ? 0.93 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

import SwiftUI

struct TeddyFloatingSOSButton: View {
    let action: () -> Void

    @State private var isPulsing = false

    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
            action()
        } label: {
            ZStack {
                // Pulsing outer ring
                Circle()
                    .fill(TeddyTheme.secondary.opacity(0.25))
                    .frame(width: 64, height: 64)
                    .scaleEffect(isPulsing ? 1.2 : 1.0)

                // Glass circle with red tint
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .fill(TeddyTheme.secondary.gradient.opacity(0.85))
                    )
                    .frame(width: 52, height: 52)
                    .shadow(color: TeddyTheme.secondary.opacity(0.4), radius: 8, x: 0, y: 4)

                Image(systemName: "bolt.shield.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

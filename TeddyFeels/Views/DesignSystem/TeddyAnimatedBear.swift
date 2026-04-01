import SwiftUI

struct TeddyAnimatedBear: View {
    let imageName: String
    var size: CGFloat = 120
    var style: AnimationStyle = .floating

    enum AnimationStyle {
        case floating   // Hover suave — banner, home hero
        case breathing  // Escala sutil — detalle, cards
        case bouncy     // Entrada con rebote — onboarding
        case idle       // Combinación floating + breathing + wobble
        case none       // Sin animación (fallback para reduceMotion)
    }

    @State private var breathingPhase = false
    @State private var floatingPhase = false
    @State private var wobblePhase = false
    @State private var bouncyAppeared = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            // Sombra difusa debajo del osito (no drop shadow — elipse blurred)
            Ellipse()
                .fill(.black.opacity(0.08))
                .frame(width: size * 0.6, height: size * 0.15)
                .blur(radius: 8)
                .offset(y: size * 0.48 + floatingOffset * 0.5)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(
                    x: bouncyScaleX,
                    y: breathingScale * bouncyScaleY
                )
                .offset(y: floatingOffset + bouncyOffset)
                .rotationEffect(.degrees(wobbleDegrees))
        }
        .frame(width: size, height: size * 1.1) // Extra space for shadow
        .onAppear {
            guard !reduceMotion else { return }
            startAnimations()
        }
    }

    // MARK: - Computed Animation Values

    private var breathingScale: CGFloat {
        guard style == .breathing || style == .idle else { return 1.0 }
        return breathingPhase ? 1.03 : 0.97
    }

    private var floatingOffset: CGFloat {
        guard style == .floating || style == .idle else { return 0 }
        return floatingPhase ? -4 : 4
    }

    private var wobbleDegrees: Double {
        guard style == .idle else { return 0 }
        return wobblePhase ? 1.5 : -1.5
    }

    private var bouncyScaleX: CGFloat {
        guard style == .bouncy else { return 1.0 }
        return bouncyAppeared ? 1.0 : 0.3
    }

    private var bouncyScaleY: CGFloat {
        guard style == .bouncy else { return 1.0 }
        return bouncyAppeared ? 1.0 : 0.3
    }

    private var bouncyOffset: CGFloat {
        guard style == .bouncy else { return 0 }
        return bouncyAppeared ? 0 : 60
    }

    // MARK: - Start Animations

    private func startAnimations() {
        switch style {
        case .floating:
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                floatingPhase = true
            }
        case .breathing:
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                breathingPhase = true
            }
        case .idle:
            // Duraciones distintas para movimiento orgánico
            withAnimation(.easeInOut(duration: 2.3).repeatForever(autoreverses: true)) {
                breathingPhase = true
            }
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                floatingPhase = true
            }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
                wobblePhase = true
            }
        case .bouncy:
            withAnimation(.spring(response: 0.6, dampingFraction: 0.55)) {
                bouncyAppeared = true
            }
            // After landing, start idle breathing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                    breathingPhase = true
                }
            }
        case .none:
            break
        }
    }
}

import SwiftUI
import ConfettiSwiftUI

struct PositividadView: View {
    @State private var vm = PositividadViewModel()
    @State private var confettiCounter = 0

    private var bearImage: String {
        if vm.negativeCount == 0 && vm.positiveCount == 0 { return "oso_Positivo" }
        return vm.ratio >= 3 ? "oso_Feliz" : "oso_Triste"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: TeddyTheme.spacingMD) {
                TeddyBearBanner(
                    imageName: bearImage,
                    message: vm.ratio >= 3 ? "¡Excelente! Estás en equilibrio." : "Aprende a balancear tus emociones con un juego",
                    imageSize: 100
                )

                researchCard(title: "¿Qué es la Regla 3:1?", content: "Según la doctora Barbara Fredrickson, necesitamos al menos 3 emociones positivas por cada 1 negativa para sentirnos bien y crecer.")

                researchCard(title: "¿Por qué es importante?", content: "Si tu ratio es 3:1 o más, ¡floreces! Eres más feliz, resiliente y creativo. Aunque el número exacto ha sido discutido, la idea principal es: ¡más positivo que negativo!")

                // Seesaw game
                TeddyCard(accentColor: TeddyTheme.EmotionColor.esperanzado) {
                    VStack(spacing: TeddyTheme.spacingMD) {
                        Text("¡Balancea el Oso!")
                            .font(TeddyTheme.sectionTitle())
                            .foregroundColor(TeddyTheme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("Intenta llegar a 3 positivas por cada negativa")
                            .font(TeddyTheme.body())
                            .foregroundColor(TeddyTheme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Seesaw visualization
                        SeesawView(
                            ratio: vm.ratio,
                            positiveCount: vm.positiveCount,
                            negativeCount: vm.negativeCount,
                            isBalanced: vm.ratio >= 3 && vm.negativeCount > 0
                        )
                        .frame(height: 160)

                        // Buttons
                        HStack(spacing: TeddyTheme.spacingSM) {
                            Button {
                                vm.addNegative()
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "minus.circle.fill")
                                    Text("Negativa")
                                }
                                .font(TeddyTheme.bodyBold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(TeddyTheme.secondary)
                                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                            }

                            Button {
                                vm.addPositive()
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                if vm.ratio >= 3 {
                                    confettiCounter += 1
                                    let notif = UINotificationFeedbackGenerator()
                                    notif.notificationOccurred(.success)
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Positiva")
                                }
                                .font(TeddyTheme.bodyBold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(TeddyTheme.primary)
                                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                            }
                        }

                        // Score and message
                        HStack {
                            Label("\(vm.negativeCount)", systemImage: "arrow.down.circle.fill")
                                .foregroundColor(TeddyTheme.secondary)
                            Spacer()
                            Text(vm.message)
                                .foregroundColor(vm.ratio >= 3 ? TeddyTheme.success : TeddyTheme.warning)
                            Spacer()
                            Label("\(vm.positiveCount)", systemImage: "arrow.up.circle.fill")
                                .foregroundColor(TeddyTheme.success)
                        }
                        .font(TeddyTheme.caption())

                        TeddyButton(title: "Reiniciar Juego", icon: "arrow.counterclockwise", style: .secondary) {
                            vm.reset()
                        }
                    }
                }
            }
            .padding(.horizontal, TeddyTheme.screenPadding)
            .padding(.top, TeddyTheme.spacingMD)
            .padding(.bottom, 100)
        }
        .background { TeddyAnimatedBackground().ignoresSafeArea() }
        .navigationTitle("La Regla 3:1")
        .teddyCelebration(counter: $confettiCounter)
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

// MARK: - Seesaw Physics View

struct SeesawView: View {
    let ratio: Double
    let positiveCount: Int
    let negativeCount: Int
    let isBalanced: Bool

    /// Tilt angle in degrees: negative = left down, positive = right down
    /// When ratio >= 3, balanced (0°). Otherwise tilts based on imbalance.
    private var tiltAngle: Double {
        let total = positiveCount + negativeCount
        guard total > 0, negativeCount > 0 else {
            if positiveCount > 0 { return -12 } // All positive, left side heavy
            return 0 // Empty
        }
        if ratio >= 3 { return 0 } // Balanced
        // Ratio < 3: tilt right (too many negatives relative to positives)
        // Map ratio 0...3 to angle 15..0
        let clamped = min(ratio, 3.0)
        return (3.0 - clamped) * 5 // 0→15°, 1→10°, 2→5°, 3→0°
    }

    /// Bear position along the bar: -1 (left) to 1 (right), 0 = center
    private var bearPosition: Double {
        let total = positiveCount + negativeCount
        guard total > 0 else { return 0 }
        if isBalanced { return 0 }
        // Slide toward the low side (like gravity on the tilted bar)
        let pos = tiltAngle / 15.0 // Normalize to -1...1
        return min(1, max(-1, pos * 0.8))
    }

    var body: some View {
        GeometryReader { geo in
            let barWidth = geo.size.width - 40
            let centerX = geo.size.width / 2
            let barY = geo.size.height * 0.65

            ZStack {
                // Fulcrum (triangle)
                Path { path in
                    let triW: CGFloat = 30
                    let triH: CGFloat = 24
                    path.move(to: CGPoint(x: centerX - triW / 2, y: barY + 6))
                    path.addLine(to: CGPoint(x: centerX, y: barY - triH + 6))
                    path.addLine(to: CGPoint(x: centerX + triW / 2, y: barY + 6))
                    path.closeSubpath()
                }
                .fill(TeddyTheme.textTertiary.opacity(0.4))

                // Bar
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [TeddyTheme.secondary.opacity(0.6), TeddyTheme.primary.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: barWidth, height: 8)
                    .position(x: centerX, y: barY)
                    .rotationEffect(.degrees(tiltAngle), anchor: .center)

                // Negative label (left end of bar)
                Text("−")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(TeddyTheme.secondary)
                    .position(
                        x: centerX - barWidth / 2 + 10,
                        y: barY - 20
                    )
                    .rotationEffect(.degrees(tiltAngle), anchor: UnitPoint(x: 0.5, y: 1))

                // Positive label (right end of bar)
                Text("+")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(TeddyTheme.success)
                    .position(
                        x: centerX + barWidth / 2 - 10,
                        y: barY - 20
                    )
                    .rotationEffect(.degrees(tiltAngle), anchor: UnitPoint(x: 0.5, y: 1))

                // Bear on the bar
                let bearX = centerX + (barWidth / 2 - 30) * CGFloat(bearPosition)
                let bearOffsetY = sin(CGFloat(tiltAngle) * .pi / 180) * (barWidth / 2) * CGFloat(bearPosition)

                Image("oso_Positivo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .position(x: bearX, y: barY - 44 + bearOffsetY)
                    .animation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.3), value: bearPosition)

                // Balance indicator
                if isBalanced {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(TeddyTheme.success)
                        .position(x: centerX, y: barY + 30)
                        .transition(.scale.combined(with: .opacity))
                }

                // Ground line
                Path { path in
                    path.move(to: CGPoint(x: 20, y: barY + 8))
                    path.addLine(to: CGPoint(x: geo.size.width - 20, y: barY + 8))
                }
                .stroke(TeddyTheme.border, lineWidth: 2)
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: tiltAngle)
        }
    }
}

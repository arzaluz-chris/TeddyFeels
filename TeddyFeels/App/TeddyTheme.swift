import SwiftUI

enum TeddyTheme {
    // MARK: - Colors
    static let primary = Color(hex: "6C63FF")
    static let primaryLight = Color(hex: "8B83FF")
    static let secondary = Color(hex: "FF6B6B")
    static let background = Color(hex: "F8F7FC")
    static let surface = Color.white
    static let textPrimary = Color(hex: "1A1A2E")
    static let textSecondary = Color(hex: "6B7280")
    static let textTertiary = Color(hex: "9CA3AF")
    static let success = Color(hex: "22C55E")
    static let warning = Color(hex: "F59E0B")
    static let border = Color(hex: "E5E7EB")

    // MARK: - Gradient Background
    static let gradientTop = Color(hex: "FFE5EC")       // Rosa pastel
    static let gradientBottom = Color(hex: "E8E0FF")     // Lavanda
    static let gradientAccent1 = Color(hex: "FFC371")    // Coral del playground
    static let gradientAccent2 = Color(hex: "81FFEF")    // Cyan del playground
    static let gradientAccent3 = Color(hex: "F067B4")    // Magenta del playground

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [gradientTop, gradientBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Glass Properties
    static let glassFill = Color.white.opacity(0.55)
    static let glassBorderColors: [Color] = [
        .white.opacity(0.6), .white.opacity(0.1), .white.opacity(0.3)
    ]
    static let glassBorderWidth: CGFloat = 1.5

    // MARK: - Emotion Pastels
    enum EmotionColor {
        static let feliz = Color(hex: "4ADE80")
        static let triste = Color(hex: "60A5FA")
        static let enojado = Color(hex: "F87171")
        static let ansioso = Color(hex: "FB923C")
        static let estresado = Color(hex: "A78BFA")
        static let confundido = Color(hex: "9CA3AF")
        static let esperanzado = Color(hex: "FBBF24")
        static let agradecido = Color(hex: "818CF8")
        static let orgulloso = Color(hex: "F472B6")

        static let felizBg = Color(hex: "ECFDF5")
        static let tristeBg = Color(hex: "EFF6FF")
        static let enojadoBg = Color(hex: "FEF2F2")
        static let ansiosoBg = Color(hex: "FFF7ED")
        static let estresadoBg = Color(hex: "F5F3FF")
        static let confundidoBg = Color(hex: "F9FAFB")
        static let esperanzadoBg = Color(hex: "FFFBEB")
        static let agradecidoBg = Color(hex: "EEF2FF")
        static let orgullosoBg = Color(hex: "FDF2F8")
    }

    // MARK: - Typography
    static func heroTitle() -> Font {
        .system(size: 34, weight: .black, design: .rounded)
    }
    static func screenTitle() -> Font {
        .system(size: 28, weight: .bold, design: .rounded)
    }
    static func sectionTitle() -> Font {
        .system(size: 22, weight: .bold, design: .rounded)
    }
    static func cardTitle() -> Font {
        .system(size: 17, weight: .semibold, design: .rounded)
    }
    static func body() -> Font {
        .system(size: 16, weight: .regular, design: .rounded)
    }
    static func bodyBold() -> Font {
        .system(size: 16, weight: .semibold, design: .rounded)
    }
    static func caption() -> Font {
        .system(size: 13, weight: .medium, design: .rounded)
    }
    static func badge() -> Font {
        .system(size: 11, weight: .bold, design: .rounded)
    }

    // MARK: - Spacing
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 48
    static let cardPadding: CGFloat = 20
    static let screenPadding: CGFloat = 20

    // MARK: - Shadows
    static let cardShadow = Shadow(color: .black.opacity(0.12), radius: 15, y: 6)
    static let elevatedShadow = Shadow(color: .black.opacity(0.15), radius: 20, y: 8)

    // MARK: - Corner Radius
    static let cardRadius: CGFloat = 25
    static let buttonRadius: CGFloat = 16
    static let smallRadius: CGFloat = 12

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let y: CGFloat
    }
}

// MARK: - Animated Background View

struct TeddyAnimatedBackground: View {
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            TeddyTheme.backgroundGradient

            // Decorative floating blurred circles
            Circle()
                .fill(TeddyTheme.gradientAccent1.opacity(0.25))
                .frame(width: 200, height: 200)
                .blur(radius: 60)
                .offset(x: animate ? -30 : -60, y: animate ? -80 : -120)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            Circle()
                .fill(TeddyTheme.gradientAccent2.opacity(0.2))
                .frame(width: 250, height: 250)
                .blur(radius: 70)
                .offset(x: animate ? 40 : 70, y: animate ? 100 : 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            Circle()
                .fill(TeddyTheme.gradientAccent3.opacity(0.15))
                .frame(width: 180, height: 180)
                .blur(radius: 55)
                .offset(x: animate ? -20 : 20, y: animate ? 50 : 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .ignoresSafeArea()
        .drawingGroup()
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Glass Card Modifier

struct GlassCardModifier: ViewModifier {
    var tintColor: Color = .clear
    var tintOpacity: Double = 0.12

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        if reduceTransparency {
            content
                .background(Color.white.opacity(0.95))
                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
                .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
        } else {
            content
                .background(
                    ZStack {
                        TeddyTheme.glassFill
                        tintColor.opacity(tintOpacity)
                    }
                )
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: TeddyTheme.cardRadius)
                        .stroke(
                            LinearGradient(
                                colors: TeddyTheme.glassBorderColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: TeddyTheme.glassBorderWidth
                        )
                )
                .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
        }
    }
}

extension View {
    func glassCard(tint: Color = .clear, tintOpacity: Double = 0.12) -> some View {
        modifier(GlassCardModifier(tintColor: tint, tintOpacity: tintOpacity))
    }
}

import SwiftUI

enum TeddyTheme {
    // MARK: - Adaptive Colors (Light / Dark)

    static let primary = Color(hex: "6C63FF")
    static let primaryLight = Color(hex: "8B83FF")
    static let secondary = Color(hex: "FF6B6B")
    static let success = Color(hex: "22C55E")
    static let warning = Color(hex: "F59E0B")

    static let background = Color(light: "F8F7FC", dark: "0F0A1E")
    static let surface = Color(light: "FFFFFF", dark: "1E1B2E")
    static let textPrimary = Color(light: "1A1A2E", dark: "F5F5F7")
    static let textSecondary = Color(light: "6B7280", dark: "A1A1AA")
    static let textTertiary = Color(light: "9CA3AF", dark: "6B6B78")
    static let border = Color(light: "E5E7EB", dark: "2A2735")

    // MARK: - Gradient Background (Adaptive)

    static let gradientTop = Color(light: "FFE5EC", dark: "0F0A1E")
    static let gradientBottom = Color(light: "E8E0FF", dark: "1A1035")
    static let gradientAccent1 = Color(hex: "FFC371")    // Coral
    static let gradientAccent2 = Color(hex: "81FFEF")    // Cyan
    static let gradientAccent3 = Color(hex: "F067B4")    // Magenta

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [gradientTop, gradientBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Glass Properties (Adaptive)

    static let glassFillLight = Color.white.opacity(0.55)
    static let glassFillDark = Color.white.opacity(0.08)
    /// Adaptive glass fill — use in views that read colorScheme
    static let glassFill = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.08)
            : UIColor.white.withAlphaComponent(0.55)
    })
    static let glassBorderWidth: CGFloat = 1.5

    // MARK: - Emotion Colors (same in both modes — vibrant enough)

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

        // Light backgrounds (adaptive)
        static let felizBg = Color(light: "ECFDF5", dark: "0D2818")
        static let tristeBg = Color(light: "EFF6FF", dark: "0D1A2E")
        static let enojadoBg = Color(light: "FEF2F2", dark: "2E0D0D")
        static let ansiosoBg = Color(light: "FFF7ED", dark: "2E1A0D")
        static let estresadoBg = Color(light: "F5F3FF", dark: "1A0D2E")
        static let confundidoBg = Color(light: "F9FAFB", dark: "1A1A1E")
        static let esperanzadoBg = Color(light: "FFFBEB", dark: "2E2A0D")
        static let agradecidoBg = Color(light: "EEF2FF", dark: "0D102E")
        static let orgullosoBg = Color(light: "FDF2F8", dark: "2E0D1E")
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

// MARK: - Adaptive Color Helper

extension Color {
    /// Creates an adaptive color from light and dark hex values
    init(light: String, dark: String) {
        self.init(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(Color(hex: dark))
                : UIColor(Color(hex: light))
        })
    }
}

// MARK: - Animated Background View

struct TeddyAnimatedBackground: View {
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    private var accentOpacity1: Double { colorScheme == .dark ? 0.15 : 0.25 }
    private var accentOpacity2: Double { colorScheme == .dark ? 0.10 : 0.20 }
    private var accentOpacity3: Double { colorScheme == .dark ? 0.12 : 0.15 }

    var body: some View {
        ZStack {
            TeddyTheme.backgroundGradient

            Circle()
                .fill(TeddyTheme.gradientAccent1.opacity(accentOpacity1))
                .frame(width: 200, height: 200)
                .blur(radius: 60)
                .offset(x: animate ? -30 : -60, y: animate ? -80 : -120)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            Circle()
                .fill(TeddyTheme.gradientAccent2.opacity(accentOpacity2))
                .frame(width: 250, height: 250)
                .blur(radius: 70)
                .offset(x: animate ? 40 : 70, y: animate ? 100 : 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            Circle()
                .fill(TeddyTheme.gradientAccent3.opacity(accentOpacity3))
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
    @Environment(\.colorScheme) private var colorScheme

    private var glassFill: Color {
        colorScheme == .dark ? TeddyTheme.glassFillDark : TeddyTheme.glassFillLight
    }

    private var glassBorderColors: [Color] {
        let base: Double = colorScheme == .dark ? 0.15 : 0.6
        return [
            .white.opacity(base),
            .white.opacity(base * 0.15),
            .white.opacity(base * 0.5)
        ]
    }

    func body(content: Content) -> some View {
        if reduceTransparency {
            content
                .background(TeddyTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
                .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
        } else {
            content
                .background(
                    ZStack {
                        glassFill
                        tintColor.opacity(tintOpacity)
                    }
                )
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: TeddyTheme.cardRadius)
                        .stroke(
                            LinearGradient(
                                colors: glassBorderColors,
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

    /// Constrains content width on iPad for better readability
    func iPadReadableWidth() -> some View {
        modifier(iPadReadableWidthModifier())
    }
}

// MARK: - iPad Readable Width

struct iPadReadableWidthModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        if sizeClass == .regular {
            content
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
        } else {
            content
        }
    }
}

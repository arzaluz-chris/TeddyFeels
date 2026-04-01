import SwiftUI

enum TeddyTheme {
    // MARK: - Core Brand Colors

    static let primary = Color(hex: "6C63FF")
    static let primaryLight = Color(hex: "8B83FF")
    static let accent = Color(hex: "FF8A5C")       // Coral cálido — secundario de marca
    static let accentLight = Color(hex: "FFBA93")
    static let secondary = Color(hex: "FF6B6B")
    static let success = Color(hex: "22C55E")
    static let warning = Color(hex: "F59E0B")

    // MARK: - Adaptive Colors (Light / Dark)

    static let background = Color(light: "FFF8F3", dark: "0F0A1E")    // Crema cálido
    static let surface = Color(light: "FFFCF9", dark: "1E1B2E")       // Blanco cálido
    static let textPrimary = Color(light: "1A1A2E", dark: "F5F5F7")
    static let textSecondary = Color(light: "6B7280", dark: "A1A1AA")
    static let textTertiary = Color(light: "9CA3AF", dark: "6B6B78")
    static let border = Color(light: "E5E7EB", dark: "2A2735")

    // MARK: - Gradient Background (Adaptive)

    static let gradientTop = Color(light: "FFF0E6", dark: "0F0A1E")     // Durazno suave
    static let gradientBottom = Color(light: "F0E6FF", dark: "1A1035")   // Lavanda
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
        .system(size: 40, weight: .black, design: .rounded)
    }
    static func screenTitle() -> Font {
        .system(size: 28, weight: .bold, design: .rounded)
    }
    static func sectionTitle() -> Font {
        .system(size: 20, weight: .bold, design: .rounded)
    }
    static func cardTitle() -> Font {
        .system(size: 15, weight: .semibold, design: .rounded)
    }
    static func body() -> Font {
        .system(size: 16, weight: .regular, design: .rounded)
    }
    static func bodyBold() -> Font {
        .system(size: 16, weight: .semibold, design: .rounded)
    }
    static func caption() -> Font {
        .system(size: 12, weight: .medium, design: .rounded)
    }
    static func badge() -> Font {
        .system(size: 11, weight: .bold, design: .rounded)
    }
    static func jumboScore() -> Font {
        .system(size: 48, weight: .black, design: .rounded)
    }

    // MARK: - Spacing

    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 48
    static let spacingHuge: CGFloat = 64
    static let cardPadding: CGFloat = 20
    static let screenPadding: CGFloat = 20

    // MARK: - Shadows

    static let cardShadow = Shadow(color: .black.opacity(0.10), radius: 12, y: 4)
    static let elevatedShadow = Shadow(color: .black.opacity(0.15), radius: 20, y: 8)
    static let glowShadow = Shadow(color: .black.opacity(0.06), radius: 24, y: 0)

    // MARK: - Corner Radius

    static let cardRadius: CGFloat = 22
    static let cardRadiusLG: CGFloat = 28
    static let buttonRadius: CGFloat = 16
    static let smallRadius: CGFloat = 12

    // MARK: - Animation Tokens

    static let bounceSpring = Animation.spring(response: 0.4, dampingFraction: 0.5)
    static let gentleSpring = Animation.spring(response: 0.6, dampingFraction: 0.7)
    static let snappySpring = Animation.spring(response: 0.25, dampingFraction: 0.65)
    static let floatingLoop = Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)
    static let breathingLoop = Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true)

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let y: CGFloat
    }
}

// MARK: - Adaptive Color Helper

extension Color {
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
    var emotion: Emocion? = nil
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    private var accentOpacity1: Double { colorScheme == .dark ? 0.15 : 0.25 }
    private var accentOpacity2: Double { colorScheme == .dark ? 0.10 : 0.20 }
    private var accentOpacity3: Double { colorScheme == .dark ? 0.12 : 0.15 }

    private var emotionBlend: Color {
        emotion?.color.opacity(0.15) ?? .clear
    }

    var body: some View {
        ZStack {
            // Base gradient, blended with emotion color when set
            TeddyTheme.backgroundGradient

            emotionBlend

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
        .animation(.easeInOut(duration: 1.5), value: emotion)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Solid Card Modifier (replaces glassCard as default)

struct SolidCardModifier: ViewModifier {
    var color: Color
    var cornerRadius: CGFloat = TeddyTheme.cardRadius

    func body(content: Content) -> some View {
        content
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: TeddyTheme.cardShadow.color,
                radius: TeddyTheme.cardShadow.radius,
                x: 0,
                y: TeddyTheme.cardShadow.y
            )
    }
}

// MARK: - Elevated Card Modifier

struct ElevatedCardModifier: ViewModifier {
    var cornerRadius: CGFloat = TeddyTheme.cardRadius

    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(TeddyTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: TeddyTheme.elevatedShadow.color,
                radius: TeddyTheme.elevatedShadow.radius,
                x: 0,
                y: TeddyTheme.elevatedShadow.y
            )
    }
}

// MARK: - Glass Card Modifier (retained for floating overlays only)

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
    func solidCard(color: Color, cornerRadius: CGFloat = TeddyTheme.cardRadius) -> some View {
        modifier(SolidCardModifier(color: color, cornerRadius: cornerRadius))
    }

    func elevatedCard(cornerRadius: CGFloat = TeddyTheme.cardRadius) -> some View {
        modifier(ElevatedCardModifier(cornerRadius: cornerRadius))
    }

    func glassCard(tint: Color = .clear, tintOpacity: Double = 0.12) -> some View {
        modifier(GlassCardModifier(tintColor: tint, tintOpacity: tintOpacity))
    }

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

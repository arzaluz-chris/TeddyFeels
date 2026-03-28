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
    static let cardShadow = Shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    static let elevatedShadow = Shadow(color: .black.opacity(0.1), radius: 20, y: 8)

    // MARK: - Corner Radius
    static let cardRadius: CGFloat = 20
    static let buttonRadius: CGFloat = 16
    static let smallRadius: CGFloat = 12

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let y: CGFloat
    }
}

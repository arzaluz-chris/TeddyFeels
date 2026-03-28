import SwiftUI

struct TeddyCard<Content: View>: View {
    var accentColor: Color? = nil
    var padding: CGFloat = TeddyTheme.cardPadding
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack(spacing: 0) {
            if let accent = accentColor {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accent)
                    .frame(width: 4)
                    .padding(.vertical, 8)
            }

            content()
                .padding(padding)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .glassCard(tint: accentColor ?? .clear, tintOpacity: accentColor != nil ? 0.08 : 0)
    }
}

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
        .background(TeddyTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
        .shadow(
            color: TeddyTheme.cardShadow.color,
            radius: TeddyTheme.cardShadow.radius,
            x: 0,
            y: TeddyTheme.cardShadow.y
        )
    }
}

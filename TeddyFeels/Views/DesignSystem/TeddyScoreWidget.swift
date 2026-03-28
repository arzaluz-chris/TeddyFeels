import SwiftUI

struct TeddyScoreWidget: View {
    let score: Double
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: TeddyTheme.spacingMD) {
                // Circular progress ring
                ZStack {
                    Circle()
                        .stroke(TeddyTheme.border, lineWidth: 6)

                    Circle()
                        .trim(from: 0, to: score / 100)
                        .stroke(
                            TeddyTheme.primary,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.8), value: score)

                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(TeddyTheme.primary)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Tu Energía Mental")
                        .font(TeddyTheme.caption())
                        .foregroundColor(TeddyTheme.textSecondary)

                    Text("\(Int(score))%")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(TeddyTheme.textPrimary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(TeddyTheme.textTertiary)
            }
            .padding(TeddyTheme.cardPadding)
            .background(TeddyTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.cardRadius))
            .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
        }
        .buttonStyle(.plain)
    }
}

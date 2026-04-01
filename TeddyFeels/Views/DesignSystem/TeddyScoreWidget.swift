import SwiftUI

struct TeddyScoreWidget: View {
    let score: Double
    var onTap: (() -> Void)? = nil

    @State private var animatedScore: Double = 0

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: TeddyTheme.spacingMD) {
                // Score number — bold and prominent
                Text("\(Int(animatedScore))%")
                    .font(TeddyTheme.jumboScore())
                    .foregroundColor(TeddyTheme.primary)
                    .contentTransition(.numericText())

                VStack(alignment: .leading, spacing: TeddyTheme.spacingXS) {
                    Text("Tu Energía Mental")
                        .font(TeddyTheme.caption())
                        .foregroundColor(TeddyTheme.textSecondary)

                    // Horizontal bar instead of circular ring
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(TeddyTheme.border)
                                .frame(height: 10)

                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [TeddyTheme.primary, TeddyTheme.accent],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * (animatedScore / 100), height: 10)
                                .shadow(color: TeddyTheme.primary.opacity(0.4), radius: 4, y: 0)
                        }
                    }
                    .frame(height: 10)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(TeddyTheme.textTertiary)
            }
            .padding(TeddyTheme.cardPadding)
            .elevatedCard()
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.spring(response: 0.8)) {
                animatedScore = score
            }
        }
        .onChange(of: score) { _, newValue in
            withAnimation(.spring(response: 0.8)) {
                animatedScore = newValue
            }
        }
    }
}

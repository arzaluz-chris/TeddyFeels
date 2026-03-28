import SwiftUI

struct TeddyBearBanner: View {
    let imageName: String
    let message: String
    var imageSize: CGFloat = 120
    var onTap: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: TeddyTheme.spacingMD) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .onTapGesture { onTap?() }

            VStack(alignment: .leading, spacing: TeddyTheme.spacingXS) {
                Text(message)
                    .font(TeddyTheme.body())
                    .foregroundColor(TeddyTheme.textPrimary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, TeddyTheme.spacingSM)

            Spacer(minLength: 0)
        }
        .padding(TeddyTheme.cardPadding)
        .glassCard(tint: TeddyTheme.primary, tintOpacity: 0.05)
    }
}

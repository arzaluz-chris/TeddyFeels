import SwiftUI

struct TeddyBearBanner: View {
    let imageName: String
    let message: String
    var imageSize: CGFloat = 140
    var onTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: TeddyTheme.spacingSM) {
            // Bear centered with floating animation
            TeddyAnimatedBear(
                imageName: imageName,
                size: imageSize,
                style: .idle
            )
            .onTapGesture { onTap?() }

            // Greeting text centered
            Text(message)
                .font(TeddyTheme.bodyBold())
                .foregroundColor(TeddyTheme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, TeddyTheme.spacingMD)
    }
}

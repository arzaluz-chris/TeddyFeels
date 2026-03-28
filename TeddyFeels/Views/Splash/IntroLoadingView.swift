import SwiftUI

struct IntroLoadingView: View {
    @Binding var welcome: Bool
    var isColdStart: Bool = true

    @State private var scale = 0.5
    @State private var opacity = 0.0
    @State private var isPulsing = false

    private var duration: Double {
        isColdStart ? 2.5 : 1.2
    }

    var body: some View {
        ZStack {
            TeddyAnimatedBackground()

            VStack(spacing: TeddyTheme.spacingXL) {
                HStack {
                    Spacer()
                    Image("oso_Escuela")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .scaleEffect(scale)
                        .scaleEffect(isPulsing ? 1.05 : 1.0)
                }
                .padding(.trailing, -60)

                Text("TEDDY FEELS")
                    .font(TeddyTheme.heroTitle())
                    .foregroundColor(TeddyTheme.primary)
                    .opacity(opacity)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Reset state for re-shows
            scale = 0.5
            opacity = 0.0
            isPulsing = false

            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
            }
            withAnimation(.easeIn(duration: 0.4).delay(0.2)) {
                opacity = 1.0
            }
            if isColdStart {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.8)) {
                    isPulsing = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    welcome = true
                }
            }
        }
    }
}

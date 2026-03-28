import SwiftUI

struct IntroLoadingView: View {
    @Binding var welcome: Bool
    @State private var scale = 0.5
    @State private var opacity = 0.0
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            TeddyTheme.background.ignoresSafeArea()

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
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }
            withAnimation(.easeIn(duration: 0.8).delay(0.3)) {
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(1.0)) {
                isPulsing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    welcome = true
                }
            }
        }
    }
}

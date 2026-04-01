import SwiftUI
import Vortex

struct IntroLoadingView: View {
    @Binding var welcome: Bool
    var isColdStart: Bool = true

    // Title staggered
    @State private var titleProgress: Int = 0
    @State private var subtitleOpacity: Double = 0

    // Carousel
    @State private var carouselOffset: CGFloat = 0
    @State private var showCarousel = false

    // Exit
    @State private var exitScale: CGFloat = 1.0
    @State private var exitOpacity: Double = 1.0

    private let titleText = Array("TEDDY FEELS")

    // Positive emotions only for the splash
    private static let positiveEmotions: [Emocion] = [
        .feliz, .esperanzado, .agradecido, .orgulloso
    ]

    private let carouselImages: [String] = {
        positiveEmotions.map { emocion in
            let useDani = Bool.random()
            return emocion.imageName(for: useDani ? .dani : .dan)
        }
    }()

    // Triple the array for seamless scroll
    private var extendedImages: [String] {
        carouselImages + carouselImages + carouselImages
    }

    private var duration: Double {
        isColdStart ? 3.2 : 1.2
    }

    var body: some View {
        ZStack {
            TeddyAnimatedBackground()

            // Sparkle particles
            VortexView(.splash) {
                Circle()
                    .fill(.white)
                    .frame(width: 4, height: 4)
                    .blur(radius: 1)
                    .tag("spark")
            }
            .allowsHitTesting(false)

            VStack(spacing: TeddyTheme.spacingLG) {
                Spacer()

                // Title — staggered letter animation
                HStack(spacing: 3) {
                    ForEach(Array(titleText.enumerated()), id: \.offset) { index, char in
                        Text(String(char))
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(TeddyTheme.primary)
                            .opacity(index < titleProgress ? 1 : 0)
                            .offset(y: index < titleProgress ? 0 : -20)
                            .animation(
                                .spring(response: 0.35, dampingFraction: 0.6)
                                    .delay(Double(index) * 0.04),
                                value: titleProgress
                            )
                    }
                }

                // Subtitle
                Text("Tu amigo emocional")
                    .font(TeddyTheme.body())
                    .foregroundColor(TeddyTheme.textSecondary)
                    .opacity(subtitleOpacity)

                // Emotion carousel — below text, large and centered
                if showCarousel {
                    emotionCarousel
                        .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }

                Spacer()
            }
        }
        .scaleEffect(exitScale)
        .opacity(exitOpacity)
        .ignoresSafeArea()
        .onAppear {
            if isColdStart {
                coldStartSequence()
            } else {
                warmStartSequence()
            }
        }
    }

    // MARK: - Emotion Carousel

    private var emotionCarousel: some View {
        let imageSize: CGFloat = 140
        let spacing: CGFloat = 24
        let totalWidth = CGFloat(carouselImages.count) * (imageSize + spacing)

        return GeometryReader { _ in
            HStack(spacing: spacing) {
                ForEach(Array(extendedImages.enumerated()), id: \.offset) { _, img in
                    Image(img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                }
            }
            .offset(x: carouselOffset)
            .onAppear {
                carouselOffset = 0
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    carouselOffset = -totalWidth
                }
            }
        }
        .frame(height: imageSize)
        .clipped()
    }

    // MARK: - Cold Start

    private func coldStartSequence() {
        // 1. Show carousel immediately with scale
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(TeddyTheme.gentleSpring) {
                showCarousel = true
            }
        }

        // 2. Title appears letter by letter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            titleProgress = titleText.count
        }

        // 3. Subtitle fades in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeIn(duration: 0.4)) {
                subtitleOpacity = 1.0
            }
        }

        // 4. Exit with scale-down + fade
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut(duration: 0.5)) {
                exitScale = 0.92
                exitOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                welcome = true
            }
        }
    }

    // MARK: - Warm Start

    private func warmStartSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(TeddyTheme.snappySpring) {
                showCarousel = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            titleProgress = titleText.count
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeIn(duration: 0.2)) {
                subtitleOpacity = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut(duration: 0.3)) {
                exitScale = 0.95
                exitOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                welcome = true
            }
        }
    }
}

// MARK: - Vortex Splash Preset

extension VortexSystem {
    static let splash: VortexSystem = {
        var system = VortexSystem(tags: ["spark"])
        system.position = [0.5, 0.8]
        system.shape = .box(width: 1.0, height: 0.1)
        system.birthRate = 8
        system.lifespan = 4
        system.speed = 0.15
        system.speedVariation = 0.1
        system.angle = .degrees(270)
        system.angleRange = .degrees(40)
        system.size = 0.04
        system.sizeVariation = 0.02
        system.sizeMultiplierAtDeath = 0
        system.colors = .random(
            VortexSystem.Color(red: 1.0, green: 0.54, blue: 0.36, opacity: 0.6),
            VortexSystem.Color(red: 0.55, green: 0.51, blue: 1.0, opacity: 0.5),
            VortexSystem.Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4),
            VortexSystem.Color(red: 0.96, green: 0.62, blue: 0.04, opacity: 0.4)
        )
        return system
    }()
}

import SwiftUI
import ConfettiSwiftUI

struct TeddyCelebration: ViewModifier {
    @Binding var counter: Int
    var colors: [Color] = [.green, .yellow, .blue, .purple, .pink, .orange]

    func body(content: Content) -> some View {
        content
            .confettiCannon(
                counter: $counter,
                num: 40,
                colors: colors,
                confettiSize: 12,
                rainHeight: 500,
                radius: 350
            )
    }
}

extension View {
    func teddyCelebration(counter: Binding<Int>, colors: [Color] = [.green, .yellow, .blue, .purple, .pink, .orange]) -> some View {
        self.modifier(TeddyCelebration(counter: counter, colors: colors))
    }
}

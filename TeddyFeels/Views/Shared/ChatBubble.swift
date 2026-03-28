import SwiftUI

struct ChatBubble: Shape {
    enum Direction { case left, right }
    var direction: Direction

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 15, height: 15))
        return path
    }
}

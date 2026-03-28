import SwiftUI

struct TeddyButton: View {
    let title: String
    var icon: String? = nil
    var style: ButtonStyle = .primary
    let action: () -> Void

    @State private var isPressed = false

    enum ButtonStyle {
        case primary
        case secondary
        case destructive
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return TeddyTheme.primary
        case .secondary: return TeddyTheme.primary.opacity(0.1)
        case .destructive: return TeddyTheme.secondary
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return TeddyTheme.primary
        case .destructive: return .white
        }
    }

    var body: some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        } label: {
            HStack(spacing: TeddyTheme.spacingSM) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(TeddyTheme.bodyBold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, TeddyTheme.cardPadding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

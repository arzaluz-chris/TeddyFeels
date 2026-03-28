import SwiftUI

struct TeddySectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(TeddyTheme.sectionTitle())
                .foregroundColor(TeddyTheme.textPrimary)

            Spacer()

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(TeddyTheme.caption())
                        .foregroundColor(TeddyTheme.primaryLight)
                }
            }
        }
    }
}

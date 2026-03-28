import SwiftUI

struct SecretPasswordView: View {
    @Environment(PINService.self) private var pinService
    let title: String
    let subtitle: String
    let bearImage: String
    let onSuccess: () -> Void

    var body: some View {
        if !pinService.isSetup {
            PINSetupView(bearImage: bearImage) {
                onSuccess()
            }
        } else {
            PINEntryView(
                title: title,
                subtitle: subtitle,
                bearImage: bearImage,
                onSuccess: onSuccess
            )
        }
    }
}

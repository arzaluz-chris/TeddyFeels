import SwiftUI

/// Parental gate required by Apple for kids apps before external links,
/// phone calls, or any action that leaves the app.
struct ParentalGateView: View {
    let onSuccess: () -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var answer = ""
    @State private var showError = false
    @State private var challenge = ParentalGateView.generateChallenge()

    var body: some View {
        NavigationStack {
            VStack(spacing: TeddyTheme.spacingLG) {
                Spacer()

                Image(systemName: "person.2.fill")
                    .font(.system(size: 50))
                    .foregroundColor(TeddyTheme.primary)

                Text("Verificación de adulto")
                    .font(TeddyTheme.screenTitle())
                    .foregroundColor(TeddyTheme.textPrimary)

                Text("Pide a un adulto que resuelva esto para continuar")
                    .font(TeddyTheme.body())
                    .foregroundColor(TeddyTheme.textSecondary)
                    .multilineTextAlignment(.center)

                // Math challenge
                VStack(spacing: TeddyTheme.spacingMD) {
                    Text("¿Cuánto es \(challenge.question)?")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(TeddyTheme.textPrimary)

                    TextField("Respuesta", text: $answer)
                        .keyboardType(.numberPad)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(TeddyTheme.cardPadding)
                        .background(TeddyTheme.glassFill)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))

                    if showError {
                        Text("Respuesta incorrecta")
                            .font(TeddyTheme.caption())
                            .foregroundColor(TeddyTheme.secondary)
                    }

                    TeddyButton(title: "Verificar", icon: "checkmark.circle.fill") {
                        if answer.trimmingCharacters(in: .whitespaces) == "\(challenge.answer)" {
                            onSuccess()
                            dismiss()
                        } else {
                            showError = true
                            answer = ""
                            challenge = ParentalGateView.generateChallenge()
                        }
                    }
                    .padding(.horizontal, TeddyTheme.spacingXL)
                }

                Spacer()
            }
            .padding(TeddyTheme.screenPadding)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(TeddyTheme.textSecondary)
                }
            }
        }
        .background { TeddyAnimatedBackground().ignoresSafeArea() }
    }

    // MARK: - Challenge Generator

    private struct Challenge {
        let question: String
        let answer: Int
    }

    private static func generateChallenge() -> Challenge {
        let a = Int.random(in: 12...49)
        let b = Int.random(in: 3...9)
        return Challenge(question: "\(a) × \(b)", answer: a * b)
    }
}

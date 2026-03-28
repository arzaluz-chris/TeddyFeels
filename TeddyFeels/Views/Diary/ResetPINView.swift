import SwiftUI

struct ResetPINView: View {
    @Environment(PINService.self) private var pinService
    @Environment(\.dismiss) private var dismiss
    let bearImage: String
    let onResetComplete: () -> Void

    @State private var answer1 = ""
    @State private var answer2 = ""
    @State private var showError = false
    @State private var showSuccess = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: TeddyTheme.spacingLG) {
                    Image(bearImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)

                    Text("Recupera tu PIN")
                        .font(TeddyTheme.screenTitle())
                        .foregroundColor(TeddyTheme.textPrimary)

                    Text("Responde tus preguntas secretas para crear un PIN nuevo")
                        .font(TeddyTheme.body())
                        .foregroundColor(TeddyTheme.textSecondary)
                        .multilineTextAlignment(.center)

                    if let (q1, q2) = pinService.getRescueQuestions() {
                        VStack(alignment: .leading, spacing: TeddyTheme.spacingLG) {
                            // Question 1
                            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                                Text(q1)
                                    .font(TeddyTheme.cardTitle())
                                    .foregroundColor(TeddyTheme.primary)

                                TextField("Tu respuesta...", text: $answer1)
                                    .textInputAutocapitalization(.never)
                                    .padding(TeddyTheme.cardPadding)
                                    .background(TeddyTheme.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                                    .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
                            }

                            // Question 2
                            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                                Text(q2)
                                    .font(TeddyTheme.cardTitle())
                                    .foregroundColor(TeddyTheme.primary)

                                TextField("Tu respuesta...", text: $answer2)
                                    .textInputAutocapitalization(.never)
                                    .padding(TeddyTheme.cardPadding)
                                    .background(TeddyTheme.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                                    .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
                            }
                        }

                        if showError {
                            Text("Las respuestas no coinciden, revisa bien")
                                .font(TeddyTheme.caption())
                                .foregroundColor(TeddyTheme.secondary)
                        }

                        if showSuccess {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(TeddyTheme.success)
                                Text("¡Respuestas correctas! Crea tu nuevo PIN")
                                    .font(TeddyTheme.bodyBold())
                                    .foregroundColor(TeddyTheme.success)
                            }
                            .transition(.scale.combined(with: .opacity))
                        }

                        TeddyButton(title: "Verificar respuestas", icon: "checkmark.shield.fill") {
                            if pinService.validateRescueAnswers(answer1: answer1, answer2: answer2) {
                                withAnimation {
                                    showError = false
                                    showSuccess = true
                                }
                                pinService.resetPIN()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    onResetComplete()
                                }
                            } else {
                                withAnimation { showError = true }
                            }
                        }
                        .padding(.horizontal, TeddyTheme.spacingMD)
                    }
                }
                .padding(TeddyTheme.screenPadding)
                .padding(.bottom, TeddyTheme.spacingXXL)
            }
            .background(TeddyTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                        .foregroundColor(TeddyTheme.textSecondary)
                }
            }
        }
    }
}

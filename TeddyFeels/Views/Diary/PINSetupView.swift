import SwiftUI

struct PINSetupView: View {
    @Environment(PINService.self) private var pinService
    let bearImage: String
    let onComplete: () -> Void

    @State private var step: SetupStep = .createPIN
    @State private var pin = ""
    @State private var confirmPIN = ""
    @State private var showMismatch = false

    @State private var question1Index = 0
    @State private var question2Index = 1
    @State private var answer1 = ""
    @State private var answer2 = ""
    @State private var showIncomplete = false

    private enum SetupStep {
        case createPIN, confirmPIN, rescueQuestions
    }

    var body: some View {
        Group {
            if step == .rescueQuestions {
                ScrollView {
                    VStack(spacing: TeddyTheme.spacingLG) {
                        Image(bearImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)

                        rescueQuestionsStep
                    }
                    .padding(TeddyTheme.screenPadding)
                    .iPadReadableWidth()
                    .padding(.bottom, TeddyTheme.spacingXXL)
                }
            } else {
                VStack(spacing: TeddyTheme.spacingMD) {
                    Spacer()

                    Image(bearImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)

                    if step == .createPIN {
                        createPINStep
                    } else {
                        confirmPINStep
                    }

                    Spacer()
                }
                .padding(TeddyTheme.screenPadding)
                .iPadReadableWidth()
            }
        }
    }

    // MARK: - Step 1: Create PIN

    private var createPINStep: some View {
        VStack(spacing: TeddyTheme.spacingMD) {
            Text("Crea tu PIN secreto")
                .font(TeddyTheme.screenTitle())
                .foregroundColor(TeddyTheme.textPrimary)

            Text("Elige 4 números que solo tú sepas")
                .font(TeddyTheme.body())
                .foregroundColor(TeddyTheme.textSecondary)
                .multilineTextAlignment(.center)

            PINDotsView(count: pin.count)

            PINKeypadView(pin: $pin, maxDigits: 4)

            if pin.count == 4 {
                TeddyButton(title: "Siguiente", icon: "arrow.right") {
                    withAnimation { step = .confirmPIN }
                }
                .padding(.horizontal, TeddyTheme.spacingXL)
            }
        }
    }

    // MARK: - Step 2: Confirm PIN

    private var confirmPINStep: some View {
        VStack(spacing: TeddyTheme.spacingMD) {
            Text("Repite tu PIN")
                .font(TeddyTheme.screenTitle())
                .foregroundColor(TeddyTheme.textPrimary)

            Text("Escribe los mismos 4 números")
                .font(TeddyTheme.body())
                .foregroundColor(TeddyTheme.textSecondary)

            PINDotsView(count: confirmPIN.count)

            if showMismatch {
                Text("Los números no coinciden, intenta de nuevo")
                    .font(TeddyTheme.caption())
                    .foregroundColor(TeddyTheme.secondary)
            }

            PINKeypadView(pin: $confirmPIN, maxDigits: 4)

            HStack(spacing: TeddyTheme.spacingSM) {
                TeddyButton(title: "Atrás", icon: "arrow.left", style: .secondary) {
                    confirmPIN = ""
                    showMismatch = false
                    withAnimation { step = .createPIN }
                }

                if confirmPIN.count == 4 {
                    TeddyButton(title: "Siguiente", icon: "arrow.right") {
                        if confirmPIN == pin {
                            showMismatch = false
                            withAnimation { step = .rescueQuestions }
                        } else {
                            showMismatch = true
                            confirmPIN = ""
                        }
                    }
                }
            }
            .padding(.horizontal, TeddyTheme.spacingMD)
        }
    }

    // MARK: - Step 3: Rescue Questions

    private var rescueQuestionsStep: some View {
        VStack(spacing: TeddyTheme.spacingLG) {
            Text("Preguntas de rescate")
                .font(TeddyTheme.screenTitle())
                .foregroundColor(TeddyTheme.textPrimary)

            Text("Si olvidas tu PIN, estas preguntas te ayudarán a recuperarlo")
                .font(TeddyTheme.body())
                .foregroundColor(TeddyTheme.textSecondary)
                .multilineTextAlignment(.center)

            // Question 1
            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                Text("Pregunta 1")
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.primary)

                Picker("Pregunta 1", selection: $question1Index) {
                    ForEach(availableQuestions(excluding: question2Index), id: \.offset) { item in
                        Text(item.element).tag(item.offset)
                    }
                }
                .pickerStyle(.menu)
                .tint(TeddyTheme.textPrimary)

                TextField("Tu respuesta...", text: $answer1)
                    .padding(TeddyTheme.cardPadding)
                    .background(TeddyTheme.glassFill)
                        .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                    .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
            }

            // Question 2
            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                Text("Pregunta 2")
                    .font(TeddyTheme.cardTitle())
                    .foregroundColor(TeddyTheme.primary)

                Picker("Pregunta 2", selection: $question2Index) {
                    ForEach(availableQuestions(excluding: question1Index), id: \.offset) { item in
                        Text(item.element).tag(item.offset)
                    }
                }
                .pickerStyle(.menu)
                .tint(TeddyTheme.textPrimary)

                TextField("Tu respuesta...", text: $answer2)
                    .padding(TeddyTheme.cardPadding)
                    .background(TeddyTheme.glassFill)
                        .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                    .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
            }

            if showIncomplete {
                Text("Escribe las dos respuestas para continuar")
                    .font(TeddyTheme.caption())
                    .foregroundColor(TeddyTheme.secondary)
            }

            TeddyButton(title: "¡Listo!", icon: "checkmark.circle.fill") {
                let a1 = answer1.trimmingCharacters(in: .whitespaces)
                let a2 = answer2.trimmingCharacters(in: .whitespaces)
                if !a1.isEmpty && !a2.isEmpty {
                    pinService.setupPIN(
                        pin,
                        question1Index: question1Index,
                        answer1: a1,
                        question2Index: question2Index,
                        answer2: a2
                    )
                    onComplete()
                } else {
                    showIncomplete = true
                }
            }
            .padding(.horizontal, TeddyTheme.spacingMD)
        }
    }

    private func availableQuestions(excluding index: Int) -> [EnumeratedSequence<[String]>.Element] {
        Array(PINService.rescueQuestions.enumerated()).filter { $0.offset != index }
    }
}

// MARK: - PIN Dots

struct PINDotsView: View {
    let count: Int

    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(i < count ? TeddyTheme.primary : TeddyTheme.border)
                    .frame(width: 20, height: 20)
                    .scaleEffect(i < count ? 1.1 : 1.0)
                    .animation(.spring(response: 0.2), value: count)
            }
        }
        .padding(.vertical, TeddyTheme.spacingSM)
    }
}

// MARK: - PIN Keypad

struct PINKeypadView: View {
    @Binding var pin: String
    let maxDigits: Int

    private let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { key in
                        if key.isEmpty {
                            Color.clear.frame(width: 72, height: 52)
                        } else {
                            Button {
                                handleTap(key)
                            } label: {
                                Text(key)
                                    .font(.system(size: key == "⌫" ? 20 : 24, weight: .semibold, design: .rounded))
                                    .foregroundColor(TeddyTheme.textPrimary)
                                    .frame(width: 72, height: 52)
                                    .background(TeddyTheme.glassFill)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .shadow(color: TeddyTheme.cardShadow.color, radius: 2, x: 0, y: 1)
                            }
                        }
                    }
                }
            }
        }
    }

    private func handleTap(_ key: String) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        if key == "⌫" {
            if !pin.isEmpty { pin.removeLast() }
        } else if pin.count < maxDigits {
            pin.append(key)
        }
    }
}

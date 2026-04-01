import SwiftUI
import SwiftData

struct PINEntryView: View {
    @Environment(PINService.self) private var pinService
    @Environment(\.modelContext) private var modelContext
    let title: String
    let subtitle: String
    let bearImage: String
    let onSuccess: () -> Void

    @State private var pin = ""
    @State private var showError = false
    @State private var showReset = false
    @State private var showWipeWarning = false
    @State private var shake = false

    private let maxAttempts = 5

    private var attempts: Int {
        get { pinService.failedAttempts }
        nonmutating set { pinService.failedAttempts = newValue }
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                // Top section: bear + title + dots
                VStack(spacing: 12) {
                    Image(bearImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)

                    Text(title)
                        .font(TeddyTheme.sectionTitle())
                        .foregroundColor(TeddyTheme.textPrimary)

                    Text(subtitle)
                        .font(TeddyTheme.caption())
                        .foregroundColor(TeddyTheme.textSecondary)
                        .multilineTextAlignment(.center)

                    // PIN Dots — pop animation per digit
                    HStack(spacing: 20) {
                        ForEach(0..<4, id: \.self) { i in
                            Circle()
                                .fill(i < pin.count ? TeddyTheme.primary : TeddyTheme.border)
                                .frame(width: 18, height: 18)
                                .scaleEffect(i < pin.count ? 1.0 : 0.6)
                                .animation(
                                    .spring(response: 0.3, dampingFraction: 0.4)
                                        .delay(i < pin.count ? 0.05 : 0),
                                    value: pin.count
                                )
                        }
                    }
                    .offset(x: shake ? -10 : 0)
                    .padding(.top, 4)

                    // Error message
                    if showError {
                        VStack(spacing: 2) {
                            Text("PIN incorrecto")
                                .font(TeddyTheme.caption())
                                .foregroundColor(TeddyTheme.secondary)

                            if attempts >= 3 {
                                Text("\(maxAttempts - attempts) intento\(maxAttempts - attempts == 1 ? "" : "s") antes de borrar datos")
                                    .font(TeddyTheme.caption())
                                    .foregroundColor(TeddyTheme.secondary)
                                    .bold()
                            }
                        }
                        .transition(.opacity)
                    } else {
                        // Placeholder to keep layout stable
                        Color.clear.frame(height: 16)
                    }
                }
                .padding(.top, geo.safeAreaInsets.top > 50 ? 20 : 8)

                Spacer(minLength: 8)

                // Keypad - centered
                VStack(spacing: 10) {
                    ForEach(keypadRows, id: \.self) { row in
                        HStack(spacing: 16) {
                            ForEach(row, id: \.self) { key in
                                if key.isEmpty {
                                    Color.clear.frame(width: 68, height: 48)
                                } else {
                                    Button {
                                        tapKey(key)
                                    } label: {
                                        Text(key)
                                            .font(.system(size: key == "⌫" ? 18 : 22, weight: .medium, design: .rounded))
                                            .foregroundColor(TeddyTheme.textPrimary)
                                            .frame(width: 68, height: 48)
                                            .background(TeddyTheme.glassFill)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .shadow(color: TeddyTheme.cardShadow.color, radius: 2, x: 0, y: 1)
                                    }
                                }
                            }
                        }
                    }
                }

                Spacer(minLength: 8)

                // Bottom: forgot PIN
                Button {
                    showReset = true
                } label: {
                    Text("Olvidé mi PIN")
                        .font(TeddyTheme.body())
                        .foregroundColor(TeddyTheme.primary)
                        .underline()
                }
                .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 12 : 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, TeddyTheme.screenPadding)
            .iPadReadableWidth()
        }
        .onAppear {
            // Show error state if there are persisted failed attempts
            if attempts > 0 {
                showError = true
                print("🔐 [PIN] Cargando \(attempts) intentos fallidos previos")
            }
        }
        .onChange(of: pin) { _, newValue in
            if newValue.count == 4 {
                validatePIN()
            }
        }
        .sheet(isPresented: $showReset) {
            ResetPINView(bearImage: bearImage) {
                showReset = false
                pin = ""
                showError = false
                pinService.resetFailedAttempts()
            }
        }
        .alert("Datos borrados", isPresented: $showWipeWarning) {
            Button("Entendido") {
                pinService.resetPIN()
            }
        } message: {
            Text("Se superaron los \(maxAttempts) intentos. Las entradas del diario y las metas fueron borradas por seguridad. Crea un nuevo PIN para continuar.")
        }
    }

    // MARK: - Keypad

    private let keypadRows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]

    private func tapKey(_ key: String) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        if key == "⌫" {
            if !pin.isEmpty { pin.removeLast() }
        } else if pin.count < 4 {
            pin.append(key)
        }
    }

    // MARK: - Validation

    private func validatePIN() {
        print("🔐 [PIN] Validando PIN — intento \(attempts + 1)/\(maxAttempts)")

        if pinService.validatePIN(pin) {
            print("🔐 [PIN] ✅ PIN correcto")
            showError = false
            onSuccess()
        } else {
            attempts += 1
            print("🔐 [PIN] ❌ PIN incorrecto — intentos: \(attempts)/\(maxAttempts)")

            withAnimation(.default) {
                showError = true
            }
            let errorHaptic = UINotificationFeedbackGenerator()
            errorHaptic.notificationOccurred(.error)
            withAnimation(.linear(duration: 0.05).repeatCount(7, autoreverses: true)) {
                shake = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                shake = false
            }

            pin = ""

            if attempts >= maxAttempts {
                print("🔐 [PIN] Máximo de intentos — borrando datos")
                wipeData()
            }
        }
    }

    private func wipeData() {
        do {
            try modelContext.delete(model: EntradaDiario.self)
            try modelContext.delete(model: Meta.self)
            try modelContext.save()
            print("🔐 [PIN] Datos de diario y metas borrados")
        } catch {
            print("🔐 [PIN] Error al borrar datos: \(error)")
        }
        showWipeWarning = true
    }
}

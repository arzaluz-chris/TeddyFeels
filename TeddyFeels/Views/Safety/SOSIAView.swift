import SwiftUI

struct SOSIAView: View {
    @Environment(BearVoiceService.self) private var bearVoice
    @Environment(\.dismiss) var dismiss
    @State private var emoSel: Emocion?
    @State private var breatheIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.opacity(0.95).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: TeddyTheme.spacingLG) {
                        // Header with calming bear
                        VStack(spacing: TeddyTheme.spacingMD) {
                            TeddyAnimatedBear(
                                imageName: "oso_Doctor",
                                size: 120,
                                style: .breathing
                            )

                            Text("MODO RESCATE")
                                .font(TeddyTheme.heroTitle())
                                .foregroundColor(.white)

                            Text("No estás solo, Teddy te acompaña.")
                                .font(TeddyTheme.body())
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, TeddyTheme.spacingXL)

                        // Breathing exercise
                        VStack(spacing: TeddyTheme.spacingSM) {
                            Text("Respira conmigo")
                                .font(TeddyTheme.bodyBold())
                                .foregroundColor(.white)

                            Circle()
                                .fill(.white.opacity(0.25))
                                .frame(width: breatheIn ? 100 : 50, height: breatheIn ? 100 : 50)
                                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: breatheIn)
                                .overlay(
                                    Text(breatheIn ? "Exhala..." : "Inhala...")
                                        .font(TeddyTheme.caption())
                                        .foregroundColor(.white)
                                )

                        }

                        // Emotion picker
                        VStack(spacing: TeddyTheme.spacingSM) {
                            Text("Elige qué sientes ahora mismo:")
                                .font(TeddyTheme.bodyBold())
                                .foregroundColor(.white.opacity(0.9))

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: TeddyTheme.spacingSM) {
                                    ForEach(Emocion.allCases) { e in
                                        Button {
                                            withAnimation(TeddyTheme.bounceSpring) { emoSel = e }
                                        } label: {
                                            VStack(spacing: 4) {
                                                Image(e.imageName(for: bearVoice.selectedCharacter))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 44, height: 44)
                                                Text(e.displayName(for: bearVoice.selectedCharacter))
                                                    .font(TeddyTheme.badge())
                                                    .bold()
                                            }
                                            .padding(.horizontal, TeddyTheme.spacingSM)
                                            .padding(.vertical, TeddyTheme.spacingSM + 2)
                                            .frame(minHeight: 52)
                                            .background(emoSel == e ? Color.white : Color.white.opacity(0.25))
                                            .foregroundColor(emoSel == e ? .red : .white)
                                            .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius, style: .continuous))
                                        }
                                    }
                                }
                                .padding(.horizontal, TeddyTheme.screenPadding)
                            }
                        }

                        // Action steps
                        if let e = emoSel {
                            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                                Text("Pasos para calmarte:")
                                    .font(TeddyTheme.sectionTitle())
                                    .foregroundColor(.white)

                                ForEach(e.accionesCriticas, id: \.self) { accion in
                                    HStack(spacing: TeddyTheme.spacingSM) {
                                        Image(systemName: "hand.tap.fill")
                                            .font(.system(size: 16))
                                        Text(accion)
                                            .font(TeddyTheme.bodyBold())
                                    }
                                    .padding(TeddyTheme.spacingMD)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.white.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.smallRadius, style: .continuous))
                                    .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, TeddyTheme.screenPadding)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }

                        // Calm button
                        Button {
                            dismiss()
                        } label: {
                            Text("YA ESTOY MÁS TRANQUILO")
                                .font(TeddyTheme.bodyBold())
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, TeddyTheme.spacingMD)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius, style: .continuous))
                        }
                        .padding(.horizontal, TeddyTheme.screenPadding)
                        .padding(.bottom, TeddyTheme.spacingHuge)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") { dismiss() }.foregroundColor(.white)
                }
            }
        }
        .onAppear {
            breatheIn = true
        }
    }
}

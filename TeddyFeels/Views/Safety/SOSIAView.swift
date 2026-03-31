import SwiftUI

struct SOSIAView: View {
    @Environment(BearVoiceService.self) private var bearVoice
    @Environment(\.dismiss) var dismiss
    @State private var emoSel: Emocion?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.opacity(0.98).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 25) {
                        VStack {
                            Text("MODO RESCATE").font(.system(.largeTitle, design: .rounded)).bold()
                            Text("No estás solo, Teddy te acompaña.").font(.subheadline)
                        }.foregroundColor(.white).padding(.top, 40)

                        Text("Elige qué sientes ahora mismo:").foregroundColor(.white.opacity(0.9))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(Emocion.allCases) { e in
                                    Button { withAnimation { emoSel = e } } label: {
                                        VStack {
                                            Image(e.imageName(for: bearVoice.selectedCharacter))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                            Text(e.displayName(for: bearVoice.selectedCharacter)).font(.caption).bold()
                                        }
                                        .padding()
                                        .background(emoSel == e ? Color.white : Color.white.opacity(0.3))
                                        .foregroundColor(emoSel == e ? .red : .white)
                                        .cornerRadius(20)
                                    }
                                }
                            }.padding(.horizontal)
                        }

                        if let e = emoSel {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Pasos para calmarte:").font(.headline).foregroundColor(.white)
                                ForEach(e.accionesCriticas, id: \.self) { accion in
                                    HStack {
                                        Image(systemName: "hand.tap.fill")
                                        Text(accion).font(.callout).bold()
                                    }
                                    .padding().frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.white.opacity(0.2)).cornerRadius(15).foregroundColor(.white)
                                }
                            }.padding().transition(.move(edge: .bottom))
                        }

                        Button("YA ESTOY MÁS TRANQUILO") { dismiss() }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .foregroundColor(.red)
                            .bold()
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .padding(.bottom, 60)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") { dismiss() }.foregroundColor(.white)
                }
            }
        }
    }
}

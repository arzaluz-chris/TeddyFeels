import SwiftUI
import SwiftData
import ConfettiSwiftUI

struct MetasControlView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(BearVoiceService.self) private var bearVoice
    @Query(sort: \Meta.fechaCreacion, order: .reverse) private var metas: [Meta]

    @State private var metasVM = MetasViewModel()
    @State private var newGoalText = ""
    @State private var confettiCounter = 0

    private var completedCount: Int { metas.filter(\.esCompletada).count }

    var body: some View {
        ScrollView {
            VStack(spacing: TeddyTheme.spacingMD) {
                TeddyBearBanner(
                    imageName: "oso_Metas",
                    message: "¡Establece metas pequeñas y celebra cada logro!",
                    imageSize: 100,
                    onTap: { bearVoice.replay(for: "Metas") }
                )

                if !metas.isEmpty {
                    TeddyCard {
                        HStack {
                            VStack(alignment: .leading, spacing: TeddyTheme.spacingXS) {
                                Text("\(completedCount) de \(metas.count)")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(TeddyTheme.primary)
                                Text("metas completadas")
                                    .font(TeddyTheme.caption())
                                    .foregroundColor(TeddyTheme.textSecondary)
                            }
                            Spacer()
                            ZStack {
                                Circle()
                                    .stroke(TeddyTheme.border, lineWidth: 6)
                                Circle()
                                    .trim(from: 0, to: metas.isEmpty ? 0 : Double(completedCount) / Double(metas.count))
                                    .stroke(TeddyTheme.success, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                            }
                            .frame(width: 52, height: 52)
                        }
                    }
                }

                HStack(spacing: TeddyTheme.spacingSM) {
                    TextField("Escribe una meta...", text: $newGoalText)
                        .font(TeddyTheme.body())
                        .padding(TeddyTheme.spacingMD)
                        .background(TeddyTheme.glassFill)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: TeddyTheme.buttonRadius))
                        .shadow(color: TeddyTheme.cardShadow.color, radius: TeddyTheme.cardShadow.radius, x: 0, y: TeddyTheme.cardShadow.y)
                        .submitLabel(.done)
                        .onSubmit { addGoal() }

                    Button {
                        addGoal()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(newGoalText.trimmingCharacters(in: .whitespaces).isEmpty ? TeddyTheme.border : TeddyTheme.primary)
                                .frame(width: 48, height: 48)
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .shadow(color: TeddyTheme.primary.opacity(0.3), radius: 8, y: 4)
                    }
                    .disabled(newGoalText.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                TeddySectionHeader(title: "Mis Metas")

                ForEach(metas) { meta in
                    TeddyCard(accentColor: meta.esCompletada ? TeddyTheme.success : nil) {
                        HStack(spacing: TeddyTheme.spacingMD) {
                            Button {
                                metasVM.toggleMeta(meta)
                                if meta.esCompletada {
                                    confettiCounter += 1
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .stroke(meta.esCompletada ? TeddyTheme.success : TeddyTheme.border, lineWidth: 2)
                                        .frame(width: 28, height: 28)
                                    if meta.esCompletada {
                                        Circle()
                                            .fill(TeddyTheme.success)
                                            .frame(width: 28, height: 28)
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .buttonStyle(.plain)

                            Text(meta.titulo)
                                .font(TeddyTheme.body())
                                .strikethrough(meta.esCompletada)
                                .foregroundColor(meta.esCompletada ? TeddyTheme.textSecondary : TeddyTheme.textPrimary)

                            Spacer()
                        }
                    }
                }
            }
            .padding(.horizontal, TeddyTheme.screenPadding)
            .padding(.top, TeddyTheme.spacingMD)
            .padding(.bottom, 100)
        }
        .teddyCelebration(counter: $confettiCounter)
        .onAppear {
            print("📱 [Metas] Vista apareció")
            bearVoice.play(for: "Metas")
        }
    }

    private func addGoal() {
        let trimmed = newGoalText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        print("📱 [Metas] Añadiendo meta: \"\(trimmed)\"")
        metasVM.addMeta(context: modelContext, titulo: trimmed)
        newGoalText = ""
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

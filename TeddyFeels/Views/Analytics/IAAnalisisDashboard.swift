import SwiftUI
import Charts

struct IAAnalisisDashboard: View {
    @Environment(BearVoiceService.self) private var bearVoice
    @State private var analyticsVM = AnalyticsViewModel()
    @State private var chartProgress: CGFloat = 0

    private var score: Double {
        UserDefaults.standard.double(forKey: "score_v2_full")
    }

    private var teddyNote: String {
        if analyticsVM.daysActive == 0 {
            return "¡Empieza a contarme cómo te sientes para ver tu progreso aquí!"
        } else if analyticsVM.weekAverage >= 7 {
            return "¡Lo estás haciendo increíble! Tu energía emocional está muy alta esta semana."
        } else if analyticsVM.weekAverage >= 4 {
            return "¡Vas muy bien! Sigue contándome tus secretos para que te sientas siempre ligero."
        } else {
            return "Recuerda que todas las emociones son válidas. Estoy aquí para ti siempre."
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: TeddyTheme.spacingLG) {
                    // Bear banner
                    TeddyBearBanner(
                        imageName: "oso_Analisis",
                        message: "Aquí puedes ver cómo vas con tu bienestar emocional.",
                        imageSize: 100,
                        onTap: { bearVoice.replay(for: "Progreso") }
                    )

                    // Score card — jumbo number with ring
                    VStack(spacing: TeddyTheme.spacingMD) {
                        Text("Tu Energía Mental")
                            .font(TeddyTheme.caption())
                            .foregroundColor(TeddyTheme.textSecondary)

                        ZStack {
                            Circle()
                                .stroke(TeddyTheme.border, lineWidth: 10)
                            Circle()
                                .trim(from: 0, to: score / 100)
                                .stroke(
                                    LinearGradient(colors: [TeddyTheme.primary, TeddyTheme.accent], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .animation(.spring(response: 0.8), value: score)

                            VStack(spacing: 2) {
                                Text("\(Int(score))%")
                                    .font(TeddyTheme.jumboScore())
                                    .foregroundColor(TeddyTheme.textPrimary)
                                Text("energía")
                                    .font(TeddyTheme.caption())
                                    .foregroundColor(TeddyTheme.textSecondary)
                            }
                        }
                        .frame(width: 160, height: 160)

                        TeddyButton(title: "Restablecer", icon: "arrow.counterclockwise", style: .secondary) {
                            UserDefaults.standard.set(0.0, forKey: "score_v2_full")
                            DailyScoreService.resetAll()
                            analyticsVM.refresh()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(TeddyTheme.cardPadding)
                    .elevatedCard()

                    // Weekly stats summary — colored tinted cards
                    if analyticsVM.daysActive > 0 {
                        HStack(spacing: TeddyTheme.spacingSM) {
                            statCard(value: "\(analyticsVM.daysActive)", label: "Días activos", icon: "calendar", tint: TeddyTheme.EmotionColor.tristeBg)
                            statCard(value: String(format: "%.0f", analyticsVM.weekAverage), label: "Promedio", icon: "chart.line.uptrend.xyaxis", tint: TeddyTheme.EmotionColor.estresadoBg)
                            statCard(value: analyticsVM.bestDay, label: "Mejor día", icon: "star.fill", tint: TeddyTheme.EmotionColor.esperanzadoBg)
                        }
                    }

                    // Weekly chart
                    VStack(alignment: .leading, spacing: TeddyTheme.spacingMD) {
                        Text("Tu semana con Teddy")
                            .font(TeddyTheme.cardTitle())
                            .foregroundColor(TeddyTheme.textPrimary)

                        if analyticsVM.daysActive > 0 {
                            Chart {
                                ForEach(analyticsVM.weeklyData) { day in
                                    if day.hasData {
                                        LineMark(
                                            x: .value("Día", day.label),
                                            y: .value("Puntaje", day.displayScore)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .foregroundStyle(TeddyTheme.primary)
                                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))

                                        PointMark(
                                            x: .value("Día", day.label),
                                            y: .value("Puntaje", day.displayScore)
                                        )
                                        .foregroundStyle(TeddyTheme.primary)
                                        .symbolSize(40)

                                        AreaMark(
                                            x: .value("Día", day.label),
                                            y: .value("Puntaje", day.displayScore)
                                        )
                                        .interpolationMethod(.catmullRom)
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [TeddyTheme.primary.opacity(0.2), TeddyTheme.primary.opacity(0.0)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                    }
                                }
                            }
                            .frame(height: 180)
                            .chartYScale(domain: 0...12)
                            .chartYAxis {
                                AxisMarks(position: .leading)
                            }
                        } else {
                            VStack(spacing: TeddyTheme.spacingSM) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 40))
                                    .foregroundColor(TeddyTheme.textTertiary)
                                Text("Aún no hay datos esta semana")
                                    .font(TeddyTheme.body())
                                    .foregroundColor(TeddyTheme.textSecondary)
                                Text("Selecciona emociones y escribe en tu diario para ver tu progreso")
                                    .font(TeddyTheme.caption())
                                    .foregroundColor(TeddyTheme.textTertiary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                        }
                    }
                    .padding(TeddyTheme.cardPadding)
                    .elevatedCard()

                    // Teddy's note
                    VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                        HStack(spacing: TeddyTheme.spacingSM) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(TeddyTheme.primary)
                                .frame(width: 4, height: 20)
                            Text("Nota de Teddy")
                                .font(TeddyTheme.cardTitle())
                                .foregroundColor(TeddyTheme.primary)
                        }
                        Text(teddyNote)
                            .font(TeddyTheme.body())
                            .foregroundColor(TeddyTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(TeddyTheme.cardPadding)
                    .elevatedCard()
                }
                .padding(.horizontal, TeddyTheme.screenPadding)
                .iPadReadableWidth()
                .padding(.top, TeddyTheme.spacingMD)
                .padding(.bottom, 100)
            }
            .navigationTitle("Progreso")
            .navigationBarTitleDisplayMode(.large)
        }
        .background { TeddyAnimatedBackground().ignoresSafeArea() }
        .onAppear {
            bearVoice.play(for: "Progreso")
            analyticsVM.refresh()
        }
    }

    private func statCard(value: String, label: String, icon: String, tint: Color) -> some View {
        VStack(spacing: TeddyTheme.spacingXS) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(TeddyTheme.primary)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(TeddyTheme.textPrimary)
            Text(label)
                .font(TeddyTheme.caption())
                .foregroundColor(TeddyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(TeddyTheme.spacingSM)
        .solidCard(color: tint)
    }
}

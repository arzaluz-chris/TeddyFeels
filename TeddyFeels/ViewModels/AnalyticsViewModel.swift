import Foundation

@Observable
final class AnalyticsViewModel {
    struct DayData: Identifiable {
        let id = UUID()
        let label: String
        let date: Date
        let score: Double?
        var displayScore: Double { score ?? 0 }
        var hasData: Bool { score != nil }
    }

    private(set) var weeklyData: [DayData] = []
    private(set) var weekAverage: Double = 0
    private(set) var daysActive: Int = 0
    private(set) var bestDay: String = "—"

    init() {
        refresh()
    }

    func refresh() {
        let raw = DailyScoreService.weeklyData()
        weeklyData = raw.map { DayData(label: $0.label, date: $0.date, score: $0.score) }

        let activeDays = weeklyData.filter { $0.hasData }
        daysActive = activeDays.count

        if !activeDays.isEmpty {
            weekAverage = activeDays.map(\.displayScore).reduce(0, +) / Double(activeDays.count)
            if let best = activeDays.max(by: { $0.displayScore < $1.displayScore }) {
                bestDay = best.label
            }
        } else {
            weekAverage = 0
            bestDay = "—"
        }

        print("📊 [Analytics] Datos semanales: \(weeklyData.map { "\($0.label): \($0.score.map { String(format: "%.0f", $0) } ?? "—")" }.joined(separator: ", "))")
    }
}

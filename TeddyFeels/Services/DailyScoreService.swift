import Foundation

/// Tracks daily wellbeing scores for the weekly chart.
/// Each day stores: cumulative score, number of interactions, and the emotions logged.
enum DailyScoreService {
    private static let calendar = Calendar.current

    /// Key format: "daily_score_2026-03-27"
    private static func key(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "daily_score_\(formatter.string(from: date))"
    }

    /// Key for interaction count: "daily_count_2026-03-27"
    private static func countKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "daily_count_\(formatter.string(from: date))"
    }

    // MARK: - Recording

    /// Records a score change for today. Called when user selects emotion or writes diary.
    static func record(scoreChange: Double) {
        let today = Date()
        let k = key(for: today)
        let ck = countKey(for: today)
        let defaults = UserDefaults.standard

        let currentTotal = defaults.double(forKey: k)
        let currentCount = defaults.integer(forKey: ck)

        defaults.set(currentTotal + scoreChange, forKey: k)
        defaults.set(currentCount + 1, forKey: ck)

        print("📊 [DailyScore] Registrado +\(String(format: "%.1f", scoreChange)) → total día: \(String(format: "%.1f", currentTotal + scoreChange)) (\(currentCount + 1) interacciones)")
    }

    // MARK: - Reading

    /// Returns the average score for a given date (total / interactions), capped at 100.
    static func score(for date: Date) -> Double? {
        let k = key(for: date)
        let ck = countKey(for: date)
        let defaults = UserDefaults.standard

        let count = defaults.integer(forKey: ck)
        guard count > 0 else { return nil }

        let total = defaults.double(forKey: k)
        return min(100, total / Double(count))
    }

    /// Returns the last 7 days of data as (dayLabel, score) pairs.
    /// Days without data get nil score.
    static func weeklyData() -> [(label: String, date: Date, score: Double?)] {
        let today = calendar.startOfDay(for: Date())
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "es_MX")
        dayFormatter.dateFormat = "EEE"

        return (0..<7).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            let label = dayFormatter.string(from: date).capitalized
            let dayScore = score(for: date)
            return (label: label, date: date, score: dayScore)
        }
    }

    /// Returns today's raw cumulative score (not averaged).
    static func todayTotal() -> Double {
        UserDefaults.standard.double(forKey: key(for: Date()))
    }

    /// Returns count of interactions today.
    static func todayCount() -> Int {
        UserDefaults.standard.integer(forKey: countKey(for: Date()))
    }

    // MARK: - Reset

    /// Clears all daily tracking data for the past 30 days.
    static func resetAll() {
        let defaults = UserDefaults.standard
        let today = Date()
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            defaults.removeObject(forKey: key(for: date))
            defaults.removeObject(forKey: countKey(for: date))
        }
        print("📊 [DailyScore] Datos reseteados")
    }
}

import SwiftUI

struct WeightTrendIndicator: View {
    let trend: WeightTrend
    let showLabel: Bool

    init(trend: WeightTrend, showLabel: Bool = false) {
        self.trend = trend
        self.showLabel = showLabel
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: trend.icon)
                .font(.subheadline)
                .fontWeight(.semibold)

            if showLabel {
                Text(trendLabel)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .foregroundColor(trend.color)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(trend.color.opacity(0.15))
        .cornerRadius(20)
    }

    // Neutral labels - no judgment
    private var trendLabel: String {
        switch trend {
        case .decreasing: return "Down"
        case .stable: return "Steady"
        case .increasing: return "Up"
        case .insufficient: return "—"
        }
    }
}

struct WeightChangeIndicator: View {
    let change: Double
    let unit: WeightUnit
    let period: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: change < 0 ? "arrow.down" : change > 0 ? "arrow.up" : "minus")
                .font(.caption)

            Text(String(format: "%.1f \(unit.rawValue)", abs(change)))
                .font(.subheadline)
                .fontWeight(.medium)

            Text(period)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .foregroundColor(changeColor)
    }

    // Neutral colors
    private var changeColor: Color {
        if change < -0.1 {
            return .blue
        } else {
            return .secondary
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        WeightTrendIndicator(trend: .decreasing, showLabel: true)
        WeightTrendIndicator(trend: .stable, showLabel: true)
        WeightTrendIndicator(trend: .increasing, showLabel: true)
        WeightTrendIndicator(trend: .insufficient, showLabel: true)

        Divider()

        WeightChangeIndicator(change: -0.5, unit: .lbs, period: "this week")
        WeightChangeIndicator(change: 0.2, unit: .lbs, period: "this week")
        WeightChangeIndicator(change: 0, unit: .kg, period: "this month")
    }
    .padding()
}

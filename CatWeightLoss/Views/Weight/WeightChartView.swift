import SwiftUI
import Charts

struct WeightChartView: View {
    let cat: Cat
    var height: CGFloat = 200
    var showTarget: Bool = true

    private var sortedEntries: [WeightEntry] {
        cat.weightEntries.sorted { $0.date < $1.date }
    }

    private var weightRange: ClosedRange<Double> {
        let weights = sortedEntries.map { $0.weight }
        let minWeight = min(weights.min() ?? cat.targetWeight, cat.targetWeight)
        let maxWeight = max(weights.max() ?? cat.startWeight, cat.startWeight)
        let padding = (maxWeight - minWeight) * 0.1
        return (minWeight - padding)...(maxWeight + padding)
    }

    var body: some View {
        Chart {
            // Weight entries line
            ForEach(sortedEntries) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight)
                )
                .foregroundStyle(Color.blue.gradient)
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight)
                )
                .foregroundStyle(Color.blue)
                .symbolSize(40)
            }

            // Target weight line
            if showTarget {
                RuleMark(y: .value("Target", cat.targetWeight))
                    .foregroundStyle(Color.green.opacity(0.7))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Target")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .padding(.horizontal, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                    }
            }

            // Area under curve
            ForEach(sortedEntries) { entry in
                AreaMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: weightRange)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel {
                    if let weight = value.as(Double.self) {
                        Text(String(format: "%.1f", weight))
                            .font(.caption2)
                    }
                }
                AxisGridLine()
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                AxisGridLine()
            }
        }
        .frame(height: height)
    }
}

struct WeightChartViewCompact: View {
    let cat: Cat

    private var sortedEntries: [WeightEntry] {
        cat.weightEntries.sorted { $0.date < $1.date }.suffix(7)
    }

    var body: some View {
        Chart {
            ForEach(Array(sortedEntries)) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight)
                )
                .foregroundStyle(Color.blue)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .frame(height: 50)
    }
}

#Preview {
    VStack {
        let cat = Cat(name: "Whiskers", startWeight: 12.0, targetWeight: 10.0)

        WeightChartView(cat: cat)
            .padding()

        WeightChartViewCompact(cat: cat)
            .padding()
    }
}

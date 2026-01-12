#if DEBUG
import SwiftUI
import SwiftData
import Charts

/// DEBUG-only analytics dashboard for viewing brand metrics
/// Shows aggregated anonymous metrics per brand for admin analysis
struct AnalyticsDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedBrandId: String = "all"
    @State private var metrics: [AnonymousMetric] = []
    @State private var brands: [BrandConfiguration] = []
    @State private var isLoading = true

    // MARK: - Computed Properties

    private var filteredMetrics: [AnonymousMetric] {
        if selectedBrandId == "all" {
            return metrics
        }
        return metrics.filter { $0.brandId == selectedBrandId }
    }

    private var totalActivations: Int {
        filteredMetrics.filter { $0.metricType == MetricType.appActivation.rawValue }.count
    }

    private var reorderViews: Int {
        filteredMetrics.filter { $0.metricType == MetricType.reorderViewed.rawValue }.count
    }

    private var reorderClicks: Int {
        filteredMetrics.filter { $0.metricType == MetricType.reorderClick.rawValue }.count
    }

    private var dailyTrackingSessions: Int {
        let weightLogs = filteredMetrics.filter { $0.metricType == MetricType.weightLogged.rawValue }
        let uniqueDays = Set(weightLogs.map { Calendar.current.startOfDay(for: $0.recordedAt) })
        return uniqueDays.count
    }

    private var reorderConversionRate: Double {
        guard reorderViews > 0 else { return 0 }
        return Double(reorderClicks) / Double(reorderViews) * 100
    }

    private var timeSeriesData: [DailyMetricPoint] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredMetrics) { metric in
            calendar.startOfDay(for: metric.recordedAt)
        }

        return grouped.map { date, dayMetrics in
            DailyMetricPoint(
                date: date,
                activations: dayMetrics.filter { $0.metricType == MetricType.appActivation.rawValue }.count,
                weightLogs: dayMetrics.filter { $0.metricType == MetricType.weightLogged.rawValue }.count,
                reorderViews: dayMetrics.filter { $0.metricType == MetricType.reorderViewed.rawValue }.count,
                reorderClicks: dayMetrics.filter { $0.metricType == MetricType.reorderClick.rawValue }.count
            )
        }.sorted { $0.date < $1.date }
    }

    private var csvExportString: String {
        var csv = "Date,Brand,SKU,Metric Type,Value,Device Hash\n"

        for metric in filteredMetrics.sorted(by: { $0.recordedAt < $1.recordedAt }) {
            let dateFormatter = ISO8601DateFormatter()
            let dateString = dateFormatter.string(from: metric.recordedAt)
            csv += "\(dateString),\(metric.brandId),\(metric.skuId),\(metric.metricType),\(metric.value),\(metric.deviceHash)\n"
        }

        return csv
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading metrics...")
                } else if metrics.isEmpty {
                    emptyStateView
                } else {
                    metricsContent
                }
            }
            .navigationTitle("Analytics Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if !metrics.isEmpty {
                        ShareLink(
                            item: csvExportString,
                            subject: Text("CatWeightLoss Analytics Export"),
                            message: Text("Exported metrics data")
                        ) {
                            Label("Export CSV", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
            .onAppear {
                loadData()
            }
        }
    }

    // MARK: - Views

    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Metrics Yet",
            systemImage: "chart.bar.xaxis",
            description: Text("Metrics will appear here as users interact with the app.")
        )
    }

    private var metricsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                brandPickerSection
                summaryCardsSection
                funnelChartSection
                timeSeriesChartSection
            }
            .padding()
        }
    }

    private var brandPickerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Brand")
                .font(.headline)

            Picker("Brand", selection: $selectedBrandId) {
                Text("All Brands").tag("all")
                ForEach(brands, id: \.brandId) { brand in
                    Text(brand.brandName).tag(brand.brandId)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var summaryCardsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            MetricCard(
                title: "Total Activations",
                value: "\(totalActivations)",
                icon: "app.badge.checkmark",
                color: .blue
            )

            MetricCard(
                title: "Tracking Sessions",
                value: "\(dailyTrackingSessions)",
                icon: "calendar",
                color: .green
            )

            MetricCard(
                title: "Reorder Views",
                value: "\(reorderViews)",
                icon: "eye",
                color: .orange
            )

            MetricCard(
                title: "Reorder Clicks",
                value: "\(reorderClicks)",
                icon: "hand.tap",
                color: .purple
            )
        }
    }

    private var funnelChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reorder Funnel")
                .font(.headline)

            Chart {
                BarMark(
                    x: .value("Count", reorderViews),
                    y: .value("Stage", "Views")
                )
                .foregroundStyle(.orange.gradient)
                .cornerRadius(4)

                BarMark(
                    x: .value("Count", reorderClicks),
                    y: .value("Stage", "Clicks")
                )
                .foregroundStyle(.purple.gradient)
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .frame(height: 120)

            if reorderViews > 0 {
                Text("Conversion Rate: \(reorderConversionRate, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var timeSeriesChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Over Time")
                .font(.headline)

            if timeSeriesData.isEmpty {
                Text("No time series data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(timeSeriesData) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Activations", point.activations),
                            series: .value("Type", "Activations")
                        )
                        .foregroundStyle(.blue)
                        .symbol(.circle)

                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Weight Logs", point.weightLogs),
                            series: .value("Type", "Weight Logs")
                        )
                        .foregroundStyle(.green)
                        .symbol(.square)

                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Reorder Views", point.reorderViews),
                            series: .value("Type", "Reorder Views")
                        )
                        .foregroundStyle(.orange)
                        .symbol(.triangle)
                    }
                }
                .chartLegend(position: .bottom)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                        AxisGridLine()
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .frame(height: 250)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // MARK: - Data Loading

    private func loadData() {
        isLoading = true

        // Load brands
        brands = BrandConfigService.shared.getAllBrands(from: modelContext)

        // Load metrics
        let descriptor = FetchDescriptor<AnonymousMetric>(
            sortBy: [SortDescriptor(\.recordedAt, order: .reverse)]
        )

        do {
            metrics = try modelContext.fetch(descriptor)
        } catch {
            print("[AnalyticsDashboard] Failed to fetch metrics: \(error.localizedDescription)")
            metrics = []
        }

        isLoading = false
    }
}

// MARK: - Supporting Types

private struct DailyMetricPoint: Identifiable {
    let id = UUID()
    let date: Date
    let activations: Int
    let weightLogs: Int
    let reorderViews: Int
    let reorderClicks: Int
}

private struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.title.bold())
                .foregroundColor(.primary)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    AnalyticsDashboardView()
        .modelContainer(for: [AnonymousMetric.self, BrandConfiguration.self], inMemory: true)
}
#endif

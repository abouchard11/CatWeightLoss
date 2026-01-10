import SwiftUI
import SwiftData
import Charts

struct CatDetailView: View {
    @Bindable var cat: Cat
    @Environment(\.modelContext) private var modelContext

    @State private var showingWeightLog = false
    @State private var showingFeedingPlan = false
    @State private var showingActivityLog = false
    @State private var showingPortionCalculator = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Card
                headerCard

                // Quick Stats
                quickStats

                // Weight Chart
                weightChartSection

                // Quick Actions
                quickActions

                // Recent Activity
                recentActivitySection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(cat.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingWeightLog) {
            WeightLogView(cat: cat)
        }
        .sheet(isPresented: $showingFeedingPlan) {
            FeedingPlanView(cat: cat)
        }
        .sheet(isPresented: $showingActivityLog) {
            ActivityLogView(cat: cat)
        }
        .sheet(isPresented: $showingPortionCalculator) {
            PortionCalculatorView(cat: cat)
        }
    }

    private var headerCard: some View {
        HStack(spacing: 16) {
            // Cat photo
            if let photoData = cat.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "cat.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 6) {
                if let breed = cat.breed {
                    Text(breed)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                if let age = cat.age {
                    Text(age)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                WeightTrendIndicator(trend: cat.weightTrend)
            }

            Spacer()

            // Progress Ring
            ProgressRingWithLabel(
                progress: cat.progressPercentage / 100,
                label: "\(Int(cat.progressPercentage))%",
                foregroundColor: .green
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }

    private var quickStats: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Current",
                value: String(format: "%.1f %@", cat.currentWeight, cat.weightUnit.rawValue),
                subtitle: String(format: "%.1f to go", cat.weightToLose),
                icon: "scalemass",
                color: .blue
            )

            StatCard(
                title: "Target",
                value: String(format: "%.1f %@", cat.targetWeight, cat.weightUnit.rawValue),
                icon: "flag.fill",
                color: .green
            )
        }
    }

    private var weightChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weight Progress")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: WeightHistoryView(cat: cat)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }

            if cat.weightEntries.count >= 2 {
                WeightChartView(cat: cat, height: 180)
            } else {
                ContentUnavailableView {
                    Label("Not Enough Data", systemImage: "chart.line.uptrend.xyaxis")
                } description: {
                    Text("Log at least 2 weight entries to see your chart")
                }
                .frame(height: 180)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }

    private var quickActions: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ActionButton(
                    title: "Log Weight",
                    icon: "scalemass.fill",
                    color: .blue
                ) {
                    showingWeightLog = true
                }

                ActionButton(
                    title: "Log Activity",
                    icon: "figure.run",
                    color: .orange
                ) {
                    showingActivityLog = true
                }
            }

            HStack(spacing: 12) {
                ActionButton(
                    title: "Feeding Plan",
                    icon: "fork.knife",
                    color: .purple
                ) {
                    showingFeedingPlan = true
                }

                ActionButton(
                    title: "Calculator",
                    icon: "function",
                    color: .green
                ) {
                    showingPortionCalculator = true
                }
            }
        }
    }

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Activity")
                    .font(.headline)
                Spacer()
                ProgressRingWithIcon(
                    progress: cat.activityGoalProgress,
                    iconName: "figure.run",
                    size: 40,
                    lineWidth: 4,
                    foregroundColor: .orange
                )
            }

            HStack {
                Text("\(cat.todayActivityMinutes) / \(cat.dailyActivityMinutes) min")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                if cat.activityGoalProgress >= 1.0 {
                    Label("Goal Met!", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.subheadline)
                }
            }

            if !cat.activitySessions.isEmpty {
                let todaySessions = cat.activitySessions
                    .filter { Calendar.current.isDateInToday($0.date) }
                    .prefix(3)

                if !todaySessions.isEmpty {
                    Divider()
                    ForEach(Array(todaySessions)) { session in
                        HStack {
                            Image(systemName: session.activityType.icon)
                                .foregroundColor(.orange)
                            Text(session.activityType.rawValue)
                            Spacer()
                            Text(session.formattedDuration)
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        CatDetailView(cat: Cat(
            name: "Whiskers",
            breed: "British Shorthair",
            birthDate: Calendar.current.date(byAdding: .year, value: -3, to: Date()),
            startWeight: 12.0,
            targetWeight: 10.0
        ))
    }
    .modelContainer(for: Cat.self, inMemory: true)
}

import SwiftUI
import SwiftData

struct ActivityHistoryView: View {
    @Bindable var cat: Cat
    @Environment(\.modelContext) private var modelContext

    @State private var showingAddActivity = false

    private var sortedSessions: [ActivitySession] {
        cat.activitySessions.sorted { $0.date > $1.date }
    }

    private var groupedSessions: [(String, [ActivitySession])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        let grouped = Dictionary(grouping: sortedSessions) { session in
            formatter.string(from: session.date)
        }

        return grouped.sorted { $0.value.first?.date ?? Date() > $1.value.first?.date ?? Date() }
    }

    private var weeklyStats: (totalMinutes: Int, totalCalories: Double, sessionsCount: Int) {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        let weekSessions = sortedSessions.filter { $0.date >= weekAgo }
        let totalMinutes = weekSessions.reduce(0) { $0 + $1.durationMinutes }
        let totalCalories = weekSessions.reduce(0.0) { $0 + $1.estimatedCaloriesBurned }

        return (totalMinutes, totalCalories, weekSessions.count)
    }

    var body: some View {
        List {
            // Weekly Summary
            Section("This Week") {
                HStack(spacing: 16) {
                    StatBlock(
                        value: "\(weeklyStats.totalMinutes)",
                        label: "Minutes",
                        icon: "clock.fill",
                        color: .blue
                    )

                    Divider()

                    StatBlock(
                        value: "\(Int(weeklyStats.totalCalories))",
                        label: "Calories",
                        icon: "flame.fill",
                        color: .orange
                    )

                    Divider()

                    StatBlock(
                        value: "\(weeklyStats.sessionsCount)",
                        label: "Sessions",
                        icon: "figure.run",
                        color: .green
                    )
                }
                .padding(.vertical, 8)
            }

            // Activity Goal
            Section("Daily Goal Progress") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(cat.todayActivityMinutes) / \(cat.dailyActivityMinutes) min today")
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(Int(cat.activityGoalProgress * 100))%")
                            .foregroundColor(cat.activityGoalProgress >= 1 ? .green : .secondary)
                    }

                    ProgressView(value: cat.activityGoalProgress)
                        .tint(cat.activityGoalProgress >= 1 ? .green : .orange)

                    if cat.activityGoalProgress >= 1 {
                        Label("Daily goal achieved!", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
            }

            // History
            Section("History") {
                if groupedSessions.isEmpty {
                    ContentUnavailableView {
                        Label("No Activities", systemImage: "figure.run")
                    } description: {
                        Text("Start logging play sessions")
                    }
                } else {
                    ForEach(groupedSessions, id: \.0) { date, sessions in
                        Section(date) {
                            ForEach(sessions) { session in
                                ActivitySessionRow(session: session)
                            }
                            .onDelete { indexSet in
                                deleteSessions(sessions, at: indexSet)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Activity History")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddActivity = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddActivity) {
            ActivityLogView(cat: cat)
        }
    }

    private func deleteSessions(_ sessions: [ActivitySession], at offsets: IndexSet) {
        for index in offsets {
            let session = sessions[index]
            modelContext.delete(session)
        }
    }
}

struct ActivitySessionRow: View {
    let session: ActivitySession

    var body: some View {
        HStack {
            Image(systemName: session.activityType.icon)
                .font(.title3)
                .foregroundColor(.orange)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(session.activityType.rawValue)
                    .fontWeight(.medium)

                HStack(spacing: 8) {
                    Label(session.formattedDuration, systemImage: "clock")
                    Label("\(Int(session.estimatedCaloriesBurned)) kcal", systemImage: "flame")
                    IntensityIndicator(level: session.intensityLevel)
                }
                .font(.caption)
                .foregroundColor(.secondary)

                if let notes = session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(timeString(from: session.date))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct IntensityIndicator: View {
    let level: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Circle()
                    .fill(i <= level ? Color.orange : Color.gray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }
}

struct StatBlock: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        ActivityHistoryView(cat: Cat(
            name: "Whiskers",
            startWeight: 12.0,
            targetWeight: 10.0
        ))
    }
    .modelContainer(for: Cat.self, inMemory: true)
}

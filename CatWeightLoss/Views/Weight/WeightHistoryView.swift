import SwiftUI
import SwiftData

struct WeightHistoryView: View {
    @Bindable var cat: Cat
    @Environment(\.modelContext) private var modelContext

    @State private var showingAddEntry = false

    private var sortedEntries: [WeightEntry] {
        cat.weightEntries.sorted { $0.date > $1.date }
    }

    private var weeklyChange: Double? {
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        let recentEntries = sortedEntries.filter { $0.date >= oneWeekAgo }
        guard let oldest = recentEntries.last, let newest = recentEntries.first else {
            return nil
        }
        return newest.weight - oldest.weight
    }

    var body: some View {
        List {
            // Chart Section
            Section {
                if cat.weightEntries.count >= 2 {
                    WeightChartView(cat: cat, height: 200)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                } else {
                    ContentUnavailableView {
                        Label("Not Enough Data", systemImage: "chart.line.uptrend.xyaxis")
                    } description: {
                        Text("Add more weight entries to see your progress chart")
                    }
                }
            }

            // Summary Section
            Section("Summary") {
                HStack {
                    Text("Starting Weight")
                    Spacer()
                    Text(String(format: "%.1f \(cat.weightUnit.rawValue)", cat.startWeight))
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Current Weight")
                    Spacer()
                    Text(String(format: "%.1f \(cat.weightUnit.rawValue)", cat.currentWeight))
                        .fontWeight(.medium)
                }

                HStack {
                    Text("Target Weight")
                    Spacer()
                    Text(String(format: "%.1f \(cat.weightUnit.rawValue)", cat.targetWeight))
                        .foregroundColor(.green)
                }

                HStack {
                    Text("Total Change")
                    Spacer()
                    let change = cat.currentWeight - cat.startWeight
                    Text(String(format: "%+.1f \(cat.weightUnit.rawValue)", change))
                        .foregroundColor(change <= 0 ? .blue : .secondary)
                        .fontWeight(.medium)
                }

                if let weeklyChange = weeklyChange {
                    HStack {
                        Text("This Week")
                        Spacer()
                        Text(String(format: "%+.1f \(cat.weightUnit.rawValue)", weeklyChange))
                            .foregroundColor(weeklyChange <= 0 ? .blue : .secondary)
                    }
                }
            }

            // History Section
            Section("History (\(sortedEntries.count) entries)") {
                ForEach(sortedEntries) { entry in
                    WeightEntryRow(entry: entry, unit: cat.weightUnit)
                }
                .onDelete(perform: deleteEntries)
            }
        }
        .navigationTitle("Weight History")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddEntry = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            WeightLogView(cat: cat)
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = sortedEntries[index]
            modelContext.delete(entry)
        }
    }
}

struct WeightEntryRow: View {
    let entry: WeightEntry
    let unit: WeightUnit

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.formattedDate)
                    .font(.subheadline)
                if let notes = entry.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(String(format: "%.1f \(unit.rawValue)", entry.weight))
                .font(.headline)
                .monospacedDigit()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        WeightHistoryView(cat: Cat(
            name: "Whiskers",
            startWeight: 12.0,
            targetWeight: 10.0
        ))
    }
    .modelContainer(for: Cat.self, inMemory: true)
}

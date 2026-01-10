import SwiftUI
import SwiftData

struct WeightLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.brandConfig) private var brandConfig

    @Bindable var cat: Cat

    @State private var weight = ""
    @State private var date = Date()
    @State private var notes = ""

    var isValid: Bool {
        guard let weightValue = Double(weight) else { return false }
        return weightValue > 0 && weightValue < 100
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("0.0", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text(cat.weightUnit.rawValue)
                            .foregroundColor(.secondary)
                    }

                    DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                }

                Section("Notes (Optional)") {
                    TextField("Any observations...", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }

                if let weightValue = Double(weight) {
                    Section("Change") {
                        let change = weightValue - cat.currentWeight
                        HStack {
                            Image(systemName: change < 0 ? "arrow.down.circle.fill" : change > 0 ? "arrow.up.circle.fill" : "minus.circle.fill")
                                .foregroundColor(change < 0 ? (brandConfig?.primaryColor ?? .accentColor) : .secondary)

                            Text(change < 0 ? "Down" : change > 0 ? "Up" : "No change")

                            Spacer()

                            Text(String(format: "%.2f \(cat.weightUnit.rawValue)", abs(change)))
                                .fontWeight(.medium)
                                .foregroundColor(change < 0 ? (brandConfig?.primaryColor ?? .accentColor) : .secondary)
                        }

                        if weightValue <= cat.targetWeight {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(brandConfig?.accentColor ?? .green)
                                Text("Target reached")
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Log Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                weight = String(format: "%.1f", cat.currentWeight)
            }
        }
    }

    private func saveEntry() {
        guard let weightValue = Double(weight) else { return }

        // Delete existing entry for this day (if any) — one entry per day rule
        if let existingEntry = cat.existingEntry(for: date) {
            modelContext.delete(existingEntry)
        }

        // Create new entry
        let entry = WeightEntry(
            weight: weightValue,
            date: date,
            notes: notes.isEmpty ? nil : notes
        )
        cat.addWeightEntry(entry)

        // Record weight logged metric
        if let config = brandConfig {
            let skuId = config.defaultSKUId
            // Calculate days since last log
            let lastEntry = cat.weightEntries
                .filter { $0.id != entry.id }
                .sorted { $0.date > $1.date }
                .first
            let daysSinceLast = lastEntry.map { entry in
                Calendar.current.dateComponents([.day], from: entry.date, to: date).day ?? 0
            } ?? 0

            MetricsAggregator.shared.recordWeightLogged(
                brandId: config.brandId,
                skuId: skuId,
                daysSinceLastLog: daysSinceLast,
                in: modelContext
            )

            // Record progress percentage
            MetricsAggregator.shared.recordProgress(
                brandId: config.brandId,
                skuId: skuId,
                progressPercentage: cat.progressPercentage,
                in: modelContext
            )

            // Record entries count
            MetricsAggregator.shared.recordEntriesCount(
                brandId: config.brandId,
                skuId: skuId,
                count: cat.weightEntries.count,
                in: modelContext
            )
        }

        dismiss()
    }
}

#Preview {
    WeightLogView(cat: Cat(
        name: "Whiskers",
        startWeight: 12.0,
        targetWeight: 10.0
    ))
    .modelContainer(for: Cat.self, inMemory: true)
}

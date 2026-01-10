import SwiftUI
import SwiftData

struct WeightLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

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
                                .foregroundColor(change < 0 ? .blue : .secondary)

                            Text(change < 0 ? "Down" : change > 0 ? "Up" : "No change")

                            Spacer()

                            Text(String(format: "%.2f \(cat.weightUnit.rawValue)", abs(change)))
                                .fontWeight(.medium)
                                .foregroundColor(change < 0 ? .blue : .secondary)
                        }

                        if weightValue <= cat.targetWeight {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
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

        let entry = WeightEntry(
            weight: weightValue,
            date: date,
            notes: notes.isEmpty ? nil : notes
        )
        entry.cat = cat
        cat.weightEntries.append(entry)

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

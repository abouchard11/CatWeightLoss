import SwiftUI
import SwiftData

struct ActivityLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.brandConfig) private var brandConfig

    @Bindable var cat: Cat

    @State private var activityType: ActivityType = .play
    @State private var durationMinutes = 10
    @State private var intensityLevel = 3
    @State private var notes = ""
    @State private var date = Date()

    private var estimatedCalories: Double {
        let baseCalories = activityType.caloriesPerMinute * Double(durationMinutes)
        let intensityMultiplier = 0.8 + (Double(intensityLevel) * 0.1)
        return baseCalories * intensityMultiplier
    }

    var body: some View {
        NavigationStack {
            Form {
                // Activity Type
                Section("Activity Type") {
                    Picker("Type", selection: $activityType) {
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }

                // Duration
                Section("Duration") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("\(durationMinutes) minutes")
                                .font(.title2)
                                .fontWeight(.bold)

                            Spacer()

                            HStack(spacing: 8) {
                                Button {
                                    if durationMinutes > 1 { durationMinutes -= 1 }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                }
                                .disabled(durationMinutes <= 1)

                                Button {
                                    if durationMinutes < 120 { durationMinutes += 1 }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                }
                                .disabled(durationMinutes >= 120)
                            }
                        }

                        Slider(
                            value: Binding(
                                get: { Double(durationMinutes) },
                                set: { durationMinutes = Int($0) }
                            ),
                            in: 1...60,
                            step: 1
                        )
                    }

                    // Quick presets
                    HStack(spacing: 12) {
                        ForEach([5, 10, 15, 20, 30], id: \.self) { mins in
                            Button("\(mins)m") {
                                durationMinutes = mins
                            }
                            .buttonStyle(.bordered)
                            .tint(durationMinutes == mins ? .orange : .gray)
                        }
                    }
                }

                // Intensity
                Section("Intensity") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Level \(intensityLevel)")
                                .fontWeight(.medium)
                            Spacer()
                            Text(intensityDescription)
                                .foregroundColor(.secondary)
                        }

                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { level in
                                Button {
                                    intensityLevel = level
                                } label: {
                                    Image(systemName: level <= intensityLevel ? "flame.fill" : "flame")
                                        .foregroundColor(level <= intensityLevel ? .orange : .gray)
                                        .font(.title2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                // Date/Time
                Section {
                    DatePicker("When", selection: $date)
                }

                // Notes
                Section("Notes (Optional)") {
                    TextField("How did it go?", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }

                // Summary
                Section("Summary") {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("Estimated calories burned")
                        Spacer()
                        Text("\(Int(estimatedCalories)) kcal")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }

                    HStack {
                        Image(systemName: "figure.run")
                            .foregroundColor(brandConfig?.primaryColor ?? .accentColor)
                        Text("Today's total")
                        Spacer()
                        Text("\(cat.todayActivityMinutes + durationMinutes) / \(cat.dailyActivityMinutes) min")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Log Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveActivity()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var intensityDescription: String {
        switch intensityLevel {
        case 1: return "Very Light"
        case 2: return "Light"
        case 3: return "Moderate"
        case 4: return "High"
        case 5: return "Intense"
        default: return ""
        }
    }

    private func saveActivity() {
        let session = ActivitySession(
            date: date,
            durationMinutes: durationMinutes,
            activityType: activityType,
            intensityLevel: intensityLevel,
            notes: notes.isEmpty ? nil : notes
        )
        session.cat = cat
        cat.activitySessions.append(session)

        // Firebase Analytics: activity logged
        if let config = brandConfig {
            AnalyticsService.shared.logActivityLogged(
                brandId: config.brandId,
                activityType: activityType.rawValue,
                durationMinutes: durationMinutes
            )
        }

        dismiss()
    }
}

#Preview {
    ActivityLogView(cat: Cat(
        name: "Whiskers",
        startWeight: 12.0,
        targetWeight: 10.0
    ))
    .modelContainer(for: Cat.self, inMemory: true)
}

import SwiftUI
import SwiftData

struct FeedingPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var cat: Cat

    @State private var showingAddMeal = false

    private var sortedSchedules: [FeedingSchedule] {
        cat.feedingSchedules.sorted { $0.mealTime < $1.mealTime }
    }

    private var totalDailyCalories: Double {
        cat.feedingSchedules
            .filter { $0.isEnabled }
            .reduce(0) { $0 + $1.caloriesPerPortion }
    }

    var body: some View {
        NavigationStack {
            List {
                // Daily Summary
                Section("Daily Summary") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Calories")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(Int(totalDailyCalories)) kcal")
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        if let goal = cat.dailyCalorieGoal {
                            VStack(alignment: .trailing) {
                                Text("Goal")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(Int(goal)) kcal")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.vertical, 4)

                    NavigationLink {
                        PortionCalculatorView(cat: cat)
                    } label: {
                        Label("Calculate Portions", systemImage: "function")
                    }
                }

                // Meal Schedule
                Section("Meal Schedule") {
                    if sortedSchedules.isEmpty {
                        ContentUnavailableView {
                            Label("No Meals Scheduled", systemImage: "fork.knife")
                        } description: {
                            Text("Add meals to create a feeding schedule")
                        }
                    } else {
                        ForEach(sortedSchedules) { schedule in
                            MealScheduleRow(schedule: schedule, onToggle: {
                                toggleSchedule(schedule)
                            })
                        }
                        .onDelete(perform: deleteSchedules)
                    }
                }

                // Tips
                Section("Tips") {
                    Label("Split daily food into 2-3 meals", systemImage: "lightbulb.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Label("Measure portions with a kitchen scale", systemImage: "scalemass")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Label("Avoid free-feeding for weight loss", systemImage: "xmark.circle")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Feeding Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddMeal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView(cat: cat)
            }
        }
    }

    private func toggleSchedule(_ schedule: FeedingSchedule) {
        schedule.isEnabled.toggle()
        NotificationService.shared.updateFeedingReminders(for: cat)
    }

    private func deleteSchedules(at offsets: IndexSet) {
        for index in offsets {
            let schedule = sortedSchedules[index]
            NotificationService.shared.cancelFeedingReminder(for: schedule)
            modelContext.delete(schedule)
        }
    }
}

struct MealScheduleRow: View {
    @Bindable var schedule: FeedingSchedule
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Toggle(isOn: Binding(
                get: { schedule.isEnabled },
                set: { _ in onToggle() }
            )) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(schedule.mealName)
                            .fontWeight(.medium)
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(schedule.formattedTime)
                            .foregroundColor(.secondary)
                    }

                    HStack(spacing: 12) {
                        Label("\(Int(schedule.portionGrams))g", systemImage: "scalemass")
                        Label("\(Int(schedule.caloriesPerPortion)) kcal", systemImage: "flame")
                        Image(systemName: schedule.foodType.icon)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .green))
        }
        .opacity(schedule.isEnabled ? 1.0 : 0.5)
    }
}

struct AddMealView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var cat: Cat

    @State private var mealName = "Meal"
    @State private var mealTime = Date()
    @State private var portionGrams = "50"
    @State private var foodType: FoodType = .dry
    @State private var notificationEnabled = true

    var isValid: Bool {
        !mealName.isEmpty && Double(portionGrams) != nil
    }

    var calculatedCalories: Double {
        (Double(portionGrams) ?? 0) * foodType.averageCaloriesPerGram
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Meal Details") {
                    TextField("Meal Name", text: $mealName)

                    DatePicker("Time", selection: $mealTime, displayedComponents: .hourAndMinute)
                }

                Section("Portion") {
                    Picker("Food Type", selection: $foodType) {
                        ForEach(FoodType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }

                    HStack {
                        Text("Portion Size")
                        Spacer()
                        TextField("0", text: $portionGrams)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 60)
                        Text("grams")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Estimated Calories")
                        Spacer()
                        Text("\(Int(calculatedCalories)) kcal")
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Toggle("Reminder Notification", isOn: $notificationEnabled)
                }
            }
            .navigationTitle("Add Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addMeal()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private func addMeal() {
        guard let grams = Double(portionGrams) else { return }

        let schedule = FeedingSchedule(
            mealName: mealName,
            mealTime: mealTime,
            portionGrams: grams,
            foodType: foodType,
            notificationEnabled: notificationEnabled
        )
        schedule.cat = cat
        cat.feedingSchedules.append(schedule)

        if notificationEnabled {
            Task {
                let granted = await NotificationService.shared.requestAuthorization()
                if granted {
                    NotificationService.shared.scheduleFeedingReminder(for: schedule, catName: cat.name)
                }
            }
        }

        dismiss()
    }
}

#Preview {
    FeedingPlanView(cat: Cat(
        name: "Whiskers",
        startWeight: 12.0,
        targetWeight: 10.0
    ))
    .modelContainer(for: Cat.self, inMemory: true)
}

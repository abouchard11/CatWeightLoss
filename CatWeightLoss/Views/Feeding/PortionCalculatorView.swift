import SwiftUI

struct PortionCalculatorView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var cat: Cat

    @State private var mealsPerDay = 2
    @State private var foodType: FoodType = .dry
    @State private var aggressiveness: WeightLossAggressiveness = .moderate
    @State private var showingApply = false

    private var weightInKg: Double {
        cat.weightUnit == .kg ? cat.currentWeight : cat.currentWeight / 2.20462
    }

    private var targetInKg: Double {
        cat.weightUnit == .kg ? cat.targetWeight : cat.targetWeight / 2.20462
    }

    private var calorieRecommendation: DailyCalorieRecommendation {
        PortionCalculator.weightLossCalories(
            currentWeightKg: weightInKg,
            targetWeightKg: targetInKg,
            aggressiveness: aggressiveness
        )
    }

    private var portionRecommendation: PortionRecommendation {
        PortionCalculator.portionSizes(
            dailyCalories: calorieRecommendation.calories,
            mealsPerDay: mealsPerDay,
            foodType: foodType
        )
    }

    var body: some View {
        NavigationStack {
            List {
                // Current Stats
                Section("Current Stats") {
                    HStack {
                        Text("Current Weight")
                        Spacer()
                        Text(String(format: "%.1f \(cat.weightUnit.rawValue)", cat.currentWeight))
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Target Weight")
                        Spacer()
                        Text(String(format: "%.1f \(cat.weightUnit.rawValue)", cat.targetWeight))
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("To Lose")
                        Spacer()
                        Text(String(format: "%.1f \(cat.weightUnit.rawValue)", cat.weightToLose))
                            .foregroundColor(.orange)
                    }
                }

                // Settings
                Section("Portion Settings") {
                    Stepper("Meals per day: \(mealsPerDay)", value: $mealsPerDay, in: 1...4)

                    Picker("Food Type", selection: $foodType) {
                        ForEach(FoodType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon).tag(type)
                        }
                    }
                }

                // Results
                Section("Daily Guide") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily Calories")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(calorieRecommendation.formattedCalories) kcal")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("Per Meal")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(Int(portionRecommendation.caloriesPerMeal)) kcal")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }

                        Divider()

                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Daily")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(portionRecommendation.formattedTotalGrams)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("Per Meal (\(mealsPerDay)x)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(portionRecommendation.formattedGramsPerMeal)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Apply Button
                Section {
                    Button {
                        applyRecommendation()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Set as Daily Goal", systemImage: "checkmark.circle.fill")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Portion Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Goal Set!", isPresented: $showingApply) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Daily calorie goal set to \(calorieRecommendation.formattedCalories) kcal")
            }
        }
    }

    private func applyRecommendation() {
        cat.dailyCalorieGoal = calorieRecommendation.calories
        showingApply = true
    }
}

#Preview {
    PortionCalculatorView(cat: Cat(
        name: "Whiskers",
        startWeight: 12.0,
        targetWeight: 10.0,
        weightUnit: .lbs
    ))
    .modelContainer(for: Cat.self, inMemory: true)
}

import SwiftUI
import SwiftData

struct QuickSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let brandConfig: BrandConfiguration
    let onComplete: (Cat) -> Void

    @State private var catName = ""
    @State private var currentWeight = ""
    @State private var targetWeight = ""
    @State private var weightUnit: WeightUnit = .lbs
    @State private var showingError = false
    @State private var errorMessage = ""

    private var isValid: Bool {
        guard !catName.trimmingCharacters(in: .whitespaces).isEmpty,
              let current = Double(currentWeight),
              let target = Double(targetWeight),
              current > 0,
              target > 0,
              target < current else {
            return false
        }

        // Validate safe weight loss bounds
        return PortionCalculator.validateTargetWeight(current: current, target: target)
    }

    private var validationMessage: String? {
        guard let current = Double(currentWeight),
              let target = Double(targetWeight) else {
            return nil
        }

        if target >= current {
            return "Target should be less than current weight"
        }

        let maxLoss = current * 0.30
        if target < (current - maxLoss) {
            return "Target is too aggressive (max 30% total change)"
        }

        return nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Quick Setup")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Enter your cat's details to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)

                // Form
                VStack(spacing: 20) {
                    // Cat Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cat's Name")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        TextField("e.g., Whiskers", text: $catName)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.name)
                    }

                    // Weight Unit Toggle
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight Unit")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        Picker("Unit", selection: $weightUnit) {
                            ForEach(WeightUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Current Weight
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Weight")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        HStack {
                            TextField("0.0", text: $currentWeight)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)

                            Text(weightUnit.rawValue)
                                .foregroundColor(.secondary)
                                .frame(width: 30)
                        }
                    }

                    // Target Weight
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Target Weight")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        HStack {
                            TextField("0.0", text: $targetWeight)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)

                            Text(weightUnit.rawValue)
                                .foregroundColor(.secondary)
                                .frame(width: 30)
                        }

                        // Validation message
                        if let message = validationMessage {
                            Text(message)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Start Tracking Button
                Button(action: createCat) {
                    Text("Start Tracking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? brandConfig.primaryColor : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isValid)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .background(Color(.systemBackground))
            .alert("Error", isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func createCat() {
        guard let current = Double(currentWeight),
              let target = Double(targetWeight) else {
            errorMessage = "Please enter valid weight values"
            showingError = true
            return
        }

        // Create cat with brand association
        let cat = Cat(
            name: catName.trimmingCharacters(in: .whitespaces),
            startWeight: current,
            targetWeight: target,
            weightUnit: weightUnit
        )

        // Set calorie goal based on brand SKU
        if let sku = brandConfig.defaultSKU {
            let weightKg = weightUnit == .kg ? current : current / 2.20462
            let targetKg = weightUnit == .kg ? target : target / 2.20462
            let recommendation = PortionCalculator.weightLossCalories(
                currentWeightKg: weightKg,
                targetWeightKg: targetKg
            )
            cat.dailyCalorieGoal = recommendation.calories
        }

        // Create initial weight entry
        let initialEntry = WeightEntry(
            weight: current,
            date: Date(),
            notes: nil
        )
        initialEntry.cat = cat
        cat.weightEntries.append(initialEntry)

        modelContext.insert(cat)
        onComplete(cat)
    }
}

#Preview {
    let config = BrandConfiguration(
        brandId: "preview",
        brandName: "PetWell Foods",
        primaryColorHex: "#FF6B35",
        accentColorHex: "#004E64",
        defaultSKUId: "preview-sku"
    )

    return QuickSetupView(brandConfig: config) { cat in
        print("Created cat: \(cat.name)")
    }
}

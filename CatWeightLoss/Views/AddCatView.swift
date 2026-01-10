import SwiftUI
import SwiftData
import PhotosUI

struct AddCatView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var breed = ""
    @State private var birthDate = Date()
    @State private var includeBirthDate = false
    @State private var startWeight = ""
    @State private var targetWeight = ""
    @State private var weightUnit: WeightUnit = .lbs
    @State private var dailyActivityMinutes = 15

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?

    @State private var showingError = false
    @State private var errorMessage = ""

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(startWeight) != nil &&
        Double(targetWeight) != nil &&
        (Double(startWeight) ?? 0) > (Double(targetWeight) ?? 0)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Photo Section
                Section {
                    HStack {
                        Spacer()
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            if let photoData, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                            } else {
                                VStack {
                                    Image(systemName: "cat.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.accentColor.opacity(0.6))
                                .clipShape(Circle())
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(6)
                                        .background(Color.accentColor)
                                        .clipShape(Circle())
                                        .offset(x: 35, y: 35)
                                )
                            }
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                // Basic Info
                Section("Basic Information") {
                    TextField("Cat's Name", text: $name)
                        .textContentType(.name)

                    TextField("Breed (optional)", text: $breed)

                    Toggle("Add Birthday", isOn: $includeBirthDate)

                    if includeBirthDate {
                        DatePicker(
                            "Birthday",
                            selection: $birthDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                    }
                }

                // Weight Settings
                Section("Weight") {
                    Picker("Unit", selection: $weightUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack {
                        Text("Current Weight")
                        Spacer()
                        TextField("0.0", text: $startWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text(weightUnit.rawValue)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Target Weight")
                        Spacer()
                        TextField("0.0", text: $targetWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text(weightUnit.rawValue)
                            .foregroundColor(.secondary)
                    }

                    if let start = Double(startWeight), let target = Double(targetWeight) {
                        let toLose = start - target
                        if toLose > 0 {
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.green)
                                Text(String(format: "Goal: Lose %.1f %@", toLose, weightUnit.rawValue))
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Target should be less than current weight")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                            }
                        }
                    }
                }

                // Activity Goal
                Section("Daily Activity Goal") {
                    Stepper(
                        "\(dailyActivityMinutes) minutes",
                        value: $dailyActivityMinutes,
                        in: 5...60,
                        step: 5
                    )

                    Text("Recommended: 15-30 minutes of active play per day")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Cat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCat()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func saveCat() {
        guard let start = Double(startWeight),
              let target = Double(targetWeight) else {
            errorMessage = "Please enter valid weight values"
            showingError = true
            return
        }

        let cat = Cat(
            name: name.trimmingCharacters(in: .whitespaces),
            breed: breed.isEmpty ? nil : breed.trimmingCharacters(in: .whitespaces),
            birthDate: includeBirthDate ? birthDate : nil,
            startWeight: start,
            targetWeight: target,
            weightUnit: weightUnit,
            dailyActivityMinutes: dailyActivityMinutes
        )

        cat.photoData = photoData

        // Add initial weight entry
        let initialEntry = WeightEntry(weight: start, date: Date(), notes: "Starting weight")
        initialEntry.cat = cat
        cat.weightEntries.append(initialEntry)

        modelContext.insert(cat)
        dismiss()
    }
}

#Preview {
    AddCatView()
        .modelContainer(for: Cat.self, inMemory: true)
}

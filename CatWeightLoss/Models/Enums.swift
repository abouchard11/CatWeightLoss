import Foundation

enum WeightUnit: String, Codable, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"

    var conversionFactor: Double {
        switch self {
        case .kg: return 1.0
        case .lbs: return 2.20462
        }
    }

    func convert(_ value: Double, to unit: WeightUnit) -> Double {
        if self == unit { return value }
        switch (self, unit) {
        case (.kg, .lbs): return value * 2.20462
        case (.lbs, .kg): return value / 2.20462
        default: return value
        }
    }
}

enum ActivityType: String, Codable, CaseIterable {
    case play = "Play"
    case laser = "Laser Pointer"
    case featherToy = "Feather Toy"
    case catnip = "Catnip Session"
    case climbing = "Climbing/Cat Tree"
    case chase = "Chase Game"
    case walk = "Leash Walk"
    case other = "Other"

    var icon: String {
        switch self {
        case .play: return "figure.play"
        case .laser: return "light.max"
        case .featherToy: return "wind"
        case .catnip: return "leaf.fill"
        case .climbing: return "arrow.up.right"
        case .chase: return "hare.fill"
        case .walk: return "figure.walk"
        case .other: return "ellipsis.circle"
        }
    }

    var caloriesPerMinute: Double {
        switch self {
        case .play: return 5.0
        case .laser: return 6.0
        case .featherToy: return 5.5
        case .catnip: return 3.0
        case .climbing: return 7.0
        case .chase: return 8.0
        case .walk: return 4.0
        case .other: return 4.0
        }
    }
}

enum FoodType: String, Codable, CaseIterable {
    case dry = "Dry Food"
    case wet = "Wet Food"
    case mixed = "Mixed"
    case raw = "Raw Diet"

    var icon: String {
        switch self {
        case .dry: return "circle.grid.3x3.fill"
        case .wet: return "drop.fill"
        case .mixed: return "circle.lefthalf.filled"
        case .raw: return "leaf.arrow.circlepath"
        }
    }

    var averageCaloriesPerGram: Double {
        switch self {
        case .dry: return 3.5
        case .wet: return 1.0
        case .mixed: return 2.0
        case .raw: return 1.5
        }
    }
}

enum WeightTrend {
    case decreasing
    case stable
    case increasing
    case insufficient

    var icon: String {
        switch self {
        case .decreasing: return "arrow.down.right"
        case .stable: return "arrow.right"
        case .increasing: return "arrow.up.right"
        case .insufficient: return "minus"
        }
    }

    // Neutral colors - no judgment implied
    var color: String {
        switch self {
        case .decreasing: return "blue"
        case .stable: return "gray"
        case .increasing: return "gray"
        case .insufficient: return "gray"
        }
    }
}

import SwiftUI

struct CatCard: View {
    let cat: Cat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with photo and name
            HStack(spacing: 12) {
                catImage
                VStack(alignment: .leading, spacing: 4) {
                    Text(cat.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    if let breed = cat.breed, !breed.isEmpty {
                        Text(breed)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                trendIndicator
            }

            Divider()

            // Weight progress
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Weight Progress")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(cat.progressPercentage))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.accentColor)
                }

                ProgressView(value: cat.progressPercentage, total: 100)
                    .tint(progressColor)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Current")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f %@", cat.currentWeight, cat.weightUnit.rawValue))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Target")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f \(cat.weightUnit.rawValue)", cat.targetWeight))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }

            // Activity progress
            HStack {
                Image(systemName: "figure.run")
                    .foregroundColor(.orange)
                Text("\(cat.todayActivityMinutes)/\(cat.dailyActivityMinutes) min")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                ProgressRing(progress: cat.activityGoalProgress, size: 24, lineWidth: 3)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    @ViewBuilder
    private var catImage: some View {
        if let photoData = cat.photoData, let uiImage = UIImage(data: photoData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        } else {
            Image(systemName: "cat.fill")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.accentColor.opacity(0.8))
                .clipShape(Circle())
        }
    }

    @ViewBuilder
    private var trendIndicator: some View {
        let trend = cat.weightTrend
        Image(systemName: trend.icon)
            .font(.caption)
            .foregroundColor(trendColor(trend))
            .padding(6)
            .background(trendColor(trend).opacity(0.15))
            .clipShape(Circle())
    }

    // Neutral progress color - no judgment
    private var progressColor: Color {
        return .blue
    }

    // Neutral trend colors - no judgment
    private func trendColor(_ trend: WeightTrend) -> Color {
        switch trend {
        case .decreasing: return .blue
        case .stable: return .gray
        case .increasing: return .gray
        case .insufficient: return .gray
        }
    }
}

#Preview {
    CatCard(cat: Cat(
        name: "Whiskers",
        breed: "British Shorthair",
        startWeight: 12.0,
        targetWeight: 10.0
    ))
    .padding()
}

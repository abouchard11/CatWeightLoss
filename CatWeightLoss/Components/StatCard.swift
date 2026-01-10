import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color

    init(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String,
        color: Color = .accentColor
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct StatCardCompact: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack {
            StatCard(
                title: "Current Weight",
                value: "11.2 lbs",
                subtitle: "-0.8 lbs from start",
                icon: "scalemass",
                color: .blue
            )
            StatCard(
                title: "Target",
                value: "10.0 lbs",
                subtitle: "1.2 lbs to go",
                icon: "flag.fill",
                color: .green
            )
        }

        StatCardCompact(
            title: "Today's Activity",
            value: "12 min",
            icon: "figure.run",
            color: .orange
        )
    }
    .padding()
}

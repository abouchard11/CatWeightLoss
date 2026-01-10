import SwiftUI

/// Reusable action button with icon and tinted background
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

/// Compact action button for tighter layouts
struct ActionButtonCompact: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            ActionButton(title: "Log Weight", icon: "scalemass.fill", color: .blue) {}
            ActionButton(title: "Log Activity", icon: "figure.run", color: .orange) {}
        }

        HStack(spacing: 8) {
            ActionButtonCompact(title: "Edit", icon: "pencil", color: .blue) {}
            ActionButtonCompact(title: "Delete", icon: "trash", color: .red) {}
        }
    }
    .padding()
}

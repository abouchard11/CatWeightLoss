import SwiftUI

struct ProgressRing: View {
    let progress: Double
    var size: CGFloat = 60
    var lineWidth: CGFloat = 6
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var foregroundColor: Color = .accentColor

    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    foregroundColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
        .frame(width: size, height: size)
    }
}

struct ProgressRingWithLabel: View {
    let progress: Double
    let label: String
    var size: CGFloat = 80
    var lineWidth: CGFloat = 8
    var foregroundColor: Color = .accentColor

    var body: some View {
        ZStack {
            ProgressRing(
                progress: progress,
                size: size,
                lineWidth: lineWidth,
                foregroundColor: foregroundColor
            )

            Text(label)
                .font(.system(size: size * 0.2, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}

struct ProgressRingWithIcon: View {
    let progress: Double
    let iconName: String
    var size: CGFloat = 60
    var lineWidth: CGFloat = 6
    var foregroundColor: Color = .accentColor

    var body: some View {
        ZStack {
            ProgressRing(
                progress: progress,
                size: size,
                lineWidth: lineWidth,
                foregroundColor: foregroundColor
            )

            Image(systemName: iconName)
                .font(.system(size: size * 0.3))
                .foregroundColor(foregroundColor)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressRing(progress: 0.75)
        ProgressRingWithLabel(progress: 0.65, label: "65%")
        ProgressRingWithIcon(progress: 0.5, iconName: "figure.run")
    }
    .padding()
}

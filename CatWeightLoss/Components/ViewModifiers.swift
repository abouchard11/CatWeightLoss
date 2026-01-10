import SwiftUI

// MARK: - Card Style Modifier

/// Standard card appearance used throughout the app
struct CardStyle: ViewModifier {
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 16
    var backgroundColor: Color = Color(.systemBackground)

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

extension View {
    /// Apply standard card styling
    func cardStyle(
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 16,
        backgroundColor: Color = Color(.systemBackground)
    ) -> some View {
        modifier(CardStyle(
            padding: padding,
            cornerRadius: cornerRadius,
            backgroundColor: backgroundColor
        ))
    }

    /// Apply compact card styling (smaller padding)
    func cardStyleCompact() -> some View {
        modifier(CardStyle(padding: 12, cornerRadius: 12))
    }
}

// MARK: - Conditional Modifier

extension View {
    /// Apply modifier conditionally
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Loading Overlay

struct LoadingOverlay: ViewModifier {
    let isLoading: Bool
    let message: String?

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)

            if isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.2)
                    if let message = message {
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(24)
                .background(.ultraThinMaterial)
                .cornerRadius(16)
            }
        }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool, message: String? = nil) -> some View {
        modifier(LoadingOverlay(isLoading: isLoading, message: message))
    }
}

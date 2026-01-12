import SwiftUI

/// Error view displayed when database initialization fails
/// Provides retry and reset options for recovery
struct DatabaseErrorView: View {
    let error: Error
    let onRetry: () -> Void
    let onReset: () -> Void

    @State private var showingResetConfirmation = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundColor(.orange)

            VStack(spacing: 12) {
                Text("Unable to Load Data")
                    .font(.title2)
                    .fontWeight(.bold)

                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: onRetry) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                        Text("Try Again")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                }

                Button {
                    showingResetConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .font(.title3)
                        Text("Reset Data")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.red.opacity(0.15))
                    .foregroundColor(.red)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .alert("Reset All Data?", isPresented: $showingResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                onReset()
            }
        } message: {
            Text("This will delete all saved data and restart the app. This cannot be undone.")
        }
    }
}

#Preview {
    DatabaseErrorView(
        error: NSError(
            domain: "SwiftData",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Failed to load persistent stores"]
        ),
        onRetry: { },
        onReset: { }
    )
}

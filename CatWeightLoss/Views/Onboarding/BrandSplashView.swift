import SwiftUI

struct BrandSplashView: View {
    let brandConfig: BrandConfiguration
    let onContinue: () -> Void

    @State private var animateGradient = false
    @State private var showContent = false
    @State private var showButton = false

    /// Get brand tagline from seed data if available
    private var brandTagline: String {
        if let seed = BrandSeeds.all.first(where: { $0.brandId == brandConfig.brandId }) {
            return seed.tagline
        }
        return "Premium nutrition for your cat"
    }

    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    brandConfig.primaryColor.opacity(0.15),
                    brandConfig.accentColor.opacity(0.08),
                    Color(.systemBackground)
                ],
                startPoint: animateGradient ? .topLeading : .topTrailing,
                endPoint: animateGradient ? .bottomTrailing : .bottomLeading
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }

            VStack(spacing: 40) {
                Spacer()

                // Brand Product Image or Logo
                Group {
                    if let productImage = brandConfig.productImage {
                        productImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220, maxHeight: 180)
                            .shadow(color: brandConfig.primaryColor.opacity(0.3), radius: 20, y: 10)
                    } else if let logoData = brandConfig.logoData,
                              let uiImage = UIImage(data: logoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 100)
                    } else {
                        // Stylized cat icon with brand gradient
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [brandConfig.primaryColor, brandConfig.accentColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 140, height: 140)
                                .shadow(color: brandConfig.primaryColor.opacity(0.4), radius: 20, y: 8)

                            Image(systemName: "cat.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .scaleEffect(showContent ? 1 : 0.8)
                .opacity(showContent ? 1 : 0)

                // Brand Name
                Text(brandConfig.brandName)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [brandConfig.primaryColor, brandConfig.primaryColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)

                // Tagline
                VStack(spacing: 12) {
                    Text(brandTagline)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 4) {
                        Image(systemName: "pawprint.fill")
                            .font(.caption)
                        Text("Weight tracking made simple")
                        Image(systemName: "pawprint.fill")
                            .font(.caption)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 15)

                Spacer()

                // Get Started Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("Get Started")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [brandConfig.primaryColor, brandConfig.accentColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: brandConfig.primaryColor.opacity(0.4), radius: 12, y: 6)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .scaleEffect(showButton ? 1 : 0.9)
                .opacity(showButton ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5)) {
                showButton = true
            }
        }
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

    return BrandSplashView(brandConfig: config) {
        print("Continue tapped")
    }
}

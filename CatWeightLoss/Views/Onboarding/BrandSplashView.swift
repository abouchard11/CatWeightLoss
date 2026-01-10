import SwiftUI

struct BrandSplashView: View {
    let brandConfig: BrandConfiguration
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Brand Logo or Icon
            if let logoData = brandConfig.logoData,
               let uiImage = UIImage(data: logoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 100)
            } else {
                // Default cat icon with brand color
                Image(systemName: "cat.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(brandConfig.primaryColor)
            }

            // Brand Name
            Text(brandConfig.brandName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(brandConfig.primaryColor)

            // Tagline
            VStack(spacing: 8) {
                Text("Track your cat's progress")
                    .font(.title2)
                    .foregroundColor(.primary)

                Text("Simple weight tracking")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Get Started Button
            Button(action: onContinue) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(brandConfig.primaryColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
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

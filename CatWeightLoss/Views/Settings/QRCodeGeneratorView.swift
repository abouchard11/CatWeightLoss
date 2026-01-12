import SwiftUI
import SwiftData
import CoreImage.CIFilterBuiltins

#if DEBUG
/// DEBUG-only admin tool for generating QR codes for brand activation.
/// Generates deep links in the format: catweighttracker://activate?brand=...&sku=...
struct QRCodeGeneratorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedBrandSeed: BrandSeed?
    @State private var selectedSKU: SKUSeed?
    @State private var generatedImage: UIImage?
    @State private var deepLinkURL: String = ""
    @State private var showShareSheet = false

    private let context = CIContext()
    private let qrFilter = CIFilter.qrCodeGenerator()

    var body: some View {
        NavigationStack {
            Form {
                brandPickerSection
                skuPickerSection

                if !deepLinkURL.isEmpty {
                    qrCodeSection
                    deepLinkPreviewSection
                    shareSection
                }
            }
            .navigationTitle("QR Code Generator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedBrandSeed?.brandId) { _, _ in
                selectedSKU = selectedBrandSeed?.skus.first
                regenerateQRCode()
            }
            .onChange(of: selectedSKU?.skuId) { _, _ in
                regenerateQRCode()
            }
            .onAppear {
                if selectedBrandSeed == nil {
                    selectedBrandSeed = BrandSeeds.all.first
                    selectedSKU = selectedBrandSeed?.skus.first
                    regenerateQRCode()
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = generatedImage {
                    ShareSheet(activityItems: [image])
                }
            }
        }
    }

    // MARK: - Sections

    private var brandPickerSection: some View {
        Section {
            Picker("Brand", selection: $selectedBrandSeed) {
                ForEach(BrandSeeds.all, id: \.brandId) { brand in
                    HStack {
                        Circle()
                            .fill(Color(hex: brand.primaryColorHex) ?? .blue)
                            .frame(width: 12, height: 12)
                        Text(brand.brandName)
                    }
                    .tag(Optional(brand))
                }
            }
        } header: {
            Text("Select Brand")
        } footer: {
            if let brand = selectedBrandSeed {
                Text(brand.tagline)
            }
        }
    }

    private var skuPickerSection: some View {
        Section {
            if let brand = selectedBrandSeed {
                Picker("Product SKU", selection: $selectedSKU) {
                    ForEach(brand.skus, id: \.skuId) { sku in
                        VStack(alignment: .leading) {
                            Text(sku.displayName)
                            Text("\(String(format: "%.1f", sku.caloriesPerGram)) cal/g")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .tag(Optional(sku))
                    }
                }
            } else {
                Text("Select a brand first")
                    .foregroundColor(.secondary)
            }
        } header: {
            Text("Select Product")
        }
    }

    private var qrCodeSection: some View {
        Section {
            if let image = generatedImage {
                HStack {
                    Spacer()
                    Image(uiImage: image)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        } header: {
            Text("Generated QR Code")
        } footer: {
            Text("Scan this QR code to activate the brand configuration in the app.")
        }
    }

    private var deepLinkPreviewSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Deep Link URL")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(deepLinkURL)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
            }
            .padding(.vertical, 4)

            if let brand = selectedBrandSeed, let sku = selectedSKU {
                VStack(alignment: .leading, spacing: 4) {
                    parameterRow(label: "Brand ID", value: brand.brandId)
                    parameterRow(label: "Brand Name", value: brand.brandName)
                    parameterRow(label: "SKU ID", value: sku.skuId)
                    parameterRow(label: "SKU Name", value: sku.displayName)
                    parameterRow(label: "Calories/gram", value: String(format: "%.1f", sku.caloriesPerGram))
                    parameterRow(label: "Serving Size", value: "\(Int(sku.servingSizeGrams))g")
                    parameterRow(label: "Primary Color", value: brand.primaryColorHex)
                    parameterRow(label: "Accent Color", value: brand.accentColorHex)
                }
            }
        } header: {
            Text("Parameters")
        }
    }

    private var shareSection: some View {
        Section {
            Button {
                showShareSheet = true
            } label: {
                Label("Export QR Code as PNG", systemImage: "square.and.arrow.up")
            }
            .disabled(generatedImage == nil)

            Button {
                UIPasteboard.general.string = deepLinkURL
            } label: {
                Label("Copy Deep Link URL", systemImage: "doc.on.doc")
            }
        } header: {
            Text("Export")
        }
    }

    // MARK: - Helpers

    private func parameterRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .foregroundColor(.primary)
        }
    }

    private func regenerateQRCode() {
        guard let brand = selectedBrandSeed,
              let sku = selectedSKU else {
            deepLinkURL = ""
            generatedImage = nil
            return
        }

        deepLinkURL = buildDeepLink(brand: brand, sku: sku)
        generatedImage = generateQRCodeImage(from: deepLinkURL)
    }

    private func buildDeepLink(brand: BrandSeed, sku: SKUSeed) -> String {
        var components = URLComponents()
        components.scheme = "catweighttracker"
        components.host = "activate"

        components.queryItems = [
            URLQueryItem(name: "brand", value: brand.brandId),
            URLQueryItem(name: "name", value: brand.brandName),
            URLQueryItem(name: "sku", value: sku.skuId),
            URLQueryItem(name: "skuname", value: sku.displayName),
            URLQueryItem(name: "cal", value: String(format: "%.1f", sku.caloriesPerGram)),
            URLQueryItem(name: "serving", value: String(format: "%.0f", sku.servingSizeGrams)),
            URLQueryItem(name: "color", value: brand.primaryColorHex),
            URLQueryItem(name: "accent", value: brand.accentColorHex)
        ]

        return components.url?.absoluteString ?? ""
    }

    private func generateQRCodeImage(from string: String) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }

        qrFilter.message = data
        qrFilter.correctionLevel = "M"

        guard let outputImage = qrFilter.outputImage else { return nil }

        // Scale up for better resolution
        let scale: CGFloat = 10
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledImage = outputImage.transformed(by: transform)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

// MARK: - ShareSheet

private struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - BrandSeed Conformances

extension BrandSeed: Equatable {
    static func == (lhs: BrandSeed, rhs: BrandSeed) -> Bool {
        lhs.brandId == rhs.brandId
    }
}

extension BrandSeed: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(brandId)
    }
}

extension SKUSeed: Equatable {
    static func == (lhs: SKUSeed, rhs: SKUSeed) -> Bool {
        lhs.skuId == rhs.skuId
    }
}

extension SKUSeed: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(skuId)
    }
}

// MARK: - Preview

#Preview {
    QRCodeGeneratorView()
        .modelContainer(for: BrandConfiguration.self, inMemory: true)
}
#endif

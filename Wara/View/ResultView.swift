//
//  ResultView.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI

// --- RESULT VIEW (UTAMA) ---
struct ResultView: View {
    let result: DetectionResult
    let onDismiss: () -> Void
    
    private var sortedIngredients: [Ingredient] {
        result.foundIngredients.sorted {
            // Urutkan berdasarkan skor kategori, dari skor terkecil (paling kritis)
            // ke terbesar (paling aman).
            order(for: $0.category) < order(for: $1.category)
        }
    }
    
    // Helper function untuk memberikan skor prioritas pada setiap kategori
    private func order(for category: IngredientCategory) -> Int {
        switch category {
        case .tidakAman:
            return 0 // Prioritas tertinggi
        case .raguRagu:
            return 1 // Prioritas menengah
        case .aman:
            return 2 // Prioritas terendah
        }
    }

    private var statusColor: Color {
        switch result.status {
        case .aman: return .green
        case .raguRagu: return .orange
        case .tidakAman: return .red
        case .ingredientsNotFound: return .blue
        }
    }

    private var statusIcon: String {
        switch result.status {
        case .aman: return "checkmark.circle.fill"
        case .raguRagu: return "questionmark.diamond.fill"
        case .tidakAman: return "xmark.octagon.fill"
        case .ingredientsNotFound: return "doc.text.magnifyingglass"
        }
    }

    private var statusTitle: String {
        switch result.status {
        case .aman:
            return result.foundIngredients.isEmpty
                ? "Insya Allah Aman" : "Bahan Aman Terdeteksi"
        case .raguRagu: return "Ragu-ragu"
        case .tidakAman: return "Terdeteksi Tidak Aman"
        case .ingredientsNotFound: return "Label Bahan Tidak Ditemukan"
        }
    }

    var body: some View {
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            Image(systemName: statusIcon).font(.system(size: 60)).foregroundColor(statusColor)
                            Text(statusTitle).font(.title.bold()).foregroundColor(statusColor).multilineTextAlignment(.center)

                            Group {
                                switch result.status {
                                case .aman where result.foundIngredients.isEmpty:
                                    Text("Tidak ditemukan bahan kritis dari database pada gambar. Selalu periksa kembali untuk memastikan.")
                                    
                                case .ingredientsNotFound:
                                    Text("Aplikasi tidak dapat menemukan kata kunci '원재료' (Bahan). Pastikan Anda memindai bagian daftar bahan pada kemasan.")
                                    
                                default:
                                    if !result.foundIngredients.isEmpty {
                                        Text("Bahan Dikenali:").font(.headline)
                                        // MARK: - PERUBAHAN: Gunakan 'sortedIngredients'
                                        ForEach(sortedIngredients, id: \.koreanName) { item in
                                            IngredientCard(ingredient: item)
                                        }
                                    }
                                }
                            }
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    Button("Scan Lagi", action: onDismiss)
                        .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity)
                        .padding().background(Color.blue).cornerRadius(12)
                        .padding([.horizontal, .bottom])
                }
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.75)
                .background(Color(.systemBackground)).cornerRadius(20).shadow(radius: 10)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .background(Color.black.opacity(0.4).ignoresSafeArea())
        }
    }

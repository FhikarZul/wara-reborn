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
        case .aman: return result.foundIngredients.isEmpty ? "Insya Allah Aman" : "Bahan Aman Terdeteksi"
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
                                // Hanya menampilkan bahan yang dikenali
                                if !result.foundIngredients.isEmpty {
                                    Text("Bahan Dikenali:").font(.headline)
                                    ForEach(result.foundIngredients, id: \.koreanName) { item in
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


// --- INGREDIENT CARD ---
struct IngredientCard: View {
    let ingredient: Ingredient
    
    private var categoryColor: Color {
        switch ingredient.category {
        case .aman: return .green
        case .raguRagu: return .orange
        case .tidakAman: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(ingredient.koreanName).font(.headline)
                Spacer()
                Text(ingredient.category.rawValue.capitalized).font(.caption.bold()).foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(categoryColor).cornerRadius(8)
            }
            Text(ingredient.englishName).font(.subheadline).foregroundColor(.secondary)
            
            if !ingredient.descriptionText.isEmpty {
                Divider()
                Text(ingredient.descriptionText).font(.footnote)
            }
        }
        .padding().background(Color(.secondarySystemBackground)).cornerRadius(12)
    }
}


// --- PROCESSING VIEW ---
struct ProcessingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView().scaleEffect(2).progressViewStyle(CircularProgressViewStyle(tint: .white))
                Text("Menganalisa Gambar...").font(.headline).foregroundColor(.white)
            }
        }
    }
}


// --- ERROR VIEW ---
struct ErrorView: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 60)).foregroundColor(.yellow)
            Text("Terjadi Kesalahan").font(.title.bold())
            Text(message).font(.body).multilineTextAlignment(.center).foregroundColor(.secondary)
            
            Button("Coba Lagi", action: onDismiss)
                .font(.headline).foregroundColor(.white).padding()
                .background(Color.blue).cornerRadius(12)
        }
        .padding(30).frame(maxWidth: 300)
        .background(Color(.systemBackground)).cornerRadius(20).shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea())
    }
}

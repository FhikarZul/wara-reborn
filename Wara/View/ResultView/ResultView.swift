//
//  ResultView.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI

struct ResultView: View {
    let result: DetectionResult
    let onDismiss: () -> Void
    @State private var showContent = false

    
    private var ingredientsToAvoid: [Ingredient] {
        result.foundIngredients.filter { $0.category == .tidakAman }
    }
    private var ingredientsToReview: [Ingredient] {
        result.foundIngredients.filter { $0.category == .raguRagu }
    }
    private var safeIngredients: [Ingredient] {
        result.foundIngredients.filter { $0.category == .aman }
    }
    private var mainStatusTuple: (icon: String, color: Color, title: String, subtitle: String) {
        switch result.status {
        case .tidakAman:
            return ("xmark.circle.fill", .red, "Produk ini mengandung\nbahan yang perlu dihindari", "Kami menyarankan untuk menghindari produk ini karena mengandung bahan yang perlu dihindari")
        case .raguRagu:
            return ("exclamationmark.triangle.fill", .orange, "Produk ini mengandung\nbahan yang perlu ditinjau", "Beberapa bahan dalam produk ini perlu ditinjau lebih lanjut")
        case .aman where !result.foundIngredients.isEmpty:
            return ("checkmark.circle.fill", .green, "Produk ini mengandung\nbahan yang dapat dikonsumsi", "Semua bahan yang terdeteksi dalam produk ini dapat dikonsumsi")
        case .ingredientsNotFound:
            return ("doc.text.magnifyingglass", .blue, "Label Bahan\nTidak Ditemukan", "Pastikan Anda memindai bagian daftar bahan pada kemasan")
        default:
            return ("checkmark.circle.fill", .green, "Tidak Ada Bahan Kritis\nDitemukan", "Tidak ada bahan yang perlu dihindari atau ditinjau yang terdeteksi")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        let status = mainStatusTuple
                        Image(systemName: status.icon)
                            .font(.system(size: 80))
                            .foregroundColor(status.color)
                            .scaleEffect(showContent ? 1 : 0.5)
                            .opacity(showContent ? 1 : 0)
                        
                        Text(status.title)
                            .font(.title2).fontWeight(.bold).multilineTextAlignment(.center)
                            .foregroundColor(.primary).padding(.horizontal)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring().delay(0.1), value: showContent)

                        Text(status.subtitle)
                            .font(.body).foregroundColor(.secondary).multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring().delay(0.2), value: showContent)
                    }
                    .padding(.vertical, 10)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            showContent = true
                        }
                    }
                    
                    Divider()
                    
                    VStack(spacing: 0) {
                        if !ingredientsToAvoid.isEmpty {
                            NavigationLink(destination: IngredientListView(ingredients: ingredientsToAvoid, category: .tidakAman)) {
                                ResultCategoryRow(icon: "xmark.circle.fill", color: .red, title: "Bahan yang perlu dihindari", count: ingredientsToAvoid.count)
                            }
                        }
                        if !ingredientsToReview.isEmpty {
                            NavigationLink(destination: IngredientListView(ingredients: ingredientsToReview, category: .raguRagu)) {
                                ResultCategoryRow(icon: "exclamationmark.circle.fill", color: .orange, title: "Bahan yang perlu ditinjau", count: ingredientsToReview.count)
                            }
                        }
                        if !safeIngredients.isEmpty {
                            NavigationLink(destination: IngredientListView(ingredients: safeIngredients, category: .aman)) {
                                ResultCategoryRow(icon: "checkmark.circle.fill", color: .green, title: "Bahan yang dapat dikonsumsi", count: safeIngredients.count)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Tombol Scan Kembali
                Button(action: onDismiss) {
                    Text("Scan Kembali")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity) // Perluas frame dari Text
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Hasil Pindai")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}



#Preview {
    ResultView(
        result: DetectionResult(
            status: .tidakAman,
            foundIngredients: [
                Ingredient(koreanName: "돼지고기", pronunciation: "Dwaeji-gogi", englishName: "Pork", descriptionText: "Daging babi yang diharamkan dalam Islam.", category: .tidakAman),
                Ingredient(koreanName: "돈지", pronunciation: "Donji", englishName: "Lard", descriptionText: "Lemak babi yang sering digunakan dalam pembuatan kue dan masakan.", category: .tidakAman),
                Ingredient(koreanName: "젤라틴", pronunciation: "Jellatin", englishName: "Gelatin", descriptionText: "Bisa berasal dari babi, sapi, atau ikan. Perlu dipastikan sumbernya. Tanpa sertifikasi, statusnya syubhat.", category: .raguRagu),
                Ingredient(koreanName: "소금", pronunciation: "Sogeum", englishName: "Salt", descriptionText: "Garam mineral, halal untuk dikonsumsi.", category: .aman)
            ],
            originalText: ""
        ),
        onDismiss: {}
    )
}

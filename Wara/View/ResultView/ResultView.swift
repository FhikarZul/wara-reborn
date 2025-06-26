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

    private func createSummary(for ingredients: [Ingredient]) -> String {
        let names = ingredients.map { $0.englishName.lowercased() }

        switch names.count {
        case 0:
            return ""
        case 1:
            return names.first ?? ""
        case 2:
            return names.joined(separator: " dan ")
        default:
            let topThree = names.prefix(3).joined(separator: ", ")
            return "\(topThree), dll."
        }
    }

    private var mainStatusTuple:
        (icon: String, color: Color, title: String, subtitle: String)
    {
        switch result.status {
        case .tidakAman:
            let summary = createSummary(for: ingredientsToAvoid)
            let subtitle =
                "Kami menyarankan untuk menghindari produk ini karena mengandung \(summary) yang perlu dihindari."
            return (
                "xmark.circle.fill", .red,
                "Produk ini mengandung\nbahan yang perlu dihindari", subtitle
            )
        case .raguRagu:
            let summary = createSummary(for: ingredientsToReview)
            let subtitle =
                "Beberapa bahan dalam produk ini perlu ditinjau lebih lanjut seperti: \(summary)."
            return (
                "exclamationmark.triangle.fill", .orange,
                "Produk ini mengandung\nbahan yang perlu ditinjau", subtitle
            )
        case .aman where !result.foundIngredients.isEmpty:
            return (
                "checkmark.circle.fill", .green,
                "Produk ini mengandung\nbahan yang dapat dikonsumsi",
                "Semua bahan yang terdeteksi dalam produk ini dapat dikonsumsi"
            )
        case .ingredientsNotFound:
            return (
                "doc.text.magnifyingglass", .primaryblue,
                "Label Bahan\nTidak Ditemukan",
                "Pastikan Anda memindai bagian daftar bahan pada kemasan"
            )
        default:
            return (
                "checkmark.circle.fill", .green,
                "Tidak Ada Bahan Kritis\nDitemukan",
                "Tidak ada bahan yang perlu dihindari atau ditinjau yang terdeteksi"
            )
        }
    }

    struct HowToStep: Identifiable {
        let id = UUID()
        let imageName: String
        let description: String
    }

    let howToData: [HowToStep] = [
        HowToStep(
            imageName: "guide_step_1",
            description: "Cari bagian kemasan yang berisi daftar bahan produk."
        ),
        HowToStep(
            imageName: "guide_step_2",
            description:
                "Arahkan Kamera ke arah box komposisi makanan, pastikan teks terlihat jelas, tidak buram, dan terkena cahaya yang cukup."
        ),
        HowToStep(
            imageName: "guide_step_3",
            description:
                "Pindai & tunggu hasil setelah teks terbaca, sistem akan otomatis memproses dan menampilkan hasilnya."
        ),
    ]

    struct HowToStepCard: View {
        let step: HowToStep
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Image(step.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 361, height: 361)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(step.description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 361)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    if result.status == .ingredientsNotFound {
                        VStack(spacing: 24) {
                            let status = mainStatusTuple
                            Image(systemName: status.icon).font(
                                .system(size: 80)
                            ).foregroundColor(status.color)
                            Text(status.title).font(.title2).fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary)
                            Text(status.subtitle).font(.body).foregroundColor(
                                .secondary
                            ).multilineTextAlignment(.center).padding(
                                .horizontal
                            )

                            Divider()

                            VStack(alignment: .leading, spacing: 12) {
                                Text("Cara Pindai yang Benar")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false)
                                {
                                    HStack(spacing: 16) {
                                        ForEach(howToData) { step in
                                            HowToStepCard(step: step)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 35)

                    } else {
                        VStack(spacing: 10) {
                            let status = mainStatusTuple
                            Image(systemName: status.icon).font(
                                .system(size: 80)
                            ).foregroundColor(status.color)
                                .scaleEffect(showContent ? 1 : 0.5).opacity(
                                    showContent ? 1 : 0
                                )
                            Text(status.title).font(.title2).fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.primary).padding(.horizontal)
                                .opacity(showContent ? 1 : 0).animation(
                                    .spring().delay(0.1),
                                    value: showContent
                                )
                            Text(status.subtitle).font(.body).foregroundColor(
                                .secondary
                            ).multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .opacity(showContent ? 1 : 0).animation(
                                    .spring().delay(0.2),
                                    value: showContent
                                )
                        }
                        .padding(.bottom, 35)
                        .padding(.top, 35)

                        // Daftar Kategori (hanya muncul jika ada hasil)
                        VStack(spacing: 0) {
                            if !ingredientsToAvoid.isEmpty {
                                NavigationLink(
                                    destination: IngredientListView(
                                        ingredients: ingredientsToAvoid,
                                        category: .tidakAman
                                    )
                                ) {
                                    ResultCategoryRow(
                                        icon: "xmark.circle.fill",
                                        color: .red,
                                        title: "Bahan yang perlu dihindari",
                                        count: ingredientsToAvoid.count
                                    )
                                }
                            }
                            if !ingredientsToReview.isEmpty {
                                NavigationLink(
                                    destination: IngredientListView(
                                        ingredients: ingredientsToReview,
                                        category: .raguRagu
                                    )
                                ) {
                                    ResultCategoryRow(
                                        icon: "exclamationmark.circle.fill",
                                        color: .orange,
                                        title: "Bahan yang perlu ditinjau",
                                        count: ingredientsToReview.count
                                    )
                                }
                            }
                            if !safeIngredients.isEmpty {
                                NavigationLink(
                                    destination: IngredientListView(
                                        ingredients: safeIngredients,
                                        category: .aman
                                    )
                                ) {
                                    ResultCategoryRow(
                                        icon: "checkmark.circle.fill",
                                        color: .green,
                                        title: "Bahan yang dapat dikonsumsi",
                                        count: safeIngredients.count
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6))
                    {
                        showContent = true
                    }
                }

                Spacer()

                // Tombol Scan Kembali
                Button(action: onDismiss) {
                    Text("Scan Kembali")
                        .font(.headline).foregroundColor(.white).frame(
                            maxWidth: .infinity
                        )
                        .padding().background(Color("primaryblue", bundle: nil))
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
                Ingredient(
                    koreanName: "돼지고기",
                    pronunciation: "Dwaeji-gogi",
                    englishName: "Pork",
                    descriptionText: "Daging babi yang diharamkan dalam Islam.",
                    category: .tidakAman
                ),
                Ingredient(
                    koreanName: "돈지",
                    pronunciation: "Donji",
                    englishName: "Lard",
                    descriptionText:
                        "Lemak babi yang sering digunakan dalam pembuatan kue dan masakan.",
                    category: .tidakAman
                ),
                Ingredient(
                    koreanName: "젤라틴",
                    pronunciation: "Jellatin",
                    englishName: "Gelatin",
                    descriptionText:
                        "Bisa berasal dari babi, sapi, atau ikan. Perlu dipastikan sumbernya. Tanpa sertifikasi, statusnya syubhat.",
                    category: .raguRagu
                ),
                Ingredient(
                    koreanName: "소금",
                    pronunciation: "Sogeum",
                    englishName: "Salt",
                    descriptionText: "Garam mineral, halal untuk dikonsumsi.",
                    category: .aman
                ),
            ],
            originalText: ""
        ),
        onDismiss: {}
    )
}

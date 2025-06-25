//
//  IngredientCard.swift
//  Wara
//
//  Created by Immanuel Sitepu on 25/06/25.
//

import SwiftUI

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
        VStack(alignment: .leading, spacing: 10) {
            // Header Kartu: Nama & Kategori
            HStack {
                Text(ingredient.koreanName)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(ingredient.category.rawValue.capitalized)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor)
                    .cornerRadius(8)
            }
            
            // Sub-header: Nama Inggris & Pengucapan
            VStack(alignment: .leading, spacing: 2) {
                Text(ingredient.englishName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if !ingredient.pronunciation.isEmpty {
                    Text(ingredient.pronunciation)
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.secondary)
                }
            }
            
            // Deskripsi
            if !ingredient.descriptionText.isEmpty {
                Divider()
                Text(ingredient.descriptionText)
                    .font(.body)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

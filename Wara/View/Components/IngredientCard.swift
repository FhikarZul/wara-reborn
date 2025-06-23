//
//  IngredientCard.swift
//  Wara
//
//  Created by Immanuel Sitepu on 22/06/25.
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(ingredient.koreanName).font(.headline)
                Text(ingredient.pronunciation).font(.caption)
                Spacer()
                Text(ingredient.category.rawValue.capitalized).font(
                    .caption.bold()
                ).foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(categoryColor).cornerRadius(8)
            }
            Text(ingredient.englishName).font(.subheadline).foregroundColor(
                .secondary
            )

            if !ingredient.descriptionText.isEmpty {
                Divider()
                Text(ingredient.descriptionText).font(.footnote)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding().background(Color(.secondarySystemBackground)).cornerRadius(
            12
        )
    }
}

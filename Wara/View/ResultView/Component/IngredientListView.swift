//
//  IngredientListView.swift
//  Wara
//
//  Created by Immanuel Sitepu on 25/06/25.
//

import SwiftUI

struct IngredientListView: View {
    let ingredients: [Ingredient]
    let category: IngredientCategory

    var body: some View {
        // Menggunakan List untuk menampung kartu-kartu bahan
        List {
            ForEach(ingredients, id: \.koreanName) { ingredient in
                IngredientCard(ingredient: ingredient)
                    // Menghilangkan garis pemisah bawaan List agar rapi
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain) // Menggunakan style plain agar tidak ada background tambahan
        .navigationTitle(category.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

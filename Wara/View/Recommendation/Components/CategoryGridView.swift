//
//  CategoryGridView.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//
import SwiftUI

struct CategoryGridView: View {
    private let categories: [CategoryModel] = [
        .init(name: "Snacks", icon: "photo"),
        .init(name: "Drinks", icon: "photo"),
        .init(name: "Noodles", icon: "photo"),
        .init(name: "Sauces", icon: "photo"),
        .init(name: "Meals", icon: "photo"),
        .init(name: "Protein", icon: "photo"),
        .init(name: "Veggies", icon: "photo"),
        .init(name: "Health", icon: "photo")
    ]
    
    // 2 kolom grid
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(categories) { category in
                VStack(spacing: 6) {
                    ZStack {
                        Color(.systemGray5)
                            .frame(width: 80, height: 80)
                            .cornerRadius(16)
                        
                        Image(systemName: category.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.gray)
                    }
                    
                    Text(category.name)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
    }
}

#Preview {
    CategoryGridView()
}

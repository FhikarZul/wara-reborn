//
//  FoodDetailView.swift
//  Wara
//
//  Created by Meow on 29/10/25.
//

import SwiftUI

struct FoodDetailView: View {
    let id: String
    let title: String
    
    @State private var searchText = ""
    let columns = [
           GridItem(.flexible(), spacing: 12),
           GridItem(.flexible(), spacing: 12)
        ]
    
    var body: some View {
        VStack{
            FoodDetailHeader(
                title: title,
                description: "Taste what locals love! Curated Korean food you can enjoy with confidence."
            )
            .frame(maxWidth: .infinity)
            
            SearchBar(text: $searchText)
                .padding(.horizontal)
                .padding(.top, 55)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ChipButton(label: "All", isSelected: true) {
                        
                    }
                    
                    ChipButton(label: "Halal KMF", isSelected: false) {
                        
                    }
                    
                    ChipButton(label: "Safe to Eat", isSelected: false) {
                        
                    }
                    
                    ChipButton(label: "Popular", isSelected: false) {
                        
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)
            
            ScrollView{
                LazyVGrid(columns: columns, spacing: 12) {
                    FoodCard(
                        title: "Choco Sticks",
                        subtitle: "Cho-kho seu-tik",
                        label: "Halal KMF",
                        likes: 1020,
                        isLike: true,
                        isHalalKMF: true,
                        width: .infinity,
                        onFavoriteTapped: {
                            print("Favorited!")
                        }
                    )
                    
                    FoodCard(
                        title: "Choco Sticks",
                        subtitle: "Cho-kho seu-tik",
                        label: "Halal KMF",
                        likes: 1020,
                        isLike: true,
                        isHalalKMF: true,
                        width: .infinity,
                        onFavoriteTapped: {
                            print("Favorited!")
                        }
                    )
                    
                    FoodCard(
                        title: "Choco Sticks",
                        subtitle: "Cho-kho seu-tik",
                        label: "Halal KMF",
                        likes: 1020,
                        isLike: true,
                        isHalalKMF: true,
                        width: .infinity,
                        onFavoriteTapped: {
                            print("Favorited!")
                        }
                    )
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .background(Color.green.opacity(0.1))
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FoodDetailView(id: "", title: "Food Souvenirs")
}

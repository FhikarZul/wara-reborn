//
//  RandomFavoriteView.swift
//  Wara
//
//  Created by Meow on 29/10/25.
//

import SwiftUI

struct RandomFavoriteView: View {
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading){
                Text("Halal Chingu \nPicks!!")
                    .font(.headline)
                    .padding(.bottom, 8)
                
                Text("See what your fellow Chingu recommend")
                    .font(.caption)
            }
            .padding(.leading, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FoodCard(
                        title: "Choco Sticks",
                        subtitle: "Cho-kho seu-tik",
                        label: "Halal KMF",
                        likes: 1020,
                        isLike: true,
                        isHalalKMF: true,
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
                        onFavoriteTapped: {
                            print("Favorited!")
                        }
                    )
                }
                .padding()
            }
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    RandomFavoriteView()
}

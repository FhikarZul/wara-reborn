//
//  FoodCard.swift
//  Wara
//
//  Created by Meow on 28/10/25.
//

import SwiftUI

struct FoodCard: View {
    let title: String
    let subtitle: String
    let label: String
    let likes: Int
    let isLike: Bool
    let isHalalKMF: Bool
    let onFavoriteTapped: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // Product image
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        Image("")
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                    )
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.all, 8)
                
                // Favorite button
                Button(action: {
                    onFavoriteTapped?()
                }) {
                    if(isLike){
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }else{
                        Image(systemName: "heart")
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }
                }
                .padding(10)
                .padding(.top, 2)
                
                // Favorite button
                if(isHalalKMF){
                    Image("halal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 35)
                        .padding(.top, 67)
                        .padding(.trailing, 10)
                }
                    
            }
            
            // Product information
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                // Label
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("green1"))
                        .font(.system(size: 13))
                    Text(label)
                        .font(.system(size: 13))
                        .foregroundColor(Color("green1"))
                }
                
                // Likes count
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                    Text("\(likes)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("green2").opacity(0.4), lineWidth: 2)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .frame(width: 160)
    }
}


#Preview {
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

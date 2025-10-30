//
//  ResultView.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import SwiftUI

struct ScanResultView: View {
    let onDismiss: () -> Void
    
    let productType: ProductType = .SAFE_TO_CONSUME
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                CustomAppBar(
                    onBack: { onDismiss() },
                    onFavorite: { print("Favorite tapped") }
                )
                
                ScrollView{
                    CardView(backgroundColor: .white){
                        VStack{
                            ImageCarouselView(
                                isHalalKMF: true,
                                images: ["slider1", "slider2", "slider3"]
                            )
                            
                            Text("Korean Snack")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            
                            Text("Gwa-ja")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            ResultInfoCard(productType: productType)
                        }
                    }
                    .frame(width: .infinity)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    CardView(backgroundColor: .white, aligment: .leading){
                        if(productType == ProductType.HALAL){
                            VStack(alignment: .leading, spacing: 12){
                                Text("Certificate No :")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("KMFHC22-0231")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Text("Certificate Valid :")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("2022-10-18 ~ 2025-10-17")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        if(productType == ProductType.SAFE_TO_CONSUME){
                            VStack(alignment: .center, spacing: 12){
                                Text("Looks like this product’s new to us! ")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("Sharing this product to Wara, Your contribution help others find safer food choices that align with halal principles.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                
                                Button("Share to Wara") {
                                    
                                }
                                .buttonStyle(PrimaryButtonStyle(
                                    backgroundColor: Color("primaryblue")
                                ))
                                .padding(.top, 4)
                            }
                        }
                        
                        if(productType == ProductType.DOUBTFULL || productType == ProductType.NON_HALAL){
                            VStack(alignment: .leading, spacing: 12){
                                Text("Suspected Ingredient :")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Text("TEST")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(width: .infinity)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    // Ingredient
                    CardView(backgroundColor: .white){
                        VStack(alignment: .leading, spacing: 12){
                            Text("Ingredient :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Wheat flour , sugar, shortening (palm oil: Malaysia), corn starch (imported: Russia, Hungary, Serbia), vegetable cream, ammonium bicarbonate, sodium bicarbonate], Semi-chocolate I [Processed fat I (hydrogenated palm kernel oil: Malaysia), sugar")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("Manufactured with same Facility :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.top, 8)
                            
                            Text("Flour, Milk, egg")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: .infinity)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    // More Information
                    CardView(backgroundColor: .white, aligment: .leading){
                        VStack(alignment: .leading, spacing: 0){
                            Text("More information :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Text("Korean Name :")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                            Text("과자")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                
                            
                            Text("English Translation :")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                            Text("Korean Snack")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("Company Name :")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                            Text("롯데제과 (주)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                        }
                    }
                    .frame(width: .infinity)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    // Alternative Product
                    CardView(backgroundColor: .white, aligment: .leading){
                        VStack(alignment: .leading){
                            Text("Alternative Product :")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    FoodCard(
                                        title: "Choco Sticks",
                                        subtitle: "Cho-kho seu-tik",
                                        label: "Halal KMF",
                                        likes: 1020,
                                        isLike: true,
                                        isHalalKMF: true,
                                        width: nil,
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
                                        width: nil,
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
                                        width: nil,
                                        onFavoriteTapped: {
                                            print("Favorited!")
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .frame(width: .infinity)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                }
            }
            
        }
    }
}

#Preview {
    ScanResultView(onDismiss: {})
}

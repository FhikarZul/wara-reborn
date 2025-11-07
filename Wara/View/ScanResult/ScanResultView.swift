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
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                CustomAppBar(
                    onBack: { onDismiss() },
                    onFavorite: { print("Favorite tapped") }
                )
                
                ScrollView{
                    CardView(backgroundColor: Color("chipBackground"), width: .infinity){
                        VStack{
                            ImageCarouselView(
                                isHalalKMF: true,
                                images: ["slider1", "slider2", "slider3"]
                            )
                            
                            Text("Korean Snack")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                                .padding(.top, 10)
                            
                            Text("Gwa-ja")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            ResultInfoCard(productType: productType)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
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
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Sharing this product to Wara, Your contribution help others find safer food choices that align with halal principles.")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Button("Share to Wara") {
                                    showSheet.toggle()
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
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    // Ingredient
                    CardView(backgroundColor: Color("chipBackground"), width: .infinity){
                        VStack(alignment: .leading, spacing: 12){
                            Text("Ingredient :")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            Text("Wheat flour , sugar, shortening (palm oil: Malaysia), corn starch (imported: Russia, Hungary, Serbia), vegetable cream, ammonium bicarbonate, sodium bicarbonate], Semi-chocolate I [Processed fat I (hydrogenated palm kernel oil: Malaysia), sugar")
                                .font(.caption)
                                .foregroundColor(.primary)
                            
                            Text("Manufactured with same Facility :")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            
                            Text("Flour, Milk, egg")
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    // More Information
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading, spacing: 0){
                            Text("More information :")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Korean Name :")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text("과자 (chok-seu-tik)")
                                .font(.body)
                                .foregroundColor(.primary)
                                
                            
                            Text("English Translation :")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text("Korean Snack")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("Company Name :")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text("롯데제과 (주)")
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("(Lotte Snack Co., Ltd.)")
                                .font(.body)
                                .foregroundColor(.primary)
                            
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    // Alternative Product
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading){
                            Text("Alternative Product :")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            
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
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                }
            }
            .sheet(isPresented: $showSheet) {
                BottomSheetContributeView(isPresented: $showSheet)
            }
        }
    }
}

#Preview {
    ScanResultView(onDismiss: {})
}

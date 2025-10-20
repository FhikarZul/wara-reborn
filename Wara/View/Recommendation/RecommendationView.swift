//
//  RecommendationView.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

struct RecommendationView: View {
    @State private var searchText = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                CustomSearchBar(text: $searchText)
                    .padding(.bottom, 8)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ChipButton(label: "Local Favorite", action: {})
                        ChipButton(label: "Souvenirs", action: {})
                        ChipButton(label: "Daily Foods", action: {})
                        ChipButton(label: "Traditional Drinks", action: {})
                        ChipButton(label: "Street Food", action: {})
                    }
                    .padding(.horizontal)
                }
                
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
                            SnackCard(
                                imageName: "snack_sample",
                                title: "Korean Snack",
                                subtitle: "과자",
                                likes: 1020
                            )
                            
                            SnackCard(
                                imageName: "snack_sample",
                                title: "Korean Snack",
                                subtitle: "과자",
                                likes: 1020
                            )
                           
                            SnackCard(
                                imageName: "snack_sample",
                                title: "Korean Snack",
                                subtitle: "과자",
                                likes: 1020
                            )
                        }
                        .padding()
                    }
                }
                .padding(.bottom, 8)
                
                Text("Category")
                    .font(.headline)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 12)
                
                CategoryGridView()
                
                Spacer()
            }
        }
    }
}

#Preview {
    RecommendationView()
}

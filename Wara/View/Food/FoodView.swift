//
//  RecommendationView.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

struct FoodView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 0){
                SliderView()
                
                HStack{
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Korean Food\nScanner")
                            .font(.system(size: 18, weight: .bold))
                           

                        Text("See what your fellow Chingu recommend")
                            .font(.system(size: 13))
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    Image("scan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.top, -50)
               
                CategoryGridView()
                
                RandomFavoriteView()
                
                Spacer()
            }
            .background(Color.green.opacity(0.1))
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    FoodView()
}

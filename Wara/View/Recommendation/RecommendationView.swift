//
//  RecommendationView.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

struct RecommendationView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 0){
                SliderView()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Korean Food\nScanner")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.bottom, 8)

                    Text("See what your fellow Chingu recommend")
                        .font(.subheadline)
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
    RecommendationView()
}

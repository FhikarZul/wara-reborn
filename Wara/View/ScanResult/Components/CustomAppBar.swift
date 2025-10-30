//
//  CustomAppBarView.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct CustomAppBar: View {
    var title: String = "Details"
    var onBack: (() -> Void)?
    var onFavorite: (() -> Void)?
    
    var body: some View {
        HStack {
            // Left Button (Back)
            Button(action: {
                onBack?()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 1)
                            .shadow(color: Color.white.opacity(0.9), radius: 3, x: -1, y: -1)
                    )
            }
            
            Spacer()
            
            // Title
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            // Right Button (Favorite)
            Button(action: {
                onFavorite?()
            }) {
                Image(systemName: "heart")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 1)
                            .shadow(color: Color.white.opacity(0.9), radius: 3, x: -1, y: -1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.green.opacity(0.1))
    }
}

#Preview {
    CustomAppBar(
        onBack: { print("Back tapped") },
        onFavorite: { print("Favorite tapped") }
    )
    .padding()
}

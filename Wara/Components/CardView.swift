//
//  CardView.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct CardView<Content: View>: View {
    var backgroundColor: Color = .white
    var cornerRadius: CGFloat = 16
    var shadowColor: Color = .black.opacity(0.1)
    var shadowRadius: CGFloat = 8
    var padding: CGFloat = 12
    var aligment: Alignment = .center
    
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: aligment)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
    }
}

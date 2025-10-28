//
//  ChipButton.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

struct ChipButton: View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .padding(.vertical, 26)
                .padding(.horizontal, 26)
                .background(Color("primaryblue"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    ChipButton(label: "Halal") {
        print("Chip tapped")
    }
}

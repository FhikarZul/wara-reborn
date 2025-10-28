//
//  SliderView.swift
//  Wara
//
//  Created by Meow on 28/10/25.
//

import SwiftUI

struct SliderModel: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let image: String
}

struct SliderView: View {
    let sliders: [SliderModel] = [
        SliderModel(
            title: "Wanna Feels Like Korean? Try Local Favorit",
            color: .yellow,
            image: "slider1"
        ),
        SliderModel(
            title: "Tasty Memories to Go! Find Korea’s most loved food souvenirs here",
            color: .green,
            image: "slider2"
        ),
        SliderModel(
            title: "Everyday Essentials! Quick bites, simple meals",
            color: .orange,
            image: "slider3"
        )
    ]
    
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                ForEach(Array(sliders.enumerated()), id: \.offset) { index, slider in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(slider.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image(slider.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                       
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .background(slider.color.opacity(0.7))
                    .tag(index)
                }
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .frame(maxHeight: 250)
            .padding(.top, -70)
            
            HStack(spacing: 6) {
                ForEach(0..<sliders.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.black : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.1))
            )
            .padding(.bottom, 45)
        }
        .frame(height: 250)
        .animation(.easeInOut, value: currentIndex)
    }
}

#Preview {
    SliderView()
}

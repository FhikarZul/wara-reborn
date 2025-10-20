//
//  BaseView.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

struct BaseView: View {
    @State private var selectedTab: Int = 0
    @State private var showCamera: Bool = false

    var body: some View {
        TabView(selection: $selectedTab) {
            RecommendationView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Recommendation")
                }
                .tag(0)

            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Scan")
                }
                .tag(1)

            Text("Favorite Page")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }
                .tag(2)
        }
        .accentColor(Color("primaryblue"))
        .onChange(of: selectedTab) {
            if selectedTab == 1 {
                showCamera = true
                selectedTab = 0
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CaptureView()
        }
    }
}

// MARK: - Preview
#Preview {
    BaseView()
}

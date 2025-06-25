//
//  Onboarding.swift
//  Wara Onboarding
//
//  Created by Delilah Mentari on 22/06/25.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Bindings
    @Binding var hasCompletedOnboarding: Bool
    
    // MARK: - States
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedTab) {
                    OnboardingTabView(
                        title: "WARA",
                        imageName: "Onboarding1",
                        description: "Membantu kamu memilih produk makanan kemasan Korea yang aman dan sesuai prinsip Islam"
                    ).tag(0)
                    
                    OnboardingTabView(
                        title: "Cukup Scan Label",
                        imageName: "Onboarding2",
                        description: "Wara akan membaca bahan-bahan dalam makanan kemasan dan menandainya secara otomatis sesuai prinsip Islam"
                    ).tag(1)
                    
                    OnboardingTabView(
                        title: "Ambil Keputusan dengan Cepat",
                        imageName: "Onboarding3",
                        description: "Setiap bahan dikategorikan dalam tiga tingkat: Dapat Dikonsumsi, Perlu Ditinjau, dan Perlu Dihindari – untuk membantu kamu membuat keputusan yang lebih bijak."
                    ).tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                OnboardingButton(selectedTab: $selectedTab, hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
}

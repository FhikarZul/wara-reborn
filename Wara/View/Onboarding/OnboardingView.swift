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
                        title: "Aplikasi Kami",
                        imageName: "Onboarding1",
                        description: "Membantu anda memilih makanan kemasan Korea yang aman dikonsumsi sesuai prinsip Islam"
                    ).tag(0)
                    
                    OnboardingTabView(
                        title: "Cukup Scan Label",
                        imageName: "Onboarding2",
                        description: "Wara akan mendeteksi bahan makanan dan menandainya secara otomatis sesuai prinsip Islam"
                    ).tag(1)
                    
                    OnboardingTabView(
                        title: "Ambil Keputusan dengan Cepat",
                        imageName: "Onboarding3",
                        description: "Setiap bahan akan dikategorikan menjadi (Dapat Dikonsumsi, Perlu Ditinjau, dan Perlu Dihindari) untuk membantumu mengambil keputusan"
                    ).tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                OnboardingButton(selectedTab: $selectedTab, hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
}

#Preview {
    @Previewable @State  var hasCompletedOnboarding = false
    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
}

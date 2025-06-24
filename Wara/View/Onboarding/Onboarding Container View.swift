//
//  Onboarding.swift
//  Wara Onboarding
//
//  Created by Delilah Mentari on 22/06/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selectedTab) {
                    OnboardingPageView(
                        imageName: "Onboarding1",
                        title: "WARA",
                        description: "Membantu kamu memilih produk makanan kemasan Korea yang aman dan sesuai prinsip Islam"
                    ).tag(0)

                    OnboardingPageView(
                        imageName: "Onboarding2",
                        title: "Cukup Scan Label",
                        description: "Wara akan membaca bahan-bahan dalam makanan kemasan dan menandainya secara otomatis sesuai prinsip Islam"
                    ).tag(1)

                    OnboardingPageView(
                        imageName: "Onboarding3",
                        title: "Ambil Keputusan dengan Cepat",
                        description: "Setiap bahan dikategorikan dalam tiga tingkat: Dapat Dikonsumsi, Perlu Ditinjau, dan Perlu Dihindari – untuk membantu kamu membuat keputusan yang lebih bijak."
                    ).tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                // Tombol Navigasi
                if selectedTab == 2 {
                    // MARK: - PERUBAHAN: NavigationLink sekarang membawa binding
                    NavigationLink(destination: CameraPermissionView(hasCompletedOnboarding: $hasCompletedOnboarding)) {
                        Text("Mulai Sekarang")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryblue", bundle: nil)) // Ganti 'Color.blue' jika perlu
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    
                } else {
                    Button(action: {
                        withAnimation {
                            selectedTab += 1
                        }
                    }) {
                        Text("Selanjutnya")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryblue", bundle: nil)) // Ganti 'Color.blue' jika perlu
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

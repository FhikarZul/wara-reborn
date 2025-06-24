//
//  WaraApp.swift
//  Wara
//
//  Created by Immanuel Sitepu on 13/06/25.
//

import SwiftUI
import SwiftData

@main
struct WaraApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            // MARK: - PERUBAHAN: Logika untuk memilih tampilan awal
            if hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingContainerView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .modelContainer(persistenceController.container)
    }
}

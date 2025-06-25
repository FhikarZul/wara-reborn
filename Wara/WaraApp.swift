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
            if hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .modelContainer(persistenceController.container)
    }
}

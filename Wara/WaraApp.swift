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

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(persistenceController.container)
    }
}

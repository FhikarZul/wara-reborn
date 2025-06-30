//
//  Controller.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Foundation
import SwiftData

@MainActor
class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer
    
    private init() {
        do {
            container = try ModelContainer(for: Ingredient.self)
            Task(priority: .background) {
                await self.forceReloadDatabaseFromJSON()
            }
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error.localizedDescription)")
        }
    }

    private func forceReloadDatabaseFromJSON() async {
        print("Checking for database updates on app launch...")

        let backgroundContext = ModelContext(container)
        
        guard let url = Bundle.main.url(forResource: "Ingredients", withExtension: "json") else {
            fatalError("Failed to find 'Ingredients.json' in bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            let dtos = try JSONDecoder().decode([IngredientDTO].self, from: data)
            
            let descriptor = FetchDescriptor<Ingredient>()
            let currentCount = (try? backgroundContext.fetchCount(descriptor)) ?? -1
            
            if currentCount == dtos.count {
                print("Database content matches JSON file. No update needed.")
                return
            }
            
            print("Database requires update. Wiping and reloading...")
            
            try backgroundContext.delete(model: Ingredient.self)
            
            for dto in dtos {
                let newIngredient = Ingredient(
                    koreanName: dto.koreanName,
                    pronunciation: dto.pronunciation,
                    englishName: dto.englishName,
                    descriptionText: dto.descriptionText,
                    category: dto.category
                )
                backgroundContext.insert(newIngredient)
            }
            
            // Simpan perubahan
            try backgroundContext.save()
            
            print("Successfully reloaded \(dtos.count) ingredients into the database.")
            
        } catch {
            fatalError("Failed to reload database from JSON: \(error)")
        }
    }
}

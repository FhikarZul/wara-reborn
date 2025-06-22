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
            Task {
                await seedDatabaseIfNeeded()
            }
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error.localizedDescription)")
        }
    }

    private func seedDatabaseIfNeeded() async {
        // Gunakan UserDefaults untuk mengecek apakah seeding sudah pernah dilakukan.
        let hasSeededKey = "hasSeededDatabase"
        if UserDefaults.standard.bool(forKey: hasSeededKey) {
            print("Database already seeded.")
            return
        }
        
        print("Database has not been seeded. Starting seeding process...")
        
        // Cek apakah ada data di database
        let descriptor = FetchDescriptor<Ingredient>()
        let count = try? container.mainContext.fetchCount(descriptor)
        
        guard count == 0 else {
            print("Database already contains data. Skipping seed.")
            UserDefaults.standard.set(true, forKey: hasSeededKey)
            return
        }

        guard let url = Bundle.main.url(forResource: "Ingredients", withExtension: "json") else {
            fatalError("Failed to find 'CSV to JSON.json' in bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            let dtos = try JSONDecoder().decode([IngredientDTO].self, from: data)
            
            for dto in dtos {
                let newIngredient = Ingredient(
                    koreanName: dto.koreanName,
                    pronunciation: dto.pronunciation,
                    englishName: dto.englishName,
                    descriptionText: dto.descriptionText,
                    category: dto.category
                )
                container.mainContext.insert(newIngredient)
            }
            
            try container.mainContext.save()
            UserDefaults.standard.set(true, forKey: hasSeededKey)
            print("Successfully seeded \(dtos.count) ingredients.")
            
        } catch {
            fatalError("Failed to seed database: \(error.localizedDescription)")
        }
    }
}

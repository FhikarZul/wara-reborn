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
            
            // 1. Ambil referensi container di Main Actor (aman)
            let localContainer = self.container
            
            // 2. Jalankan tugas di background dengan memberikan container sebagai parameter
            Task(priority: .background) {
                await self.forceReloadDatabaseIfNeeded(using: localContainer)
            }
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error.localizedDescription)")
        }
    }

    /// Fungsi ini hanya akan berjalan di background dan terisolasi.
    private func forceReloadDatabaseIfNeeded(using container: ModelContainer) async {
        // 3. Buat context khusus untuk background dari container yang diberikan
        let backgroundContext = ModelContext(container)
        
        guard let url = Bundle.main.url(forResource: "Ingredients", withExtension: "json") else {
            fatalError("Failed to find 'Ingredients.json' in bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            let dtos = try JSONDecoder().decode([IngredientDTO].self, from: data)
            
            // Cek jumlah data untuk efisiensi
            let descriptor = FetchDescriptor<Ingredient>()
            let currentCount = (try? backgroundContext.fetchCount(descriptor)) ?? -1
            if currentCount == dtos.count {
                print("Database is up to date. No update needed.")
                return
            }
            
            print("Database requires update. Wiping and reloading...")
            
            // 4. Lakukan semua operasi (hapus, tambah, simpan) di background context
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
            
            try backgroundContext.save()
            print("Successfully reloaded \(dtos.count) ingredients.")
            
        } catch {
            fatalError("Failed to reload database from JSON: \(error)")
        }
    }
}

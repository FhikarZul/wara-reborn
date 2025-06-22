//
//  Ingredients.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Foundation
import SwiftData

// Enum untuk kategori kehalalan, lebih aman dan deskriptif daripada String.
enum IngredientCategory: String, Codable, CaseIterable {
    case aman = "aman"
    case raguRagu = "ragu-ragu"
    case tidakAman = "tidak aman"
}

@Model
final class Ingredient {
    @Attribute(.unique) var koreanName: String
    var pronunciation: String
    var englishName: String
    var descriptionText: String
    var category: IngredientCategory

    init(koreanName: String, pronunciation: String, englishName: String, descriptionText: String, category: IngredientCategory) {
        self.koreanName = koreanName
        self.pronunciation = pronunciation
        self.englishName = englishName
        self.descriptionText = descriptionText
        self.category = category
    }
}

// Struct ini HANYA untuk decoding dari JSON.
struct IngredientDTO: Decodable {
    let koreanName: String
    let pronunciation: String
    let englishName: String
    let descriptionText: String
    let category: IngredientCategory

    enum CodingKeys: String, CodingKey {
        case koreanName = "Ingredient(Korea)"
        case pronunciation = "Pronounce"
        case englishName = "Ingredient(translate)"
        case descriptionText = "Description"
        case category = "Kategori"
    }
}

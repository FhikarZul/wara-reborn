//
//  DetectionResult.swift
//  Wara
//
//  Created by Immanuel Sitepu on 23/06/25.
//

import Foundation

struct DetectionResult {
    enum Status {
        case aman
        case raguRagu
        case tidakAman
        case ingredientsNotFound
    }
    
    let status: Status
    let foundIngredients: [Ingredient]
    let originalText: String
}

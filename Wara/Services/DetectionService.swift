//
//  DetectionService.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Foundation
import SwiftData

class DetectionService {
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Methods
    func hasIngredientsLabel(in text: String) -> Bool {
        // Kita bisa mencari kedua variasi untuk hasil yang lebih baik
        let keyword1 = "원재료" // Raw Materials
        let keyword2 = "원재료명" // Raw Material Name, sering digunakan juga
        
        return text.contains(keyword1) || text.contains(keyword2)
    }
    
    func analyzeIngredients(text: String) async -> DetectionResult {
        // Check are the text contain ingredient keyword
        let containsIngredientsLabel = hasIngredientsLabel(in: text)
        
        if (!containsIngredientsLabel) {
            return DetectionResult(status: .ingredientsNotFound, foundIngredients: [], originalText: text)
        }
        
        // Jika kata kunci ditemukan, analisis seluruh teks
        var cleanedText = text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        
        let pattern = "(원재료|원재료명)(.*?)(?=제품명|식품유형|제조원|유통전문|소비기한|원재료명|포장재질|품목보고번호|$)"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
            let nsrange = NSRange(text.startIndex..<text.endIndex, in: text)
            
            if let match = regex.firstMatch(in: text, options: [], range: nsrange) {
                if let range = Range(match.range(at: 2), in: text) {
                    cleanedText = String(text[range])
                }
            } else {
                print("No match found.")
            }
        } catch {
            print("Invalid regex: \(error)")
        }
        
        let descriptor = FetchDescriptor<Ingredient>()
        guard let allIngredients = try? modelContext.fetch(descriptor) else {
            return DetectionResult(status: .raguRagu, foundIngredients: [], originalText: text)
        }
        
        var foundItems: [Ingredient] = []
        for ingredient in allIngredients {
            if cleanedText.contains(ingredient.koreanName) {
                foundItems.append(ingredient)
            }
        }
        
        if foundItems.isEmpty {
            return DetectionResult(status: .aman, foundIngredients: [], originalText: text)
        }
        
        if foundItems.contains(where: { $0.category == .tidakAman }) {
            return DetectionResult(status: .tidakAman, foundIngredients: foundItems, originalText: text)
        } else if foundItems.contains(where: { $0.category == .raguRagu }) {
            return DetectionResult(status: .raguRagu, foundIngredients: foundItems, originalText: text)
        } else {
            return DetectionResult(status: .aman, foundIngredients: foundItems, originalText: text)
        }
    }
}

//
//  DetectionResult.swift
//  Wara
//
//  Created by Immanuel Sitepu on 23/06/25.
//

import Foundation

/// Representasi hasil deteksi bahan dari teks OCR.
/// Memuat status akhir, daftar bahan ditemukan, dan teks asli.
struct DetectionResult {
    /// Kategori status hasil deteksi.
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

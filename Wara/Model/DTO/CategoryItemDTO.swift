//
//  CategoryItemDTO.swift
//  Wara
//
//  Created by Meow on 06/11/25
//

import Foundation

/// DTO item kategori sesuai field backend.
/// Mencakup id, relasi parent, nama Korea/Inggris, dan level hierarki.
struct CategoryItemDTO: Decodable {
    let id: String
    let parentId: String?
    let koreanName: String
    let koreanPronunciation: String
    let englishName: String
    let level: Int

    enum CodingKeys: String, CodingKey {
        case id
        case parentId = "parent_id"
        case koreanName = "korean_name"
        case koreanPronunciation = "korean_pronunciation"
        case englishName = "english_name"
        case level
    }
}
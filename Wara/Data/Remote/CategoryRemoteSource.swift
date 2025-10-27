//
//  CategoryRemoteSource.swift
//  Wara
//
//  Created by Meow on 27/10/25.
//

import Foundation

struct ResponseDTO<T: Decodable>: Decodable {
    let data: T
}

struct CategoriesPayloadDTO: Decodable {
    let items: [CategoryItemDTO]
}

// Item kategori sesuai field backend
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

class CategoryRemoteSource {
    static let shared = CategoryRemoteSource()
    private init() {}

    private let httpClient = HttpClient.shared

    private var baseURL: String {
        if let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String, !url.isEmpty {
            return url
        }
        // Fallback untuk pengembangan jika key belum di-set
        return "https://example.com/api"
    }

    // Flatten hasil ke array items agar mudah dipakai layer di atasnya
    func fetchCategories(completion: @escaping (Result<[CategoryItemDTO], NetworkError>) -> Void) {
        let url = "\(baseURL)/products/categories"

        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           completion: { (result: Result<ResponseDTO<CategoriesPayloadDTO>, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.data.items))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

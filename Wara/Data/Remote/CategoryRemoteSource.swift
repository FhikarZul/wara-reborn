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
        let schemeRaw = (Bundle.main.object(forInfoDictionaryKey: "API_SCHEME") as? String) ?? ""
        let hostRaw = (Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String) ?? ""
        let scheme = schemeRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        let hostVal = hostRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        precondition(!scheme.isEmpty, "API_SCHEME missing. Set via xcconfig and map to target configuration.")
        precondition(!hostVal.isEmpty, "API_HOST missing. Set via xcconfig and map to target configuration.")
        precondition(scheme == "http" || scheme == "https", "API_SCHEME must be 'http' or 'https'.")

        // Parse optional port if provided in host (e.g., localhost:4041)
        var host = hostVal
        var port: Int? = nil
        if let colonIndex = host.firstIndex(of: ":") {
            let hostname = String(host[..<colonIndex])
            let portStr = String(host[host.index(after: colonIndex)...])
            host = hostname
            if let p = Int(portStr) { port = p }
        }

        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        guard let url = components.url else {
            preconditionFailure("Invalid API_SCHEME/API_HOST combination.")
        }
        return url.absoluteString
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

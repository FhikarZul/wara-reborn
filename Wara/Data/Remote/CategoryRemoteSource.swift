//
//  CategoryRemoteSource.swift
//  Wara
//
//  Created by Meow on 27/10/25.
//

import Foundation

/// Amplop respons generik dengan properti `data` sesuai schema backend.
/// Gunakan untuk membungkus payload utama saat decoding.
struct ResponseDTO<T: Decodable>: Decodable {
    let data: T
}

struct CategoriesPayloadDTO: Decodable {
    let items: [CategoryItemDTO]
}

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

/// Sumber data remote untuk mengambil daftar kategori produk.
/// Membaca konfigurasi `API_SCHEME` dan `API_HOST` dari Info.plist, lalu
/// memanggil endpoint `GET /products/categories` menggunakan `HttpClient`.
class CategoryRemoteSource {
    static let shared = CategoryRemoteSource()
    private init() {}

    private let httpClient = HttpClient.shared

    private var baseURL: String {
        // Ambil scheme & host dari Info.plist yang dipetakan via xcconfig
        let schemeRaw = (Bundle.main.object(forInfoDictionaryKey: "API_SCHEME") as? String) ?? ""
        let hostRaw = (Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String) ?? ""
        let scheme = schemeRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        let hostVal = hostRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        precondition(!scheme.isEmpty, "API_SCHEME  missing. Set via xcconfig and map to target configuration.")
        precondition(!hostVal.isEmpty, "API_HOST missing. Set via xcconfig and map to target configuration.")
        precondition(scheme == "http" || scheme == "https", "API_SCHEME must be 'http' or 'https'.")

        // Opsional: parse port jika host menyertakan (contoh: localhost:4041)
        var host = hostVal
        var port: Int? = nil
        if let colonIndex = host.firstIndex(of: ":") {
            let hostname = String(host[..<colonIndex])
            let portStr = String(host[host.index(after: colonIndex)...])
            host = hostname
            if let p = Int(portStr) { port = p }
        }

        // Rakit URL dasar dari komponen
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        guard let url = components.url else {
            preconditionFailure("Invalid API_SCHEME/API_HOST combination.")
        }
        return url.absoluteString
    }

    /// Mengambil kategori dan mengembalikan array item yang sudah di-flatten.
    func fetchCategories(completion: @escaping (Result<[CategoryItemDTO], NetworkError>) -> Void) {
        // Bentuk URL endpoint dari base URL
        let url = "\(baseURL)/products/categories"

        // Panggil request GET tanpa parameter. Gunakan tipe generik untuk decoding.
        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           completion: { (result: Result<ResponseDTO<CategoriesPayloadDTO>, NetworkError>) in
            switch result {
            case .success(let response):
                // Ambil payload dan teruskan ke layer pemanggil
                completion(.success(response.data.items))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

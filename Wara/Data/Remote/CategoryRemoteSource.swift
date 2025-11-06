//
//  CategoryRemoteSource.swift
//  Wara
//
//  Created by Meow on 27/10/25.
//

import Foundation
import OSLog

/// Sumber data remote untuk mengambil daftar kategori produk.
/// Membaca konfigurasi `API_SCHEME` dan `API_HOST` dari Info.plist, lalu
/// memanggil endpoint `GET /products/categories` menggunakan `HttpClient`.
class CategoryRemoteSource {
    static let shared = CategoryRemoteSource()
    private init() {}

    private let httpClient = HttpClient.shared
    private let logger = Logger(subsystem: "com.otw.Wara", category: "category")

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

    /// Mengambil kategori dan mengembalikan array item.
    /// Opsional: filter dengan `kind` (contoh: "recommendation").
    func fetchCategories(kind: String? = nil, completion: @escaping (Result<[CategoryItemDTO], NetworkError>) -> Void) {
        // Bentuk URL endpoint dari base URL, tambahkan query jika ada.
        var url = "\(baseURL)/products/categories"
        if let kind = kind, !kind.isEmpty {
            url += "?kind=\(kind)"
        }
        logger.info("[Category] GET \(url, privacy: .public)")

        // Panggil request GET tanpa parameter. Gunakan tipe generik untuk decoding.
    httpClient.request(url: url,
                       method: .get,
                       parameters: nil as String?,
                       completion: { (result: Result<ApiResponseDTO<CategoriesPayloadDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if let payload = envelope.data {
                    self.logger.info("[Category] success items=\(payload.items.count)")
                    completion(.success(payload.items))
                } else {
                    self.logger.error("[Category] empty payload")
                    completion(.failure(.custom("Empty payload")))
                }
            case .failure(let error):
                self.logger.error("[Category] failed: \(error.localizedDescription, privacy: .public)")
                completion(.failure(error))
            }
        })
    }
}

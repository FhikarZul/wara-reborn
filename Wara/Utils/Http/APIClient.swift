//
//  APIClient.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

import Foundation

protocol APIService {
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T
}

final class APIClient: APIService {
    private let session: URLSession

    // Dependency Injection: Memungkinkan kita untuk menginjeksikan session untuk testing (mocking)
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request<T: Decodable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        
        // 1. Konstruksi URL Request
        guard var components = URLComponents(string: endpoint.baseURL) else {
            throw APIError.invalidURL
        }
        components.path += endpoint.path
        
        // Tambahkan query items jika GET
        if endpoint.method == .get, let params = endpoint.parameters as? [String: String] {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Tambahkan semua header
        endpoint.headers?.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Tambahkan Body (untuk POST/PUT)
        if (endpoint.method == .post || endpoint.method == .put), let params = endpoint.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
            } catch {
                throw APIError.decodingError(error) // Gagal serialisasi parameter ke JSON
            }
        }

        // 2. Melakukan Permintaan dan Penanganan Error
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            // Contoh: Mencoba membaca pesan error dari body response
            let errorMsg = String(data: data, encoding: .utf8) ?? "Server Error"
            throw APIError.apiError(statusCode: httpResponse.statusCode, message: errorMsg)
        }
        
        // 3. Decoding Data JSON
        do {
            let decoder = JSONDecoder()
            // Contoh konfigurasi: mengubah snake_case API menjadi camelCase Swift
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let decodingError {
            throw APIError.decodingError(decodingError)
        }
    }
}

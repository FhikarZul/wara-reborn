//
//  CategoryRemoteSource.swift
//  Wara
//
//  Created by Meow on 24/10/25.
//

import Foundation
import Alamofire

/// Sumber data remote untuk operasi pengguna (create/fetch).
/// Menggunakan `HttpClient` dan membaca `API_SCHEME`/`API_HOST` dari Info.plist.
class UserRemoteSource {
    static let shared = UserRemoteSource()
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
    
    // Generic envelope with optional data to handle null data in success responses
    /// Amplop respons generik dengan flag `success` dan `message` opsional.
    struct BasicResponseDTO<T: Decodable>: Decodable {
        let success: Bool
        let message: String?
        let data: T?
    }

    /// DTO kosong untuk respons sukses yang tidak memiliki payload `data`.
    struct EmptyObjectDTO: Decodable {}

    /// Create user in backend. No X-User-ID header, only body { user_id }
    func createUser(payload: CreateUserReqModel, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let url = "\(baseURL)/users"
        httpClient.request(url: url,
                           method: .post,
                           parameters: payload,
                           includeUserHeader: false,
                           completion: { (result: Result<BasicResponseDTO<EmptyObjectDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if envelope.success {
                    completion(.success(()))
                } else {
                    completion(.failure(.custom(envelope.message ?? "Unknown error")))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }

    // Example-only: keep a fetch method using JSONPlaceholder to avoid breaking samples
    func fetchUsers(completion: @escaping (Result<[UserModel], NetworkError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           completion: completion)
    }
}

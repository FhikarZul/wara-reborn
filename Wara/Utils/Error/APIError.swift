//
//  APIError.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    case apiError(statusCode: Int, message: String) 
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "URL tidak valid."
        case .invalidResponse: return "Respons server tidak valid."
        case .decodingError(let error): return "Gagal memproses data: \(error.localizedDescription)"
        case .networkError(let error): return "Kesalahan jaringan: \(error.localizedDescription)"
        case .apiError(let statusCode, let message): return "Kesalahan API (\(statusCode)): \(message)"
        }
    }
}

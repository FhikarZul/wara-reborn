//
//  APIError.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

import Alamofire

enum NetworkError: Error {
    case invalidURL
    case afError(AFError)
    case decodingError(Error)
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL tidak valid."
        case .afError(let error):
            return "Error Alamofire: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Error Decoding: \(error.localizedDescription)"
        case .custom(let message):
            return message
        }
    }
}

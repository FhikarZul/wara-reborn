//
//  Endpoint.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

enum UserEndpoint: Endpoint {
    case fetchUser(id: Int)
    case createUser(name: String, email: String)
    
    var baseURL: String { return "https://api.myapp.com/v1" }

    var path: String {
        switch self {
        case .fetchUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchUser:
            return .get
        case .createUser:
            return .post
        }
    }
    
    var headers: [String: String]? {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }

    var parameters: [String: Any]? {
        switch self {
        case .fetchUser:
            return nil // Tidak ada body/parameter untuk GET ini
        case .createUser(let name, let email):
            return ["name": name, "email": email]
        }
    }
}

//
//  CategoryRemoteSource.swift
//  Wara
//
//  Created by Meow on 24/10/25.
//

import Foundation
import Alamofire

class UserRemoteSource {
    static let shared = UserRemoteSource()
    private init() {}
    
    private let httpClient = HttpClient.shared
    private let baseURL = "https://jsonplaceholder.typicode.com"

    func fetchUsers(completion: @escaping (Result<[UserModel], NetworkError>) -> Void) {
        let url = "\(baseURL)/posts"
        httpClient.request(url: url,
                               method: .get,
                               parameters: nil as UserModel?,
                               completion: completion)
    }
    
    func createUser(payload: CreateUserModel, completion: @escaping (Result<UserModel, NetworkError>) -> Void) {
        let url = "\(baseURL)/posts"
        
        httpClient.request(url: url,
                           method: .post,
                           parameters: payload,
                           completion: completion)
    }
}

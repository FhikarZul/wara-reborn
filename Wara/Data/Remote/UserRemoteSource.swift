//
//  UserService.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

final class UserRemoteSource {
    private let apiService: APIService
    
    init(apiService: APIService = APIClient()) {
            self.apiService = apiService
        }

    func fetchUser(id: Int) async throws -> User {
        return try await apiService.request(
            UserEndpoint.fetchUser(id: id),
            responseType: User.self
        )
    }

    func registerUser(name: String, email: String) async throws -> User {
        return try await apiService.request(
            UserEndpoint.createUser(name: name, email: email),
            responseType: User.self
        )
    }
}

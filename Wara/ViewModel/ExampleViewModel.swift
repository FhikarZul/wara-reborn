//
//  ExampleViewModel.swift
//  Wara
//
//  Created by Meow on 24/10/25.
//

import Foundation
import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var posts: [UserModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let userRemoteSource = UserRemoteSource.shared

    func loadPosts() {
        isLoading = true
        errorMessage = nil
        
        userRemoteSource.fetchUsers { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let fetchedPosts):
                self.posts = fetchedPosts
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error loading posts: \(error)")
            }
        }
    }
    
    func handleCreatePost() {
        let newPostPayload = CreateUserModel(
            title: "SwiftUI Alamofire Post",
            body: "Mengirim Model sebagai body request."
        )
        
        userRemoteSource.createUser(payload: newPostPayload) { [weak self] result in
            switch result {
            case .success(let createdPost):
                print("Post berhasil dibuat: \(createdPost.id) - \(createdPost.title)")
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                print("Gagal membuat post: \(error)")
            }
        }
    }
}

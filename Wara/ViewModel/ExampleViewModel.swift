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
        // Example now triggers app user initialization flow
        UserManager.shared.ensureUserInitialized()
    }
}

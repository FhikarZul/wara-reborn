//
//  CategoryViewModel.swift
//  Wara
//
//  Created by Meow on 27/10/25.
//

import Foundation

@MainActor
class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let remoteSource = CategoryRemoteSource.shared

    func loadCategories() {
        isLoading = true
        errorMessage = nil

        remoteSource.fetchCategories { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let dtos):
                self.categories = dtos.map { dto in
                    // Tampilkan englishName pada grid; ikon placeholder
                    Category(name: dto.englishName, icon: "photo")
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
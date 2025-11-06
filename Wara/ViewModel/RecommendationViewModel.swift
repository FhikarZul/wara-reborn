//
//  RecommendationViewModel.swift
//  Wara
//
//  Created by Meow on 06/11/25.
//

import Foundation
import OSLog

@MainActor
final class RecommendationViewModel: ObservableObject {
    @Published var items: [Category] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let remoteSource = CategoryRemoteSource.shared
    private let logger = Logger(subsystem: "com.otw.Wara", category: "recommendation")

    func load() {
        isLoading = true
        errorMessage = nil
        logger.info("[Recommendation] load started")

        remoteSource.fetchCategories(kind: "recommendation") { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let dtos):
                    self.items = dtos.map { dto in
                        Category(
                            name: dto.appCategoryBannerTitle,
                            iconURL: URL(string: dto.appCategoryIconURL ?? "")
                        )
                    }
                    self.logger.info("[Recommendation] mapped items=\(self.items.count)")
                    self.isLoading = false
                case .failure(let error):
                    self.logger.error("[Recommendation] failed: \(error.localizedDescription, privacy: .public)")
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

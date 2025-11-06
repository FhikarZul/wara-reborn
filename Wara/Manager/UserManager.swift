//
//  UserManager.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import Foundation

/// Mengelola lifecycle `userId` di perangkat.
/// Membuat user di backend saat pertama kali launch lalu menyimpan ke `UserDefaults`.
final class UserManager {
    static let shared = UserManager()
    private init() {}

    private let userDefaultsKey = "userId"

    /// Ensure a userId exists; if missing, generate UUIDv7 and create user on backend.
    func ensureUserInitialized() {
        if let existing = UserDefaults.standard.string(forKey: userDefaultsKey), !existing.isEmpty {
            return
        }

        let newId = UUIDv7.generate()
        let payload = CreateUserRequestDTO(userId: newId)

        UserRemoteSource.shared.createUser(payload: payload) { result in
            switch result {
            case .success:
                UserDefaults.standard.set(newId, forKey: self.userDefaultsKey)
            case .failure(let error):
                // Keep silent for now; will retry on next launch.
                print("Failed to create user: \(error.localizedDescription)")
            }
        }
    }
}

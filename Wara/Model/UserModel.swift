//
//  UserModel.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

/// Model contoh untuk data pengguna dari sumber eksternal.
/// Saat ini digunakan sebagai placeholder untuk contoh fetch.
struct UserModel: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

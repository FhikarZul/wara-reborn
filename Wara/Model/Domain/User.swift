//
//  UserModel.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

/// Model pengguna dari sumber eksternal.
/// Digunakan untuk contoh fetch dan tampilan daftar.
struct User: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

//
//  Category.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//
import SwiftUI

/// Model kategori untuk tampilan list kategori.
/// Menyimpan nama kategori dan ikon yang ditampilkan di UI.
struct Category: Identifiable {
    let id = UUID()
    let name: String
    let iconURL: URL?
}

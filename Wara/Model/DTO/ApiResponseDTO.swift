//
//  ApiResponseDTO.swift
//  Wara
//
//  Created by Meow on 06/11/25
//

import Foundation

/// Amplop respons generik yang kompatibel dengan berbagai skema backend.
/// Mendukung properti `success`/`message` opsional dan `data` sebagai payload utama.
struct ApiResponseDTO<T: Decodable>: Decodable {
    let success: Bool?
    let message: String?
    let data: T?
}
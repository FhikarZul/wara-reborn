//
//  CategoriesPayloadDTO.swift
//  Wara
//
//  Created by Meow on 06/11/25
//

import Foundation

struct CategoriesPayloadDTO: Decodable {
    let items: [CategoryItemDTO]
}
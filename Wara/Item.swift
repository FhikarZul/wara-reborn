//
//  Item.swift
//  Wara
//
//  Created by Immanuel Sitepu on 13/06/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

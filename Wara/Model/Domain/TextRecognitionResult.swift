//
//  TextRecognitionResult.swift
//  Wara
//
//  Created by Meow on 06/11/25
//

import CoreGraphics
import Foundation

/// Hasil pengenalan teks per bounding box dari Vision.
struct TextRecognitionResult: Identifiable {
    let id = UUID()
    let text: String
    let boundingBox: CGRect
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
}
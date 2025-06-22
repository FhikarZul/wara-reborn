//
//  OCRService.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Vision
import UIKit

enum OCRError: Error {
    case imageProcessingFailed
    case noTextFound
}

class OCRService {
    func extractKoreanText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRError.imageProcessingFailed
        }
        
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try requestHandler.perform([request])
                guard let observations = request.results, !observations.isEmpty else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }
                
                let recognizedText = observations
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n")
                
                continuation.resume(returning: recognizedText)
                
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

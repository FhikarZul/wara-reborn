//
//  OCRService.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Vision
import UIKit
import CoreGraphics

enum OCRError: Error {
    case imageProcessingFailed
    case noTextFound
}

struct TextRecognitionResult : Identifiable {
    let id = UUID()
    let text: String
    let boundingBox: CGRect
}

class OCRService {
    func extractKoreanText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRError.imageProcessingFailed
        }
        
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .left)
        
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
    
    func extractKoreanText(from sampleBuffer: CMSampleBuffer) throws -> String {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer)
        
        try requestHandler.perform([request])
        
        guard let observations = request.results, !observations.isEmpty else {
            throw OCRError.noTextFound
        }
        
        let recognizedText = observations
            .compactMap { $0.topCandidates(1).first?.string }
            .joined(separator: "\n")
        
        return recognizedText
    }
    
    func extractKoreanTextWithBoxes(from image: UIImage) async throws -> [TextRecognitionResult] {
        guard let cgImage = image.cgImage else {
                throw OCRError.imageProcessingFailed
            }
            
            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ko-KR"]
            request.usesLanguageCorrection = true

            let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up) // Pastikan orientasi benar
            
            var results: [TextRecognitionResult] = []

            do {
                try requestHandler.perform([request])
                
                guard let observations = request.results, !observations.isEmpty else {
                    throw OCRError.noTextFound
                }
                
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { continue }
                    
                    let box = observation.boundingBox
                    
                    let result = TextRecognitionResult(
                        text: topCandidate.string,
                        boundingBox: box
                    )
                    results.append(result)
                }
                
                return results
                
            } catch {
                throw error
            }
    }
}

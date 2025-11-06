//
//  OCRService.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Vision
import UIKit
import CoreGraphics

/// Error yang mungkin muncul saat menjalankan proses OCR.
enum OCRError: Error {
    case imageProcessingFailed
    case noTextFound
}

// Hasil pengenalan teks dipindahkan ke Model/Domain/TextRecognitionResult.swift

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

        // Setup request
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"] // Bahasa Korea
        request.usesLanguageCorrection = true

        // Handler
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        var results: [TextRecognitionResult] = []

        do {
            try requestHandler.perform([request])

            guard let observations = request.results, !observations.isEmpty else {
                throw OCRError.noTextFound
            }

            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }

                // Ambil empat titik koordinat dari VNRecognizedTextObservation
                let topLeft = observation.topLeft
                let topRight = observation.topRight
                let bottomLeft = observation.bottomLeft
                let bottomRight = observation.bottomRight

                let box = observation.boundingBox

                let result = TextRecognitionResult(
                    text: topCandidate.string,
                    boundingBox: box,
                    topLeft: topLeft,
                    topRight: topRight,
                    bottomLeft: bottomLeft,
                    bottomRight: bottomRight
                )

                results.append(result)
            }

            return results
        } catch {
            throw error
        }
    }
}

//
//  CameraViewModel.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
class CameraViewModel: ObservableObject {
    enum ScanState {
        case idle
        case processing
        case success(DetectionResult)
        case error(String)
    }
    
    @Published var scanState: ScanState = .idle
    @Published var isTorchOn: Bool = false
    
    // MARK: - PERUBAHAN: Saluran perintah untuk siklus hidup kamera
    let startCameraSession = PassthroughSubject<Void, Never>()
    let stopCameraSession = PassthroughSubject<Void, Never>()
    
    let torchToggleAction = PassthroughSubject<Void, Never>()
    let captureAction = PassthroughSubject<Void, Never>()
    
    private let ocrService: OCRService
    private let detectionService: DetectionService
    
    init(modelContext: ModelContext) {
        self.ocrService = OCRService()
        self.detectionService = DetectionService(modelContext: modelContext)
    }
    
    func processImage(_ image: UIImage) {
        scanState = .processing
        
        Task {
            // Berhenti menerima frame kamera SEBELUM kita mulai analisis berat
            stopCameraSession.send()
            
            do {
                let extractedText = try await ocrService.extractKoreanText(from: image)
                let result = await detectionService.analyze(text: extractedText)
                self.scanState = .success(result)
            } catch let ocrError as OCRError {
                self.scanState = .error(mapOcrErrorToString(ocrError))
            } catch {
                self.scanState = .error("Terjadi kesalahan tidak dikenal: \(error.localizedDescription)")
            }
        }
    }
    
    func resetState() {
        // Nyalakan kembali kamera SEBELUM UI kembali ke mode scan
        startCameraSession.send()
        scanState = .idle
    }
    
    private func mapOcrErrorToString(_ error: OCRError) -> String {
        switch error {
        case .imageProcessingFailed:
            return "Gagal memproses gambar."
        case .noTextFound:
            return "Tidak ada teks yang dapat dideteksi."
        }
    }
}

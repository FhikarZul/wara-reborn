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
        // case detectionFailed dihapus
    }
    
    @Published var scanState: ScanState = .idle
    @Published var isTorchOn: Bool = false
    
    let torchToggleAction = PassthroughSubject<Void, Never>()
    let captureAction = PassthroughSubject<Void, Never>()
    
    private let ocrService: OCRService
    private let detectionService: DetectionService
    
    init(modelContext: ModelContext) {
        self.ocrService = OCRService()
        self.detectionService = DetectionService(modelContext: modelContext)
    }
    
    // Ini sekarang menjadi satu-satunya fungsi untuk memproses gambar,
    // baik dari kamera maupun galeri.
    func processImage(_ image: UIImage) {
        scanState = .processing
        
        Task {
            do {
                // 1. Lakukan OCR pada seluruh gambar
                let extractedText = try await ocrService.extractKoreanText(from: image)
                
                // 2. Kirim teks hasil OCR ke service untuk dianalisis
                // Service akan menangani pengecekan kata kunci "원재료"
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

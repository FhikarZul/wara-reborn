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
        case capturing
        case processing
        case success(DetectionResult)
        case error(String)
    }
    
    // Manager & Services
    let cameraManager: CameraManager?
    private let ocrService: OCRService
    private let detectionService: DetectionService
    
    // States
    @Published var scanState: ScanState = .idle
    @Published var isTorchOn: Bool = false
    
    
    // Methods
    let captureAction = PassthroughSubject<Void, Never>()
    let torchToggleAction = PassthroughSubject<Void, Never>()
    
    init(modelContext: ModelContext) {
        self.ocrService = OCRService()
        self.detectionService = DetectionService(modelContext: modelContext)
        
        do {
            let cameraManager = CameraManager()
            try cameraManager.setup()
            self.cameraManager = cameraManager
            
            cameraManager.onImageCaptured = self.processImage
        } catch {
            self.cameraManager = nil
        }
    }
    
    func capture() {
        // Early exit if state are not idle
        guard case ScanState.idle = scanState else { return }
        
        scanState = .capturing
        
        guard let cameraManager = self.cameraManager else {
            print("Camera not available")
            return
        }

        cameraManager.capture()
    }
    
    func processImage(_ image: UIImage) {
        scanState = .processing

        Task {
            // Berhenti menerima frame kamera SEBELUM mwmulai analisis
            if(cameraManager != nil) {
                cameraManager!.stopSession()
            }
            
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
        cameraManager?.startSession()
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

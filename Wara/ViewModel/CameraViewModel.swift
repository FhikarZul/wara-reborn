//
//  CameraViewModel.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Combine
import SwiftData
import SwiftUI
import AVFoundation

@MainActor
class CameraViewModel: ObservableObject {
    enum ScanState {
        case idle
        case capturing
        case processing
        case success(DetectionResult)
        case error(String)
    }
    
    // MARK: - Manager & Services
    let cameraManager: CameraManager?
    private let ocrService: OCRService
    private let detectionService: DetectionService
    
    // MARK: - States
    @Published var scanState: ScanState = .idle
    @Published var isTorchOn: Bool = false
    @Published var isIngredientLabelDectected: Bool = false
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.ocrService = OCRService()
        self.detectionService = DetectionService(modelContext: modelContext)
        
        do {
            let cameraManager = CameraManager()
            try cameraManager.setup()
            self.cameraManager = cameraManager
            
            cameraManager.onImageCaptured = self.processImage
            cameraManager.onFrameCaptured = self.processFrame
        } catch {
            self.cameraManager = nil
        }
    }
    
    // MARK: - Methods
    func capture() {
        guard case ScanState.idle = scanState else { return } // Early exit if state are not idle
        
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
            if cameraManager != nil {
                cameraManager!.stopSession()
            }
            
            do {
                let extractedText = try await ocrService.extractKoreanText(
                    from: image
                )
                let result = await detectionService.analyzeIngredients(text: extractedText)
                self.scanState = .success(result)
            } catch let ocrError as OCRError {
                self.scanState = .error(mapOcrErrorToString(ocrError))
            } catch {
                self.scanState = .error(
                    "Terjadi kesalahan tidak dikenal: \(error.localizedDescription)"
                )
            }
        }
    }
    
    func processFrame(_ sampleBuffer: CMSampleBuffer) {
        do {
            let extractedText = try self.ocrService.extractKoreanText(from: sampleBuffer)
            let hasIngredients = self.detectionService.hasIngredientsLabel(in: extractedText)
            
            // Update UI on main thread
            DispatchQueue.main.async {
                self.isIngredientLabelDectected = hasIngredients
            }
        } catch {
        }
    }
    
    func resetState() {
        cameraManager?.startSession()
        scanState = .idle
    }
    
    func toggleTorch() {
        guard let cameraManager = self.cameraManager else { return }  // Early exit if camera manager not found
        cameraManager.toggleTorch()
        isTorchOn = !isTorchOn
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

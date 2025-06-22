//
//  CameraView.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI
import AVFoundation
import Combine

struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        context.coordinator.startSession()
        
        DispatchQueue.main.async {
            guard let session = context.coordinator.captureSession else { return }
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = view.frame
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var viewModel: CameraViewModel
        var captureSession: AVCaptureSession?
        private let photoOutput = AVCapturePhotoOutput()
        private var cancellables = Set<AnyCancellable>()
        
        init(viewModel: CameraViewModel) {
            self.viewModel = viewModel
            super.init()
            Task { @MainActor in
                viewModel.captureAction.sink { [weak self] in self?.capturePhoto() }.store(in: &cancellables)
                viewModel.torchToggleAction.sink { [weak self] in self?.toggleTorch() }.store(in: &cancellables)
            }
        }
        
        func startSession() {
            DispatchQueue.global(qos: .userInitiated).async {
                let session = AVCaptureSession()
                self.captureSession = session
                session.beginConfiguration()
                
                guard let videoDevice = AVCaptureDevice.default(for: .video),
                      let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
                      session.canAddInput(videoDeviceInput) else { return }
                session.addInput(videoDeviceInput)
                
                if session.canAddOutput(self.photoOutput) { session.addOutput(self.photoOutput) }
                
                session.sessionPreset = .photo
                session.commitConfiguration()
                session.startRunning()
            }
        }
        
        func capturePhoto() {
            guard let session = captureSession, session.isRunning else { return }
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard error == nil, let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
            Task { @MainActor in
                // PERUBAHAN DI SINI: Memanggil nama fungsi yang benar
                self.viewModel.processImage(image)
            }
        }
        
        func toggleTorch() {
            guard let videoDevice = AVCaptureDevice.default(for: .video), videoDevice.hasTorch else { return }
            
            do {
                try videoDevice.lockForConfiguration()
                let currentMode = videoDevice.torchMode
                videoDevice.torchMode = currentMode == .on ? .off : .on
                videoDevice.unlockForConfiguration()
                
                let isTorchOn = videoDevice.torchMode == .on
                Task { @MainActor in
                    self.viewModel.isTorchOn = isTorchOn
                }
            } catch {
                print("Failed to lock device for torch configuration: \(error)")
            }
        }
    }
}

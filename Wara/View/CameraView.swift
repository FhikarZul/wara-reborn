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
        
        // If manager failed to initiate, return empty view
        guard let cameraManager = viewModel.cameraManager else {
            return view
        }
        
        // If manager success to initiate, return camera preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        cameraManager.startSession()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    //    func makeCoordinator() -> Coordinator {
    //        Coordinator(viewModel: viewModel)
    //    }
    //
    //    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
    //        var viewModel: CameraViewModel
    //        var captureSession: AVCaptureSession?
    //        private let photoOutput = AVCapturePhotoOutput()
    //        private var cancellables = Set<AnyCancellable>()
    //        private let sessionQueue = DispatchQueue(label: "sessionQueue")
    //
    //        init(viewModel: CameraViewModel) {
    //            self.viewModel = viewModel
    //            super.init()
    //            self.startSession()
    //        }
    //
    //        func startSession() {
    //            if(viewModel.cameraManager != nil) {
    //                viewModel.cameraManager!.startSession()
    //            }
    //        }
    //
    //        func capturePhoto() {
    //            guard let session = captureSession, session.isRunning else { return }
    //            let settings = AVCapturePhotoSettings()
    //            photoOutput.capturePhoto(with: settings, delegate: self)
    //        }
    //
    //        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    //            guard error == nil, let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
    //            Task { @MainActor in
    //                self.viewModel.processImage(image)
    //            }
    //        }
    //        func toggleTorch() {
    //            guard let videoDevice = AVCaptureDevice.default(for: .video), videoDevice.hasTorch else { return }
    //
    //            do {
    //                try videoDevice.lockForConfiguration()
    //                let currentMode = videoDevice.torchMode
    //                videoDevice.torchMode = currentMode == .on ? .off : .on
    //                videoDevice.unlockForConfiguration()
    //
    //                let isTorchOn = videoDevice.torchMode == .on
    //                Task { @MainActor in
    //                    self.viewModel.isTorchOn = isTorchOn
    //                }
    //            } catch {
    //                print("Failed to lock device for torch configuration: \(error)")
    //            }
    //        }
    //    }
}

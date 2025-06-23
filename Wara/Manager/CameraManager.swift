//
//  CameraManager.swift
//  Wara
//
//  Created by Elvis on 23/06/25.
//
import UIKit
import AVFoundation

class CameraManager: NSObject, AVCapturePhotoCaptureDelegate {
    enum CameraError: Error {
        case deviceNotFound
        case addInputFailed
        case addOutputFailed
    }

    let session: AVCaptureSession
    let photoOutput: AVCapturePhotoOutput
    var onImageCaptured: (UIImage) -> Void =  { _ in }
    
    override init() {
        self.session = AVCaptureSession()
        self.photoOutput = AVCapturePhotoOutput()
    }
    
    func setup() throws {
        // 1. Find available camera
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("Device not found")
            throw CameraError.deviceNotFound
        }
        
        // 2. Add input device into session
        let inputDevice = try AVCaptureDeviceInput(device: camera)
        
        if(session.canAddInput(inputDevice)) {
            session.addInput(inputDevice)
        } else {
            print("Can't add camera input")
            throw CameraError.addInputFailed
        }
        
        // 3. Add output device into session
        if(session.canAddOutput(self.photoOutput)) {
            session.addOutput(self.photoOutput)
        } else {
            print("Can't add camera output")
            throw CameraError.addOutputFailed
        }
    }
    
    func startSession() {
        Task {
            self.session.startRunning()
        }
    }

    func stopSession() {
        self.session.stopRunning()
    }
    
    func capture() {
        let setting = AVCapturePhotoSettings()
        self.photoOutput.capturePhoto(with: setting, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            print("Failed to get image data")
            return
        }

        guard let uiImage = UIImage(data: imageData) else {
            print("Image corrupted")
            return
        }

        self.onImageCaptured(uiImage)
    }
}

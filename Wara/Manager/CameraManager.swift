//
//  CameraManager.swift
//  Wara
//
//  Created by Elvis on 23/06/25.
//
import UIKit
import AVFoundation

class CameraManager: NSObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    enum CameraError: Error {
        case deviceNotFound
        case addInputFailed
        case addOutputFailed
    }

    // MARK: - Properties
    let session: AVCaptureSession
    let photoOutputSession: AVCapturePhotoOutput
    let videoOutputSession: AVCaptureVideoDataOutput
    
    var device: AVCaptureDevice? = nil

    // MARK: - Callbacks
    var onImageCaptured: (UIImage) -> Void =  { _ in }
    var onFrameCaptured: (CMSampleBuffer) -> Void = { _ in }
    
    // MARK: - Initialization
    override init() {
        self.session = AVCaptureSession()
        self.photoOutputSession = AVCapturePhotoOutput()
        self.videoOutputSession = AVCaptureVideoDataOutput()
    }

    // MARK: - Methods
    public func setup() throws {
        // 1. Find available camera
        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("Device not found")
            throw CameraError.deviceNotFound
        }
        
        self.device = camera
        
        // 2. Add input device into session
        let inputDevice = try AVCaptureDeviceInput(device: camera)
        
        if(session.canAddInput(inputDevice)) {
            session.addInput(inputDevice)
        } else {
            print("Can't add camera input")
            throw CameraError.addInputFailed
        }
        
        // 3. Add output device into session
        if(session.canAddOutput(self.photoOutputSession)) {
            session.addOutput(self.photoOutputSession)
        } else {
            print("Can't add camera output")
            throw CameraError.addOutputFailed
        }
        
        if(session.canAddOutput(self.videoOutputSession)) {
            self.videoOutputSession.setSampleBufferDelegate(self, queue: .global(qos: .userInitiated))
            session.addOutput(self.videoOutputSession)
        } else {
            print("Can't add video output")
            throw CameraError.addOutputFailed
        }
    }
    
    public func startSession() {
        Task {
            self.session.startRunning()
        }
    }

    public func stopSession() {
        self.session.stopRunning()
    }
    
    public func toggleTorch() {
        guard let device = self.device else { return } // Early exit if device not found
        
        do {
            if(device.hasTorch && device.isTorchAvailable) {
                if(device.isTorchActive) {
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                } else {
                    try device.lockForConfiguration()
                    device.torchMode = .on
                    device.unlockForConfiguration()
                }
            }
        } catch {
            print("Error toggling torch: \(error)")
        }
    }
    
    public func capture() {
        let setting = AVCapturePhotoSettings()
        self.photoOutputSession.capturePhoto(with: setting, delegate: self)
    }
    
    // MARK: - Delegates
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
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.onFrameCaptured(sampleBuffer)
    }
}

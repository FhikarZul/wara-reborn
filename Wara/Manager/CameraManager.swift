//
//  CameraManager.swift
//  Wara
//
//  Created by Elvis on 23/06/25.
//
import UIKit
import AVFoundation

/// Abstraksi untuk setup kamera (input/output), capture foto dan stream video.
/// Digunakan oleh `CameraViewModel` untuk menangkap gambar/frame dan mengatur torch.
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

    var onImageCaptured: (UIImage) -> Void =  { _ in }
    var onFrameCaptured: (CMSampleBuffer) -> Void = { _ in }
    
    /// Inisialisasi session, output foto, dan output video tanpa konfigurasi.
    /// Konfigurasi perangkat dilakukan di `setup()`.
    override init() {
        self.session = AVCaptureSession()
        // Dua output berbeda:
        // - AVCapturePhotoOutput: untuk mengambil foto resolusi tinggi (JPEG/HEIC),
        //   mendukung fitur seperti flash dan auto exposure saat capture.
        // - AVCaptureVideoDataOutput: untuk stream frame video real-time ke delegate,
        //   cocok untuk analisis cepat (misal deteksi label bahan/OCR live).
        self.photoOutputSession = AVCapturePhotoOutput()
        self.videoOutputSession = AVCaptureVideoDataOutput()
    }

    // MARK: - Methods
    /// Men-setup perangkat kamera dan menambahkan input/output ke session.
    /// - Mengatur delegate video untuk streaming frame.
    /// - Melempar error bila perangkat tidak tersedia/penambahan IO gagal.
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
    
    /// Memulai `AVCaptureSession` secara asynchronous agar tidak memblok UI.
    /// `startRunning()` bersifat blocking; dibungkus `Task` untuk responsivitas.
    public func startSession() {
        Task {
            self.session.startRunning()
        }
    }

    /// Menghentikan `AVCaptureSession`. Operasi ini cepat dan dilakukan langsung.
    public func stopSession() {
        self.session.stopRunning()
    }
    
    /// Mengaktifkan/nonaktifkan torch (flash) pada perangkat kamera.
    /// Menggunakan `lockForConfiguration` untuk mengubah `torchMode` secara aman.
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
    
    /// Mengambil foto menggunakan `AVCapturePhotoOutput`.
    /// Hasilnya diproses di delegate `photoOutput(...didFinishProcessingPhoto...)`.
    public func capture() {
        let setting = AVCapturePhotoSettings()
        self.photoOutputSession.capturePhoto(with: setting, delegate: self)
    }
    
    // MARK: - Delegates
    /// Delegate pemrosesan foto: mengubah `AVCapturePhoto` menjadi `UIImage`
    /// dan meneruskan ke `onImageCaptured`.
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
    
    /// Delegate streaming video: meneruskan frame kamera ke `onFrameCaptured`
    /// untuk analisis real-time (misal deteksi label bahan).
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        self.onFrameCaptured(sampleBuffer)
    }
}

//
//  Camerapermission.swift
//  Wara Onboarding
//
//  Created by Delilah Mentari on 22/06/25.
//

import SwiftUI
import AVFoundation

struct CameraPermissionView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(alignment: .leading, spacing: 32) {
                Text("Akses kamera dibutuhkan sebelum memulai")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                Text("Dengan akses ini kami bisa membantumu mengidentifikasi kandungan bahan pada label komposisi produk kemasan berbahasa Korea dengan lebih cepat")
                    .foregroundColor(.white).font(.body)
            }.padding(.horizontal)

            Image("Camerapermission")
                .resizable().scaledToFit()
                .frame(width: 240, height: 240)
                .cornerRadius(24)

            Spacer()

            Button(action: {
                requestCameraPermission()
            }) {
                Text("Izinkan akses kamera")
                    .foregroundColor(.black) // Ganti warna jika perlu
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white) // Ganti warna jika perlu
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Izin Ditolak"), message: Text("Untuk melanjutkan, silakan aktifkan izin kamera melalui Pengaturan iPhone."), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
        .background(Color("primaryblue", bundle: nil).ignoresSafeArea()) // Ganti warna jika perlu
        .navigationBarBackButtonHidden(true) // Sembunyikan tombol kembali
    }

    // MARK: - PERUBAHAN: Logika request permission
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.hasCompletedOnboarding = true
                } else {
                    showAlert = true
                }
            }
        }
    }
}

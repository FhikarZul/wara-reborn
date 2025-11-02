Created by Meow on 02/11/25

# Post-mortem: PreviewShell Crash (SwiftUI Previews)

## Ringkasan
- Gejala: SwiftUI Previews gagal dengan pesan "PreviewShell quit unexpectedly".
- Dampak: Tidak bisa merender beberapa preview (khususnya yang menyentuh kamera / inisialisasi awal aplikasi).
- Timeline: Insiden muncul 02/11/25 saat menjalankan Previews untuk beberapa view.

## Gejala & Bukti
- Crash dialog macOS: "PreviewShell quit unexpectedly".
- Crash log `~/Library/Logs/DiagnosticReports/PreviewShell-2025-11-02-*.ips` memuat `esr: Address size fault` pada beberapa thread `start_wqthread`.
- Pola umum: terjadi saat Preview memuat kode yang mengakses hardware kamera, permission prompt, atau I/O berat di awal app.

## Root Cause Analysis (RCA)
- Kombinasi faktor:
  - Konfigurasi build untuk simulator dapat memakai `wholemodule` (Release) dan optimisasi agresif yang memicu instabilitas Preview.
  - Kode runtime yang tidak aman untuk lingkungan Preview:
    - `WaraApp` melakukan inisialisasi user saat start.
    - `CameraViewModel` langsung setup hardware kamera (`AVCaptureSession`).
    - `CameraPermissionView` memicu permission prompt.
    - `PersistenceController` sebelumnya dapat melakukan operasi I/O berat saat start (dan berpotensi fatal bila resource tidak tersedia di Preview).

## Perbaikan yang Diterapkan
- Konfigurasi xcconfig (khusus iPhone Simulator):
  - `Local.xcconfig` dan `Development.xcconfig`:
    - `SWIFT_OPTIMIZATION_LEVEL[sdk=iphonesimulator*] = -Onone`
    - `SWIFT_COMPILATION_MODE[sdk=iphonesimulator*] = singlefile`
  - `Release.xcconfig` (ditambahkan jika belum ada):
    - `API_SCHEME = https`, `API_HOST = api.wara.web.id`, `API_BASE_URL` konsisten.
    - `SWIFT_OPTIMIZATION_LEVEL[sdk=iphonesimulator*] = -Onone`
    - `SWIFT_COMPILATION_MODE[sdk=iphonesimulator*] = singlefile`

- Guards untuk lingkungan Preview di kode:
  - `Wara/Utils/Env.swift`: helper `Env.isPreview` untuk deteksi konsisten.
  - `Wara/WaraApp.swift`: skip `UserManager.shared.ensureUserInitialized()` bila `Env.isPreview`.
  - `Wara/ViewModel/CameraViewModel.swift`: skip setup `CameraManager` saat Preview (hardware kamera tidak diinisialisasi).
  - `Wara/View/Onboarding/Component/CameraPermissionView.swift`: skip permission prompt saat Preview.
  - `Wara/Controller/PresistenceController.swift`: melewatkan reload DB saat Preview dan mengganti kemungkinan `fatalError` dengan logging aman.

## Verifikasi
- Build Settings target (Simulator):
  - `Optimization Level` = `No Optimization [-Onone]`.
  - `Swift Compilation Mode` = `singlefile`.
- Operasional:
  - Hapus DerivedData, bersihkan build, jalankan Preview lagi.
  - Preview untuk view ringan (mis. `OnboardingView`, `CameraPermissionView`, `BaseView`) berhasil dirender.
  - `CameraView` merender view kosong di Preview (tanpa sesi kamera) — ini adalah perilaku yang diharapkan.

## Dampak Residual & Risiko
- Preview yang benar-benar bergantung pada aliran kamera akan menampilkan stub/pengganti saat Preview (bukan feed kamera nyata).
- Perlu disiplin untuk menjaga guard `Env.isPreview` pada kode yang menyentuh hardware/I/O berat agar Preview tetap stabil.

## Aksi Lanjutan
- Tambahkan dokumentasi internal tentang pola aman Preview di README.
- Pertimbangkan injeksi dependency untuk `CameraViewModel` agar bisa memakai fake/stub di Preview.
- (Opsional) Tambahkan check otomatis di CI untuk memastikan `xcconfig` memiliki override `-Onone` + `singlefile` pada simulator.

## File yang Terdampak
- `Wara/Config/Local.xcconfig`
- `Wara/Config/Development.xcconfig`
- `Wara/Config/Release.xcconfig` (ditambahkan)
- `Wara/Utils/Env.swift`
- `Wara/WaraApp.swift`
- `Wara/ViewModel/CameraViewModel.swift`
- `Wara/View/Onboarding/Component/CameraPermissionView.swift`
- `Wara/Controller/PresistenceController.swift`

## Status
- Previews stabil untuk view non-kamera dan alur onboarding.
- Guard ditambahkan untuk mencegah akses hardware dan I/O berat saat Preview.
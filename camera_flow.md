# Alur Kamera (Capture → OCR → Deteksi → UI)

Dokumen ini menjelaskan alur lengkap ketika pengguna melakukan pemindaian: mulai dari kamera mengambil gambar/frame, proses OCR, analisis bahan, hingga pembaruan UI dan overlay hasil.

## Ringkasan Alur

- Pengguna menekan tombol capture → `CameraViewModel.capture()` memerintahkan kamera mengambil foto.
- `CameraManager.capture()` memicu capture dan mengirim hasil ke delegate foto.
- Delegate mengirim `UIImage` ke `CameraViewModel.processImage(...)`.
- Di dalam `Task {}`, gambar dinormalisasi → OCR (`OCRService.extractKoreanTextWithBoxes`) → analisis bahan (`DetectionService.analyzeIngredients`) → update state UI ke `.preview(...)`.
- Untuk mode live, `CameraManager` men-stream frame via delegate video → `CameraViewModel.processFrame(...)` → OCR ringan → indikator label bahan + haptic.

## File-File Terlibat

- `Wara/Manager/CameraManager.swift` — Mengelola lifecycle kamera (`AVCaptureSession`), capture foto, stream frame, dan torch.
- `Wara/ViewModel/CameraViewModel.swift` — Mengorkestrasi alur capture/OCR/deteksi, mengelola state UI.
- `Wara/Service/OCRService.swift` — Melakukan pengenalan teks (Vision) dari gambar atau frame.
- `Wara/Service/DetectionService.swift` — Menganalisis teks OCR untuk bahan dan memetakan ke entitas `Ingredient` (SwiftData).
- `Wara/View/Capture/HighlightView.swift` — Menampilkan gambar hasil dan overlay kotak highlight dari OCR, termasuk normalisasi orientasi gambar.
- `Wara/Model/DetectionResult.swift` — Model hasil deteksi: status (aman/tidak aman/ragu-ragu/ingredientsNotFound) dan daftar bahan ditemukan.

## Method yang Terlibat

### CameraManager (`Wara/Manager/CameraManager.swift`)

- `setup()` — Inisialisasi perangkat kamera, menambahkan input/output ke session, set delegate video.
- `startSession()` — Memulai session (dibungkus `Task {}` karena `startRunning()` blocking).
- `stopSession()` — Menghentikan session.
- `toggleTorch()` — Mengaktif/nonaktifkan torch dengan `lockForConfiguration`.
- `capture()` — Mengambil foto melalui `AVCapturePhotoOutput`.
- `photoOutput(_:didFinishProcessingPhoto:error:)` — Delegate foto; mengubah `AVCapturePhoto` menjadi `UIImage`, forward ke `onImageCaptured`.
- `captureOutput(_:didOutput:from:)` — Delegate video; forward `CMSampleBuffer` ke `onFrameCaptured` untuk analisis real-time.

### CameraViewModel (`Wara/ViewModel/CameraViewModel.swift`)

- `capture()` — Mengubah state ke `.capturing` lalu memerintahkan `CameraManager` untuk capture.
- `processImage(_ image: UIImage)` — Mengubah state ke `.processing`, menjalankan `Task {}` untuk:
  - `stopSession()`, normalisasi gambar (`normalizedImage()`),
  - OCR kotak dan teks (`OCRService.extractKoreanTextWithBoxes(from:)`),
  - gabung teks dan analisis bahan (`DetectionService.analyzeIngredients(text:)`),
  - update state ke `.preview(...)`.
- `processFrame(_ sampleBuffer: CMSampleBuffer)` — OCR ringan dari frame (`OCRService.extractKoreanText(from:)`), cek label bahan (`DetectionService.hasIngredientsLabel`), haptic soft, update indikator `isIngredientLabelDectected`.
- `resetState()` — Memulai kembali session kamera dan set state ke `.idle`.
- `toggleTorch()` — Meneruskan perintah toggle ke `CameraManager` dan sinkronisasi flag UI.
- `mapOcrErrorToString(_:)` — Konversi error OCR ke pesan user-friendly.

### OCRService (`Wara/Service/OCRService.swift`)

- `extractKoreanText(from image: UIImage) async throws` — OCR teks Korea dari gambar (`VNRecognizeTextRequest`, `cgImage`, orientasi `.left`).
- `extractKoreanText(from sampleBuffer: CMSampleBuffer) throws` — OCR teks dari frame video (sinkron, untuk indikator label).
- `extractKoreanTextWithBoxes(from image: UIImage) async throws` — OCR teks + ambil bounding boxes & corner points (`topLeft`, `topRight`, `bottomLeft`, `bottomRight`). Menghasilkan array `TextRecognitionResult`.

### DetectionService (`Wara/Service/DetectionService.swift`)

- `analyzeIngredients(text: String) async -> DetectionResult` — Alur analisis:
  - Cek label bahan (`hasIngredientsLabel`) → keluar cepat jika tidak ada.
  - Bersihkan teks (hapus spasi, newline), ekstrak bagian bahan (`extractIngredients`), hilangkan noise (`removeIngredientExtraInformation`).
  - Ambil seluruh entitas `Ingredient` via `SwiftData`, cocokkan berdasarkan `koreanName`.
  - Tentukan status: `tidakAman` jika ada ingredient kategori tersebut; `raguRagu` jika ada kategori ragu; selain itu `aman`. Jika tak ada bahan terdeteksi atau label bahan hilang, kembalikan status yang sesuai.
- `hasIngredientsLabel(in:)` — Cek kata kunci "원재료" atau "원재료명".
- `extractIngredients(from:)` — Regex untuk mengambil bagian teks bahan.
- `removeIngredientExtraInformation(from:)` — Hapus informasi tambahan (persentase, rentang, isi dalam kurung/square brackets) via regex literal Swift.

### HighlightView (`Wara/View/Capture/HighlightView.swift`)

- Overlay kotak highlight: hitung skala dan offset agar koordinat Vision (0–1) dipetakan ke ukuran tampilan.
- `UIImage.correctOrientation()` — Normalisasi orientasi ke `.up` via render ulang context; memastikan overlay sesuai posisi.

## Rincian Alur Still Capture

1. User tap capture → `CameraViewModel.capture()` memerintahkan `CameraManager.capture()`.
2. Delegate foto di `CameraManager` mengubah `AVCapturePhoto` jadi `UIImage` → memanggil `onImageCaptured` yang di-bind ke `CameraViewModel.processImage(...)`.
3. `processImage(...)` menjalankan `Task {}` (supaya tidak memblok UI):
   - Hentikan session sementara (`stopSession()`), normalisasi orientasi.
   - OCR kotak + teks (`extractKoreanTextWithBoxes`).
   - Gabungkan seluruh teks, analisis bahan (`analyzeIngredients`).
   - Update `scanState` ke `.preview(...)` agar UI menampilkan gambar dan overlay.

## Rincian Alur Live Frame

1. Saat session aktif, `CameraManager` meng-stream frame (`captureOutput`) ke `onFrameCaptured`.
2. `CameraViewModel.processFrame(...)` melakukan OCR ringan untuk tekstual indikasi label bahan.
3. Jika label terdeteksi, aktifkan haptic soft dan set `isIngredientLabelDectected = true` untuk feedback UI.

## Konversi Koordinat & Orientasi Gambar

- Vision memberikan koordinat bounding box dalam sistem ter-normalisasi (0–1) dengan origin di kiri-bawah.
- `HighlightView` menghitung `scale`, `offsetX`, `offsetY` untuk memetakan ke ukuran tampilan yang mempertahankan aspect ratio.
- `correctOrientation()` memastikan bitmap upright sehingga mapping titik `topLeft`—`bottomRight` akurat.

## Concurrency & Threading

- `CameraViewModel` ber-`@MainActor`; pembaruan state UI aman di main thread.
- `Task {}` di `processImage(...)` digunakan untuk memanggil fungsi `async` dari konteks non-async (callback kamera) tanpa memblok UI.
- Operasi berat (OCR, analisis) berjalan asinkron; UI tetap responsif.

## Haptic & Feedback UI

- Ketika label bahan terdeteksi di alur live, di-trigger haptic `UIImpactFeedbackGenerator(style: .soft)` untuk feedback cepat.
- `scanState` menggerakkan UI: `.processing` → spinner; `.preview` → gambar + highlight; `.error` → pesan.

## Ketergantungan & Model

- `TextRecognitionResult` (di OCRService) memuat teks dan titik sudut untuk overlay.
- `DetectionResult` memuat status dan daftar `Ingredient` yang cocok.
- `SwiftData` digunakan untuk mengambil seluruh daftar `Ingredient` dari storage lokal.

## Catatan Pengujian & Ekstensi

- Disarankan membuat protokol `CameraManaging` agar `CameraViewModel` bisa diuji dengan mock (tanpa hardware kamera).
- Unit test untuk `OCRService` dan `DetectionService` dapat menggunakan fixture gambar/teks.
- `correctOrientation()` dan mapping koordinat bisa diuji dengan gambar contoh agar overlay konsisten.

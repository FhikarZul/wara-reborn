# Wara (iOS/SwiftUI)

Aplikasi iOS untuk memindai label bahan makanan (khusus teks Korea) dan mengklasifikasikan status konsumsi berdasarkan daftar bahan lokal. Menggunakan kamera perangkat, OCR, dan deteksi berbasis data untuk memandu pengguna apakah produk aman, meragukan, atau tidak aman dikonsumsi.

## Fitur Utama
- Pemindaian label bahan dengan kamera (`AVFoundation`) dan pratinjau langsung.
- OCR teks Korea menggunakan `Vision` dari gambar atau frame.
- Deteksi bahan otomatis berbasis `SwiftData` dan dataset `Ingredients.json`.
- Klasifikasi hasil: aman (`aman`), meragukan (`raguRagu`), tidak aman (`tidakAman`).
- Umpan balik haptik saat label bahan terdeteksi di kamera.
- Inisialisasi pengguna sekali jalan dengan `UUIDv7`, disimpan ke `UserDefaults` dan dikirim sebagai header `X-User-ID` pada request API.
- Tampilan kategori, favorit, dan onboarding multi-layar.

## Arsitektur & Teknologi
- Pola MVVM terinspirasi Clean Architecture ringan:
  - UI/View (`SwiftUI`) → ViewModel (`@MainActor`) → Services/Manager → Data Sources.
- Komponen utama:
  - `CameraManager` (pengelola sesi kamera dan torch).
  - `OCRService` (ekstraksi teks Korea dari `UIImage`/`CMSampleBuffer` + bounding box).
  - `DetectionService` (pencocokan teks terhadap model `Ingredient` di `SwiftData`).
  - `HttpClient` (wrapper `Alamofire`, JSON encoding, header `X-User-ID`).
  - `CategoryRemoteSource`, `UserRemoteSource` (koneksi API menggunakan konfigurasi dari `Info.plist`).
  - `PersistenceController` (container `SwiftData`, seeding dari `Ingredients.json`).
- Framework & dependensi:
  - `SwiftUI`, `SwiftData`, `Vision`, `AVFoundation`, `UIKit`.
  - `Alamofire` via Swift Package Manager (versi 5.10.2).
- Target iOS: minimum iOS 18 (konfigurasi target menggunakan `xcconfig`).

## Perizinan (Info.plist)
Berikut kunci privasi yang digunakan aplikasi (dikonfigurasi melalui build settings dan dipetakan ke Info.plist):
- `NSCameraUsageDescription` — "We need to access your camera to scan ingredients label"
- `NSPhotoLibraryUsageDescription` — "We need to access your library for importing photos to scanning ingredients"

Tambahan konfigurasi Info.plist untuk API:
- `API_SCHEME` — diisi dari `xcconfig` (contoh: `http` atau `https`).
- `API_HOST` — diisi dari `xcconfig` (contoh: `localhost:4041`, `api-dev.wara.web.id`).
- `API_BASE_URL` — opsional, dirangkai dari `SCHEME` dan `HOST` bila diperlukan.

## Setup
Persyaratan:
- Xcode 16.x
- iOS Simulator atau perangkat fisik dengan iOS 18+

Langkah cepat:
1. Buka proyek `Wara.xcodeproj` di Xcode.
2. Pilih scheme `Wara` dan target perangkat/simulator.
3. Tunggu SPM menyelesaikan resolusi paket (Alamofire 5.10.2).
4. Run (⌘R).

CLI alternatif:
```bash
# Resolusi paket untuk project & scheme
xcodebuild -resolvePackageDependencies \
  -project Wara.xcodeproj \
  -scheme Wara

# Build untuk simulator (contoh iPhone 16)
xcodebuild build \
  -project Wara.xcodeproj \
  -scheme Wara \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Konfigurasi
Konfigurasi API menggunakan file `xcconfig` yang dipetakan ke `Info.plist`:
- `Wara/Config/Local.xcconfig` (Debug lokal)
- `Wara/Config/Development.xcconfig` (Lingkungan development)
- `Wara/Config/Release.xcconfig` (Produksi)

Kunci yang tersedia:
- `API_SCHEME`: `http` atau `https`.
- `API_HOST`: hostname (boleh menyertakan port, mis. `localhost:4041`).
- `API_BASE_URL`: [opsional] dirangkai sebagai `$(API_SCHEME):$(SLASH)/$(API_HOST)`.

Contoh konfigurasi lokal:
```ini
API_SCHEME = http
API_HOST   = localhost:4041
API_BASE_URL = $(API_SCHEME):$(SLASH)/$(API_HOST)
```
Validasi di runtime:
- Aplikasi memanggil `Bundle.main.object(forInfoDictionaryKey:)` untuk `API_SCHEME` dan `API_HOST`.
- Ada `precondition` yang memastikan nilai tidak kosong dan scheme hanya `http`/`https`.

## Cara Pakai
- Onboarding: ikuti layar pengantar, tekan `Mulai Sekarang`, berikan izin kamera.
- Pemindaian:
  - Buka tab `Scan` → kamera dibuka sebagai full-screen.
  - Arahkan kamera ke label bahan (umumnya "원재료").
  - Saat label terdeteksi, ada haptic ringan; ambil foto untuk analisis.
- Hasil:
  - Layar hasil menampilkan tipe produk dan klasifikasi bahan.
  - Status bahan: `aman`, `raguRagu`, `tidakAman`.

Catatan pengguna:
- Pada peluncuran pertama, aplikasi membuat `user_id` (UUIDv7) melalui `UserManager.ensureUserInitialized()`.
- `user_id` disimpan di `UserDefaults` dan otomatis ditambahkan sebagai header `X-User-ID` pada request API.

## Struktur Folder
Ringkasan direktori penting:
```
Wara/
├─ View/                # SwiftUI Views (BaseView, CaptureView, ScanResultView, dsb.)
├─ ViewModel/           # ViewModels (CameraViewModel, CategoryViewModel, ContentViewModel)
├─ Service/             # OCRService, DetectionService
├─ Manager/             # CameraManager (AVCaptureSession)
├─ Controller/          # PersistenceController (SwiftData)
├─ Data/
│  ├─ Remote/           # CategoryRemoteSource, UserRemoteSource
│  └─ Local/            # Ingredients.json (dataset)
├─ Model/               # Ingredient, DetectionResult, UserModel, CreateUserModel
├─ Utils/               # HttpClient, NetworkError, UUIDv7 util
├─ Config/              # *.xcconfig (Local/Development/Release)
├─ Assets.xcassets/     # Asset warna & gambar
└─ Info.plist           # API_* keys (diisi dari xcconfig)
```

## Data & Sinkronisasi
- Persistensi lokal: `SwiftData` dengan model `Ingredient` (fields: `koreanName`, `pronunciation`, `englishName`, `descriptionText`, `category`).
- Seeding: `PersistenceController` memuat `Ingredients.json` dan menginisialisasi database pada background task.
- Deteksi: `DetectionService` mengekstrak kata kunci dari teks OCR untuk mencocokkan ke `Ingredient` dan menentukan status.
- Jaringan:
  - `HttpClient` menggunakan `Alamofire` untuk request JSON.
  - Header `X-User-ID` otomatis ditambahkan bila tersedia di `UserDefaults`.
  - `CategoryRemoteSource` dan `UserRemoteSource` membangun `baseURL` dari `API_SCHEME` + `API_HOST` via `Info.plist`.

## Pengujian
Saat ini tidak ada target unit/UI test yang terdeteksi. [opsional]

Contoh perintah bila test ditambahkan:
```bash
# Jalankan test pada simulator
xcodebuild test \
  -project Wara.xcodeproj \
  -scheme Wara \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Aksesibilitas & Lokalization
- Typography & Dynamic Type:
  - Gunakan gaya teks SwiftUI: `.largeTitle`, `.title2`, `.headline`, `.subheadline`, `.body`, `.caption`.
  - Hindari `.font(.system(size:, weight:, design:))` agar skala teks mengikuti pengaturan aksesibilitas pengguna.
  - Standar: konten utama `.body`, label/kontrol `.subheadline`, header section `.headline`.
  - Audit sedang berlangsung untuk memigrasi komponen ke gaya teks bawaan.
- Warna & kontras: gunakan warna dari `Assets` dan pastikan kontras memadai.
- Lokalization: belum diaktifkan. [opsional]

## Privasi
- Aplikasi meminta akses kamera dan pustaka foto untuk pemindaian.
- `user_id` digunakan untuk korelasi ringan di backend (via header), tidak menyimpan rahasia.
- Jangan menaruh kredensial rahasia di repo atau `Info.plist`.

## Roadmap [opsional]
- Peningkatan impor dari pustaka foto dan galeri.
- Sinkronisasi favorit dengan backend.
- Peningkatan aksesibilitas (Dynamic Type penuh, VoiceOver, haptik adaptif).
- Lokalization multi-bahasa (ID/EN/KO).

## Kontributor [opsional]
- Tim ADA — Wara iOS.

## Lisensi
Belum ditentukan. [opsional]

---

### Build & Run Cepat
- Buka di Xcode, pilih scheme `Wara`, lalu Run.
- Pastikan `API_SCHEME`/`API_HOST` sesuai lingkungan (Local/Development/Release).
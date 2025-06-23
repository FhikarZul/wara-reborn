//
//  HalalLensView.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: CameraViewModel
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    init() {
        _viewModel = StateObject(wrappedValue: CameraViewModel(modelContext: PersistenceController.shared.container.mainContext))
    }
    
    var body: some View {
      
        ZStack {
            CameraView(viewModel: viewModel)
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                Text("Arahkan kamera ke daftar bahan makanan")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(.black.opacity(0.6))
                    .cornerRadius(10)
                    .padding(.bottom, 8)
                
                HStack(alignment: .center, spacing: 60) {
                    // Tombol Impor Galeri
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                    // Tombol Capture
                    Button(action: {
                        viewModel.captureAction.send()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 65, height: 65)
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 75, height: 75)
                        }
                    }
                    
                    // Tombol Senter
                    Button(action: {
                        viewModel.torchToggleAction.send()
                    }) {
                        Image(systemName: viewModel.isTorchOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 30)
            }
            
            // Lapisan untuk menampilkan hasil atau status
            switch viewModel.scanState {
            case .idle:
                EmptyView()
            case .processing:
                ProcessingView()
            case .success(let result):
                ResultView(result: result, onDismiss: viewModel.resetState)
            case .error(let message):
                ErrorView(message: message, onDismiss: viewModel.resetState)

            }
        }
        .onChange(of: selectedPhotoItem) {
            Task {
                if let data = try? await selectedPhotoItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    // MARK: - PERBAIKAN 2: Memanggil nama fungsi yang benar
                    viewModel.processImage(image)
                    selectedPhotoItem = nil
                }
            }
        }
    }
}

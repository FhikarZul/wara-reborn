//
//  HalalLensView.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import PhotosUI
import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: CameraViewModel

    @State private var selectedPhotoItem: PhotosPickerItem?

    init() {
        _viewModel = StateObject(
            wrappedValue: CameraViewModel(
                modelContext: PersistenceController.shared.container.mainContext
            )
        )
    }
    
    private var areControlsHidden: Bool {
        switch viewModel.scanState {
        case .idle, .capturing:
            return false
        case .processing, .success, .error:
            return true
        }
    }

    var body: some View {
        ZStack {
            CameraView(viewModel: viewModel)
                .ignoresSafeArea()

            VStack {
                HStack {
                    HStack(alignment: .center) {
                        if viewModel.isIngredientLabelDectected {
                            Image(systemName: "checkmark.circle.fill")
                        }

                        Text(
                            viewModel.isIngredientLabelDectected
                                ? "Label komposisi ditemukan"
                                : "Yuk, pindai label komposisi"
                        )
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .foregroundColor(
                        viewModel.isIngredientLabelDectected ? .green : .white
                    )
                    .background(.black.opacity(0.6))
                    .cornerRadius(40)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .transition(.scale)
                    .id(
                        "detectionStatusText_"
                            + (viewModel.isIngredientLabelDectected
                                ? "detected" : "scanning")
                    )
                }

                Spacer()

                HStack(alignment: .center, spacing: 60) {
                    // Tombol Impor Galeri
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images
                    ) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(width: 64, height: 64)
                    .background(.black.opacity(0.2))
                    .clipShape(Circle())
                    
                    // Tombol Capture
                    Button(action: {
                        viewModel.capture()
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
                    Button(action: viewModel.toggleTorch) {
                        Image(
                            systemName: viewModel.isTorchOn
                                ? "bolt.fill" : "bolt.slash.fill"
                        )
                        .font(.title)
                        .foregroundColor(.white)
                    }
                    .frame(width: 64, height: 64)
                    .background(.black.opacity(0.2))
                    .clipShape(Circle())
                }
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(areControlsHidden)
            }
            .frame(maxWidth: .infinity)

            // Lapisan untuk menampilkan hasil atau status
            switch viewModel.scanState {
            case .idle:
                EmptyView()
            case .capturing:
                EmptyView()
            case .processing:
                ProcessingView()
            case .success(let result):
                ResultView(result: result, onDismiss: viewModel.resetState)
            case .error(let message):
                ErrorView(message: message, onDismiss: viewModel.resetState)
            }
        }
        .animation(.bouncy, value: viewModel.isIngredientLabelDectected)
        .onChange(of: selectedPhotoItem) {
            Task {
                if let data = try? await selectedPhotoItem?.loadTransferable(
                    type: Data.self
                ),
                   let image = UIImage(data: data)
                {
                    viewModel.processImage(image)
                    selectedPhotoItem = nil
                }
            }
        }
    }
}

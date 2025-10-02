import SwiftUI
import UIKit 

struct HighlightView: View {
    let recognizedTexts: [TextRecognitionResult]
    let originalImage: UIImage
    let onResult: () -> Void
    let onDismiss: () -> Void
    
    @State private var selectedTexts: [TextRecognitionResult] = []
    @State private var showPopup = false
    @State private var popupLocation: CGPoint = .zero
    @State private var dragLocation: CGPoint = .zero

    var body: some View {
        NavigationView{
            ZStack {
                // Main image
                Image(uiImage: originalImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        GeometryReader { geometry in
                            let imageSize = originalImage.size
                            let viewSize = geometry.size
                            let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
                            let offsetX = (viewSize.width - imageSize.width * scale) / 2
                            let offsetY = (viewSize.height - imageSize.height * scale) / 2
                            
                            // Highlight view
                            ForEach(recognizedTexts) { textData in
                                let normalizedBox = textData.boundingBox
                                let rect = CGRect(
                                    x: normalizedBox.origin.x * imageSize.width * scale + offsetX,
                                    y: (1 - normalizedBox.origin.y - normalizedBox.size.height) * imageSize.height * scale + offsetY,
                                    width: normalizedBox.size.width * imageSize.width * scale,
                                    height: normalizedBox.size.height * imageSize.height * scale
                                )
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(selectedTexts.contains(where: { $0.id == textData.id }) ? Color.green.opacity(0.5) : Color.blue.opacity(0.3))
                                    .frame(width: rect.width, height: rect.height)
                                    .position(x: rect.midX, y: rect.midY)
                            }
                            
                            // Tap & Drag Gesture Layer
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            // Update the drag location to enable live highlighting
                                            dragLocation = value.location
                                            
                                            // Re-evaluate the selection on every drag change
                                            let selectedArea = CGRect(origin: value.startLocation, size: CGSize(width: value.location.x - value.startLocation.x, height: value.location.y - value.startLocation.y))
                                            
                                            selectedTexts = findTexts(in: selectedArea, geometry: geometry)
                                        }
                                        .onEnded { value in
                                            if !selectedTexts.isEmpty {
                                                popupLocation = value.location
                                                showPopup = true
                                            }
                                        }
                                )
                        }
                    )

                // Popup menu
                if showPopup {
                    popupMenu
                        .position(popupLocation)
                        .onTapGesture {
                            // Dismiss the popup if the user taps outside it
                            withAnimation {
                                showPopup = false
                            }
                        }
                }

                // Buttons
                VStack {
                    Spacer()
                    Button("Cek Bahan Berbahaya") {
                        onResult() // Pass the selected texts to the parent view
                    }
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: .orange))
                    
                    Button("Scan Kembali") {
                        onDismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: Color("primaryblue", bundle: nil)))
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // Helper function to find text within a given CGRect
    func findTexts(in rect: CGRect, geometry: GeometryProxy) -> [TextRecognitionResult] {
        var foundTexts: [TextRecognitionResult] = []
        
        let imageSize = originalImage.size
        let viewSize = geometry.size
        let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
        let offsetX = (viewSize.width - imageSize.width * scale) / 2
        let offsetY = (viewSize.height - imageSize.height * scale) / 2
        
        for textData in recognizedTexts {
            let normalizedBox = textData.boundingBox
            let textRect = CGRect(
                x: normalizedBox.origin.x * imageSize.width * scale + offsetX,
                y: (1 - normalizedBox.origin.y - normalizedBox.size.height) * imageSize.height * scale + offsetY,
                width: normalizedBox.size.width * imageSize.width * scale,
                height: normalizedBox.size.height * imageSize.height * scale
            )
            
            // Check for intersection
            if rect.intersects(textRect) {
                foundTexts.append(textData)
            }
        }
        return foundTexts
    }
    
    var popupMenu: some View {
        VStack(spacing: 0) {
            Button(action: {
                let combinedText = selectedTexts.map { $0.text }.joined(separator: " ")
                UIPasteboard.general.string = combinedText
                print("Copied text: \(combinedText)")
                
                withAnimation {
                    showPopup = false
                    selectedTexts = [] // Reset selection after copy
                }
            }) {
                Text("Salin")
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
            }
        }
    }
}

// Custom button style to avoid code repetition
struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


#Preview {
   
    let dummyTexts = [
        TextRecognitionResult(
            text: "Contoh Teks Pertama",
            boundingBox: CGRect(x: 0.1, y: 0.8, width: 0.3, height: 0.05)
        ),
        TextRecognitionResult(
            text: "Ini Teks Kedua",
            boundingBox: CGRect(x: 0.5, y: 0.6, width: 0.2, height: 0.05)
        ),
        TextRecognitionResult(
            text: "Teks Ketiga",
            boundingBox: CGRect(x: 0.2, y: 0.4, width: 0.35, height: 0.05)
        )
    ]

    
    let placeholderImage = UIImage(systemName: "doc.text.image") ?? UIImage()

    
    HighlightView (
        recognizedTexts: dummyTexts,
        originalImage: placeholderImage,
        onResult: {
            
        },
        onDismiss: {
            
        }
    )
}

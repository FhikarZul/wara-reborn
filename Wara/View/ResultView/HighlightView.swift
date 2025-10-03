import SwiftUI
import UIKit

struct HighlightView: View {
    let recognizedTexts: [TextRecognitionResult]
    let originalImage: UIImage
    let onResult: () -> Void
    let onDismiss: () -> Void
    
    @State private var correctedImage: UIImage?

    var body: some View {
        NavigationView {
            ZStack {
                if let correctedImage = correctedImage {
                    Image(uiImage: correctedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(
                            GeometryReader { geometry in
                                let imageSize = correctedImage.size
                                let viewSize = geometry.size
                                let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
                                let offsetX = (viewSize.width - imageSize.width * scale) / 2
                                let offsetY = (viewSize.height - imageSize.height * scale) / 2
                                
                                ZStack {
                                    // Background Layer
                                    ForEach(recognizedTexts) { textData in
                                        let normalizedBox = textData.boundingBox
                                        let rect = CGRect(
                                            x: normalizedBox.origin.x * imageSize.width * scale + offsetX,
                                            y: (1 - normalizedBox.origin.y - normalizedBox.size.height) * imageSize.height * scale + offsetY,
                                            width: normalizedBox.size.width * imageSize.width * scale,
                                            height: normalizedBox.size.height * imageSize.height * scale
                                        )
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.white)
                                            .frame(width: rect.width, height: rect.height)
                                            .position(x: rect.midX, y: rect.midY)
                                    }
                                    
                                    // Text Layer
                                    ForEach(recognizedTexts) { textData in
                                        let normalizedBox = textData.boundingBox
                                        let rect = CGRect(
                                            x: normalizedBox.origin.x * imageSize.width * scale + offsetX,
                                            y: (1 - normalizedBox.origin.y - normalizedBox.size.height) * imageSize.height * scale + offsetY,
                                            width: normalizedBox.size.width * imageSize.width * scale,
                                            height: normalizedBox.size.height * imageSize.height * scale
                                        )
                                        
                                        Text(textData.text)
                                            .foregroundColor(.black)
                                            .font(.system(size: rect.height * 0.8))
                                            .minimumScaleFactor(0.2)
                                            .lineLimit(1)
                                            .padding(1)
                                            .frame(width: rect.width, height: rect.height)
                                            .position(x: rect.midX, y: rect.midY)
                                            .textSelection(.enabled)
                                    }
                                }
                            }
                        )
                }
                
                VStack {
                    Spacer()
                    
                    VStack {
                        Button("Cek Bahan Berbahaya") {
                            onResult()
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: .orange))
                        
                        Button("Scan Kembali") {
                            onDismiss()
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color("primaryblue", bundle: nil)))
                    }
                    .padding()
                    .background(
                        Color.black
                            .ignoresSafeArea()
                    )
                }
            }
            .background(Color.black)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            self.correctedImage = originalImage.correctOrientation()
        }
    }
}

extension UIImage {
    func correctOrientation() -> UIImage {
        guard self.imageOrientation != .up else {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
}

// Custom button style (remains the same)
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


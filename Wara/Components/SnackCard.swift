import SwiftUI

struct SnackCard: View {
    var imageName: String?
    var title: String
    var subtitle: String
    var likes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Image
            Group {
                if let imageName = imageName, !imageName.isEmpty, UIImage(named: imageName) != nil {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(24)
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
            .frame(width: 120, height: 120)
            .background(Color(.systemGray6))
            .clipped()
            .cornerRadius(8)
            .padding(.top,-5)

            // Title
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)

            // Subtitle
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)

            // Like count
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.subheadline)
                Text("\(likes)")
                    .font(.subheadline)
            }
            .foregroundColor(.gray)
        }
        .padding(10)
        .frame(width: 130)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    VStack(spacing: 20) {
        SnackCard(
            imageName: "snack_sample",
            title: "Korean Snack",
            subtitle: "과자",
            likes: 1020
        )

       
        SnackCard(
            imageName: nil,
            title: "Unknown Snack",
            subtitle: "Tidak diketahui",
            likes: 12
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

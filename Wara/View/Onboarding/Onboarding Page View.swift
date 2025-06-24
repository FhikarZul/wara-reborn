//
//  OnboardingPageView.swift
//  Wara Onboarding
//
//  Created by Delilah Mentari on 22/06/25.
//

import SwiftUI

struct `OnboardingPageView`: View {
    let imageName: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(24)

            Text(title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingPageView(imageName: "", title: "", description: "")
}

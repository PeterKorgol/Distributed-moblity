//
//  FlowerResultView.swift
//  Python
//
//  Created by pk on 2025-04-01.
//


import SwiftUI

struct FlowerResultView: View {
    let flowerName: String
    let flowerImage: String

    var body: some View {
        VStack {
            Text(flowerName) // Display flower name
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Image(flowerImage) // Display flower image
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
        }
        .navigationTitle("Prediction Result")
    }
}


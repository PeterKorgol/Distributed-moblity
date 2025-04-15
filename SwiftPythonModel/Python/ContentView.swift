//
//  ContentView.swift
//  Python
//
//  Created by pk on 2025-03-27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            FlowerPredictionView()
                .navigationTitle("Flower Type Prediction")
        }
    }
}

#Preview {
    ContentView()
}

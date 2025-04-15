// 
//import SwiftUI
//
//struct FlowerPredictionView: View {
//    @StateObject private var viewModel = FlowerPredictionViewModel() // Fix property wrapper
//    
//    @State private var sepalLength: String = ""
//    @State private var sepalWidth: String = ""
//    @State private var petalLength: String = ""
//    @State private var petalWidth: String = ""
//    
//    var body: some View {
//        VStack {
//            
//            
//            // Input fields for flower features
//            VStack(spacing: 20) {
//                TextField("Sepal Length", text: $sepalLength)
//                    .keyboardType(.decimalPad)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                TextField("Sepal Width", text: $sepalWidth)
//                    .keyboardType(.decimalPad)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                TextField("Petal Length", text: $petalLength)
//                    .keyboardType(.decimalPad)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                TextField("Petal Width", text: $petalWidth)
//                    .keyboardType(.decimalPad)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//            }
//            
//            // Predict button
//            Button("Predict Flower Type") {
//                guard let sepalLength = Double(sepalLength),
//                      let sepalWidth = Double(sepalWidth),
//                      let petalLength = Double(petalLength),
//                      let petalWidth = Double(petalWidth) else {
//                    return
//                }
//                
//                // Send features for prediction
//                viewModel.predictFlower(features: [sepalLength, sepalWidth, petalLength, petalWidth])
//            }
//            .padding()
//            .buttonStyle(.borderedProminent)
//            
//            // Loading indicator
//            if viewModel.isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .padding()
//            }
//            
//            // Display the predicted flower type image
//            if !viewModel.flowerTypeImage.isEmpty {
//                Image(viewModel.flowerTypeImage) // Fixes issue with @StateObject
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 200, height: 200)
//                    .padding()
//            }
//            
//            // Error message
//            if let error = viewModel.errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .padding()
//    }
//}

import SwiftUI

struct FlowerPredictionView: View {
    @StateObject private var viewModel = FlowerPredictionViewModel()
    
    @State private var sepalLength: String = ""
    @State private var sepalWidth: String = ""
    @State private var petalLength: String = ""
    @State private var petalWidth: String = ""
    
    @State private var navigateToResult: Bool = false // Controls navigation
    @State private var predictedFlowerName: String = ""

    var body: some View {
        NavigationView {
            VStack {
               
                
                // Input fields
                VStack(spacing: 20) {
                    TextField("Sepal Length", text: $sepalLength)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Sepal Width", text: $sepalWidth)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Petal Length", text: $petalLength)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Petal Width", text: $petalWidth)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                // Predict button
                Button("Predict Flower Type") {
                    guard let sepalLength = Double(sepalLength),
                          let sepalWidth = Double(sepalWidth),
                          let petalLength = Double(petalLength),
                          let petalWidth = Double(petalWidth) else {
                        return
                    }
                    
                    // Send features for prediction
                    viewModel.predictFlower(features: [sepalLength, sepalWidth, petalLength, petalWidth])
                    
                    // Wait a bit for the prediction before navigating
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        predictedFlowerName = viewModel.getFlowerName() // Get the flower name
                        navigateToResult = true
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
                // Loading indicator
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                // Error message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Navigation Link (Hidden but activates when navigateToResult is true)
                NavigationLink(
                    destination: FlowerResultView(flowerName: predictedFlowerName, flowerImage: viewModel.flowerTypeImage),
                    isActive: $navigateToResult
                ) { EmptyView() }
            }
            .padding()
        }
    }
}


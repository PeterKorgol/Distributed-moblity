
import Foundation
import SwiftUI

//class FlowerPredictionViewModel: ObservableObject {
//    
//    @Published var flowerTypeImage: String = "" // This will hold the image name based on the prediction
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String? = nil // For debugging errors
//
//    // Function to send features to Flask API and get the prediction
//    func predictFlower(features: [Double]) {
//        // Validate URL
//        guard let url = URL(string: "http://127.0.0.1:5000/predict") else {
//            print("❌ Invalid URL")
//            return
//        }
//
//        // Prepare request
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Create request body
//        let body: [String: Any] = ["features": features] // Fix JSON structure
//        
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: body)
//            request.httpBody = jsonData
//            print("✅ Request JSON: \(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")")
//        } catch {
//            print("❌ JSON Serialization Error: \(error)")
//            return
//        }
//
//        // API Call
//        self.isLoading = true
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//            }
//
//            if let error = error {
//                DispatchQueue.main.async {
//                    self?.errorMessage = "❌ API Request Failed: \(error.localizedDescription)"
//                    print(self?.errorMessage ?? "Unknown Error")
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self?.errorMessage = "❌ No Data Received"
//                    print(self?.errorMessage ?? "Unknown Error")
//                }
//                return
//            }
//
//            // DEBUG: Print Raw Response
//            print("✅ Raw Response: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
//
//            // Decode JSON response
//            do {
//                let predictionResponse = try JSONDecoder().decode(FlowerPredictionResponse.self, from: data)
//
//                // Update UI with predicted flower image
//                DispatchQueue.main.async {
//                    self?.flowerTypeImage = self?.getImageForFlowerType(prediction: predictionResponse.prediction) ?? ""
//                    print("🌸 Predicted Flower Type Image: \(self?.flowerTypeImage ?? "Unknown")")
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self?.errorMessage = "❌ Decoding Error: \(error.localizedDescription)"
//                    print(self?.errorMessage ?? "Unknown Error")
//                }
//            }
//        }.resume()
//    }
//
//    // Function to map prediction to image
//    private func getImageForFlowerType(prediction: Int) -> String {
//        switch prediction {
//        case 0: return "setosaImage"      // Replace with actual asset name
//        case 1: return "versicolorImage"  // Replace with actual asset name
//        case 2: return "virginicaImage"   // Replace with actual asset name
//        default: return ""
//        }
//    }
//}
//
//// Define the expected response structure
class FlowerPredictionViewModel: ObservableObject {
    @Published var flowerTypeImage: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var flowerPrediction: Int? = nil // Stores the predicted value
    
    func predictFlower(features: [Double]) {
        guard let url = URL(string: "http://127.0.0.1:5000/predict") else {
            print("❌ Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["features": features]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            print("❌ JSON Serialization Error: \(error)")
            return
        }

        self.isLoading = true
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "❌ API Request Failed: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "❌ No Data Received"
                }
                return
            }

            do {
                let predictionResponse = try JSONDecoder().decode(FlowerPredictionResponse.self, from: data)

                DispatchQueue.main.async {
                    self?.flowerPrediction = predictionResponse.prediction // Store prediction
                    self?.flowerTypeImage = self?.getImageForFlowerType(prediction: predictionResponse.prediction) ?? ""
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "❌ Decoding Error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    // Function to get image name
    private func getImageForFlowerType(prediction: Int) -> String {
        switch prediction {
        case 0: return "setosaImage"
        case 1: return "versicolorImage"
        case 2: return "virginicaImage"
        default: return ""
        }
    }

    // Function to get the flower name based on prediction
    func getFlowerName() -> String {
        switch flowerPrediction {
        case 0: return "Setosa"
        case 1: return "Versicolor"
        case 2: return "Virginica"
        default: return "Unknown"
        }
    }
}

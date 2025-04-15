//
//  PizzaService.swift
//  PizzaOrder
//
//  Created by pk on 2025-02-19.
//


import Foundation

class PizzaService {
    private let baseURL = "http://localhost:5198/pizza"
    
    // Fetch all pizzas
    func fetchPizzas(completion: @escaping ([Pizza]?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let pizzas = try? JSONDecoder().decode([Pizza].self, from: data)
                DispatchQueue.main.async {
                    completion(pizzas)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    // Add a new pizza
    func addPizza(name: String, description: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let pizza = ["name": name, "description": description]
        request.httpBody = try? JSONSerialization.data(withJSONObject: pizza)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
    
    // Update an existing pizza
    func updatePizza(id: Int, name: String, description: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let pizza = ["name": name, "description": description]
        request.httpBody = try? JSONSerialization.data(withJSONObject: pizza)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
    
    // Delete a pizza
    func deletePizza(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}

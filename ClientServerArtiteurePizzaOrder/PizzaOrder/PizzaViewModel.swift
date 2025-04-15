//
//  PizzaViewModel.swift
//  PizzaOrder
//
//  Created by pk on 2025-02-19.
//


import Foundation

class PizzaViewModel: ObservableObject {
    @Published var pizzas: [Pizza] = []
    
    private let service = PizzaService()
    
    func fetchPizzas() {
        service.fetchPizzas { [weak self] pizzas in
            if let pizzas = pizzas {
                self?.pizzas = pizzas
            }
        }
    }
    
    func addPizza(name: String, description: String) {
        service.addPizza(name: name, description: description) { success in
            if success {
                self.fetchPizzas()
            }
        }
    }
    
    func updatePizza(id: Int, name: String, description: String) {
        service.updatePizza(id: id, name: name, description: description) { success in
            if success {
                self.fetchPizzas()
            }
        }
    }
    
    func deletePizza(id: Int) {
        service.deletePizza(id: id) { success in
            if success {
                self.fetchPizzas()
            }
        }
    }
}

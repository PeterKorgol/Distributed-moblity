//
//  PizzaSelectionView.swift
//  PizzaOrder
//
//  Created by pk on 2025-02-20.
//


import SwiftUI

struct PizzaSelectionView: View {
    @StateObject private var viewModel = PizzaViewModel()
    
    let hardcodedPizzas = [
        Pizza(id: nil, name: "Margherita", description: "Classic pizza with tomato, mozzarella, and basil."),
        Pizza(id: nil, name: "Pepperoni", description: "Loaded with spicy pepperoni and cheese."),
        Pizza(id: nil, name: "BBQ Chicken", description: "Grilled chicken with tangy BBQ sauce and red onions.")
    ]
    
    @State private var showAlert = false
    @State private var selectedPizzaName = ""

    var body: some View {
        NavigationView {
            VStack {
                List(hardcodedPizzas, id: \.name) { pizza in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(pizza.name)
                                .font(.headline)
                            Text(pizza.description)
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.addPizza(name: pizza.name, description: pizza.description)
                            selectedPizzaName = pizza.name
                            showAlert = true
                        }) {
                            Text("Add to Bucket")
                                .padding(8)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Button to navigate to PizzaListView (Order Bucket)
                NavigationLink(destination: PizzaListView()) {
                    Text("View Order Bucket")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .navigationTitle("Select a Pizza")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Added to Bucket"),
                    message: Text("\(selectedPizzaName) has been added."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

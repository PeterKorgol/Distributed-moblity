//
//  EditPizzaView.swift
//  PizzaOrder
//
//  Created by pk on 2025-02-19.
//
import SwiftUI

struct EditPizzaView: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: PizzaViewModel
    var pizza: Pizza

    let predefinedPizzas = [
        Pizza(id: nil, name: "Margherita", description: "Classic pizza with tomato, mozzarella, and basil."),
        Pizza(id: nil, name: "Pepperoni", description: "Loaded with spicy pepperoni and cheese."),
        Pizza(id: nil, name: "BBQ Chicken", description: "Grilled chicken with tangy BBQ sauce and red onions.")
    ]

    @State private var showAlert = false
    @State private var selectedPizzaName = ""

    var body: some View {
        VStack {
            Text("Select a new pizza to replace:")
                .font(.headline)
                .padding()

            List(predefinedPizzas, id: \.name) { newPizza in
                Button(action: {
                    // Update the existing pizza with the selected predefined pizza
                    viewModel.updatePizza(id: pizza.id!, name: newPizza.name, description: newPizza.description)
                    selectedPizzaName = newPizza.name
                    showAlert = true
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(newPizza.name)
                                .font(.headline)
                            Text(newPizza.description)
                                .font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .padding(8)
                }
            }
        }
        .navigationTitle("Edit Pizza")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Pizza Updated"),
                message: Text("\(selectedPizzaName) has been set as your new pizza."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

//
//  AddPizzaView.swift
//  PizzaOrder
//
//  Created by pk on 2025-02-19.
//


import SwiftUI

struct AddPizzaView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var description = ""
    var viewModel: PizzaViewModel

    var body: some View {
        VStack {
            TextField("Pizza Name", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Description", text: $description)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save Pizza") {
                viewModel.addPizza(name: name, description: description)
                presentationMode.wrappedValue.dismiss() // Go back after adding pizza
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationTitle("Add New Pizza")
    }
}

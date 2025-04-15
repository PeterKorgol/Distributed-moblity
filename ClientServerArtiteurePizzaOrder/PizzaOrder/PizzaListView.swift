import SwiftUI

struct PizzaListView: View {
    @StateObject private var viewModel = PizzaViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.pizzas, id: \.id) { pizza in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(pizza.name).font(.headline)
                                Text(pizza.description).font(.subheadline)
                            }
                            Spacer()
                            // Edit Button - navigates to the EditPizzaView
                            NavigationLink(
                                destination: EditPizzaView(viewModel: viewModel, pizza: pizza)
                            ) {
                                Text("Edit")
                                    .foregroundColor(.blue)
                            }
                        }
                        .swipeActions {
                            // Delete button added for swipe action
                            Button(action: {
                                viewModel.deletePizza(id: pizza.id!)
                            }) {
                                Text("Delete")
                            }
                            .tint(.red)
                        }
                    }
                    .onDelete(perform: delete)
                }
                
             
            }
            .navigationTitle("Pizza Menu")
            .onAppear {
                viewModel.fetchPizzas()
            }
        }
    }

    // Delete function for swipe-to-delete gesture
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let pizza = viewModel.pizzas[index]
            viewModel.deletePizza(id: pizza.id!)
        }
    }
}

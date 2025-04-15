import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var showingCreateTask = false
    @State private var searchQuery = ""
    
    var filteredTasks: [Task] {
        if searchQuery.isEmpty {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: TaskDetailView(taskId: task.id)) {
                            VStack(alignment: .leading) {
                                Text(task.title).font(.headline)
                                Text(task.description ?? "No description").font(.subheadline)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteTask(id: task.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("Tasks")
                
                Spacer()
                
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                    TextField("Search by title", text: $searchQuery)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom)
            }
            .onAppear {
                viewModel.fetchTasks()
            }
            .toolbar {
                NavigationLink(destination: CreateTaskView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

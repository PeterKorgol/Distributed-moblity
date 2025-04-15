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
                        TaskRow(task: task)
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
                
                SearchBar(searchQuery: $searchQuery)
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

struct TaskRow: View {
    var task: Task
    
    var body: some View {
        NavigationLink(destination: TaskDetailView(taskId: task.id)) {
            VStack(alignment: .leading) {
                Text(task.title).font(.headline)
                Text(task.description).font(.subheadline)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var searchQuery: String
    
    var body: some View {
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
    }
}

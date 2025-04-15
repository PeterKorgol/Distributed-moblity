import SwiftUI

struct TaskDetailView: View {
    @StateObject private var viewModel = TaskViewModel()
    var taskId: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let task = viewModel.task {
                Text(task.title)
                    .font(.largeTitle)
                    .bold()

                Text("Due Date: \(task.dueDate)")
                    .font(.subheadline)

                Text("Priority: \(task.priority)")
                    .font(.subheadline)

                Text("Status: \(task.status)")
                    .font(.subheadline)

                if let description = task.description {
                    Text("Description: \(description)")
                        .font(.body)
                } else {
                    Text("No description available.")
                        .font(.body)
                }

                Spacer()

                // Edit Button
                NavigationLink(destination: EditTaskView(viewModel: viewModel, task: task)) {
                    Text("Edit Task")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            } else {
                Text("Loading...")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        
        .onAppear {
            viewModel.fetchTaskById(id: taskId) 
        }
    }
}

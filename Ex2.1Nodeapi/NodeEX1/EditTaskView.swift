import SwiftUI

struct EditTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    var task: Task
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var priority: String
    @State private var status: String
    @Environment(\.dismiss) var dismiss
    
    let priorities = ["low", "medium", "high"]
    let statuses = ["pending", "completed"]
    
    init(viewModel: TaskViewModel, task: Task) {
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description ?? "")
        _dueDate = State(initialValue: ISO8601DateFormatter().date(from: task.dueDate) ?? Date())
        _priority = State(initialValue: task.priority)
        _status = State(initialValue: task.status)
        self.viewModel = viewModel
        self.task = task
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
                
                Section(header: Text("Settings")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { Text($0.capitalized) }
                    }
                    Picker("Status", selection: $status) {
                        ForEach(statuses, id: \.self) { Text($0.capitalized) }
                    }
                }
                
                Button("Save Changes") {
                    let dateFormatter = ISO8601DateFormatter()
                    let formattedDate = dateFormatter.string(from: dueDate)
                    viewModel.updateTask(id: task.id, title: title, description: description, dueDate: formattedDate, priority: priority, status: status)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

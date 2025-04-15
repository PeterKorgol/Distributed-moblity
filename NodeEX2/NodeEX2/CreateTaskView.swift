//
//  CreateTaskView.swift
//  NodeEX2
//
//  Created by pk on 2025-03-13.
//


//
//  CreateTaskView.swift
//  NodeEX1
//
//  Created by pk on 2025-03-06.
//

import SwiftUI

struct CreateTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority = "medium"
    @State private var status = "pending"
    
    let priorities = ["low", "medium", "high"]
    let statuses = ["pending", "completed"]
    
    var viewModel: TaskViewModel

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
                
                Button("Create Task") {
                    let dateFormatter = ISO8601DateFormatter()
                    let formattedDate = dateFormatter.string(from: dueDate)
                    
                   
                    let generatedId = Int.random(in: 1...1000000)

                    viewModel.createTask(id: generatedId, title: title, description: description, dueDate: formattedDate, priority: priority, status: status)
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

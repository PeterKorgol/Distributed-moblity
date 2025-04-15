import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var task: Task? = nil 
    let baseURL = "http://localhost:3000/tasks"
    let apiKey = "mysecretkey123"
    

    func fetchTasks() {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        self.tasks = try JSONDecoder().decode([Task].self, from: data)
                    } catch {
                        print("Error decoding tasks JSON: \(error)")
                    }
                }
            } else if let error = error {
                print("Error fetching tasks: \(error)")
            }
        }.resume()
    }
    
 
    func deleteTask(id: Int) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error deleting task: \(error)")
                } else {
                    self.tasks.removeAll { $0.id == id }
                }
            }
        }.resume()
    }


    func createTask(title: String, description: String?, dueDate: String, priority: String, status: String) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        let newTask: [String: Any] = [
            "title": title,
            "description": description ?? "",
            "dueDate": dueDate,
            "priority": priority,
            "status": status
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newTask, options: [])
        } catch {
            print("Error encoding new task: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let createdTask = try JSONDecoder().decode(Task.self, from: data)
                        self.tasks.append(createdTask)
                    } catch {
                        print("Error decoding created task: \(error)")
                    }
                }
            } else if let error = error {
                print("Error creating task: \(error)")
            }
        }.resume()
    }



    func fetchTaskById(id: Int) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let task = try JSONDecoder().decode(Task.self, from: data)
                        self.task = task // Assign the task to the 'task' property
                    } catch {
                        print("Error decoding task by ID: \(error)")
                    }
                }
            } else if let error = error {
                print("Error fetching task by ID: \(error)")
            }
        }.resume()
    }
    
    func updateTask(id: Int, title: String, description: String, dueDate: String, priority: String, status: String) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        let updatedTask = [
            "title": title,
            "description": description,
            "dueDate": dueDate,
            "priority": priority,
            "status": status
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: updatedTask, options: [])
        } catch {
            print("Error encoding updated task: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let updatedTask = try JSONDecoder().decode(Task.self, from: data)
                        if let index = self.tasks.firstIndex(where: { $0.id == id }) {
                            self.tasks[index] = updatedTask
                        }
                    } catch {
                        print("Error decoding updated task: \(error)")
                    }
                }
            } else if let error = error {
                print("Error updating task: \(error)")
            }
        }.resume()
    }
   
}

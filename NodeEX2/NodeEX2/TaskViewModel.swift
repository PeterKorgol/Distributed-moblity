//
//  TaskViewModel.swift
//  NodeEX2
//
//  Created by pk on 2025-03-13.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var task: Task? = nil
    let baseURL = "http://localhost:3000/tasks" 
    let apiKey = "mysecretkey123"
    
   
    func fetchTasks() {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error fetching tasks: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    self.tasks = try JSONDecoder().decode([Task].self, from: data)
                } catch {
                    print("❌ Failed to decode JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    

    func deleteTask(id: Int) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Error deleting task: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.tasks.removeAll { $0.id == id }
            }
        }.resume()
    }
    
    
    func createTask(id: Int, title: String, description: String, dueDate: String, priority: String, status: String) {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let newTask = Task(id: id, title: title, description: description, dueDate: dueDate, priority: priority, status: status)
        
        do {
            request.httpBody = try JSONEncoder().encode(newTask)
        } catch {
            print("❌ Failed to encode task: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error creating task: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }
            
           
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(TaskResponse.self, from: data)
                    self.tasks.append(response.task)
                } catch {
                    print("❌ Failed to decode response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    
    func updateTask(id: Int, title: String, description: String, dueDate: String, priority: String, status: String) {
        let updatedTask = Task(id: id, title: title, description: description, dueDate: dueDate, priority: priority, status: status)
        
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        do {
            request.httpBody = try JSONEncoder().encode(updatedTask)
        } catch {
            print("Error encoding task: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating task: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                if let index = self.tasks.firstIndex(where: { $0.id == id }) {
                    self.tasks[index] = updatedTask
                }
            }
        }.resume()
    }
    
    
    func fetchTaskById(id: Int) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }


            guard let data = data else {
                print("❌ No data received")
                return
            }



            do {
                let decodedTask = try JSONDecoder().decode(Task.self, from: data)
                DispatchQueue.main.async {
                    self.task = decodedTask
                }
            } catch {
                print("❌ JSON Decoding Error: \(error)")
            }
        }.resume()
    }

}

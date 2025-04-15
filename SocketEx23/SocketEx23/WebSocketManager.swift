//
//  WebSocketManager.swift
//  SocketEx23
//
//  Created by pk on 2025-03-27.
//
//import Foundation
//
//class WebSocketManager: ObservableObject {
//    static let shared = WebSocketManager()
//    
//    private var webSocketTask: URLSessionWebSocketTask?
//    @Published var question: String = "Loading question..."
//    @Published var options: [String] = []
//    @Published var timer: Int = 10
//    @Published var scores: [String: Int] = [:]
//    
//    private let serverURL = URL(string: "ws://localhost:3000")!
//
//    private init() {}
//    
//    func connect() {
//        webSocketTask = URLSession.shared.webSocketTask(with: serverURL)
//        webSocketTask?.resume()
//        listenForMessages()
//    }
//    
//    func sendMessage(_ message: [String: Any]) {
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
//            let jsonString = String(data: jsonData, encoding: .utf8)
//            webSocketTask?.send(.string(jsonString ?? "")) { error in
//                if let error = error {
//                    print("WebSocket send error: \(error)")
//                }
//            }
//        } catch {
//            print("Error encoding JSON: \(error)")
//        }
//    }
//    
//    private func listenForMessages() {
//        webSocketTask?.receive { [weak self] result in
//            switch result {
//            case .success(.string(let message)):
//                self?.handleMessage(message)
//            case .failure(let error):
//                print("WebSocket receive error: \(error)")
//            default:
//                break
//            }
//            self?.listenForMessages()
//        }
//    }
//    
//    private func handleMessage(_ message: String) {
//        guard let data = message.data(using: .utf8) else { return }
//        do {
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                DispatchQueue.main.async {
//                    if let event = json["event"] as? String {
//                        switch event {
//                        case "question":
//                            self.question = json["question"] as? String ?? "Unknown question"
//                            self.options = json["options"] as? [String] ?? []
//                        case "timer":
//                            self.timer = json["timeLeft"] as? Int ?? 10
//                        case "end":
//                            self.scores = json["scores"] as? [String: Int] ?? [:]
//                        default:
//                            break
//                        }
//                    }
//                }
//            }
//        } catch {
//            print("Error decoding JSON: \(error)")
//        }
//    }
//    
//    func close() {
//        webSocketTask?.cancel(with: .goingAway, reason: nil)
//    }
//}
import Foundation

class WebSocketManager: ObservableObject {
    static let shared = WebSocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var question: String = "Loading question..."
    @Published var options: [String] = []
    @Published var timer: Int = 10
    @Published var scores: [String: Int] = [:]
    private var username: String = ""

    private let serverURL = URL(string: "ws://localhost:3000")!

    private init() {}

    func connect() {
        webSocketTask = URLSession.shared.webSocketTask(with: serverURL)
        webSocketTask?.resume()
        listenForMessages()
    }

    func setUsername(_ name: String) {
        self.username = name
        sendMessage(["event": "setUsername", "username": name])
    }

    func sendMessage(_ message: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            webSocketTask?.send(.string(jsonString ?? "")) { error in
                if let error = error {
                    print("WebSocket send error: \(error)")
                }
            }
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }

    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(.string(let message)):
                self?.handleMessage(message)
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            default:
                break
            }
            self?.listenForMessages()
        }
    }

    private func handleMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                DispatchQueue.main.async {
                    if let event = json["event"] as? String {
                        switch event {
                        case "question":
                            self.question = json["question"] as? String ?? "Unknown question"
                            self.options = json["options"] as? [String] ?? []
                        case "timer":
                            self.timer = json["timeLeft"] as? Int ?? 10
                        case "end":
                            if let rawScores = json["scores"] as? [String: Int],
                               let playerUsernames = json["playerUsernames"] as? [String: String] {
                                // Convert socket IDs to usernames in the leaderboard
                                self.scores = rawScores.mapKeys { playerUsernames[$0] ?? "Unknown" }
                            }
                        default:
                            break
                        }
                    }
                }
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }

    func close() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}

// Extension to map keys in a dictionary
extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        var newDict: [T: Value] = [:]
        for (key, value) in self {
            newDict[transform(key)] = value
        }
        return newDict
    }
}

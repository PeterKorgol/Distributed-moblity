//
//  WebSocketManager.swift
//  SocketEx1
//
//  Created by pk on 2025-03-20.
//

import  Foundation
class WebSocketManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText: String = ""
    
    private var webSocketTask: URLSessionWebSocketTask?

    init() {
        connectToWebSocket()
    }

    func connectToWebSocket() {
        guard let url = URL(string: "ws://localhost:8080") else { return }
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        // Create a JSON object for the outgoing message
        let outgoingMessage = [
            "sender": "Swift Client",  // Identify the Swift client
            "message": messageText
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: outgoingMessage, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            webSocketTask?.send(.string(jsonString!)) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.messageText = "" // Clear input after sending
                    }
                }
            }
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        do {
                            let jsonData = text.data(using: .utf8)!
                            let receivedMessage = try JSONDecoder().decode(ChatMessage.self, from: jsonData)
                            self?.messages.append(receivedMessage)
                        } catch {
                            print("Error decoding JSON message: \(error)")
                        }
                    }
                    self?.receiveMessage() // Keep listening for new messages
                case .data(let data):
                    print("Received binary data: \(data)")
                @unknown default:
                    break
                }
            }
        }
    }

    func closeWebSocket() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        print("WebSocket connection closed")
    }
}

//
//  ViewController.swift
//  SocketEx1
//
//  Created by pk on 2025-03-20.
//


import UIKit

class ViewController: UIViewController {
// Define a URLSessionWebSocketTask instance to handle the WebSocket connection
var webSocketTask: URLSessionWebSocketTask?
// UI Elements
@IBOutlet weak var messagesTextView: UITextView!
@IBOutlet weak var messageTextField: UITextField!
override func viewDidLoad() {
super.viewDidLoad()
// Establish the WebSocket connection
connectToWebSocket()
}
func connectToWebSocket() {
// Replace with your WebSocket server URL
let url = URL(string: "ws://localhost:8080")!
// Create a URLSession configuration
let session = URLSession(configuration: .default)
// Initialize the WebSocket task
webSocketTask = session.webSocketTask(with: url)
// Start the WebSocket task
    webSocketTask?.resume()
    // Start receiving messages
    receiveMessage()
    }
    func sendMessage() {
    // Get the message text from the text field
    guard let message = messageTextField.text, !message.isEmpty else { return }
    // Create a WebSocket message to send
    let messageToSend = URLSessionWebSocketTask.Message.string(message)
    // Send the message
    webSocketTask?.send(messageToSend) { error in
    if let error = error {
    print("Error sending message: \(error)")
    } else {
    print("Message sent: \(message)")
    // Clear the message field after sending
    DispatchQueue.main.async {
    self.messageTextField.text = ""
    }
    }
    }
    }
    // Function to continuously receive messages
    func receiveMessage() {
    webSocketTask?.receive { [weak self] result in
    switch result {
    case .failure(let error):
    print("Error receiving message: \(error)")
    case .success(let message):
    switch message {
    case .string(let text):
    // Display the received message
    DispatchQueue.main.async {
    self?.messagesTextView.text.append("\(text)\n")
    }
    // Continue receiving next message
    self?.receiveMessage()
    case .data(let data):
    print("Received binary data: \(data)")
    @unknown default:
    break
    }
    }
    }
    }
    // Button action to send a message
    @IBAction func sendButtonTapped(_ sender: UIButton) {
    sendMessage()
    }
    // Button action to close WebSocket connection
    @IBAction func closeButtonTapped(_ sender: UIButton) {
    webSocketTask?.cancel(with: .normalClosure, reason: nil)
    print("WebSocket connection closed")
    }
    }

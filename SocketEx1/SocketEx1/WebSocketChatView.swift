//
//  WebSocketChatView.swift
//  SocketEx1
//
//  Created by pk on 2025-03-20.
//


import SwiftUI

struct WebSocketChatView: View {
    @StateObject private var webSocketManager = WebSocketManager()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(webSocketManager.messages) { message in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(message.sender) • \(formattedDate(message.timestamp))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(message.message)
                                    .padding()
                                    .background(message.sender == "Client 2" ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity, alignment: message.sender == "Client 2" ? .trailing : .leading)
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Enter message", text: $webSocketManager.messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Send") {
                    webSocketManager.sendMessage()
                }
                .padding()
            }
            .padding()
            
            Button("Close Connection") {
                webSocketManager.closeWebSocket()
            }
            .foregroundColor(.red)
            .padding()
        }
        .padding()
    }
    
    // Convert timestamp to a readable format
    private func formattedDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "h:mm a" // Example: "2:30 PM"
            return displayFormatter.string(from: date)
        }
        return isoDate // Fallback to raw string
    }
}

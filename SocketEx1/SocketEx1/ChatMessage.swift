//
//  ChatMessage.swift
//  SocketEx1
//
//  Created by pk on 2025-03-20.
//

import SwiftUI
struct ChatMessage: Codable, Identifiable {
    let id = UUID()  // Unique ID for SwiftUI list
    let sender: String
    let message: String
    let timestamp: String  // ISO 8601 format (e.g., "2025-03-20T14:30:00Z")
}

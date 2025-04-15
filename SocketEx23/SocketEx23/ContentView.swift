//
//  ContentView.swift
//  SocketEx23
//
//  Created by pk on 2025-03-26.
//
//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var webSocketManager = WebSocketManager.shared
//    @State private var username: String = ""
//    @State private var gameStarted = false
//    @State private var selectedOption: Int? = nil
//
//    var body: some View {
//        VStack(spacing: 20) {
//            if !gameStarted {
//                VStack {
//                    Text("Live Quiz Game")
//                        .font(.largeTitle)
//                        .bold()
//                    
//                    TextField("Enter your name", text: $username)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                    
//                    Button("Join Game") {
//                        if !username.isEmpty {
//                            webSocketManager.sendMessage(["event": "setUsername", "username": username])
//                            gameStarted = true
//                            webSocketManager.sendMessage(["event": "startGame"])
//                        }
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//                .padding()
//            } else {
//                VStack {
//                    Text(webSocketManager.question)
//                        .font(.title)
//                        .bold()
//                        .multilineTextAlignment(.center)
//                        .padding()
//                    
//                    VStack(spacing: 10) {
//                        ForEach(webSocketManager.options.indices, id: \.self) { index in
//                            Button(webSocketManager.options[index]) {
//                                selectedOption = index
//                                webSocketManager.sendMessage(["event": "answer", "answer": index])
//                            }
//                            .buttonStyle(.bordered)
//                            .padding(5)
//                        }
//                    }
//                    
//                    Text("Time: \(webSocketManager.timer)")
//                        .font(.headline)
//                        .padding(.top, 10)
//                    
//                    if !webSocketManager.scores.isEmpty {
//                        VStack {
//                            Text("Leaderboard")
//                                .font(.title2)
//                                .bold()
//                            ForEach(webSocketManager.scores.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
//                                Text("\(key): \(value)")
//                            }
//                        }
//                        .padding()
//                    }
//                }
//            }
//        }
//        .onAppear {
//            webSocketManager.connect()
//        }
//        .onDisappear {
//            webSocketManager.close()
//        }
//    }
//}
import SwiftUI

struct ContentView: View {
    @StateObject private var webSocketManager = WebSocketManager.shared
    @State private var username: String = ""
    @State private var gameStarted = false

    var body: some View {
        VStack(spacing: 20) {
            if !gameStarted {
                VStack {
                    Text("Live Quiz Game")
                        .font(.largeTitle)
                        .bold()
                    
                    TextField("Enter your name", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Join Game") {
                        if !username.isEmpty {
                            webSocketManager.setUsername(username)
                            gameStarted = true
                            webSocketManager.sendMessage(["event": "startGame"])
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                VStack {
                    Text(webSocketManager.question)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    VStack(spacing: 10) {
                        ForEach(webSocketManager.options.indices, id: \.self) { index in
                            Button(webSocketManager.options[index]) {
                                webSocketManager.sendMessage(["event": "answer", "answer": index])
                            }
                            .buttonStyle(.bordered)
                            .padding(5)
                        }
                    }
                    
                    Text("Time: \(webSocketManager.timer)")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    if !webSocketManager.scores.isEmpty {
                        VStack {
                            Text("Leaderboard")
                                .font(.title2)
                                .bold()
                            ForEach(webSocketManager.scores.sorted(by: { $0.value > $1.value }), id: \.key) { username, score in
                                Text("\(username): \(score)")
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            webSocketManager.connect()
        }
        .onDisappear {
            webSocketManager.close()
        }
    }
}

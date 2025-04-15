//
//  Task.swift
//  NodeEX1
//
//  Created by pk on 2025-03-06.
//


import SwiftUI

struct Task: Identifiable, Codable {
    var id: Int
     var title: String
     var description: String?
     var dueDate: String
     var priority: String
     var status: String
}

//
//  to.swift
//  Twitter_Sample2
//
//  Created by pk on 2025-01-30.
//


import SwiftUI

struct Tweet: Identifiable, Decodable {
    let id: Int
    let name: String
    let text: String
    let likes: Int
    let dislikes: Int
    let image: String
}

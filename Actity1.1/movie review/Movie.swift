//
//  Movie.swift
//  movie review
//
//  Created by pk on 2025-01-09.
//

import Foundation
struct Movie: Identifiable {
let id: UUID
let title: String
let genre: String
let releaseYear: Int
let posterImageName: String
let description: String
}

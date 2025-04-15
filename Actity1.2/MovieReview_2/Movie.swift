//
//  Movie.swift
//  MovieReview_2
//
//  Created by pk on 2025-01-14.
//

import Foundation
struct Movie: Identifiable, Codable {
let id: String
let title: String
let genre: String
let releaseYear: Int
let posterImageName: String
let description: String
}

//
//  JSONLoader.swift
//  MovieReview_2
//
//  Created by pk on 2025-01-14.
//


import Foundation
class JSONLoader {
static func loadMovies(from fileName: String) -> [Movie] {
guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
print("JSON file not found")
return []
}
do {
let data = try Data(contentsOf: url)
let movies = try JSONDecoder().decode([Movie].self, from: data)
return movies
} catch {
print("Failed to decode JSON: \(error)")
return []
}
}
}
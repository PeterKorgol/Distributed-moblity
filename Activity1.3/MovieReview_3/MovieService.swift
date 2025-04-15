//
//  MovieService.swift
//  MovieReview_3
//
//  Created by pk on 2025-01-14.
//


import Foundation
class MovieService {
static let shared = MovieService()
private let apiURL = "https://mocki.io/v1/77912aba-7268-4bcc-897d-e4e40e186c0c" 
func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
guard let url = URL(string: apiURL) else {
completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
return
}
URLSession.shared.dataTask(with: url) { data, response, error in
if let error = error {
completion(.failure(error))
return
}
guard let data = data else {
completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
return
}
do {
let movies = try JSONDecoder().decode([Movie].self, from: data)
completion(.success(movies))
} catch {
completion(.failure(error))
}
}.resume()
}
}

//
//  JokeViewModel.swift
//  Joke
//
//  Created by pk on 2025-01-16.
//


import Foundation
class JokeViewModel: ObservableObject {
    @Published var jokeText: String = "Loading..."
    @Published var errorMessage: String?
    @Published var selectedCategory: String = "Any" // Default category
    private let jokeService = JokeService()

    func fetchJoke() {
        jokeService.fetchRandomJoke(category: selectedCategory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let joke):
                    if joke.type == "single" {
                        self?.jokeText = joke.joke ?? "No joke available."
                    } else if joke.type == "twopart" {
                        self?.jokeText = "\(joke.setup ?? "No setup.") \n\n\(joke.delivery ?? "No punchline.")"
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch joke: \(error.localizedDescription)"
                }
            }
        }
    }
}

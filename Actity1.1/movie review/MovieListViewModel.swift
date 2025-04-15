//
//  MovieListViewModel.swift
//  movie review
//
//  Created by pk on 2025-01-09.
//


import Foundation
class MovieListViewModel: ObservableObject {
@Published var movies: [Movie] = []
init() {
fetchMovies()
}
private func fetchMovies() {
// Example movie data
movies = [
Movie(
id: UUID(),
title: "Inception",
genre: "Sci-Fi",
releaseYear: 2010,
posterImageName: "inception",
description: "A thief who steals corporate secrets through dream-sharing technology is given the inversetask of planting an idea into the mind of a CEO."
),
Movie(
id: UUID(),
title: "The Godfather",
genre: "Crime",
releaseYear: 1972,
posterImageName: "godfather",
description: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empireto his reluctant son."
),
Movie(
id: UUID(),
title: "Parasite",
genre: "Thriller",
releaseYear: 2019,
posterImageName: "parasite",
description: "Greed and class discrimination threaten the newly formed symbiotic relationship between thewealthy Park family and the destitute Kim clan."
),
Movie(
id: UUID(),
title: "The Dark Knight",
genre: "Action",
releaseYear: 2008,
posterImageName: "dark_knight",
description: "When the menace known as The Joker emerges from his mysterious past, he wreaks havocand chaos on the people of Gotham."
)
]
}
}

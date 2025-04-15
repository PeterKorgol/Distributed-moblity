//
//  MovieListViewModel.swift
//  MovieReview_2
//
//  Created by pk on 2025-01-14.
//


import Foundation
class MovieListViewModel: ObservableObject {
@Published var movies: [Movie] = []
   
    init() {
    fetchMovies()
    }
    private func fetchMovies() {
    movies = JSONLoader.loadMovies(from: "movies")
    }
    }

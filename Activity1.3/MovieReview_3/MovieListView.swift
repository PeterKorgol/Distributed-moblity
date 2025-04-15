//
//  MovieListView.swift
//  MovieReview_3
//
//  Created by pk on 2025-01-14.
//


import SwiftUI
struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    var body: some View {
        NavigationView {
            Group {
                if viewModel.movies.isEmpty {
                    ProgressView("Loading Movies...")
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieRowView(movie: movie)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchMovies()
            }
            .navigationTitle("Movies")
        }
    }
    
}

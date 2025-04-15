//
//  MovieListView.swift
//  MovieReview_2
//
//  Created by pk on 2025-01-14.
//


import SwiftUI
struct MovieListView: View {
@StateObject private var viewModel = MovieListViewModel()
var body: some View {
NavigationView {
List(viewModel.movies) { movie in
NavigationLink(destination: MovieDetailView(movie: movie)) {
    MovieRowView(movie: movie)
    }
    }
    .navigationTitle("Movies")
    }
    }
    }

//
//  MovieDetailView.swift
//  MovieReview_3
//
//  Created by pk on 2025-01-14.
//


import SwiftUI
struct MovieDetailView: View {
    let movie: Movie
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(movie.posterImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(movie.genre) - \(movie.releaseYear)")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Divider()
                    Text("Description")
                        .font(.headline)
                    Text(movie.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        
    }
}

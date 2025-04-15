//
//  MovieRowView.swift
//  MovieReview_2
//
//  Created by pk on 2025-01-14.
//


import SwiftUI
struct MovieRowView: View {
let movie: Movie
var body: some View {
HStack {
Image(movie.posterImageName)
.resizable()
.scaledToFit()
.frame(width: 60, height: 90)
.cornerRadius(8)
.shadow(radius: 4)
VStack(alignment: .leading, spacing: 5) {
Text(movie.title)
.font(.headline)
Text("\(movie.genre) - \(movie.releaseYear)")
.font(.subheadline)
.foregroundColor(.gray)
}
}
.padding(.vertical, 8)
}
}
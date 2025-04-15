//
//  TweetDetailView.swift
//  Twitter_sample
//
//  Created by pk on 2025-01-14.
//

import SwiftUI
struct TweetDetailView: View {
    let tweet: Tweet
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(tweet.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .cornerRadius(12)
                    .shadow(radius: 8)
                VStack(alignment: .leading, spacing: 8) {
                    Text(tweet.id)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(tweet.likes) - Likes")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("\(tweet.dislikes) - Dislikes")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Divider()
                    Text("Tweet")
                        .font(.headline)
                    Text(tweet.text)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(tweet.id)
        
    }
}

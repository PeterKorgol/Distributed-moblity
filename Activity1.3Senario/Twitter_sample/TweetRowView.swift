//
//  TweetRowView.swift
//  Twitter_sample
//
//  Created by pk on 2025-01-14.
//

import SwiftUI
struct TweetRowView: View {
    let tweet: Tweet
    var body: some View {
        HStack {
            Image(tweet.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 120)
                .cornerRadius(8)
                .shadow(radius: 4)
            VStack(alignment: .leading, spacing: 4) {
                Text(tweet.id)
                    .font(.headline)
                Text(tweet.text)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

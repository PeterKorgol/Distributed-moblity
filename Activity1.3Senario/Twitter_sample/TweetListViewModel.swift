//
//  TweetListViewModel.swift
//  Twitter_sample
//
//  Created by pk on 2025-01-14.
//

import Foundation

class TweetListViewModel: ObservableObject {
    @Published var tweets: [Tweet] = []
    
    func fetchTweets() {
        TweetService.shared.fetchTweets { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedTweets):
                    self?.tweets = fetchedTweets
                case .failure(let error):
                    print("Error fetching Tweets: \(error.localizedDescription)")
                }
            }
        }
    }
}

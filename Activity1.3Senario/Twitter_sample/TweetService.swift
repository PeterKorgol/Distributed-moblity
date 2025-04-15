//
//  TweetService.swift
//  Twitter_sample
//
//  Created by pk on 2025-01-14.
//

import Foundation
class TweetService {
    static let shared = TweetService()
    private let apiURL = "https://mocki.io/v1/8893401f-a22d-4623-860f-0f993e6d6069"
    func fetchTweets(completion: @escaping (Result<[Tweet], Error>) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            do {
                let tweets = try JSONDecoder().decode([Tweet].self, from: data)
                completion(.success(tweets))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

import SwiftUI

class TweetViewModel: ObservableObject {
    @Published var tweets: [Tweet] = []
    @Published var selectedTweet: Tweet? = nil // For search result

    // Function to fetch all tweets
    func fetchTweets() {
        guard let url = URL(string: "http://localhost:5271/tweets") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching tweets: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedTweets = try JSONDecoder().decode([Tweet].self, from: data)
                DispatchQueue.main.async {
                    self.tweets = decodedTweets
                }
            } catch {
                print("Error decoding tweets: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    // Function to fetch a tweet by its ID
    func fetchTweetById(id: Int, completion: @escaping (Tweet?) -> Void) {
        guard let url = URL(string: "http://localhost:5271/tweets/\(id)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching tweet: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let tweet = try JSONDecoder().decode(Tweet.self, from: data)
                DispatchQueue.main.async {
                    completion(tweet)
                }
            } catch {
                print("Error decoding tweet: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }

    // Function to fetch tweets by name
    func fetchTweetsByName(name: String) {
        guard let url = URL(string: "http://localhost:5271/tweets/name/\(name)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching tweets by name: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedTweets = try JSONDecoder().decode([Tweet].self, from: data)
                DispatchQueue.main.async {
                    self.tweets = decodedTweets
                }
            } catch {
                print("Error decoding tweets: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

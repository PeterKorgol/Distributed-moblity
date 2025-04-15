import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = TweetViewModel()
    @State private var searchId: String = "" // Tweet ID to search
    @State private var searchName: String = "" // Tweet name to search
    @State private var showSearchResults = false // Flag for showing search results
    @State private var selectedTweet: Tweet? = nil // Tweet found during search
    @State private var foundTweetsByName: [Tweet] = [] // Store tweets found by name
    
    var body: some View {
        VStack {
            // Search by ID
            HStack {
                TextField("Enter Tweet ID", text: $searchId)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button("Search by ID") {
                    if let tweetId = Int(searchId) {
                        viewModel.fetchTweetById(id: tweetId) { tweet in
                            if let tweet = tweet {
                                selectedTweet = tweet
                                showSearchResults = true
                            } else {
                                showSearchResults = false
                            }
                        }
                    }
                }
                .padding()
            }
            .padding()
            
            // Search by Name
//            HStack {
//                TextField("Enter Tweet Name", text: $searchName)
//                    .padding()
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                Button("Search by Name") {
//                    // URL encode the name
//                    if let encodedName = searchName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
//                        viewModel.fetchTweetsByName(name: encodedName)
//                        foundTweetsByName = viewModel.tweets
//                        showSearchResults = !foundTweetsByName.isEmpty
//                    }
//                }
//                .padding()
//            }
//            .padding()

            // Display search results if available
            if showSearchResults {
                if let tweet = selectedTweet {
                    NavigationLink(destination: TweetDetailView(tweet: tweet)) {
                        Text("Found Tweet by ID: \(tweet.name)")
                            .padding()
                    }
                } else {
                    ForEach(foundTweetsByName, id: \.id) { tweet in
                        NavigationLink(destination: TweetDetailView(tweet: tweet)) {
                            Text("Found Tweet by Name: \(tweet.name)")
                                .padding()
                        }
                    }
                }
            } else if !searchId.isEmpty || !searchName.isEmpty {
                Text("No tweets found.")
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Search Tweet")
    }
}

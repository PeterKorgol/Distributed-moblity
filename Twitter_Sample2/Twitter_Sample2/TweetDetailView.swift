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
                    Text("ID: \(tweet.id)").font(.largeTitle)
                        .fontWeight(.bold)
                    Text(tweet.name)
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
        .navigationTitle("Tweet Detail")
    }
}

struct TweetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TweetDetailView(tweet: Tweet(id: 1, name: "John Doe", text: "Sample Tweet", likes: 100, dislikes: 5, image: "person1"))
    }
}

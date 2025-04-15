using System;
using System.Collections.Generic;
using System.Linq;

namespace Tweets.DB
{
    public class TweetDB
    {
        private static readonly List<Tweet> _tweets = new List<Tweet>()
        {
            new Tweet { Id = 1, Name = "John Doe", Text = "Swift is amazing for iOS development!", Likes = 150, Dislikes = 10, Image = "person1" },
            new Tweet { Id = 2, Name = "Jane Smith", Text = "Learning about structs in Swift is fun and powerful.", Likes = 200, Dislikes = 5, Image = "person2" },
            new Tweet { Id = 3, Name = "Alex Jones", Text = "Foundation framework makes handling data easy in Swift.", Likes = 120, Dislikes = 8, Image = "person3" }
        };

        public static List<Tweet> GetTweets()
        {
            return _tweets;
        }

        public static Tweet? GetTweet(int id)
        {
            return _tweets.FirstOrDefault(tweet => tweet.Id == id);  // Using FirstOrDefault instead of SingleOrDefault
        }

        public static Tweet? GetTweetByName (string name){
            return _tweets.FirstOrDefault(tweet=> tweet.Name == name);
        }

        public static Tweet CreateTweet(Tweet tweet)
        {
            tweet.Id = _tweets.Count > 0 ? _tweets.Max(t => t.Id) + 1 : 1; // Assign unique ID
            _tweets.Add(tweet);
            return tweet;
        }

        public static Tweet? UpdateTweet(Tweet update)
        {
            var tweet = _tweets.FirstOrDefault(t => t.Id == update.Id);
            if (tweet.Id == update.Id)
        {
            tweet.Text = update.Text;
            tweet.Likes = update.Likes;
            tweet.Dislikes = update.Dislikes;
            tweet.Image = update.Image;
        }

            return tweet;
        }

        public static void RemoveTweet(int id)
        {
            var tweet = _tweets.FirstOrDefault(t => t.Id == id);
            if (tweet != null)
            {
                _tweets.Remove(tweet);
            }
        }
    }
}

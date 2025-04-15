namespace Tweets.DB
{
    public class Tweet  // Changed from 'record' to 'class'
    {
        public int Id { get; set; }  

        public string Name { get; set; } = string.Empty;  // Added default values to avoid null issues

        public string Text { get; set; } = string.Empty;  

        public int Likes { get; set; }  

        public int Dislikes { get; set; }  

        public string Image { get; set; } = string.Empty;  
    }
}

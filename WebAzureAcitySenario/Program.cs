using Tweets.DB;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Lab2 API", Description = "Making the Lab2", Version = "v1" });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Lab2 API V1");
    });
}


app.MapGet("/tweets/{id}", (int id) => TweetDB.GetTweet(id));
app.MapGet("/tweets", () => TweetDB.GetTweets());
app.MapPost("/tweets", (Tweet tweet) => TweetDB.CreateTweet(tweet));
app.MapPut("/tweets", (Tweet tweet) => TweetDB.UpdateTweet(tweet));

app.MapDelete("/tweets/{id}", (int id) => TweetDB.RemoveTweet(id));
app.MapGet("/tweets/name/{name}", (string name)=> TweetDB.GetTweetByName(name));
app.Run();

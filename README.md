# Instagram
An Instagram API written in swift that can be used freely in iOS, OS X and Linux client and server applications. 


## The Goal

My goal when creating this library was to enable developers to add this library to their Swift based project to connect to the Instagram API via simple calls.
With this library you don't have to worry about any of the networking or HTTP.

Setting up the API has never been easier:
```swift
let api = InstagramAPI(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
api.accessToken = "..."
```

And this API allows you to make simple calls and handle the asynchronous result in a closure like this:
```swift
let userId = ...
api.getUserRecentMedia(userId) { recentMedia in
    print(recentMedia)
}
```

## Contributing

Obviously this is still a work in progress. Please feel free to fork and PRs are more than welcome!
I haven't had a lot of time recently to make any significant progress on this but I think this would be useful for a lot of people.

## Direction

Since the open source release of Swift, there has been a lot of momentum on libraries that could be very useful. I'm considering dropping my `NSURLSession` based code in favor of the goergeous [Alamofire library](https://github.com/Alamofire/Alamofire).

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

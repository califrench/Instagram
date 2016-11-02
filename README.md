# Instagram
An Instagram API written in swift that can be used freely in iOS, macOS and Linux client and server applications. 


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

Swift being open source offers some great opportunities for cross-platform software and libraries. I haven't had a lot of time to dedicate to this API and much remains to be done.
The [Swift Server APIs Project](https://swift.org/server-apis/) is aiming to built a full suite of networking utilities that can run on both macOS and Linux and I hope [Alamofire](https://github.com/Alamofire/Alamofire) moves towards those APIs eventually to help with cross-platform support because it's one of the cleanest and simplest networking libraries I've seen out there.
It integrates nicely in Swift with the new advent of closures and looks a lot like [GCD](https://en.wikipedia.org/wiki/Grand_Central_Dispatch)'s facelift in Swift 3.
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

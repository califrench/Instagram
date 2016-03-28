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

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

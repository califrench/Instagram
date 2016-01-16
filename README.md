# Instagram
An Instagram API written in swift that can be used freely in iOS, OS X and Linux client and server applications. 


## The Goal

My goal when creating this library was to enable developers to add this library to their Swift based project to connect to the Instagram API via simple calls.
With this library you don't have to worry about any of the networking or HTTP and you can perform simple calls like the following:
```
let api = InstagramAPI(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
api.accessToken = "..."
let userId = ...
api.getUserRecentMedia(userId) { recentMedia in
    print(recentMedia)
}
```

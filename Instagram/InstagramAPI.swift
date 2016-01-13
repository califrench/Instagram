//
//  InstagramAPI.swift
//  Photo Tiles
//
//  Created by Scott Gauthreaux on 10/01/16.
//  Copyright © 2016 Scott Gauthreaux. All rights reserved.
//

import Foundation


public class InstagramAPI {
    let baseAPIURL = "https://api.instagram.com/v1"
    var clientId : String?
    var clientSecret : String?
    public var accessToken : String?
    
    // TODO: add support for parameters
    // TODO: finish all API methods
    // TODO: add getUserId(username: String) -> Int? method
    // TODO: add versions of the methods that take InstagramModels instead of an id 
    
    // MARK: Convenience methods
    public init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    
    public func performAPIRequest(var urlString: String, withParameters parameters: [String:AnyObject]? = nil, usingMethod method: String = "GET", completion: (AnyObject?) -> Void) {
        guard let accessTokenString = accessToken else {
            print("Attempted to call \"performAPIRequest\" before authentication")
            completion(nil)
            return
        }
        
        urlString += "?access_token=" + accessTokenString
        
        if parameters != nil {
            for (parameterKey, parameterValue) in parameters! {
                urlString += "&\(parameterKey)=\(parameterValue)"
            }
        }
        
        guard let url = NSURL(string: baseAPIURL + urlString) else {
            print("Invalid url string supplied\"\(urlString)\" when calling performAPIRequest")
            completion(nil)
            return
        }
        
        print(url)
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
    
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String:AnyObject]
                
                if responseObject!["meta"]!["code"] as! Int == 200 {
                    completion(responseObject!["data"]!)
                }

            } catch {
                print("An error occurred while trying to convert the json data to an object")
            }
        }
        task.resume()
        
        return
    }
    
    // MARK: User Endpoint
    public func getUser(completion: (InstagramUser?) -> Void) {
        getUser(nil, completion: completion)
    }
    
    public func getUser(userId: Int, completion: (InstagramUser?) -> Void) {
        getUser(userId, completion: completion)
    }
    
    func getUser(userId: Int?, completion: (InstagramUser?) -> Void) {
        let userIdParameter = userId != nil ? "\(userId!)" : "self"
        performAPIRequest("/users/"+userIdParameter) { responseData in
            guard let responseData = responseData, instagramUser = InstagramUser(data: responseData) else {
                completion(nil)
                return
            }
            
            completion(instagramUser)
        }
    }
    
    public func getUserRecentMedia(completion: ([InstagramMedia]?) -> Void) {
        getUserRecentMedia(nil, completion: completion)
    }
    
    public func getUserRecentMedia(userId: Int, completion: ([InstagramMedia]?) -> Void) {
        getUserRecentMedia(userId, completion: completion)
    }

    
    func getUserRecentMedia(userId: Int?, completion: ([InstagramMedia]?) -> Void) {
        let userIdParameter = userId != nil ? "\(userId!)" : "self"
        performAPIRequest("/users/\(userIdParameter)/media/recent") { responseData in
            guard let medias = responseData as? [AnyObject] else {
                completion(nil)
                return
            }
            
            var newMedias = [InstagramMedia]()
            
            for mediaData in medias {
                if let newMedia = InstagramMedia(data: mediaData) {
                    newMedias.append(newMedia)
                }
            }
            
            completion(newMedias)
        }
    }
    
    public func getUserLikedMedia(completion: ([InstagramMedia]?) -> Void) {
        performAPIRequest("/users/self/media/liked") { responseData in
            guard let medias = responseData as? [AnyObject] else {
                completion(nil)
                return
            }
            
            var newMedias = [InstagramMedia]()
            
            for mediaData in medias {
                if let newMedia = InstagramMedia(data: mediaData) {
                    newMedias.append(newMedia)
                }
            }
            
            completion(newMedias)

        }
    }
    
    public func searchUsers(query: String, completion: ([InstagramUser]?) -> Void) {
        
    }
    
    // MARK: Relationships Endpoint
    public func getUserFollows(completion: ([InstagramUser]?) -> Void) {
        
    }
    
    public func getUserFollowedBy(completion: ([InstagramUser]?) -> Void) {
        
    }
    
    public func getUserRequestedBy(completion: ([InstagramUser]?) -> Void) {
        
    }
    
    public func getUserRelationship(to userId:Int, completion:(InstagramRelationship?) -> Void) {
        
    }
    
    public func setUserRelationship(to userId:Int, relation: String, completion:(Bool) -> Void) {
        
    }
    
    // MARK: Media Endpoint
    public func getMedia(id id: Int, completion: (InstagramMedia?) -> Void) {
        
    }
    
    public func getMedia(shortcode shortcode: String, completion: (InstagramMedia?) -> Void) {
        
    }
    
    public func searchMedia(lat: Double, lng: Double, completion: ([InstagramMedia]?) -> Void) {
        
    }
    
    // MARK: Comments Endpoint
    public func getMediaComments(mediaId id: Int, completion: ([InstagramComment]?) -> Void) {
        
    }
    
    public func setMediaComment(mediaId id: Int, comment: String, completion: (InstagramComment?) -> Void) {
        
    }
    
    public func removeMediaComment(mediaId: Int, commentId: Int, completion: (Bool) -> Void) {
        
    }
    
    // MARK: Likes Endpoint
    public func getMediaLikes(mediaId id: Int, completion: ([InstagramLike]?) -> Void) {
        
    }
    
    public func setMediaLike(mediaId id: Int, completion: (InstagramLike?) -> Void) {
        
    }
    
    public func removeMediaLike(mediaId: Int, completion: (Bool) -> Void) {
        
    }
    
    // MARK: Tags Endpoint
    public func getTag(name: String, completion: (InstagramTag?) -> Void) {
        
    }
    
    public func getTagRecentMedia(tagName: String, completion: ([InstagramMedia]?) -> Void) {
        
    }
    
    public func searchTags(query: String, completion: ([InstagramMedia]?) -> Void) {
        
    }
    
    // MARK: locations Endpoint
    public func getLocation(locationId: Int, completion: (InstagramLocation?) -> Void) {
        
    }
    
    public func getLocationRecentMedia(locationId: Int, completion: ([InstagramMedia]?) -> Void) {
        
    }
    
    public func searchLocations(query: String, completion: ([InstagramMedia]?) -> Void) {
        
    }

    

}



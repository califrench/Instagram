//
//  InstagramAPI.swift
//  Photo Tiles
//
//  Created by Scott Gauthreaux on 10/01/16.
//  Copyright © 2016 Scott Gauthreaux. All rights reserved.
//

import Foundation

public enum HTTPMethod : String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
    case Delete = "DELETE"
}




public class InstagramAPI {
    let baseAPIURL = "https://api.instagram.com/v1"
    var clientId : String?
    var clientSecret : String?
    public var accessToken : String?
    
    // TODO: finish all API methods
    // TODO: add getUserId(username: String) -> Int? method
    // TODO: add versions of the methods that take InstagramModels instead of an id 
    // TODO: document methods
    
    // MARK: - Convenience methods
    
    public init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    
    public func performAPIRequest(var urlString: String, withParameters parameters: [String:AnyObject]? = nil, usingMethod method: HTTPMethod = .Get, completion: (AnyObject?) -> Void) {
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
        request.HTTPMethod = method.rawValue
    
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
    
    func objectsArray<T: InstagramModel>(withType: T.Type, fromData data: AnyObject?) -> [T]? {
        
        guard let datas = data as? [AnyObject] else {
            return nil
        }
        
        var newObjects = [T]()
        
        for objectData in datas {
            if let newObject = T(data: objectData) {
                newObjects.append(newObject)
            }
        }
        
        return newObjects
    }
    
    
    // MARK: - User Endpoint
   
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
    
    public func getUserRecentMedia(count: Int? = nil, minId: Int? = nil, maxId: Int? = nil, completion: ([InstagramMedia]?) -> Void) {
        getUserRecentMedia(nil, count: count, minId: minId, maxId: maxId, completion: completion)
    }
    
    public func getUserRecentMedia(userId: Int, count: Int? = nil, minId: Int? = nil, maxId: Int? = nil, completion: ([InstagramMedia]?) -> Void) {
        getUserRecentMedia(userId, count: count, minId: minId, maxId: maxId, completion: completion)
    }

    
    func getUserRecentMedia(userId: Int?, count: Int? = nil, minId: Int? = nil, maxId: Int? = nil, completion: ([InstagramMedia]?) -> Void) {
        let userIdParameter = userId != nil ? "\(userId!)" : "self"
        var parameters = [String:AnyObject]()
        if count != nil {
            parameters["count"] = count!
        }
        
        if minId != nil {
            parameters["min_id"] = minId!
        }
        
        if maxId != nil {
            parameters["max_id"] = maxId!
        }
        
        performAPIRequest("/users/\(userIdParameter)/media/recent", withParameters: parameters) {completion(self.objectsArray(InstagramMedia.self, fromData: $0))}
    }
    
    public func getUserLikedMedia(count: Int? = nil, maxLikeId: Int? = nil, completion: ([InstagramMedia]?) -> Void) {
        var parameters = [String:AnyObject]()
        
        if count != nil {
            parameters["count"] = count!
        }
        
        if maxLikeId != nil {
            parameters["max_like_id"] = maxLikeId!
        }
        
        performAPIRequest("/users/self/media/liked", withParameters: parameters) {completion(self.objectsArray(InstagramMedia.self, fromData: $0))}
    }
    
    public func searchUsers(query: String, count: Int? = nil, completion: ([InstagramUser]?) -> Void) {
        var parameters = [String:AnyObject]()
        
        if count != nil {
            parameters["count"] = count!
        }
        
        performAPIRequest("/users/search", withParameters: parameters) {completion(self.objectsArray(InstagramUser.self, fromData: $0))}
        
    }
    
    
    // MARK: Relationships Endpoint
    
    public func getUserFollows(completion: ([InstagramUser]?) -> Void) {
        performAPIRequest("/users/self/follows") {completion(self.objectsArray(InstagramUser.self, fromData: $0))}
    }
    
    public func getUserFollowedBy(completion: ([InstagramUser]?) -> Void) {
        performAPIRequest("/users/self/followed-by") {completion(self.objectsArray(InstagramUser.self, fromData: $0))}
    }
    
    public func getUserRequestedBy(completion: ([InstagramUser]?) -> Void) {
        performAPIRequest("/users/self/requested-by") {completion(self.objectsArray(InstagramUser.self, fromData: $0))}
    }
    
    public func getUserRelationship(to userId:Int, completion:(InstagramRelationship?) -> Void) {
        performAPIRequest("/users/\(userId)/relationship") { responseData in
            guard let responseData = responseData, relationship = InstagramRelationship(data: responseData) else {
                completion(nil)
                return
            }
            
            completion(relationship)
        }
    
    }
    
    public func setUserRelationship(to userId:Int, relation: String, completion:(InstagramRelationship?) -> Void) {
        performAPIRequest("/users/\(userId)/relationship", withParameters: ["action":relation], usingMethod: .Post) { responseData in
            guard let responseData = responseData, relationship = InstagramRelationship(data: responseData) else {
                completion(nil)
                return
            }
            
            completion(relationship)
        }
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
    
    
    // MARK: Locations Endpoint
    
    public func getLocation(locationId: Int, completion: (InstagramLocation?) -> Void) {
        
    }
    
    public func getLocationRecentMedia(locationId: Int, completion: ([InstagramMedia]?) -> Void) {
        
    }
    
    public func searchLocations(query: String, completion: ([InstagramMedia]?) -> Void) {
        
    }

}



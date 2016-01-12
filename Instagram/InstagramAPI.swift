//
//  InstagramAPI.swift
//  Photo Tiles
//
//  Created by Scott Gauthreaux on 10/01/16.
//  Copyright © 2016 Scott Gauthreaux. All rights reserved.
//

import Foundation
import UIKit


public class InstagramAPI {
    let baseAPIURL = "https://api.instagram.com/v1"
    let clientId = "bcbe2c3e2971438b99083178e8614801"
    let clientSecret = "2e12bfb2305047cfb0668c5551096815"
    
    // TODO: need to remove this before prod, the app will need to be able to generate one and store it persistently between uses
    var accessToken = Optional("404827908.bcbe2c3.0d2abe8f4b054e23b32ac60aa46cec89")
    
    // TODO: add support for parameters
    // TODO: finish all API methods
    // TODO: add getUserId(username: String) -> Int? method
    
    // MARK: Convenience methods
    public init() {}
    
    
    public func performAPIRequest(var urlString: String, withParameters parameters: [String:StringLiteralType]? = nil, usingMethod method: String = "GET", closure: (AnyObject?) -> Void) {
        guard let accessTokenString = accessToken else {
            print("Attempted to call \"performAPIRequest\" before authentication")
            closure(nil)
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
            closure(nil)
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
                    closure(responseObject!["data"]!)
                }

            } catch {
                print("An error occurred while trying to convert the json data to an object")
            }
        }
        task.resume()
        
        return
    }
    
    // MARK: User Endpoint
    
    public func getUser(userId: Int?, closure: (InstagramUser?) -> Void) {
        let userIdParameter = userId != nil ? "\(userId!)" : "self"
        performAPIRequest("/users/"+userIdParameter) { responseData in
            guard let responseData = responseData else {
                closure(nil)
                return
            }
            var instagramUser = InstagramUser(id: Int(responseData["id"] as! String)!)
            instagramUser.bio = responseData["bio"] as! String
            instagramUser.fullName = responseData["full_name"] as! String
            instagramUser.profilePicture = responseData["profile_picture"] as! String
            instagramUser.username = responseData["username"] as! String
            instagramUser.website = responseData["website"] as? String
            
            closure(instagramUser)
        }
    }
    
    public func getUserRecentMedia(userId: Int?, closure: ([InstagramMedia]?) -> Void) {
        let userIdParameter = userId != nil ? "\(userId!)" : "self"
        performAPIRequest("/users/\(userIdParameter)/media/recent") { responseData in
            guard let medias = responseData else {
                closure(nil)
                return
            }
            
            var newMedias = [InstagramMedia]()
            
            for media in medias as! [[String:AnyObject]] {
                var newMedia = InstagramMedia(id: media["id"] as! String, type:InstagramMediaType(rawValue: media["type"] as! String)!)
                newMedia.link = media["link"] as! String
                if let images = media["images"], let standardResolution = images["standard_resolution"], let url = standardResolution!["url"] {
                    newMedia.standardResolutionURL = url as! String
                }
                
                newMedias.append(newMedia)
            }
            
            closure(newMedias)
        }
    }
    
    public func getUserLikedMedia(closure: ([InstagramMedia]?) -> Void) {
        performAPIRequest("/users/self/media/liked") { responseData in
            
        }
    }
    
    public func searchUser(query: String, closure: ([InstagramUser]?) -> Void) {
        
    }
    
    // MARK: Relationships Endpoint
    public func getUserFollows(closure: ([InstagramUser]?) -> Void) {
        
    }
    
    public func getUserFollowers(closure: ([InstagramUser]?) -> Void) {
        
    }
    
    public func getUserFollowerRequests(closure: ([InstagramUser]?) -> Void) {
        
    }
    
    public func getUserRelationship(to userId:Int, closure:(InstagramRelationship?) -> Void) {
        
    }
    
    public func setUserRelationship(to userId:Int, relation: String, closure:(Bool) -> Void) {
        
    }
    
    // MARK: Media Endpoint
    public func getMedia(id id: Int, closure: (InstagramMedia?) -> Void) {
        
    }
    
    public func getMedia(shortcode shortcode: String, closure: (InstagramMedia?) -> Void) {
        
    }
    
    public func searchMedia(lat: Double, lng: Double, closure: ([InstagramMedia]?) -> Void) {
        
    }
    
    public func getImage(image: InstagramMedia, closure: (UIImage?) -> Void) {
        print("Getting image \(image)")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            print(NSURL(string: image.standardResolutionURL))
            if let url = NSURL(string: image.standardResolutionURL), let data = NSData(contentsOfURL: url), let image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Got image")
                    closure(image)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Failed to get image")
                    closure(nil)
                }
            }
        }

    }
    

    
}



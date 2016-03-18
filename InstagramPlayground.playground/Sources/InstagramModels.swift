//
//  InstagramModels.swift
//  Instagram
//
//  Created by Scott Gauthreaux on 12/01/16.
//  Copyright © 2016 Scott Gauthreaux. All rights reserved.
//

// TODO: Try to minimize the occurrences of AnyObject
// TODO: Document methods

import Foundation

/// The protocol defining what all Instagram models are supposed to be initialized
public protocol InstagramModel {
    var id : String { get }
    init(id: String)
    init?(data: AnyObject)
}


/// Defines the possible media types (currently image and video)
public enum InstagramMediaType : String {
    case Image = "image"
    case Video = "video"
}


/// Represents an Instagram user
public struct InstagramUser: InstagramModel {
    public var id : String
    var bio = ""
    var fullName = ""
    var profilePicture = ""
    var username = ""
    var website : String?
    
    public init(id: String) {
        self.id = id
    }

    public
    init?(data: AnyObject) {
        print(data)
        guard let id  =   data["id"] as? String,
            bio             =   data["bio"] as? String,
            fullName        =   data["full_name"] as? String,
            profilePicture  =   data["profile_picture"] as? String,
            username        =   data["username"] as? String
            else { return nil }
        
        self.id = id
        self.bio = bio
        
        self.fullName = fullName
        self.profilePicture = profilePicture
        self.username = username
        self.website = data["website"] as? String
    }
}

/// Represents a relationship between two Instagram Users
public struct InstagramRelationship: InstagramModel {
    public var id : String
    var outgoingStatus = ""
    var incomingStatus = ""
    
    public init(id: String) {
        self.id = id
    }
    
    public init?(data: AnyObject) {
        guard let id  =   data["id"] as? String,
            outgoingStatus = data["outgoing_status"] as? String,
            incomingStatus = data["incoming_status"] as? String
            else { return nil}
        
        self.id = id
        self.outgoingStatus = outgoingStatus
        self.incomingStatus = incomingStatus
    }
}

/// Represents an instagram media object that can either be an image or a video
public struct InstagramMedia: InstagramModel {
    public var id : String
    var comments : [InstagramComment] = []
    var caption : InstagramCaption?
    var link = ""
    var standardResolutionURL = ""
    var location : InstagramLocation?
    var tags : [InstagramTag] = []
    var type : InstagramMediaType
    var user : InstagramUser?
    
    public init(id: String) {
        self.id = id
        self.type = .Image
    }
    
    init(id: String, type: InstagramMediaType) {
        self.id = id
        self.type = type
    }
    
    public init?(data: AnyObject) {
        guard let id = data["id"] as? String,
        typeString = data["type"] as? String,
        type = InstagramMediaType(rawValue: typeString),
            link = data["link"] as? String else {
                return nil
        }

        self.id = id
        self.type = type
        self.link = link
        
        if let images = data["images"], standardResolution = images!["standard_resolution"], url = standardResolution!["url"] {
            self.standardResolutionURL = url as! String
        }

    }
    
    /// Gets the image data for the current InstagramImage object
    public func getImageData(closure: (NSData?) -> Void) {
        print("Getting image \(self)")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            print(NSURL(string: self.standardResolutionURL))
            if let url = NSURL(string: self.standardResolutionURL), let data = NSData(contentsOfURL: url) {
                dispatch_async(dispatch_get_main_queue()) {
                    print("Got image")
                    closure(data)
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

/// Represents a caption on an InstagramMedia object
public struct InstagramCaption: InstagramModel {
    public var id: String
    var from : InstagramUser?
    var text = ""
    
    public init(id: String) {
        self.id = id
    }
  
    public init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

/// Represents a comment made by a user on a given media object
public struct InstagramComment: InstagramModel {
    public var id: String
    var from : InstagramUser?
    var createdTime = ""
    var text = ""
    
    public init(id: String) {
        self.id = id
    }
    
    public init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

/// Represents a like on a media object
public struct InstagramLike: InstagramModel {
    public var id: String
    
    public init(id: String) {
        self.id = id
    }
    
    public init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

/// A tag on a media object, can be used to search for other media with the same tag
public struct InstagramTag: InstagramModel {
    public var id: String
    public var name: String = ""
    
    public init(id: String) {
        self.id = id
    }
    
    public init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

/// A simple struct representing a location in the Instagram graph
public struct InstagramLocation: InstagramModel {
    public var id: String
    
    public init(id: String) {
        self.id = id
    }
    
    public init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}
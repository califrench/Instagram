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

protocol InstagramModel {
    var id : String { get }
    init(id: String)
    init?(data: AnyObject)
}

public enum InstagramMediaType : String {
    case Image = "image"
    case Video = "video"
}

public struct InstagramUser: InstagramModel {
    var id : String
    var bio = ""
    var fullName = ""
    var profilePicture = ""
    var username = ""
    var website : String?
    
    init(id: String) {
        self.id = id
    }
    
    init?(data: AnyObject) {
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

public struct InstagramRelationship: InstagramModel {
    var id : String
    var outgoingStatus = ""
    var incomingStatus = ""
    
    init(id: String) {
        self.id = id
    }
    
    init?(data: AnyObject) {
        guard let id  =   data["id"] as? String,
            outgoingStatus = data["outgoing_status"] as? String,
            incomingStatus = data["incoming_status"] as? String
            else { return nil}
        
        self.id = id
        self.outgoingStatus = outgoingStatus
        self.incomingStatus = incomingStatus
    }
}

public struct InstagramMedia: InstagramModel {
    var id : String
    var comments : [InstagramComment] = []
    var caption : InstagramCaption?
    var link = ""
    var standardResolutionURL = ""
    var location : InstagramLocation?
    var tags : [InstagramTag] = []
    var type : InstagramMediaType
    var user : InstagramUser?
    
    init(id: String) {
        self.id = id
        self.type = .Image
    }
    
    init(id: String, type: InstagramMediaType) {
        self.id = id
        self.type = type
    }
    
    init?(data: AnyObject) {
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

public struct InstagramCaption: InstagramModel {
    var id: String
    var from : InstagramUser?
    var text = ""
    
    init(id: String) {
        self.id = id
    }
    
    init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

public struct InstagramComment: InstagramModel {
    var id: String
    var from : InstagramUser?
    var createdTime = ""
    var text = ""
    
    init(id: String) {
        self.id = id
    }
    
    init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

public struct InstagramLike: InstagramModel {
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

public struct InstagramTag: InstagramModel {
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}

public struct InstagramLocation: InstagramModel {
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    init?(data: AnyObject) {
        guard let id  =   data["id"] as? String
            else { return nil}
        
        self.id = id
    }
}
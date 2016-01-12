//
//  InstagramModels.swift
//  Instagram
//
//  Created by Scott Gauthreaux on 12/01/16.
//  Copyright © 2016 Scott Gauthreaux. All rights reserved.
//

import Foundation

public enum InstagramMediaType : String {
    case Image = "image"
    case Video = "video"
}

public struct InstagramUser {
    var id : Int
    var bio = ""
    var fullName = ""
    var profilePicture = ""
    var username = ""
    var website : String?
    
    init(id: Int) {
        self.id = id
    }
}

public struct InstagramRelationship {
    
}

public struct InstagramMedia {
    var id : String
    var comments : [InstagramComment] = []
    var caption : InstagramCaption?
    var link = ""
    var standardResolutionURL = ""
    var location : InstagramLocation?
    var tags : [InstagramTag] = []
    var type : InstagramMediaType
    var user : InstagramUser?
    
    init(id: String, type: InstagramMediaType) {
        self.id = id
        self.type = type
    }
}

public struct InstagramCaption {
    var id : Int
    var from : InstagramUser?
    var text = ""
    
    init(id: Int) {
        self.id = id
    }
}

public struct InstagramComment {
    var id : Int
    var from : InstagramUser?
    var createdTime = ""
    var text = ""
    
    init(id: Int) {
        self.id = id
    }
}

public struct InstagramLike {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}

public struct InstagramTag {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}

public struct InstagramLocation {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}
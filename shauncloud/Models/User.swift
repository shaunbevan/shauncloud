//
//  User.swift
//  shauncloud
//
//  Created by Shaun on 7/15/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit
import SwiftyJSON

class User {
    
    static let currentUser = User()
    
    let networking = Networking()
    
    var username: String?
    var avatarURL: String?
    var friends: String?
    var trackCount: Int?
    
    func updateUser(completionHandler: (success: Bool) -> ()){
        networking.getUser() { responseObject, error in
            if let json = responseObject {
                User.currentUser.username = json["username"].stringValue
                User.currentUser.trackCount = json["track_count"].intValue
                User.currentUser.friends = json["followers_count"].stringValue
                User.currentUser.avatarURL = json["avatar_url"].stringValue
            }
            completionHandler(success: true)
        }
    }
    
  
    
}
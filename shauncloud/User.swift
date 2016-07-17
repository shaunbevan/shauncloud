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
    let username: String
    let fullName: String
    let description: String
    let playlistCount: String
    let trackCount: String
    
    init(username: String, fullName: String, description: String, playlistCount: String, trackCount: String){
        self.username = username
        self.fullName = fullName
        self.description = description
        self.playlistCount = playlistCount
        self.trackCount = trackCount
    }
    
    class func getUser(json:JSON) -> User? {
        if let
            username = json["username"].string,
            fullName = json["full_name"].string,
            description = json["description"].string,
            playlistCount = json["playlist_count"].string,
            trackCount = json["track_count"].string {
            return User(username: username, fullName: fullName, description: description, playlistCount: playlistCount, trackCount: trackCount)
        } else {
            print("Bad JSON \(json)")
            return nil
        }
    }

}
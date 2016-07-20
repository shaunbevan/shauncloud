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
    
    var username: String?
    var fullName: String?
    var avatarURL: String?
    var description: String?
    var friends: String?
    var playlistCount: Int?
    var trackCount: Int?
    
}
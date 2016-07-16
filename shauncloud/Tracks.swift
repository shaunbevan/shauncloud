//
//  Tracks.swift
//  shauncloud
//
//  Created by Shaun on 7/15/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class Tracks {
    var id: String?
    var username: String?
    var fullName: String?
    var description: String?
    var trackCount: String?
    var playlistCount: String?
    
    required init(json: JSON){
        self.id = json["id"].string
        self.username = json["username"].string
        self.fullName = json["full_name"].string
        self.description = json["description"].string
        self.trackCount = json["track_count"].string
        self.playlistCount = json["playlist_count"].string
    }
}
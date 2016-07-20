//
//  Playlists.swift
//  shauncloud
//
//  Created by Shaun on 7/17/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit
import SwiftyJSON

class Playlists {
    
    static let userPlaylists = Playlists()
    
    // Contains a dictionary of all playlists and their tracks
    var playlists: [String: [String]] = [:]
    
    
    var playlistTitles = [String]()
    var playlistArtURL = [String]()
    var playlistTrackCount = [Int]()
    var playlistIDs = [String]()
    
}
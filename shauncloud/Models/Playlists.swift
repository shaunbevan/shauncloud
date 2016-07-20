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
    
    let networking = Networking()
        
    var playlistTitles = [String]()
    var playlistArtURL = [String]()
    var playlistTrackCount = [Int]()
    var playlistIDs = [String]()
    
    
    func updatePlaylist(completionHandler: (success: Bool) -> ()){
        
        networking.getPlaylist() { responseObject, error in
            var newPlaylist = [String]()
            var newArtURL = [String]()
            var newIDs = [String]()
            var newTrackCount = [Int]()
            
            if let json = responseObject {
                
                for index in 0..<json.count {
                    let artURL = json[index]["artwork_url"].stringValue
                    let title = json[index]["title"].stringValue
                    let id = json[index]["id"].stringValue
                    let count = json[index]["tracks"].count
                    
                    
                    newIDs.append(id)
                    newPlaylist.append(title)
                    newArtURL.append(artURL)
                    newTrackCount.append(count)
                }
                
                    Playlists.userPlaylists.playlistIDs = newIDs
                    Playlists.userPlaylists.playlistArtURL = newArtURL
                    Playlists.userPlaylists.playlistTitles = newPlaylist
                    Playlists.userPlaylists.playlistTrackCount = newTrackCount
            }
            completionHandler(success: true)
        }
    }
}
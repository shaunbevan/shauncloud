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
    
    
    func updatePlaylist(){
        
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
                
                if newIDs != Playlists.userPlaylists.playlistIDs {
                    Playlists.userPlaylists.playlistIDs = newIDs
                }
                if newArtURL != Playlists.userPlaylists.playlistArtURL {
                    Playlists.userPlaylists.playlistArtURL = newArtURL
                }
                
                if newPlaylist != Playlists.userPlaylists.playlistTitles {
                    Playlists.userPlaylists.playlistTitles = newPlaylist
                }
                
                if newTrackCount != Playlists.userPlaylists.playlistTrackCount {
                    Playlists.userPlaylists.playlistTrackCount = newTrackCount
                }
            }
        }
    }
}
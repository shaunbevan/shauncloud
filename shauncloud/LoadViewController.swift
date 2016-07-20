//
//  LoadViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/18/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyJSON
class LoadViewController: UIViewController {
    
    let networking = Networking()
    
    private let keychain = Keychain(service: "com.shaunbevan.shauncloud")
    private let keychainKey = "shauncloud"
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customFont = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: customFont!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
        
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)

        
//        let playlist: Array = ["1", "2", "3", "4", "5"]
//        let tracks: Array = [["123", "456"], ["789", "012"], ["345", "678"], ["901", "234"], ["567", "890"]]
//
//        
//        for (index, element) in playlist.enumerate()
//        {
//            Playlists.userPlaylists.playlists[element] = tracks[index]
//        }
//        
//        print(Playlists.userPlaylists.playlists)
        
        //print("Playlist 1: \(Playlists.userPlaylists.playlists["1"])")
        

        // Playlist Playlists.userPlaylists.playlists[playlistID]
        // Track: Playlists.userPlaylists.playlists[playlistID, index]
        
        /*
         json = ["playlist": [
        
         
 
 
        */
    }
    
    
    var playlistArray = [String]()
    var trackArray = [[String]]()
    var buildTrackArray = [String]()


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let token = keychain[keychainKey]

        if token == nil {
            self.loadingLabel.hidden = true
            self.signInButton.hidden = false
        } else {
            self.loadingLabel.hidden = false
            self.signInButton.hidden = true
            // Initial load of user data
            networking.getUser() { responseObject, error in
                if let json = responseObject {
                    User.currentUser.username = json["username"].string
                    User.currentUser.playlistCount = json["playlist_count"].intValue
                    User.currentUser.trackCount = json["track_count"].intValue
                    User.currentUser.friends = json["followers_count"].stringValue
                    User.currentUser.avatarURL = json["avatar_url"].stringValue
                    
                }
            }
            

            // Initial load of playlist data
            networking.getPlaylist() { responseObject, error in
                if let json = responseObject {
                    
                    // For each playlist there are a number of tracks
                    // For each track, there is an id
                    // I need take each id for each track and put them in a single array for a single playlist
                    // I need to combine all those arrays into one big array of tracks

                    for index in 0..<json.count {
                        
                        let artURL = json[index]["artwork_url"].stringValue
                        let title = json[index]["title"].stringValue
                        let tracks = json[index]["tracks"].count
                        let playlistID = json[index]["id"].stringValue
                        
                        // This will loop the amount of tracks in a playlist
                        for i in 0..<tracks {
                            // This will assign the trackID of each track in a playlist
                            let trackID = json[index]["tracks", i]["id"].stringValue
                            // Add track to single array
                            self.buildTrackArray.insert(trackID, atIndex: i)
                            
                        }
                        
                        // Add tempArray holding a single playlist's track to a bigger array
                        
                        self.trackArray.append(self.buildTrackArray)
                        self.buildTrackArray.removeAll(keepCapacity: false)
                        self.playlistArray.append(playlistID)
                        

                        Playlists.userPlaylists.playlistIDs.append(playlistID)
                        Playlists.userPlaylists.playlistArtURL.append(artURL)
                        Playlists.userPlaylists.playlistTitles.append(title)
                        Playlists.userPlaylists.playlistTrackCount.append(tracks)
                    }
                    
 
                }
                
                for (index, element) in self.playlistArray.enumerate()
                {
                    Playlists.userPlaylists.playlists[element] = self.trackArray[index]
                }
                

                self.performSegueWithIdentifier("showPlaylist", sender: self)
                
            }

        }


    }

    @IBAction func logInButtonPressed(sender: AnyObject) {
        networking.requestAuthenication()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

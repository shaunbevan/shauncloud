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

    private var playlistArray = [String]()
    private var trackArray = [[String]]()
    private var buildTrackArray = [String]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logInButtonPressed(sender: AnyObject) {
        networking.requestAuthenication(self)
    }

    // MARK: Helpers
    
    private func setup() {
        // Setup nav and tab bar font
        let customFont = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: customFont!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
        
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    }
    
    private func loadData() {
        // Load keychain from KeychainAccess
        let token = keychain[keychainKey]
        
        // If there isn't a token, reveal Sign In button
        if token == nil {
            self.loadingLabel.hidden = true
            self.signInButton.hidden = false
        } else {
            self.loadingLabel.hidden = false
            self.signInButton.hidden = true
            // Initial load of user data
            networking.getUser() { responseObject, error in
                if let json = responseObject {
                    User.currentUser.username = json["username"].stringValue
                    User.currentUser.trackCount = json["track_count"].intValue
                    User.currentUser.friends = json["followers_count"].stringValue
                    User.currentUser.avatarURL = json["avatar_url"].stringValue
                }
            }
            
            // Initial load of playlist data
            networking.getPlaylist() { responseObject, error in
                if let json = responseObject {
                    for index in 0..<json.count {
                        let artURL = json[index]["artwork_url"].stringValue
                        let title = json[index]["title"].stringValue
                        let tracks = json[index]["tracks"].count
                        let playlistID = json[index]["id"].stringValue
                        
                        Playlists.userPlaylists.playlistIDs.append(playlistID)
                        Playlists.userPlaylists.playlistArtURL.append(artURL)
                        Playlists.userPlaylists.playlistTitles.append(title)
                        Playlists.userPlaylists.playlistTrackCount.append(tracks)
                    }
                }
                self.performSegueWithIdentifier("showPlaylist", sender: self)
            }
        }
    }
}

//
//  LoadViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/18/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit
import KeychainAccess

class LoadViewController: UIViewController {
    
    let networking = Networking()
    
    private let keychain = Keychain(service: "com.shaunbevan.shauncloud")
    private let keychainKey = "shauncloud"
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Keychain: \(keychain[keychainKey])")

    }
    
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
                }
            }
            
            
            // Initial load of playlist data
            networking.getPlaylist() { responseObject, error in
                if let json = responseObject {
                    for index in 0..<json.count {
                        
                        let artURL = json[index]["artwork_url"].stringValue
                        let title = json[index]["title"].stringValue
                        let tracks = json[index]["tracks"].count
                        
                        Playlists.userPlaylists.playlistArtURL.append(artURL)
                        Playlists.userPlaylists.playlistTitles.append(title)
                        Playlists.userPlaylists.playlistTrackCount.append(tracks)
                    }
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

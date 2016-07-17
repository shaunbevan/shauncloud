//
//  LoginViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/15/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit
import OAuthSwift
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var playlistButton: UIButton!
    var networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistButton.hidden = true
        
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
                self.spinner.stopAnimating()
                self.playlistButton.hidden = false
                for index in 0..<json.count {

                    let artURL = json[index]["artwork_url"].stringValue
                    let title = json[index]["title"].stringValue
                    let tracks = json[index]["tracks"].count

                    Playlists.userPlaylists.playlistArtURL.append(artURL)
                    Playlists.userPlaylists.playlistTitles.append(title)
                    Playlists.userPlaylists.playlistTracks.append(tracks)
                }
            }
            else {
                self.spinner.startAnimating()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signInPressed(sender: AnyObject) {
        //networking.requestAuthenication()
        
    }
    
    @IBAction func getInfoPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("showPlaylist", sender: self)
    }
    
    

}

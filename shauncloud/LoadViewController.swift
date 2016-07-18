//
//  LoadViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/18/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {
    
    let networking = Networking()

    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

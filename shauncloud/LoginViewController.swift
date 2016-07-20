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
import KeychainAccess

class LoginViewController: UIViewController {
    
    var networking = Networking()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var tracksLabel: UILabel!
    @IBOutlet weak var namesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Playlists.userPlaylists.updatePlaylist()
        User.currentUser.updateUser()
        
        self.namesLabel.text = User.currentUser.username
        self.friendsLabel.text = User.currentUser.friends
        
        if let tracks = User.currentUser.trackCount {
            self.tracksLabel.text = String(tracks)
        }
        
        if let avatar = User.currentUser.avatarURL {
            if let url = NSURL(string: avatar) {
                if let data = NSData(contentsOfURL: url) {
                    self.profileImage.image = UIImage(data: data)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signOutPressed(sender: AnyObject) {
        networking.requestAuthenication(self)
    }
}

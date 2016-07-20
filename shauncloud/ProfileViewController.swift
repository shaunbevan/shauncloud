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

class ProfileViewController: UIViewController {
    
    var networking = Networking()
    
    let keychain = Keychain()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var tracksLabel: UILabel!
    @IBOutlet weak var namesLabel: UILabel!
    
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.color = UIColor.lightGrayColor()
        spinner.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.bringSubviewToFront(self.view)
        
        updateProfile()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        spinner.startAnimating()
        Playlists.userPlaylists.updatePlaylist()
        User.currentUser.updateUser() { success in
            if success {
                self.spinner.stopAnimating()
                self.updateProfile()
            } else {
                print("Failed to update user")
            }
        }
    }
    
    
    func updateProfile() {
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
    
    @IBAction func signOutPressed(sender: AnyObject) {
        networking.requestAuthenication(self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

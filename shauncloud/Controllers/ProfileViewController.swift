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

class ProfileViewController: UIViewController {
    
    private var networking = Networking()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var tracksLabel: UILabel!
    @IBOutlet weak var namesLabel: UILabel!
    
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.updateProfile()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.requestProfile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutPressed(sender: AnyObject) {
        networking.requestAuthenication(self)
    }
    
    // MARK: Helpers
    
    private func updateProfile() {
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
    
    private func setUp() {
        spinner.color = UIColor.lightGrayColor()
        spinner.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.bringSubviewToFront(self.view)
    }
    
    private func requestProfile() {
        spinner.startAnimating()
        Playlists.userPlaylists.updatePlaylist() { _ in }
        User.currentUser.updateUser() { success in
            if success {
                self.spinner.stopAnimating()
                self.updateProfile()
            } else {
                print("Failed to update user")
            }
        }
    }
}

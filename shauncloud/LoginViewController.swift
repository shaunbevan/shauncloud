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
    
    
    let networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signInPressed(sender: AnyObject) {
        networking.requestAuthenication()
        
    }
    
    @IBAction func getInfoPressed(sender: AnyObject) {
        networking.requestUserInfo()
    }
    
    

}

//
//  PlaylistViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/15/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PlaylistViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let userEndpoint: String = "http://api.soundcloud.com/users/\(id)?client_id=\(key)"
//        
//        Alamofire.request(.GET, userEndpoint)
//            .responseJSON { response in
//                guard response.result.error == nil else {
//                    // Got an error getting the data, handle it
//                    print("Error: \(response.result.error!)")
//                    return
//                }
//                
//                if let value = response.result.value {
//                    let user = JSON(value)
//                    
//                    print("The user is: \(user)")
//                    
//                    if let username = user["username"].string {
//                        print("The username is: \(username)")
//                    } else {
//                        print("Error parsing users")
//                    }
//                }
//        }
    }

}

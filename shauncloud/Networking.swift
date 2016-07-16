//
//  Networking.swift
//  shauncloud
//
//  Created by Shaun on 7/16/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import Alamofire
import SwiftyJSON
import OAuthSwift
import KeychainAccess

class Networking {
    
    private let key: String = "fabf2f35c07dd3cc26612bf4c91a235e"
    private let secret: String = "bbe66afaf03a2cf9c3ecbf0e684bf444"
    private let redirect: String = "oauth-swift://oauth-callback/soundcloud"
    private let keychain = Keychain(service: "com.shaunbevan.shauncloud")
    
    // MARK: Authenicate
    func requestAuthenication(){
        
        let oauthswift = OAuth2Swift(
            consumerKey: key,
            consumerSecret: secret,
            authorizeUrl: "https://soundcloud.com/connect/",
            accessTokenUrl: "https://api.soundcloud.com/oauth2/token",
            responseType: "code"
        )
        
        oauthswift.authorize_url_handler = WebViewController()
        
        let state: String = generateStateWithLength(20) as String
        
        // Ask for access permission
        oauthswift.authorizeWithCallbackURL( NSURL(string: redirect)!, scope: "non-expiring", state: state, success: {
            credential, response, parameters in
            print("Access token: \(credential.oauth_token)")
            self.keychain["shauncloud"] = credential.oauth_token
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    
    // MARK: Requests
    
    func requestUserInfo(){
        let token = keychain["shauncloud"]
        if let token = token {
            let userEndpoint: String = "https://api.soundcloud.com/me?oauth_token=\(token)"
            
            /* Subresource endpoints
             * Client id: "https://api.soundclound.com/users/\(id)/playlists?client_id=\(key)"
             * Token: "https://api.soundcloud.com/me/playlists?oauth_token=\(token)"
             */
            
            Alamofire.request(.GET, userEndpoint)
                .responseJSON { response in
                    guard response.result.error == nil else {
                        // Got an error getting the data, handle it
                        print("Error: \(response.result.error!)")
                        return
                    }
                    
                    if let value = response.result.value {
                        let user = JSON(value)
                        
                        print("The user is: \(user)")
                        
                        if let username = user["username"].string {
                            print("The username is: \(username)")
                        } else {
                            print("Error parsing users")
                        }
                    }
            }

        }
    }
}

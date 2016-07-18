//
//  Networking.swift
//  shauncloud
//
//  Created by Shaun on 7/16/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

/* Subresource endpoints
 * Client id: "https://api.soundclound.com/users/\(id)/playlists?client_id=\(key)"
 * Token: "https://api.soundcloud.com/me/playlists?oauth_token=\(token)"
 */

import Alamofire
import SwiftyJSON
import OAuthSwift
import KeychainAccess

enum UserResults {
    case Success([User])
    case Failure(ErrorType)
}

struct Networking {
    
    private let key: String = "fabf2f35c07dd3cc26612bf4c91a235e"
    private let secret: String = "bbe66afaf03a2cf9c3ecbf0e684bf444"
    private let redirect: String = "oauth-swift://oauth-callback/soundcloud"
    private let keychain = Keychain(service: "com.shaunbevan.shauncloud")
    private let keychainKey = "shauncloud"
    
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
            self.keychain[self.keychainKey] = credential.oauth_token
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    
    // MARK: Requests
    
    // User
    
    func getUser(completionHandler: (JSON?, NSError?) -> ()) {
        requestUser(completionHandler)
    }
    
    func requestUser(completionHandler: (JSON?, NSError?) -> ()) {
        
        let token = keychain[keychainKey]
        print(token)
        
        if let token = token {
            let userEndpoint: String = "https://api.soundcloud.com/me?oauth_token=\(token)"
            
            Alamofire.request(.GET, userEndpoint) .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    completionHandler(JSON(value), nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
        

    }
    
    // Playlist
    
    func getPlaylist(completionHandler: (JSON?, NSError?) -> ()) {
        requestPlaylist(completionHandler)
    }
    
    func requestPlaylist(completionHandler: (JSON?, NSError?) ->()) {
        let token = keychain[keychainKey]
        if let token = token {
            let playlistEndpoint: String = "https://api.soundcloud.com/me/playlists?oauth_token=\(token)"
            Alamofire.request(.GET, playlistEndpoint) .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    completionHandler(JSON(value), nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func searchTracks(completionHandler: (JSON?, NSError?) -> ()) {
        requestSearch(completionHandler)
    }
    
    func requestSearch(completionHandler: (JSON?, NSError?) -> ()) {
        let token = keychain[keychainKey]
        
        if let token = token {
            let query: String = "https://api.soundcloud.com/me/tracks?oauth_token=\(token)&q=dogs"
            Alamofire.request(.GET, query) .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    completionHandler(JSON(value), nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        
        }
    }
    
//    func requestUserPlaylist(){
//        let token = keychain[keychainKey]
//        print(token)
//        if let token = token {
//            let playlistEndpoint: String = "https://api.soundcloud.com/me/playlists?oauth_token=\(token)"
//            
//            Alamofire.request(.GET, playlistEndpoint)
//                .responseJSON { response in
//                    guard response.result.error == nil else {
//                        // Error!
//                        print("Error: \(response.result.error!)")
//                        return
//                    }
//                    
//                    if let value = response.result.value {
//                        let playlist = JSON(value)
//                        let tracks = playlist[0, "tracks"].count
//                        let title = playlist[0, "title"].string
//                        print(tracks, title)
//                    } else {
//                        print("Error parsing playlist")
//                    }
//            }
//        }
//        
//    }
}

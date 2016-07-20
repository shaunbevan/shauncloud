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

struct Networking {
    
    private let key: String = "fabf2f35c07dd3cc26612bf4c91a235e"
    private let secret: String = "bbe66afaf03a2cf9c3ecbf0e684bf444"
    private let redirect: String = "oauth-swift://oauth-callback/soundcloud"
    private let keychain = Keychain(service: "com.shaunbevan.shauncloud")
    private let keychainKey = "shauncloud"
    
    // MARK: Authenicate
    func requestAuthenication(viewcontroller: UIViewController){
        let oauthswift = OAuth2Swift(
            consumerKey: key,
            consumerSecret: secret,
            authorizeUrl: "https://soundcloud.com/connect/",
            accessTokenUrl: "https://api.soundcloud.com/oauth2/token",
            responseType: "code"
        )
        
        // Open Soundcloud Connect with Safari view controller
        oauthswift.authorize_url_handler = SafariURLHandler(viewController: viewcontroller)
        
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
    
    // MARK: User
    
    func getUser(completionHandler: (JSON?, NSError?) -> ()) {
        requestUser(completionHandler)
    }
    
    func requestUser(completionHandler: (JSON?, NSError?) -> ()) {
        
        let token = keychain[keychainKey]
        
        if let token = token {
            let parameters: [String: AnyObject] = ["oauth_token": token]
            let userEndpoint: String = "https://api.soundcloud.com/me"
            
            Alamofire.request(.GET, userEndpoint, parameters: parameters) .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    completionHandler(JSON(value), nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    // MARK: Playlist
    
    func getPlaylist(completionHandler: (JSON?, NSError?) -> ()) {
        requestPlaylist(completionHandler)
    }
    
    func requestPlaylist(completionHandler: (JSON?, NSError?) ->()) {
        let token = keychain[keychainKey]
        if let token = token {
            let parameters: [String: AnyObject] = ["oauth_token": token]
            let playlistEndpoint: String = "https://api.soundcloud.com/me/playlists"
            Alamofire.request(.GET, playlistEndpoint, parameters: parameters) .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    completionHandler(JSON(value), nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    // MARK: Add playlist
    
    func addPlaylist(title: String, completionHandler: (success: Bool) -> ()) {
        createPlaylist(title, completionHandler: completionHandler)
    }
    
    
    func createPlaylist(title: String, completionHandler: (success: Bool) -> ()) {
        let token = keychain[keychainKey]
        
        if let token = token {
            
            let trackIdentifiers = []
            
            let parameters: [String: AnyObject] = [
                "oauth_token": token,
                "playlist": [
                    "title": title,
                    "sharing": "public",
                    "tracks": trackIdentifiers.map { ["id": "\($0)"] }
                ]
            ]
            let endpoint: String = "https://api.soundcloud.com/playlists"
            Alamofire.request(.POST, endpoint, parameters: parameters) .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    print(value)
                    completionHandler(success: true)
                case .Failure(let error):
                    print(error)
                    completionHandler(success: false)
                }
            }
        }
    }
    
    // MARK: Search
    
    func searchTracks(query: String, completionHandler: (JSON?, NSError?) -> ()) {
        requestSearch(query, completionHandler: completionHandler)
    }
    
    func requestSearch(query: String, completionHandler: (JSON?, NSError?) -> ()) {
        let token = keychain[keychainKey]
        
        let searchQuery = query.stringByAddingPercentEncodingForURLQueryParameter()
        
        if let token = token {
            
            if let queryString = searchQuery {
                let parameters: [String: AnyObject] = [
                    "oauth_token": token,
                    "q": queryString
                ]
            
                let endpoint: String = "https://api.soundcloud.com/tracks"

                Alamofire.request(.GET, endpoint, parameters: parameters) .responseJSON { response in
                    switch response.result {
                    case .Success(let value):
                        completionHandler(JSON(value), nil)
                    case .Failure(let error):
                        completionHandler(nil, error)
                    }
                }
            }
        
        }
    }
    
    // MARK: Add track
    func addTrack(playlist: String, tracks: [String], completionHandler: (String?, NSError?) -> ()) {
        putTrackInPlaylist(playlist, tracks: tracks, completionHandler: completionHandler)
    }
    
    func putTrackInPlaylist(playlist: String, tracks: [String], completionHandler: (String?, NSError?) -> ()) {
        let token = keychain[keychainKey]
        
        if let token = token {
            // Guessing at api, need to add token too
            
            let trackIdentifiers = tracks
            
            let parameters: [String: AnyObject] = [
                "oauth_token": token,
                "playlist": [
                    "tracks": trackIdentifiers.map { ["id": "\($0)"] }
                ],
                "sharing": "public"
            ]
            
            let endpoint: String = "https://api.soundcloud.com/me/playlists/\(playlist)"
            Alamofire.request(.PUT, endpoint, parameters: parameters) .responseJSON { response in
                print("Status Code: \(response.response!.statusCode)")
                switch response.result {
                case .Success(let value):
                    completionHandler(value as? String, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    // MARK: Remove track
    func removeTrack(playlist: String, tracks: [String], completionHandler: (String?, NSError?) -> ()) {
        removeTrackFromPlaylist(playlist, tracks: tracks, completionHandler: completionHandler)
    }
    
    func removeTrackFromPlaylist(playlist: String, tracks: [String], completionHandler: (String?, NSError?) ->()) {
        let token = keychain[keychainKey]
        
        if let token = token {
            
            var trackIdentifiers = tracks
            
            // If the last track in the playlist is deleted, remove track by setting id to 0
            if trackIdentifiers.isEmpty {
                trackIdentifiers.append("0")
            }
            
            let parameters: [String: AnyObject] = [
                "oauth_token": token,
                "playlist": [
                    "tracks": trackIdentifiers.map { ["id": "\($0)"] }
                ],
                "sharing": "public"
            ]
            
            let endpoint: String = "https://api.soundcloud.com/me/playlists/\(playlist)"
            Alamofire.request(.PUT, endpoint, parameters: parameters) .responseJSON { response in
                print("Status Code: \(response.response!.statusCode)")
                switch response.result {
                case .Success(let value):
                    completionHandler(value as? String, nil)
                case .Failure(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }
}

extension String {
    func stringByAddingPercentEncodingForURLQueryParameter() -> String? {
        // Encode spaces in query
        let allowedCharacters = NSCharacterSet.URLQueryAllowedCharacterSet()
        return stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
    }
}

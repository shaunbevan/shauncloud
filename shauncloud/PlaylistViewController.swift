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

class PlaylistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let networking = Networking()
    
    private var cellIdentifier: String = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        networking.getPlaylist() { responseObject, error in
            
            var newPlaylist = [String]()
            var newArtURL = [String]()
            
            if let json = responseObject {
                for index in 0..<json.count {
                    
                    let artURL = json[index]["artwork_url"].stringValue
                    let title = json[index]["title"].stringValue
                    
                    newPlaylist.append(title)
                    newArtURL.append(artURL)
                }
                
                if newArtURL == Playlists.userPlaylists.playlistArtURL {
                } else {
                    Playlists.userPlaylists.playlistArtURL = newArtURL
                    self.collectionView.reloadData()
                }
                
                if newPlaylist == Playlists.userPlaylists.playlistTitles {
                } else {
                    Playlists.userPlaylists.playlistTitles = newPlaylist
                    self.collectionView.reloadData()
                }
            }
        }
    }
    

    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let playlistIndex = Playlists.userPlaylists.playlistTitles.indexOf(Playlists.userPlaylists.playlistTitles[indexPath.row])
        
        let playlistIndexPath = NSIndexPath(forRow: playlistIndex!, inSection: 0)
        
        if let cell = self.collectionView.cellForItemAtIndexPath(playlistIndexPath) as? PlaylistCollectionViewCell {
            cell.titleLabel.text = Playlists.userPlaylists.playlistTitles[playlistIndexPath.row]
            
            if let url = NSURL(string: Playlists.userPlaylists.playlistArtURL[playlistIndexPath.row]){
                if let data = NSData(contentsOfURL: url) {
                    cell.updateWithImage(UIImage(data: data))
                } else {
                    cell.updateWithImage(UIImage(named: "download"))
                }
            }
        }

        
//        networking.getPlaylist() { responseObject, error in
//            if let json = responseObject {
//
//                for index in 0..<json.count {
//                    
//                    let artURL = json[index]["artwork_url"].stringValue
//                    let title = json[index]["title"].stringValue
//                    Playlists.userPlaylists.playlistArtURL.append(artURL)
//                    Playlists.userPlaylists.playlistTitles.append(title)
//                    
//                    let playlistIndex = Playlists.userPlaylists.playlistTitles.indexOf(title)
//                    let playlistIndexPath = NSIndexPath(forRow: playlistIndex!, inSection: 0)
//                    
//                    if let cell = self.collectionView.cellForItemAtIndexPath(playlistIndexPath) as? PlaylistCollectionViewCell {
//                        cell.titleLabel.text = Playlists.userPlaylists.playlistTitles[playlistIndexPath.row]
//                        
//                        if let url = NSURL(string: Playlists.userPlaylists.playlistArtURL[playlistIndexPath.row]){
//                            if let data = NSData(contentsOfURL: url) {
//                                cell.updateWithImage(UIImage(data: data))
//                            } else {
//                                cell.updateWithImage(UIImage(named: "download"))
//                            }
//                        }
//                    }
//
//                }
//                
//            }
//            
//        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = User.currentUser.playlistCount {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PlaylistCollectionViewCell
        
        let playlistIndex = Playlists.userPlaylists.playlistTitles.indexOf(Playlists.userPlaylists.playlistTitles[indexPath.row])
        
        let playlistIndexPath = NSIndexPath(forRow: playlistIndex!, inSection: 0)
        
            cell.titleLabel.text = Playlists.userPlaylists.playlistTitles[playlistIndexPath.row]
            
            if let url = NSURL(string: Playlists.userPlaylists.playlistArtURL[playlistIndexPath.row]){
                if let data = NSData(contentsOfURL: url) {
                    cell.updateWithImage(UIImage(data: data))
                } else {
                    cell.updateWithImage(UIImage(named: "download"))
                }
            }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showTracks", sender: indexPath)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let row = sender?.row {
            let vc = segue.destinationViewController as! TracksViewController
            vc.playlistTitle.title = Playlists.userPlaylists.playlistTitles[row]
            vc.numberOfTracks = Playlists.userPlaylists.playlistTracks[row]
        }

    }
 

    
    

}

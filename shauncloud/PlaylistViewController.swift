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
    
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(PlaylistViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.addSubview(refreshControl) // not required when using UITableViewController
    
        self.spinner.color = UIColor.lightGrayColor()
        self.spinner.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        self.spinner.center = self.view.center
        self.view.addSubview(spinner)
        self.spinner.bringSubviewToFront(self.view)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        updatePlaylist()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.lightGrayColor()
        self.updatePlaylist()
       
    }
    
    func updatePlaylist(){
        self.spinner.startAnimating()
        networking.getPlaylist() { responseObject, error in
            
            self.spinner.stopAnimating()
            var newPlaylist = [String]()
            var newArtURL = [String]()
            var newIDs = [String]()
            
            if let json = responseObject {

                for index in 0..<json.count {
                    let artURL = json[index]["artwork_url"].stringValue
                    let title = json[index]["title"].stringValue
                    let id = json[index]["id"].stringValue
                    
                    
                    newIDs.append(id)
                    newPlaylist.append(title)
                    newArtURL.append(artURL)
                }
                
                if newIDs == Playlists.userPlaylists.playlistIDs {
                } else {
                    Playlists.userPlaylists.playlistIDs = newIDs
                }
                
                if newArtURL == Playlists.userPlaylists.playlistArtURL {
                } else {
                    Playlists.userPlaylists.playlistArtURL = newArtURL
                }
                
                if newPlaylist == Playlists.userPlaylists.playlistTitles {
                } else {
                    Playlists.userPlaylists.playlistTitles = newPlaylist
                }
            }
            self.refreshControl.endRefreshing()

        }
        self.collectionView.reloadData()
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
            vc.numberOfTracks = Playlists.userPlaylists.playlistTrackCount[row]
            vc.playlistArtURL = Playlists.userPlaylists.playlistArtURL[row]
            vc.playlistID = Playlists.userPlaylists.playlistIDs[row]
            
        }

    }
 

    
    

}

//
//  PlaylistViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/15/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let networking = Networking()
    private var cellIdentifier: String = "Cell"
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    private var refreshControl: UIRefreshControl!
    
    // MARK: View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updatePlaylist()
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
    
    // MARK: Table view
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Playlists.userPlaylists.playlistIDs.count != 0 {
            return Playlists.userPlaylists.playlistIDs.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PlaylistCollectionViewCell
        
        if let index = Playlists.userPlaylists.playlistTitles.indexOf(Playlists.userPlaylists.playlistTitles[indexPath.row]) {
            let playlistIndexPath = NSIndexPath(forRow: index, inSection: 0)
            cell.titleLabel.text = Playlists.userPlaylists.playlistTitles[playlistIndexPath.row]
            if let url = NSURL(string: Playlists.userPlaylists.playlistArtURL[playlistIndexPath.row]){
                if let data = NSData(contentsOfURL: url) {
                    cell.updateWithImage(UIImage(data: data))
                } else {
                    cell.updateWithImage(UIImage(named: "download"))
                }
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showTracks", sender: indexPath)
    }
    
    
    @IBAction func addPlaylistButtonPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add Playlist", message: "It may take a minute to update", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            let playlistName = alertController.textFields![0] as UITextField

            if let name = playlistName.text {
                self.networking.addPlaylist(name) { response in
                    print(response)
                    if response {
                        Playlists.userPlaylists.updatePlaylist() { response in
                            if response {
                                self.collectionView.reloadData()
                            }
                        }
                    } else {
                        print("Error: Failed to add playlist")
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Playlist Name"
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func updatePlaylist(){
        self.spinner.startAnimating()
        networking.getPlaylist() { responseObject, error in
            self.spinner.stopAnimating()
            
            if let json = responseObject {
                
                var tempIDs = [String]()
                var tempTitles = [String]()
                var tempArt = [String]()
                
                for index in 0..<json.count {
                    let artURL = json[index]["artwork_url"].stringValue
                    let title = json[index]["title"].stringValue
                    let id = json[index]["id"].stringValue
                    
                    tempIDs.append(id)
                    tempTitles.append(title)
                    tempArt.append(artURL)
                }
                Playlists.userPlaylists.playlistIDs = tempIDs
                Playlists.userPlaylists.playlistTitles = tempTitles
                Playlists.userPlaylists.playlistArtURL = tempArt
                
                self.collectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }

    
    private func setUp() {
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
}

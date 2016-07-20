//
//  SearchDetailViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/18/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trackID: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var networking = Networking()
    private var playlistID = [String]()
    private var tracks = [String]()

    private var refreshControl: UIRefreshControl!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.checkForUpdatedPlaylists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Playlists.userPlaylists.playlistIDs.count != 0 {
            return Playlists.userPlaylists.playlistIDs.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let row = indexPath.row
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TracksTableViewCell
        
        cell.searchPlaylistTitleLabel?.text = Playlists.userPlaylists.playlistTitles[row]
        
        cell.searchPlaylistNumberLabel?.text = String(row+1)
        
        if let url = NSURL(string: Playlists.userPlaylists.playlistArtURL[row]){
            if let data = NSData(contentsOfURL: url) {
                cell.searchPlaylistImage?.image = UIImage(data: data)
            } else {
                cell.searchPlaylistImage?.image = UIImage(named: "download")
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        let selectedPlaylist = self.playlistID[row]
        
        // Clean up track array
        self.cleanUp()
        
        // Find selected playlist to add track
        networking.getPlaylist() { response, error in
            if let json = response {
                let trackCount = json[row]["tracks"].count
                for index in 0..<trackCount {
                    let id = json[row]["tracks", index]["id"].stringValue
                    self.tracks.append(id)
                }
                // Insert new track into local array
                if let newTrack = self.trackID {
                    self.tracks.insert(newTrack, atIndex: 0)
                }
            } else {
                print(error)
            }
            // Add new track to playlist in Soundcloud
            self.networking.addTrack(selectedPlaylist, tracks: self.tracks) { response, error in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    // MARK: Helpers
    
    private func checkForUpdatedPlaylists() {
        // Check to see if any playlists have been added since load.
        networking.getPlaylist() { responseObject, error in
            var newPlaylist = [String]()
            var newArtURL = [String]()
            
            if let json = responseObject {
                for index in 0..<json.count {
                    let artURL = json[index]["artwork_url"].stringValue
                    let title = json[index]["title"].stringValue
                    let id = json[index]["id"].stringValue
                    self.playlistID.append(id)
                    newPlaylist.append(title)
                    newArtURL.append(artURL)
                }
                Playlists.userPlaylists.playlistArtURL = newArtURL
                Playlists.userPlaylists.playlistTitles = newPlaylist
                self.tableView.reloadData()
            }
        }
    }
    
    private func setUp() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(SearchDetailViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func cleanUp() {
        self.tracks.removeAll(keepCapacity: false)
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

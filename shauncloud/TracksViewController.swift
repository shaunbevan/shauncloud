//
//  TracksViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/17/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class TracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let networking = Networking()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playlistTitle: UINavigationItem!
    @IBOutlet weak var playlistImage: UIImageView!
        
    var playlistArtURL: String?
    var playlistID: String?
    
    var trackArtURLs = [String]()
    
    var numberOfTracks: Int = 0
    var tracks = [String]()
    let cellIdentifier = "Cell"
    
    var refreshControl: UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(PlaylistViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        if let artURL = self.playlistArtURL {
            if let url = NSURL(string: artURL) {
                if let data = NSData(contentsOfURL: url){
                    self.playlistImage.image = UIImage(data: data)
                } else {
                    self.playlistImage.image = UIImage(named: "download")
                }
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        loadTracks()
        self.tracks.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadTracks()
        self.tracks.removeAll(keepCapacity: false)
    }
    
    
    private func loadTracks() {
        print("Loading...")
        // Fetch tracks from playlist endpoint
        networking.getPlaylist() { responseObject, error in
            print("Done")
            if let json = responseObject {
                if let selectedPlaylist = self.playlistID {
                    let playlistIndex = Playlists.userPlaylists.playlistIDs.indexOf(selectedPlaylist)
                        if let index = playlistIndex {
                            self.numberOfTracks = json[index]["tracks"].count
                            for i in 0..<self.numberOfTracks {
                                let trackTitle = json[index]["tracks", i]["title"].stringValue
                                let trackArtURL = json[index]["tracks", i]["artwork_url"].stringValue
                                
                                self.tracks.append(trackTitle)
                                self.trackArtURLs.append(trackArtURL)
                            }
                            self.tableView.reloadData()
                        }
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.numberOfTracks != 0 {
            return self.tracks.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TracksTableViewCell
        
        let row = indexPath.row
        cell.trackLabel!.text = self.tracks[row]
        cell.numberLabel!.text = String(row+1)
        
        let artURL = self.trackArtURLs[row]
        
    
        if let url = NSURL(string: artURL) {
            if let data = NSData(contentsOfURL: url){
                cell.playlistImage?.image = UIImage(data: data)
            } else {
                cell.playlistImage?.image = UIImage(named: "download")
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! TrackDetailViewController
        vc.index = sender?.row
        vc.songLabelText = self.playlistTitle.title!
    }
    
}

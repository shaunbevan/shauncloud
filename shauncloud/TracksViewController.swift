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
    var numberOfTracks: Int = 0
    var tracks = [String]()
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch tracks from playlist endpoint
        networking.getPlaylist() { responseObject, error in
            
            if let json = responseObject {
                
                let playlistIndex = Playlists.userPlaylists.playlistTitles.indexOf(self.playlistTitle.title!)

                for index in 0..<self.numberOfTracks {
                    let track = json[playlistIndex!]["tracks", index]["title"].stringValue
                    self.tracks.append(track)
                }

                self.playlistArtURL = json[playlistIndex!]["artwork_url"].stringValue
                self.tableView.reloadData()
            }
        }
        
        // Set playlist image
        
        if let artURL = self.playlistArtURL {
            if let url = NSURL(string: artURL){
                if let data = NSData(contentsOfURL: url){
                    self.playlistImage.image = UIImage(data: data)
                } else {
                    self.playlistImage.image = UIImage(named: "download")
                }
            }
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TracksTableViewCell
        
        let row = indexPath.row
        cell.trackLabel.text = tracks[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: indexPath)
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

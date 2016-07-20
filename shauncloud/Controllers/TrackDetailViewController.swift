//
//  TrackDetailViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/18/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class TrackDetailViewController: UIViewController {

    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    
    var songLabelText: String?
    var index: Int?
    private var networking = Networking()
    private var trackID: String?
    private var trackArray = [String]()
    private var playlistID: String?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.setUp()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTrackInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func removeTrackFromPlaylist(sender: AnyObject) {
        // Remove track from playlist
        
        let alert = UIAlertController(title: "Are you sure?", message: "Delete track", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            if let track = self.trackID {
                // Find index of deleted track in local array
                let deleteTrackIndex = self.trackArray.indexOf(track)
                if let index = deleteTrackIndex {
                    // Remove from local array
                    self.trackArray.removeAtIndex(index)
                }
            }
            // Remove track from Soundcloud
            if let id = self.playlistID {
                self.networking.removeTrack(id, tracks: self.trackArray) {response, error in
                    if let error = error {
                        print(error)
                    }
                }
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    // MARK: Helpers
    
    private func setUp() {
        self.spinner.color = UIColor.lightGrayColor()
        self.spinner.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        self.spinner.center = self.view.center
        self.view.addSubview(spinner)
        self.spinner.bringSubviewToFront(self.view)
    }
    
    private func updateTrackInfo() {
        self.spinner.startAnimating()
        networking.getPlaylist() { responseObject, error in
            self.spinner.stopAnimating()
            if let json = responseObject {
                
                if let playlistIndex = Playlists.userPlaylists.playlistTitles.indexOf(self.songLabelText!) {
                    if let index = self.index {
                        let artistName = json[playlistIndex]["tracks", index]["user"]["username"].stringValue
                        let songName = json[playlistIndex]["tracks", index]["title"].stringValue
                        let description = json[playlistIndex]["tracks", index]["description"].stringValue
                        let artURL = json[playlistIndex]["tracks", index]["artwork_url"].stringValue
                        let playlist = json[playlistIndex]["id"].stringValue
                        let selectedTrack = json[playlistIndex]["tracks", index]["id"].stringValue
                        let favorites = json[playlistIndex]["tracks", index]["favoritings_count"].stringValue
                        let trackCount = json[playlistIndex]["tracks"].count
                        
                        for i in 0..<trackCount {
                            let tracks = json[playlistIndex]["tracks", i]["id"].stringValue
                            self.trackArray.append(tracks)
                        }
                        
                        // Update labels
                        self.playlistID = playlist
                        self.trackID = selectedTrack
                        self.artistLabel.text = artistName
                        self.songLabel.text = songName
                        self.descriptionLabel.text = description
                        self.favoritesLabel.text = favorites
                        
                        if let url = NSURL(string: artURL) {
                            if let data = NSData(contentsOfURL: url) {
                                self.trackImageView.image = UIImage(data: data)
                            } else {
                                self.trackImageView.image = UIImage(named: "download")
                            }
                        }
                    }
                }
            }
        }
    }
}

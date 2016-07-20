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
    var networking = Networking()
    var index: Int?
    var trackID: String?
    var trackArray = [String]()
    var playlistID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.spinner.color = UIColor.lightGrayColor()
        self.spinner.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        self.spinner.center = self.view.center
        self.view.addSubview(spinner)
        self.spinner.bringSubviewToFront(self.view)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.spinner.startAnimating()

        networking.getPlaylist() { responseObject, error in
            self.spinner.stopAnimating()
            if let json = responseObject {
                let playlistIndex = Playlists.userPlaylists.playlistTitles.indexOf(self.songLabelText!)

                let artistName = json[playlistIndex!]["tracks", self.index!]["user"]["username"].stringValue
                let songName = json[playlistIndex!]["tracks", self.index!]["title"].stringValue
                let description = json[playlistIndex!]["tracks", self.index!]["description"].stringValue
                let artURL = json[playlistIndex!]["tracks", self.index!]["artwork_url"].stringValue
                let playlist = json[playlistIndex!]["id"].stringValue
                let selectedTrack = json[playlistIndex!]["tracks", self.index!]["id"].stringValue
                let favorites = json[playlistIndex!]["tracks", self.index!]["favoritings_count"].stringValue

                let trackCount = json[playlistIndex!]["tracks"].count
                
                for index in 0..<trackCount {
                    let tracks = json[playlistIndex!]["tracks", index]["id"].stringValue
                    self.trackArray.append(tracks)
                }
                print(self.trackID)
                print(selectedTrack)
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

    @IBAction func removeTrackFromPlaylist(sender: AnyObject) {
        // Remove track from playlist
        
        let alert = UIAlertController(title: "Are you sure?", message: "Delete track", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            
            if let track = self.trackID {
                let deleteTrackIndex = self.trackArray.indexOf(track)
                
                if let index = deleteTrackIndex {
                    self.trackArray.removeAtIndex(index)
                }
            }
            

            
            self.networking.removeTrack(self.playlistID!, tracks: self.trackArray) {response, error in
            
            }
        }))

        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

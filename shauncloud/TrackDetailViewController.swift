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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var songLabelText: String?
    var networking = Networking()
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        networking.getPlaylist() { responseObject, error in
            
            if let json = responseObject {
                let playlistIndex = Playlists.userPlaylists.playlistTitles.indexOf(self.songLabelText!)
                
                print(playlistIndex!)
                print(self.index!)
                let artistName = json[playlistIndex!]["tracks", self.index!]["user"]["username"].stringValue
                let songName = json[playlistIndex!]["tracks", self.index!]["title"].stringValue
                let description = json[playlistIndex!]["tracks", self.index!]["description"].stringValue
                let artURL = json[playlistIndex!]["tracks", self.index!]["artwork_url"].stringValue
                
                self.artistLabel.text = artistName
                self.songLabel.text = songName
                self.descriptionLabel.text = description
                
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

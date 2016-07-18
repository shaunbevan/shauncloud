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
    
    var networking = Networking()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if any playlists have been added since load.
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
                    self.tableView.reloadData()
                }
                
                if newPlaylist == Playlists.userPlaylists.playlistTitles {
                } else {
                    Playlists.userPlaylists.playlistTitles = newPlaylist
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = User.currentUser.playlistCount {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let row = indexPath.row
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = Playlists.userPlaylists.playlistTitles[row]
        
        if let url = NSURL(string: Playlists.userPlaylists.playlistArtURL[row]){
            if let data = NSData(contentsOfURL: url) {
                cell.imageView?.image = UIImage(data: data)
            } else {
                cell.imageView?.image = UIImage(named: "download")
            }
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
            } else {
                cell.accessoryType = .Checkmark
            }
        }
    }

    @IBAction func doneButtonPressed(sender: AnyObject) {
        
        // Save tracks
        
    }
}

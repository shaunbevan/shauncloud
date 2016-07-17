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
    
    let cellIdentifier = "Cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var numberOfTracks: Int = 0
    
    @IBOutlet weak var playlistTitle: UINavigationItem!
    
    var playlistTitleName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of tracks: \(numberOfTracks)")
        return numberOfTracks
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TracksTableViewCell
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

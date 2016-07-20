//
//  SearchViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/18/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var networking = Networking()

    private var searchArray = [String]()
    private var filteredArray = [String]()
    private var filteredArrayImages = [String]()
    private var availablePlaylists = [String]()
    private var trackID = [String]()
    
    private var resultSearchController: UISearchController!
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    private var notFoundLabel: UILabel!
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Update playlist in background in preparation for search detail controller
        networking.getPlaylist() { responseObject, error in
            if let json = responseObject {
                for index in 0..<json.count {
                    let title = json[index]["title"].stringValue
                    self.availablePlaylists.append(title)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addTrack" {
            let index = sender?.row
            let vc = segue.destinationViewController as! SearchDetailViewController
            if let row = index {
                vc.trackID = self.trackID[row]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredArray.count ?? 0
        } else {
            return self.searchArray.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TracksTableViewCell
        
        let row = indexPath.row
        
        cell.searchCellNumberLabel?.text = String(row+1)
        
        if self.resultSearchController.active {
            cell.searchCellTitleLabel?.text = self.filteredArray[row]
            if let url = NSURL(string: self.filteredArrayImages[row]) {
                if let data = NSData(contentsOfURL: url) {
                    cell.searchCellImage?.image = UIImage(data: data)
                } else {
                    cell.searchCellImage?.image = UIImage(named: "download")
                }
            }
            
        } else {
            cell.searchCellTitleLabel!.text = self.searchArray[row]
        }
        
        // Setup accessory
        let addTrackIcon = UIImage(named: "addtrack")
        let addTrackImage = UIImageView(image: addTrackIcon)
        addTrackImage.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        cell.accessoryType = .DisclosureIndicator
        cell.accessoryView = addTrackImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("addTrack", sender: indexPath)
    }
    
    // MARK: Search bar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let searchText = self.resultSearchController.searchBar.text
        
        if let query = searchText {
            
            spinner.startAnimating()
            
            // Search for query on Soundcloud
            networking.searchTracks(query) { responseObject, error in
                if let json = responseObject {
                    self.spinner.stopAnimating()
                    self.spinner.hidesWhenStopped = true
                    
                    // Display Not Found label if result is empty
                    if json.isEmpty {
                        self.notFoundLabel.hidden = false
                    }
                    
                    for index in 0..<json.count {
                        let title = json[index]["title"].stringValue
                        let imageResult = json[index]["artwork_url"].stringValue
                        let id = json[index]["id"].stringValue
                        self.filteredArray.append(title)
                        self.filteredArrayImages.append(imageResult)
                        self.trackID.append(id)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.resultSearchController.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        // Clear search arrays
        cleanUp()
    }
  
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Hide Not Found label if search returns results
        self.notFoundLabel.hidden = true
        
        if let text = searchController.searchBar.text {
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", text)
            let array = (self.searchArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
            self.filteredArray = array as! [String]
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Helpers
    
    private func cleanUp() {
        // Clean up arrays used to hold data
        self.filteredArray.removeAll(keepCapacity: false)
        self.filteredArrayImages.removeAll(keepCapacity: false)
        self.trackID.removeAll(keepCapacity: false)
    }
    
    private func setUp() {
        self.navigationController?.navigationBar.hidden = true
        
        // Instantiate Not Found Label
        self.notFoundLabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 100))
        self.notFoundLabel.center = self.view.center
        self.notFoundLabel.textColor = UIColor.lightGrayColor()
        self.view.addSubview(notFoundLabel)
        self.notFoundLabel.text = "Track not found"
        self.notFoundLabel.textAlignment = .Center
        self.notFoundLabel.bringSubviewToFront(self.view)
        self.notFoundLabel.hidden = true
        
        // Setup spinner
        spinner.color = UIColor.lightGrayColor()
        spinner.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.bringSubviewToFront(self.view)
        
        // Setup search controller
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController?.searchBar.delegate = self
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        // Allow SearchViewController to hold after activating the search bar
        self.definesPresentationContext = true
    }
}

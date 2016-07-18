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
    
    var array = [String]()
    var filteredArray = [String]()
    var filteredArrayImages = [String]()
    var availablePlaylists = [String]()
    var trackID = [String]()
    var resultSearchController: UISearchController!
    
    var networking = Networking()
    
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        spinner.color = UIColor.lightGrayColor()
        spinner.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.bringSubviewToFront(self.view)
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController?.searchBar.delegate = self
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        networking.getPlaylist() { responseObject, error in
            
            
            if let json = responseObject {
                for index in 0..<json.count {
                    let title = json[index]["title"].stringValue
                    self.availablePlaylists.append(title)
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
        if self.resultSearchController.active {
            return self.filteredArray.count ?? 0
        } else {
            return self.array.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) 
        
        if self.resultSearchController.active {
            cell.textLabel?.text = self.filteredArray[indexPath.row]
            if let url = NSURL(string: self.filteredArrayImages[indexPath.row]) {
                if let data = NSData(contentsOfURL: url) {
                    cell.imageView?.image = UIImage(data: data)
                }
            }
            
        } else {
            cell.textLabel!.text = self.array[indexPath.row]
            cell.imageView?.image = UIImage(named: "download")
        }
        
        let addTrackIcon = UIImage(named: "addtrack")
        
        let addTrackImage = UIImageView(image: addTrackIcon)
        addTrackImage.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        cell.accessoryType = .DisclosureIndicator
        cell.accessoryView = addTrackImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("addTrack", sender: indexPath)
        
//        if self.resultSearchController.active{
//            let alert = UIAlertController(title: "\(self.filteredArray[indexPath.row])", message: "", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "Add track", style: .Default, handler: nil))
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.resultSearchController.active = false

        if segue.identifier == "addTrack" {
            let index = sender?.row
            
            let vc = segue.destinationViewController as! SearchDetailViewController
            
            if let row = index {
                vc.trackID = self.trackID[row]
            }
            
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.resultSearchController.searchBar.resignFirstResponder()
        
//        let searchText = self.resultSearchController.searchBar.text
//        
//        if let query = searchText {
//            print(query)
//        }
//        
        spinner.startAnimating()
        networking.searchTracks() { responseObject, error in
            if let json = responseObject {
                self.spinner.stopAnimating()
                self.spinner.hidesWhenStopped = true
                
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
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("search cancel clicked")
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredArray.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (self.array as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredArray = array as! [String]
        
        self.tableView.reloadData()
    }
    

}

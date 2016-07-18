//
//  SearchViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/18/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    
    var array = [String]()
    var filteredArray = [String]()
    var resultSearchController: UISearchController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.array.append("Shaun")
        self.array.append("Chris")
        self.array.append("Hilda")
        self.array.append("Lisa")
        self.array.append("Angelbello")
        self.array.append("Craig")
        self.array.append("Leena")
        
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
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
        } else {
            cell.textLabel!.text = self.array[indexPath.row]
        }
        
        return cell
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredArray.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (self.array as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredArray = array as! [String]
        
        self.tableView.reloadData()
    }
    

}

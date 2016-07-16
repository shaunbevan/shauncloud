//
//  PlaylistViewController.swift
//  shauncloud
//
//  Created by Shaun on 7/15/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PlaylistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let networking = Networking()
    
    private var cellIdentifier: String = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PlaylistCollectionViewCell
        
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    

}

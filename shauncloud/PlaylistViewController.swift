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
    
    private var playlistCount: Int?
    
    private var playlistTitles: [String] = []
    private var playlistImages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.whiteColor()
        
        networking.getUser() { responseObject, error in
            if let json = responseObject {
                self.playlistCount = json["playlist_count"].intValue
                self.collectionView.reloadData()
            }
        }
        
//        networking.getPlaylist() { responseObject, error in
//            if let json = responseObject {
//                
//                for index in 0..<json.count {
//                    let artURL = json[index]["artwork_url"].stringValue
//                    let title = json[index]["title"].stringValue
//                    self.playlistImages.append(artURL)
//                    self.playlistTitles.append(title)
//                    self.collectionView.reloadData()
//                }
//
//            }
//
//        }



    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        
        networking.getPlaylist() { responseObject, error in
            if let json = responseObject {
                
                for index in 0..<json.count {
                    let artURL = json[index]["artwork_url"].stringValue
                    let title = json[index]["title"].stringValue
                    self.playlistImages.append(artURL)
                    self.playlistTitles.append(title)
                    
                    let playlistIndex = self.playlistTitles.indexOf(title)
                    let playlistIndexPath = NSIndexPath(forRow: playlistIndex!, inSection: 0)
                    
                    if let cell = self.collectionView.cellForItemAtIndexPath(playlistIndexPath) as? PlaylistCollectionViewCell {
                        cell.titleLabel.text = self.playlistTitles[playlistIndexPath.row]
                        
                        if let url = NSURL(string: self.playlistImages[playlistIndexPath.row]){
                            if let data = NSData(contentsOfURL: url) {
                                cell.updateWithImage(UIImage(data: data))
                            } else {
                                cell.updateWithImage(UIImage(named: "download"))
                            }
                        }
                    }

                }
                
            }
            
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.playlistCount {
            print(count)
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! PlaylistCollectionViewCell
        
        return cell
    }
    
    

}

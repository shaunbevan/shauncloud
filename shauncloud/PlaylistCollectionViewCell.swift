//
//  PlaylistCollectionViewCell.swift
//  shauncloud
//
//  Created by Shaun on 7/16/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playlistImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func updateWithImage(image:UIImage?) {

        if let imageToDisplay = image {
            spinner.stopAnimating()
            playlistImage.image = imageToDisplay
        } else {
            spinner.startAnimating()
            playlistImage.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(nil)
    }
    
}

//
//  TracksTableViewCell.swift
//  shauncloud
//
//  Created by Shaun on 7/17/16.
//  Copyright © 2016 Shaun Bevan. All rights reserved.
//

import UIKit

class TracksTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistImage: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    @IBOutlet weak var searchPlaylistTitleLabel: UILabel!
    @IBOutlet weak var searchPlaylistNumberLabel: UILabel!
    @IBOutlet weak var searchPlaylistImage: UIImageView!
    
    @IBOutlet weak var searchCellTitleLabel: UILabel!
    @IBOutlet weak var searchCellNumberLabel: UILabel!
    @IBOutlet weak var searchCellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

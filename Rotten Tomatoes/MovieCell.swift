//
//  MovieCell.swift
//  Rotten Tomatoes
//
//  Created by Do Ngoc Tan on 8/27/15.
//  Copyright (c) 2015 Do Ngoc Tan. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbSynopsis: UILabel!
    
    
    @IBOutlet weak var imgPoster: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
